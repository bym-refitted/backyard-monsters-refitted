import express, { Express } from "express";
import routes from "./app.routes.js";
import fs from "fs";

const app: Express = express();
const port = 3001;

app.use(routes);

app.get("/crossdomain.xml", (_: any, res) => {
  res.set("Content-Type", "text/xml");
  
  const crossdomain = fs.readFileSync("./crossdomain.xml");
  res.send(crossdomain);
});

app.use(express.static("./public"));

app.listen(process.env.PORT || port, () =>
  console.log(`Server running on http://localhost:${port}`)
);

export default app;
