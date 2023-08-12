const pool = require("../../config/database");
const { generarUsername, encriptarPassword } = require("../../utils/usuarios.helper");
module.exports = {
    getSelf : async function(id_usr){
        let result = await pool.query(`
        select * from getSelf($1)`,
        [id_usr]);
        if(result.rows[0].fecha_nac){
            let date = result.rows[0].fecha_nac;
            date = date.toISOString();
            date = date.split("T");
            result.rows[0].fecha_nac = date[0];
        }
        return result.rows[0];
    },
    saveProfilePhoto : async function(id_usr, path){
        await pool.query(`
        select saveProfilePhoto($1, $2)`,
        [id_usr, path]);
    },
    getPrfsByPage : async function(id_usr, desde, limit){
        const result = await pool.query(`
        select * from getPrfsByPage($1, $2, $3);`,
        [id_usr, desde, limit]);
        return result.rows;
    },
    sizePagesPrf : async function(id_usr, limit){
        const result = await pool.query(`
        select totalPrfs($1)`,
        [id_usr]);
        let total = Math.ceil(result.rows[0].totalprfs/limit);
        return total;
    },
    savePrf : async function(id_usr, data){
        const result = await pool.query(`
        select savePrf($1, $2, $3, $4, $5, $6, $7, $8);`,
        [id_usr, data.nombre, data.apellido1, data.apellido2, data.telefono, data.sexo, 
            await generarUsername(data.nombre, data.apellido1, data.apellido2),
        await encriptarPassword(data.apellido1)]);
        return result.rows[0].saveprf;
    },
    updatePrf : async function(id_usr, data){
        const result = await pool.query(`
        select updatePrf($1, $2, $3, $4, $5, $6, $7);`,
        [id_usr, data.id_usuario, data.nombre, data.apellido1, data.apellido2, data.telefono, data.sexo]);
        return result.rows[0].updateprf;
    },
    getPrfsByName : async function(id_usr, args){
        const result = await pool.query(`
        select * from getPrfsByName($1, $2);`,
        [id_usr, args]);
        return result.rows;
    },
    getPrfById : async function(id_usr, id_usr_prf){
        const result = await pool.query(`
        select * from getprfbyid($1, $2)`,
        [id_usr, id_usr_prf]);
        return result.rows[0];
    },
    getPrfByUsername : async function(id_usr, username){
        let prf = await pool.query(`
        select * from getPrfByUsername($1, $2)`, [id_usr, username]);
        prf = prf.rows[0];
        return prf;
    },
    resetPassPrf : async function(id_usr, user){
        const result = await pool.query(`
        select resetPassPrf($1, $2, $3);`, [id_usr, user.id_usuario, await encriptarPassword(user.apellido1)]);
        return result.rows[0].resetpassprf;
    },
    deletePrf : async function(id_usr, id_usr_prf){
        const result = await pool.query(`
        select * from eliminarPrf($1, $2)`,[id_usr, id_usr_prf]);
        return result.rows[0].eliminarprf;
    },
    //Eliminar profesor...
    //To students
    saveEst : async function(id_usr, data){
        const result = await pool.query(`
        select saveEst($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
        [id_usr, data.id_curso, data.nombre, data.apellido1, data.apellido2, data.telefono, data.sexo, 
        await generarUsername(data.nombre, data.apellido1, data.apellido2),
        await encriptarPassword(data.apellido1)]);
        return result.rows[0].saveest;
    },
    updateEst : async function(id_usr, data){
        const result = await pool.query(`
        select updateEst($1, $2, $3, $4, $5, $6, $7, $8);`,
        [id_usr, data.id_usuario, data.id_curso, data.nombre, data.apellido1, data.apellido2, data.telefono, data.sexo]);
        return result.rows[0].updateest;
    },
    getEstsByPage : async function(id_usr, desde, limit, curso){
        const result = await pool.query(`
        select * from getEstsByPage($1, $2, $3, $4)`,
        [id_usr, desde, limit, curso]);
        return result.rows;
    },
    sizePagesEst : async function(id_usr, limit, curso){
        const result = await pool.query(`
        select totalEsts($1, $2)`,
        [id_usr, curso]);
        let num_pag = Math.ceil(result.rows[0].totalests/limit);
        return num_pag;
    },
    getEstById : async function(id_usr, id_usr_est, id_curso){
        const result = await pool.query(`
        select * from getEstById($1, $2, $3)`,
        [id_usr, id_usr_est, id_curso]);
        return result.rows[0];
    },
    getEstsByName : async function(id_usr, args, id_curso){
        const result = await pool.query(`
        select * from getEstsByName($1, $2, $3);`,
        [id_usr, id_curso, args]);
        return result.rows;
    },
    getEstByUsername : async function(id_usr, username){
        let est = await pool.query(`
        select * from getEstByUsername($1, $2)`, [id_usr, username]);
        est = est.rows[0];
        return est;
    },
    resetPassEst : async function(id_usr, user){
        const result = await pool.query(`
        select resetPassEst($1, $2, $3);`, [id_usr, user.id_usuario, await encriptarPassword(user.apellido1)]);
        return result.rows[0].resetpassest;
    },
    deleteEst : async function(id_usr, id_usr_est){
        const result = await pool.query(`
        select eliminarEst($1,$2)`,[id_usr, id_usr_est]);
        return result.rows[0].eliminarest;
    },
    //FOR PROFILE
    saveName : async function(id_usr, data){
        const result = await pool.query(`
        select saveName($1, $2, $3, $4)`,
        [id_usr, data.nombre, data.ap, data.am]);
        return result.rows[0].savename;
    },
    saveFechaNac : async function(id_usr, fecha){
        const result = await pool.query(`
        select saveFechaNac($1, $2)`,
        [id_usr, fecha]);
        return result.rows[0].savefechanac;
    },
    saveSex : async function(id_usr, sex){
        const result = await pool.query(`
        select saveSex($1, $2)`,
        [id_usr, sex]);
        return result.rows[0].savesex;
    },
    saveTel : async function(id_usr, tel){
        const result = await pool.query(`
        select saveTel($1, $2)`,
        [id_usr, tel]);
        return result.rows[0].savetel;
    },
    savePassword : async function(id_usr, pass){
        const result = await pool.query(`
        select savePassword($1, $2)`,
        [id_usr, await encriptarPassword(pass)]);
        return result.rows[0].savepassword;
    },
    saveStyle : async function(id_usr, style){
        pool.query(`
        update estudiante set id_estilo = $1 where id_usuario = $2`,[Number(style), id_usr]);
    },
    getUsuariosReport1 : async function(id_usr, id_curso){
        const result = await pool.query(`
            select * from fn_reporte_generar_usuarios_estudiantes($1, $2)
        `,[id_usr, id_curso]);
        //console.log(result.rows);
        return result.rows;
    },
    generar_usuarios : async function(id_usr, id_curso, data){
        data.shift();
        let existentes = [];
        let v_aux;
        let nombre;
        let ape1;
        let ape2;
        let sexo;
        let result;
        let flag = true;
        console.log(data[0][0].split(" ").length);
        for (const element of data) {
            v_aux = element[0].trim().split(" ");
            switch (v_aux.length) {
                case 4:
                    ape1 = v_aux[0].toLowerCase();
                    ape2 = v_aux[1].toLowerCase();
                    nombre = v_aux[2].toLowerCase()+" "+v_aux[3].toLowerCase();
                    if(element[1]){
                        sexo = element[1].toUpperCase();
                    }else{
                        sexo = "";
                    }
                    break;
                case 3:
                    ape1 = v_aux[0].toLowerCase();
                    ape2 = v_aux[1].toLowerCase();
                    nombre = v_aux[2].toLowerCase();
                    if(element[1]){
                        sexo = element[1].toUpperCase();
                    }else{
                        sexo = "";
                    }
                    break;
                case 2:
                    ape1 = v_aux[0].toLowerCase();
                    ape2 = "";
                    nombre = v_aux[1].toLowerCase();
                    if(element[1]){
                        sexo = element[1].toUpperCase();
                    }else{
                        sexo = "";
                    }
                    break;
                default:
                    ape1 = v_aux[0].toLowerCase();
                    ape2 = v_aux[1].toLowerCase();
                    nombre = v_aux[2].toLowerCase()+" "+v_aux[3].toLowerCase();
                    if(element[1]){
                        sexo = element[1].toUpperCase();
                    }else{
                        sexo = "";
                    }
                    break;
            }
            result = await pool.query(`
            select * from guardar_lote_estudiante($1, $2, $3, $4, $5, $6, $7, $8)
            `, [id_usr, id_curso, nombre, ape1, ape2, sexo,
                await generarUsername(nombre, ape1, ape2),
                await encriptarPassword(ape1)]);
            
            if(result.rows[0].oestado==0){
                flag = false;
                /*let object = {
                    nombre,
                    ape1,
                    ape2,
                    sexo
                }
                existentes.push(object);*/
                break;
            }
        }
        if(flag==1){
            return {
                omensaje : "Usuarios importados exitosamente",
                oestado : 1}
        }else{
            return {
                omensaje : "Usuarios existentes, no se importo",
                oestado : 0
                //lista : existentes
            }
        }
    }
}