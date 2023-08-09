const { isLoggedIn } = require("../../utils/login.helper");
const cursosService = require("./cursos.service");
const router = require("express").Router();

//FOr adm and prf
router.get("/list-r1", isLoggedIn, cursosService.showView);
router.get("/list-r1-listCursos", isLoggedIn, cursosService.listCourses_r1);
//Aqui se maneja PDF
router.get("/:id/report0", isLoggedIn, cursosService.generar_report0);
router.get("/:id/list-r1-estudiantes", isLoggedIn, cursosService.listEstudiantesByCourse);
//router.get("/:id", isLoggedIn, cursosService.showCurso);

//For Profesor
router.get("/list", isLoggedIn, cursosService.listarCursosPorIdProfesor);
router.post("/save", isLoggedIn, cursosService.guardar);
router.post("/color", isLoggedIn, cursosService.cambiarColor);
router.get("/:id/get", isLoggedIn, cursosService.obtenerCursoPorId);
router.get("/:id/get-est", isLoggedIn, cursosService.getEst);
router.get("/:id/delete", isLoggedIn, cursosService.deleteCourse);
module.exports = router;