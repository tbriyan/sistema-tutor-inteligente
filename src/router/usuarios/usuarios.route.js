const router = require("express").Router();
const controller = require("../../controllers/usuarios/usuarios.controller");
const {isLoggedIn} = require("../../utils/login.helper");
const { uploadPhotoProfile } = require("../../utils/usuarios.helper");

router.get("/", isLoggedIn, controller.showView);
router.get("/list", isLoggedIn, controller.listUsers);
router.post("/save", isLoggedIn, controller.saveUser);
router.post("/find", isLoggedIn, controller.getPrfsByName);
router.post("/reset", isLoggedIn, controller.resetPassPrf);
router.get("/:id/get", isLoggedIn, controller.getUser);
router.get("/:id/delete", isLoggedIn, controller.deletePrf);

router.get("/profile", isLoggedIn, controller.showProfile);
router.post("/photo-profile", isLoggedIn, uploadPhotoProfile, controller.photoProfile);
router.post("/profile/save-name", isLoggedIn, controller.saveName);
router.post("/profile/save-nac", isLoggedIn, controller.saveFechaNac);
router.post("/profile/save-sex", isLoggedIn, controller.saveSex);
router.post("/profile/save-tel", isLoggedIn, controller.saveTelefono);
router.post("/profile/save-pass", isLoggedIn, controller.savePass);
router.post("/profile/save-style", isLoggedIn, controller.saveStyle);
module.exports = router;