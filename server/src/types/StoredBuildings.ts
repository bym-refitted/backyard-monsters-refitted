export type StoredBuildingKey = `b${number}`;

export type StoredBuildings = Partial<Record<StoredBuildingKey | `bl${number}`, number>>;

export type StoredBuildingCounts = Partial<Record<StoredBuildingKey, number>>;
