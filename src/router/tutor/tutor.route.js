const { isLoggedIn } = require("../../utils/login.helper");
const controller = require("../../controllers/tutor/Controller_pagina_principal");
const router = require("express").Router();

//Rutas de Lecciones y Temas
router.get("/list", isLoggedIn, controller.listLecciones);
router.get("/:id/tema", isLoggedIn, controller.getTema);
router.get("/:id/checkLeccion", isLoggedIn, controller.checkLeccion);
router.post("/checkTema", isLoggedIn, controller.setCheckTema);

//Rutas de Ejercicios
router.get("/:id/ejercicio", isLoggedIn, controller.getEjercicio);
router.post("/pregunta", isLoggedIn, controller.getPregunta);
router.post("/verif", isLoggedIn, controller.verificarPreg);
router.post("/sp", isLoggedIn, controller.savePuntaje);

//Rutas de Vistas
router.get("/evaluaciones", isLoggedIn, controller.get_view_evaluaciones);
router.get("/avance", isLoggedIn, controller.get_view_avance);
router.get("/maestro", isLoggedIn, controller.get_view_maestro);
router.get("/practica", isLoggedIn, controller.get_view_practica);

//Ruta de Vista evaluaciones
router.get("/puntaje", isLoggedIn, controller.get_puntaje);
//Ruta de Vista Avance
router.get("/avance-general", isLoggedIn, controller.get_avance);

//Ruta estilo de aprendizaje
router.post("/style", isLoggedIn, controller.setStyle);

//Ruta ejercicio0
router.get("/:id/tema-ejercicios", isLoggedIn, controller.obtenerEjercicio);
module.exports = router;