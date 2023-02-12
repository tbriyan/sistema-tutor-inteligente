const bcrypt = require("bcryptjs");
const path = require("path");
const multer = require("multer");
const pool = require("../config/database");

//configuracion del destino y el nombre de la imagen
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, "../public/uploads"));
    },
    filename : function(req, file, cb){
        cb(null, req.user.username + path.extname(file.originalname));
    }
});
//instanciamos el middleware
const upload = multer({
    storage : storage,
    dest : path.join(__dirname, "../public/uploads")
}).single("profile");

module.exports = {
    generarUsername : async function(nom, ap, am){
        let array = nom.split(" ")
        return array[0].charAt()+ap+am.charAt();
    },
    encriptarPassword : async function(password){
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(password, salt);
        return hash;
    },
    uploadPhotoProfile : upload
}