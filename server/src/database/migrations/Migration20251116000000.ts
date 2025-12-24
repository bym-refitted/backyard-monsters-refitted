import { Migration } from '@mikro-orm/migrations';

export class Migration20251116000000 extends Migration {

  async up(): Promise<void> {
    this.addSql(`
    ALTER TABLE bym.attack_logs
    ALTER COLUMN attackreport TYPE text
    USING attackreport::text;
    `);
    
    this.addSql(`
    CREATE TABLE IF NOT EXISTS bym.attack_log_watchers (
        id serial PRIMARY KEY,
        basesaveid integer NOT NULL REFERENCES bym.save(basesaveid) ON DELETE CASCADE,
        attacklogid integer NOT NULL REFERENCES bym.attack_logs(id) ON DELETE CASCADE,
        created_at timestamp with time zone NOT NULL DEFAULT now()
    );
    `);

    this.addSql(`
    CREATE OR REPLACE FUNCTION bym.register_attacklog_watch(p_basesaveid integer, p_attacklogid integer)
    RETURNS void LANGUAGE plpgsql AS $$
    BEGIN
        INSERT INTO bym.attack_log_watchers (basesaveid, attacklogid, created_at)
        VALUES (p_basesaveid, p_attacklogid, now());
    END;
    $$;
    `);

    this.addSql(`
    CREATE OR REPLACE FUNCTION bym.attack_log_watch_on_save_update()
    RETURNS trigger LANGUAGE plpgsql AS $$
    DECLARE
        rec record;
    BEGIN
        IF (OLD.attackid IS DISTINCT FROM NEW.attackid) THEN
            IF NEW.attackid = 0 THEN
                FOR rec IN SELECT attacklogid FROM bym.attack_log_watchers WHERE basesaveid = NEW.basesaveid
                LOOP
                    UPDATE bym.attack_logs
                    SET attackreport = NEW.attackreport
                    WHERE id = rec.attacklogid;
                END LOOP;
            END IF;
            DELETE FROM bym.attack_log_watchers WHERE basesaveid = OLD.basesaveid;
        END IF;
        RETURN NEW;
    END;
    $$;
    `);

    this.addSql(`
    CREATE TRIGGER trigger_attack_log_watch_on_save_update
    AFTER UPDATE ON bym.save
    FOR EACH ROW
    EXECUTE FUNCTION bym.attack_log_watch_on_save_update();
    `);

    this.addSql(`
    CREATE OR REPLACE FUNCTION bym.process_expired_attack_log_watchers()
    RETURNS integer LANGUAGE plpgsql AS $$
    DECLARE
        rows_processed integer := 0;
        rec record;
    BEGIN
        FOR rec IN
            SELECT w.id as watcher_id, w.attacklogid, s.attackreport
            FROM bym.attack_log_watchers w
            JOIN bym.save s ON s.basesaveid = w.basesaveid
            WHERE w.created_at <= now() - interval '7 minutes'
        LOOP
            UPDATE bym.attack_logs SET attackreport = rec.attackreport WHERE id = rec.attacklogid;
            DELETE FROM bym.attack_log_watchers WHERE id = rec.watcher_id;
            rows_processed := rows_processed + 1;
        END LOOP;
        RETURN rows_processed;
    END;
    $$;
    `);
  }

  async down(): Promise<void> {
    this.addSql(`
    ALTER TABLE bym.attack_logs
    ALTER COLUMN attackreport TYPE jsonb
    USING attackreport::jsonb;
    `);

    this.addSql(`
    DROP FUNCTION IF EXISTS bym.process_expired_attack_log_watchers();
    DROP TRIGGER IF EXISTS trigger_attack_log_watch_on_save_update ON bym.save;
    DROP FUNCTION IF EXISTS bym.attack_log_watch_on_save_update();
    DROP FUNCTION IF EXISTS bym.register_attacklog_watch(p_basesaveid integer, p_attacklogid integer);
    DROP TABLE IF EXISTS bym.attack_log_watchers;
    `);
  }
}