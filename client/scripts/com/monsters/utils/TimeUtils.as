package com.monsters.utils
{
   public class TimeUtils
   {

      public function TimeUtils()
      {
         super();
      }

      /**
       * Renders how long ago a timestamp was, as "19 hours ago", using the same
       * localised units the mailbox uses. Extracted from InboxMessage so the
       * alliance shout rows can share it - the original rendered both through
       * one relative-time helper.
       *
       * @param timestamp Seconds since epoch, as GLOBAL.Timestamp() returns.
       * @return The localised distance string.
       */
      public static function TimeDistance(timestamp:Number) : String
      {
         var unitKey:String = null;
         var elapsed:int = GLOBAL.Timestamp() - timestamp;
         var amount:int = 0;

         // GLOBAL.Timestamp() is the last base-processing time rather than a live
         // clock, so anything stamped server-side just now can read as the future.
         if(elapsed < 0)
         {
            elapsed = 0;
         }

         if(elapsed < 60)
         {
            unitKey = (amount = elapsed) == 1 ? "mail_time_second" : "mail_time_seconds";
         }
         else if(elapsed < 60 * 60)
         {
            unitKey = (amount = int(elapsed / 60)) == 1 ? "mail_time_minute" : "mail_time_minutes";
         }
         else if(elapsed < 60 * 60 * 24)
         {
            unitKey = (amount = int(elapsed / 60 / 60)) == 1 ? "mail_time_hour" : "mail_time_hours";
         }
         else if(elapsed < 60 * 60 * 24 * 7)
         {
            unitKey = (amount = int(elapsed / 60 / 60 / 24)) == 1 ? "mail_time_day" : "mail_time_days";
         }
         else if(elapsed < 60 * 60 * 24 * 7 * 31)
         {
            unitKey = (amount = int(elapsed / 60 / 60 / 24 / 7)) == 1 ? "mail_time_week" : "mail_time_weeks";
         }
         else
         {
            unitKey = (amount = int(elapsed / 60 / 60 / 24 / 7 / 31)) == 1 ? "mail_time_month" : "mail_time_months";
         }

         return KEYS.Get("mail_time_ago",{
            "v1":amount,
            "v2":KEYS.Get(unitKey)
         });
      }
   }
}
