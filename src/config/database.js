const { Pool } = require("pg");
const pool = new Pool({
    //Condiguración local
    /*user : "postgres",
    host : "localhost",
    database : "dbfinal",
    password : "postgres",
    port : 5432*/
    //Configuracion server
    user : "admin",
    host : "localhost",
    database : "testing",
    password : "71287",
    port : 5432
});
if(pool){
    console.log("Database connected");
}

module.exports = pool;