import express, { json, text } from "express";
import cors from "cors";
const app = express();
const port = 3001;

app.use(json(), cors(), text());

import highscores from "./routes/highScore.js";

app.use("/", highscores);

app.listen(port, () => {
	console.log(`Backend running on port: ${port}`);
});
