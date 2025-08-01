import { KoaController } from "../../../utils/KoaController";
import { Status } from "../../../enums/StatusCodes";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { ORMContext } from "../../../server";
import { BaseType } from "../../../enums/Base";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";

/**
 * Controller to get inferno neighbours for PvP matchmaking.
 * 
 * This system pulls real player inferno bases that are within a similar level range
 * to the current user (±3 levels). It uses the calculateBaseLevel function to determine
 * player levels based on their points and basevalue, then returns up to 20 neighbours
 * for the inferno map room.
 */
export const getNeighbours: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save", "infernosave"]);

  try {
    // Get the current user's inferno save to calculate their level
    let infernoSave = user.infernosave;
  
    // Calculate the user's current inferno level
    const userLevel = calculateBaseLevel(infernoSave.points, infernoSave.basevalue);
    
    // Find potential neighbours with inferno saves (excluding current user)
    // We get more than 20 initially to have options after level filtering
    const potentialNeighbours = await ORMContext.em.find(Save, {
      type: BaseType.INFERNO,
      userid: { $ne: user.userid }, // Exclude current user
    }, {
      limit: 100, // Get more candidates to filter by level
    });
    
    // Define level range for matchmaking (±3 levels provides good balance)
    const levelRange = 3;
    const minLevel = Math.max(1, userLevel - levelRange);
    const maxLevel = userLevel + levelRange;
    
    // Filter neighbours by calculated level and prepare response data
    const neighbours = [];
    
    // Get user IDs that we need to fetch
    const userIds = [];
    const validNeighbours = [];
    
    for (const neighbourSave of potentialNeighbours) {
      const neighbourLevel = calculateBaseLevel(neighbourSave.points, neighbourSave.basevalue);
      
      // Only include neighbours within the level range
      if (neighbourLevel >= minLevel && neighbourLevel <= maxLevel) {
        validNeighbours.push({ save: neighbourSave, level: neighbourLevel });
        userIds.push(neighbourSave.userid);
        
        // Stop once we have enough candidates
        if (validNeighbours.length >= 20) {
          break;
        }
      }
    }
    
    // Fetch user data for all valid neighbours in one query
    const neighbourUsers = await ORMContext.em.find(User, {
      userid: { $in: userIds }
    });
    
    // Create a map for quick lookup
    const userMap = new Map();
    neighbourUsers.forEach(user => {
      userMap.set(user.userid, user);
    });
    
    // Build the final response
    for (const { save: neighbourSave, level: neighbourLevel } of validNeighbours) {
      const neighbourUser = userMap.get(neighbourSave.userid);
      
      if (neighbourUser) {
        neighbours.push({
          baseid: parseInt(neighbourSave.baseid),
          level: neighbourLevel,
          type: "inferno",
          description: "Inferno Base",
          wm: 0,
          friend: 0,
          pic: neighbourUser.pic_square || "",
          basename: `${neighbourUser.username}'s Inferno`,
          saved: neighbourSave.lastupdate,
          userid: neighbourSave.userid,
          attackpermitted: 1,
        });
      }
    }
    
    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      wmbases: [],
      bases: neighbours,
    };
  } catch (error) {
    console.error("Error fetching inferno neighbours:", error);
    
    // Return empty array on error rather than failing completely
    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      wmbases: [],
      bases: [],
    };
  }
};
