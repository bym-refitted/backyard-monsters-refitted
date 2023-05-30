import express, { Express } from 'express';
import routes from './app.routes.js';

const app: Express = express();
const port = 3001;

app.use(routes);
app.use(express.static('./public'));

app.listen(process.env.PORT || port,  () => console.log(`Server running on http://localhost:${port}`));

export default app;