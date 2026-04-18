import { legionnaire } from "./legionnaire.js";
import { kozu } from "./kozu.js";
import { abunaki } from "./abunaki.js";
import { dreadnaught } from "./dreadnaught.js";

export { legionnaire, kozu, abunaki, dreadnaught };

export const MR1_TRIBE_IDS = new Set(
  [legionnaire, kozu, abunaki, dreadnaught].flatMap((tribe) =>
    Object.values(tribe).map((entry) => entry.baseid)
  )
);
