const pool = require("../../config/database");
const usuarioModel = require("../../models/usuarios/usuarios.model");
const path = require("path");
const { obtenerRol } = require("../../utils/login.helper");
//Report pdf
const fs = require("fs");
const PDF = require("pdf-creator-node");
const { options1 } = require("../../config/pdf-creator");

module.exports = {
    showView : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const user = await usuarioModel.getSelf(req.user.id_usuario);
            res.render("usuarios/prfUser", {user});
        }
    },
    listUsers : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            if(req.query.page){
                let limit = 5;
                let desde = limit * (parseInt(req.query.page)-1);
                const result = await usuarioModel.getPrfsByPage(req.user.id_usuario, desde, limit);
                const count = await usuarioModel.sizePagesPrf(req.user.id_usuario, limit);
                if(result.length<=0){
                    res.json("No existe ningun usuario!");
                }else{
                    res.json({usuarios : result, page : req.query.page, total : count});
                }
            }else{
                res.json("Debe pedir una pagina (page)!")
            }
        }else if(rol == "PRF"){
            if(req.query.page && req.query.curso){
                let limit = 5;
                let desde = limit * (parseInt(req.query.page)-1);
                const result = await usuarioModel.getEstsByPage(req.user.id_usuario, desde, limit, req.query.curso);
                const count = await usuarioModel.sizePagesEst(req.user.id_usuario, limit, req.query.curso);
                if(result.length<=0){
                    res.json("No tiene ningun estudiante inscrito!");
                }else{
                    res.json({usuarios : result, page : req.query.page, total : count});
                    //res.json(result);
                }
            }else{
                res.json("Debe pedir (page) y (curso)!");
            }
        }
    },
    saveUser : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            if(!req.body.id_usuario){
                const result = await usuarioModel.savePrf(req.user.id_usuario, req.body);
                res.json({success : result});
            }else{
                const result = await usuarioModel.updatePrf(req.user.id_usuario, req.body);
                res.json({success : result});
            }
        }else if(rol == "PRF"){
            if(!req.body.id_usuario){
                const result = await usuarioModel.saveEst(req.user.id_usuario, req.body);
                res.json({ success : result});
            }else{
                const result = await usuarioModel.updateEst(req.user.id_usuario, req.body);
                res.json({success : result});
            }
        }
    },
    getUser : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const result = await usuarioModel.getPrfById(req.user.id_usuario, req.params.id);
            res.json(result);
        }else if(rol == "PRF"){
            const result = await usuarioModel.getEstById(req.user.id_usuario, req.params.id, req.query.curso);
            res.json(result);
        }
    },
    getPrfsByName : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const result = await usuarioModel.getPrfsByName(req.user.id_usuario, req.body.args);
            res.json(result);
        }else if(rol == "PRF"){
            const result = await usuarioModel.getEstsByName(req.user.id_usuario, req.body.args, req.body.curso);
            res.json(result);
        }
    },
    resetPassPrf : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const user = await usuarioModel.getPrfByUsername(req.user.id_usuario, req.body.username);
            if(user){
                const result = await usuarioModel.resetPassPrf(req.user.id_usuario, user);
                res.json({success : result});
            }else{
                res.json({fail : "No existe el usuario!"});
            }
        }else if(rol == "PRF"){
            const user = await usuarioModel.getEstByUsername(req.user.id_usuario, req.body.username);
            if(user){
                const result = await usuarioModel.resetPassEst(req.user.id_usuario, user);
                res.json({success : result});
            }else{
                res.json({fail : "No existe el usuario!"});
            }
        }
    },
    deletePrf : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const resp = await usuarioModel.deletePrf(req.user.id_usuario, req.params.id);
            res.json(resp);
        }else if(rol == "PRF"){
            const resp = await usuarioModel.deleteEst(req.user.id_usuario, req.params.id);
            res.json(resp);
        }
    },
    //NOW IT'S FOR PROFILE //utiliza OR y listo
    showProfile : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            let user = await usuarioModel.getSelf(req.user.id_usuario);
            res.render("usuarios/admProfile", {user});
        }else if(rol == "PRF"){
            const user = await usuarioModel.getSelf(req.user.id_usuario);
            res.render("usuarios/prfProfile", {user});
        }else if(rol== "EST"){
            let user = await usuarioModel.getSelf(req.user.id_usuario);
            const result = await pool.query(`
            select id_estilo from estudiante where id_usuario = $1`,[req.user.id_usuario]);
            user.id_estilo = result.rows[0].id_estilo;
            res.render("usuarios/estProfile", {user});
        }
    },
    photoProfile :  async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF" || rol == "EST"){
            let path_photo = "/uploads/"+req.user.username+path.extname(req.file.originalname);
            await usuarioModel.saveProfilePhoto(req.user.id_usuario, path_photo);
            res.redirect("/user/profile");
        }
    },
    saveName : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF" || rol == "EST"){
            if(req.body.nombre.length>0&&req.body.ap.length>0&&req.body.am.length>0){
                await usuarioModel.saveName(req.user.id_usuario, req.body);
            }
            
            res.redirect("/user/profile");
        }
    },
    saveFechaNac : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF" || rol == "EST"){
            await usuarioModel.saveFechaNac(req.user.id_usuario, req.body.fecha_nac);
            //req.flash("info", "Flash is back");
            res.redirect("/user/profile");
        }
    },
    saveSex : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF" || rol == "EST"){
            await usuarioModel.saveSex(req.user.id_usuario, req.body.sexo);
            res.redirect("/user/profile");
        }
    },
    saveTelefono : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF" || rol == "EST"){
            if(req.body.telefono.length>0){
                await usuarioModel.saveTel(req.user.id_usuario, req.body.telefono);
            }
            res.redirect("/user/profile");
        }
    }, 
    savePass : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF" || rol == "EST"){
            await usuarioModel.savePassword(req.user.id_usuario, req.body.password);
            res.redirect("/user/profile");
        }
    },
    //Hacer uno extra para solo estudiantes para cambiar el estilo de aprendizaje
    saveStyle : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            await usuarioModel.saveStyle(req.user.id_usuario, req.body.estilo);
            res.redirect("/user/profile")
        }
    },
    //reporte usuarios
    reporte_usuarios : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF" || rol == "ADM"){
            let id_curso = parseInt(req.params.id);
            //#########
            const html = fs.readFileSync(path.join(__dirname,"../../views/report-template1.html"), "utf-8");
            const filename = req.user.username+"_report1"+".pdf";
            const result = await usuarioModel.getUsuariosReport1(req.user.id_usuario, id_curso);
            
            let document = {
                html: html,
                data: {
                  result : result,
                },
                path : path.join(__dirname, "../../public/docs/")+filename
                //path: "./docs/"+filename,
            }
            PDF
                .create(document, options1)
                .then((resp)=>{
                    res.json(filename);
                })
                .catch((error)=>{
                    res.json("Error al Generar el PDF");
                });
                
        }
        
    }
}