const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;
const pool = require("./database");
const loginHelper = require("../utils/login.helper");

passport.use("login", new LocalStrategy({
    usernameField : "username",
    passwordField : "password",
    passReqToCallback : true

}, async (req, username, password, done)=>{
    const result = await pool.query(`
        SELECT * FROM usuario WHERE username = $1
    `,[username]);

    /*if(result.rows[0].id_rol == 2){
        console.log("Eeres un proefesor");
        let query = await pool.query(`
        SELECT disabled FROM profesor WHERE id_usuario = $1`,[user.id_usuario]);
        query = query.rows[0].disabled;
        if(!query){ // query = true => esta desabilitado eoc
            if(result.rows.length>0){
                let user = result.rows[0];
                const passwordIsValid = await loginHelper.compararPassword(password, user.pass);
                if(!passwordIsValid){
                    return done(null, false, req.flash("success", "Contraseña incorrecta!"));
                }
                done(null, user); //raiz
        
            }else{
                return done(null, false, req.flash("fail", "Usuario no encontrado!"));
            }
        }
    }*/
    //Si el id rol es 3 lo mismo

    if(result.rows.length>0){
        let user = result.rows[0];
        const passwordIsValid = await loginHelper.compararPassword(password, user.pass);
        if(!passwordIsValid){
            return done(null, false, req.flash("success", "Contraseña incorrecta!"));
        }
        done(null, user); //raiz

    }else{
        return done(null, false, req.flash("fail", "Usuario no encontrado!"));
    }
}));

passport.serializeUser((user, done)=>{
    done(null, user.id_usuario);
});

passport.deserializeUser(async (id_usuario, done)=>{
    const result = await pool.query("SELECT * FROM usuario WHERE id_usuario = $1", [id_usuario]);
    done(null, result.rows[0]);
});