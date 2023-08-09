const { Pool } = require("pg");
require('dotenv').config()

const pool = new Pool({
    user: process.env.DB_USERNAME,
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    password: process.env.DB_PASSWORD,
    port: Number(process.env.DB_PORT)
});
if (pool) {
    console.log("Database connected");
}

module.exports = pool;