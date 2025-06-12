import dotenv from "dotenv";
import { createConnection } from "mysql2";

dotenv.config();
const db = createConnection({
	host: process.env.DB_HOST,
	user: process.env.DB_USER,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_NAME,
	port: process.env.DB_PORT,
});

export default db.promise();
