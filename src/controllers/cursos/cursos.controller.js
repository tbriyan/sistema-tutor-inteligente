const { obtenerRol } = require("../../utils/login.helper");
const cursosModel = require("../../models/cursos/cursos.model");
const { getSelf } = require("../../models/usuarios/usuarios.model");
//PDF-CREATOR
const fs = require("fs");
const path = require("path");
const PDF = require("pdf-creator-node");
const { options } = require("../../config/pdf-creator");

module.exports = {
    listCourses : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const result = await cursosModel.getCourses(req.user.id_usuario);
            res.json(result);
        }
    },
    saveCourse : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const result = await cursosModel.saveCourse(req.user.id_usuario, req.body);
            res.json(result);
        }
    },
    changeColor : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const result = await cursosModel.changeColor(req.body);
            res.json({success : result});
        }
    },
    getCourse : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const result = await cursosModel.getCourseById(req.user.id_usuario, req.params.id);
            res.json(result);
        }
    },
    deleteCourse : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const result = await cursosModel.deleteCourseById(req.user.id_usuario, req.params.id);
            res.json(result);
        }
    },
    //For administrador
    showView : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const user = await getSelf(req.user.id_usuario);
            res.render("cursos/admCurso", {user});
        }
    },
    listCourses_r1 : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const prof_cursos = await cursosModel.getCoursesPuntaje(req.user.id_usuario);
            res.json(prof_cursos);
        }
    },
    //########################### PDF - GENERAR #############################
    generar_report0 : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM" || rol == "PRF"){
            const html = fs.readFileSync(path.join(__dirname,"../../views/report-template0.html"), "utf-8");
            const filename = req.user.username+"_report0"+".pdf";
            const result = await cursosModel.get_est_by_curso(req.user.id_usuario, req.params.id);
            let document = {
                html: html,
                data: {
                  result : result,
                },
                path : path.join(__dirname, "../../public/docs/")+filename
                //path: "./docs/"+filename,
            }
            PDF
                .create(document, options)
                .then((resp)=>{
                    console.log(resp);
                    res.json(filename);
                })
                .catch((error)=>{
                    console.log(error);
                    res.json("Error al Generar el PDF");
                });
            //const filepath = filename;//JUGAR CON LA RUTA DE ESTO EN SERVEERRRRRR
            //res.json(filepath);
        }

    },
    listEstudiantesByCourse : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "ADM"){
            const result = await cursosModel.get_est_by_curso(req.user.id_usuario, req.params.id);
            res.json(result);         
        }
        if(rol == "PRF"){
            const result = await cursosModel.get_est_by_curso(req.user.id_usuario, req.params.id);
            res.json(result);
        }
    },
    getEst : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const result = await cursosModel.get_point_est_by_id(req.user.id_usuario, req.params.id);
            res.json(result);         
        }
    }
}