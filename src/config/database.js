const { Pool } = require("pg");
const pool = new Pool({
    //Condiguración local
    /*user : "postgres",
    host : "localhost",
    database : "dbfinal",
    password : "postgres",
    port : 5432*/
    //Configuracion server
    user : "postgres",
    host : "localhost",
    database : "db_quimtutor",
    password : "postgres",
    port : 5432
});
if(pool){
    console.log("Database connected");
}

module.exports = pool;