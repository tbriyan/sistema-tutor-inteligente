const { Pool } = require("pg");
const pool = new Pool({
    user : "postgres",
    host : "localhost",
    database : "pgrado",
    password : "postgres"
});
if(pool){
    console.log("Database connected");
}

module.exports = pool;