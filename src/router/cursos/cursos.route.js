const { isLoggedIn } = require("../../utils/login.helper");
const controller = require("../../controllers/cursos/cursos.controller");
const router = require("express").Router();

//FOr adm and prf
router.get("/list-r1", isLoggedIn, controller.showView);
router.get("/list-r1-listCursos", isLoggedIn, controller.listCourses_r1);
//Aqui se maneja PDF
router.get("/:id/report0", isLoggedIn, controller.generar_report0);
router.get("/:id/list-r1-estudiantes", isLoggedIn, controller.listEstudiantesByCourse);
//router.get("/:id", isLoggedIn, controller.showCurso);

//For Profesor
router.get("/list", isLoggedIn, controller.listCourses);
router.post("/save", isLoggedIn, controller.saveCourse);
router.post("/color", isLoggedIn, controller.changeColor);
router.get("/:id/get", isLoggedIn, controller.getCourse);
router.get("/:id/get-est", isLoggedIn, controller.getEst);
router.get("/:id/delete", isLoggedIn, controller.deleteCourse);
module.exports = router;