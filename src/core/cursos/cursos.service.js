const cursosRepository = require("./cursos.repository");
const { getSelf } = require("../../core/usuarios/usuarios.repository");
//PDF-CREATOR
const fs = require("fs");
const path = require("path");
const PDF = require("pdf-creator-node");
const { options } = require("../../config/pdf-creator");
const { rolEnum } = require("../../utils/constantes");

module.exports = {
    listarCursosPorIdProfesor : async function(req, res){
        if(req.user.rol === rolEnum.PROFESOR){
            const result = await cursosRepository.listarCursosPorIdProfesor(req.user.id_usuario);
            res.json(result);
        }
    },
    guardar : async function(req, res){
        if(req.user.rol === rolEnum.PROFESOR){
            const result = await cursosRepository.guardar(req.user.id_usuario, req.body);
            res.json(result);
        }
    },
    cambiarColor : async function(req, res){
        if(req.user.rol == rolEnum.PROFESOR){
            const result = await cursosRepository.cambiarColor(req.body);
            res.json({success : result});
        }
    },
    obtenerCursoPorId : async function(req, res){
        if(req.user.rol == rolEnum.PROFESOR){
            const result = await cursosRepository.obtenerCursoPorId(req.user.id_usuario, req.params.id);
            res.json(result);
        }
    },
    deleteCourse : async function(req, res){
        if(req.user.rol === rolEnum.PROFESOR){
            const result = await cursosRepository.eliminarPorId(req.user.id_usuario, req.params.id);
            res.json(result);
        }
    },
    //For administrador
    showView : async function(req, res){
        if(req.user.rol === rolEnum.ADMINISTRADOR){
            const user = await getSelf(req.user.id_usuario);
            res.render("cursos/admCurso", {user});
        }
    },
    listCourses_r1 : async function(req, res){
        if(req.user.rol === rolEnum.ADMINISTRADOR){
            const prof_cursos = await cursosRepository.getCoursesPuntaje(req.user.id_usuario);
            res.json(prof_cursos);
        }
    },
    //########################### PDF - GENERAR #############################
    generar_report0 : async function(req, res){
        if(req.user.rol === rolEnum.ADMINISTRADOR || req.user.rol === rolEnum.PROFESOR){
            const html = fs.readFileSync(path.join(__dirname,"../../views/report-template0.html"), "utf-8");
            const filename = req.user.username+"_report0"+".pdf";
            const result = await cursosRepository.get_est_by_curso(req.user.id_usuario, req.params.id);
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
        if(req.user.rol === rolEnum.ADMINISTRADOR){
            const result = await cursosRepository.get_est_by_curso(req.user.id_usuario, req.params.id);
            res.json(result);         
        }
        if(req.user.rol === rolEnum.PROFESOR){
            const result = await cursosRepository.get_est_by_curso(req.user.id_usuario, req.params.id);
            res.json(result);
        }
    },
    getEst : async function(req, res){
        if(req.user.rol === rolEnum.PROFESOR){
            const result = await cursosRepository.get_point_est_by_id(req.user.id_usuario, req.params.id);
            res.json(result);         
        }
    }
}