const bcrypt = require("bcryptjs");
const pool = require("./src/config/database");

async function crearSM(nombre, ap1, ap2, sexo, username, password){
    //Crear persona
    let p_sql = `
    INSERT INTO persona(nombre, apellido1, apellido2, sexo)
        VALUES($1, $2, $3, $4) RETURNING id_persona;
    `;
    let p_val = [nombre, ap1, ap2, sexo];
    let p_res = await pool.query(p_sql, p_val);
    p_res = p_res.rows[0].id_persona;
    console.log(p_res);
    //Crear usuario
    let date = new Date();
    let fecha = String(date.getDate()).padStart(2, '0') + '/' + String(date.getMonth() + 1).padStart(2, '0') + '/' + date.getFullYear();
    let u_sql = "INSERT INTO usuario(id_persona, id_rol, username, pass, fecha_cre) VALUES($1, 1, $2, $3, $4) RETURNING id_usuario";
    let u_val = [p_res, username, await encriptarPassword(password), fecha];
    let u_res = await pool.query(u_sql, u_val);
    u_res = u_res.rows[0].id_usuario;
    //Crear adm
    await pool.query("INSERT INTO administrador(id_usuario) VALUES($1)", [u_res]);
}
crearSM("briyan", "torrez", "vargas", "M", "bjtorrez", "1234");
//crearSM("enrique", "coarite", "", "M", "ecoarite", "1234");

async function encriptarPassword(password){
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);
    return hash;
}
