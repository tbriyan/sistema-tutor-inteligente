const { Pool } = require("pg");
const pool = new Pool({
    user : "postgres",
    host : "localhost",
    database : "dbfinal",
    password : "postgres",
    port : 5432
});
if(pool){
    console.log("Database connected");
}

module.exports = pool;