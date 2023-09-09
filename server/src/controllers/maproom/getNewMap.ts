import { KoaController } from "../../utils/KoaController";

export const getNewMap: KoaController = async (ctx) => {
    const cells = []; // Represents each cell
    const mapGrid = 500; // Represents the size of the map by width & height, must be kept at 500
  
    // Loops through each row and column of the map (X/Y co-ordinates) and creates a new cell
    for (let x = 0; x < mapGrid; x++) {
      for (let y = 0; y < mapGrid; y++) {
        cells.push({
          h: 0,
          t: 100,
        });
      }
    }
  
    const response = {
      newmap: true, // forces the player onto map room 3 and skips the migration process.
      mapheaderurl: "http://localhost:3001/api/bm/getnewmap", // Reminder: put in ENV
      width: 500,
      height: 500,
      data: cells,
      h: "someHashValue",
    };
  
    ctx.status = 200;
    ctx.body = response;
  };