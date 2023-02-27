const bcrypt = require("bcryptjs");
const path = require("path");
const multer = require("multer");
const pool = require("../config/database");
const { memoryStorage } = require("multer");

//configuracion del destino y el nombre de la imagen
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, "../public/uploads"));
    },
    filename : function(req, file, cb){
        cb(null, req.user.username + path.extname(file.originalname));
    }
});
/*
const storageFile = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, path.join(__dirname, "../public/uploads"));
    },
    filename : function(req, file, cb){
        cb(null, file.originalname);
    }
});
*/
//instanciamos el middleware
const upload = multer({
    storage : storage,
    dest : path.join(__dirname, "../public/uploads")
}).single("profile");

const uploadFile = multer({
    storage : memoryStorage()
    //storage  :storageFile,
    //dest : path.join(__dirname, "../public/uploads")
}).single("file");

module.exports = {
    generarUsername : async function(nom, ap, am){
        //console.log("nombre:"+nom+" ap: "+ap+" am: "+am);
        let array = nom.split(" ");
        let usuario = array[0].charAt()+ap+am.charAt();
        const result = await pool.query(`
            select * from existe_usuario($1)
        `,[usuario]);
        if(result.rows[0].existe_usuario){
            return array[0].charAt()+array[0].charAt()+ap+am.charAt();
        }
        //console.log(result.rows[0].existe_usuario);
        return usuario;
    },
    encriptarPassword : async function(password){
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(password, salt);
        return hash;
    },
    uploadPhotoProfile : upload,
    uploadFile : uploadFile
}