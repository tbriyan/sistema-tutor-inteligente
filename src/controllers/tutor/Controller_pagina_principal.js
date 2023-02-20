const { obtenerRol, obtenerEstilo } = require("../../utils/login.helper");
const modelPaginaPrincipal = require("../../models/tutor/Model_pagina_principal");
const { getSelf } = require("../../models/usuarios/usuarios.model");
module.exports = {
    //Show Temas y Lecciones
    listLecciones : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            let result = await modelPaginaPrincipal.getLecciones(req.user.id_usuario);
            res.json(result);
        }
    },
    checkLeccion : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const checkEstadoLeccion = await modelPaginaPrincipal.getEstadoLeccion(req.user.id_usuario, req.params.id);
            res.json(checkEstadoLeccion);
        }
    },
    setCheckTema : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            await modelPaginaPrincipal.setStatusTema(req.user.id_usuario, req.body);
        }
    },
    getTema : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const estilo = await obtenerEstilo(req.user.id_usuario);
            let result = await modelPaginaPrincipal.getTema(req.params.id);
            let size = await modelPaginaPrincipal.getSizeLeccion(req.params.id);
            let ultimoTema = await modelPaginaPrincipal.getUltimoTema(req.params.id);
            //SI EXISTE EL ESTILO, PUEDO QUE AUN NO EXISTA SI ES POR PRIMERA VEZ
            //console.log(ultimoTema);
            result.estilo = estilo.estilo;
            result.sizeLeccion = size.count;
            result.es_ultimo = ultimoTema.es_ultimo_id;
            res.json({tema : result});
        }
    },

    //Controladores de ejercicio
    getEjercicio : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const result = await modelPaginaPrincipal.get_ejer_by_id(req.params.id);
            res.json(result);
        }
    },
    getPregunta : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const result = await modelPaginaPrincipal.get_pregunta_from_leccion(req.body.id_leccion, req.body.num);
            res.json(result);
        }
    },
    verificarPreg : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const result = await modelPaginaPrincipal.get_bool_respuesta(req.body);
            res.json(result);
        }
        
    },
    savePuntaje : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            //console.log(req.body);
            const result = await modelPaginaPrincipal.save_points(req.user.id_usuario, req.body);
            res.json(result);
        }
    },

    //COntroladores de Vistas

    get_view_evaluaciones : async function(req, res){
        const user = await getSelf(req.user.id_usuario);
        res.render("tutor/pagina_evaluaciones", {user})
    },
    get_view_avance : async function(req, res){
        const user = await getSelf(req.user.id_usuario);
        res.render("tutor/pagina_avance", {user})
    },
    get_view_maestro : async function(req, res){
        const user = await getSelf(req.user.id_usuario);
        res.render("tutor/pagina_maestro", {user})
    },
    get_view_practica : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "PRF"){
            const user = await getSelf(req.user.id_usuario);
            res.render("tutor/pagina_practicas", {user});
        }
    },
    //Controlador de vista evaluaciones
    get_puntaje : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const result = await modelPaginaPrincipal.get_puntaje(req.user.id_usuario);
            //const result1 = await modelPaginaPrincipal.get_puntaje_tema(req.user.id_usuario);
            console.log(result);
            res.json(result);
        }
    },
    //Controlador de vista avance
    get_avance : async function(req, res){
        const rol = await obtenerRol(req.user.id_usuario);
        if(rol == "EST"){
            const result = await modelPaginaPrincipal.get_avance(req.user.id_usuario);
            res.json(result);
        }
    },
    //Controladores de estilo de aprendizaje
    setStyle : async function(req, res){
        const result = await modelPaginaPrincipal.set_learning_style(req.user.id_usuario, req.body);
        if(result){
            res.redirect("/");
        }
    },

    //Controladores de ejercicio0
    obtenerEjercicio : async function(req, res){
        console.log(req.params.id);
        const result = await modelPaginaPrincipal.obtenerEjercicioTema(req.params.id);
        res.json(result);
    },
    setPuntajeEjercicio : async (req, res)=>{
        console.log(req.body.aciertos);
        console.log(req.body.tamanio);
        let puntaje = parseInt(req.body.aciertos)/parseInt(req.body.tamanio);
        console.log(puntaje);
        puntaje = puntaje.toFixed(2)*100;
        console.log(puntaje);
        const result = await modelPaginaPrincipal.setPuntajeEjercicio(req.user.id_usuario, puntaje, req.body.tema);
        return result;
    }
}