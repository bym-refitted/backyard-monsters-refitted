export interface TribeData {
  baseid: string;
  tribeHealthData: Record<string, number>;
  monsters?: Record<string, number>;
  destroyed?: number;
  destroyedAt?: number;
}
