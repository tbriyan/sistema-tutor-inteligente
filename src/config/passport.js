const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;
const pool = require("./database");
const loginHelper = require("../utils/login.helper");

passport.use("login", new LocalStrategy({
    usernameField: "username",
    passwordField: "password",
    passReqToCallback: true

}, async (req, username, password, done) => {
    const result = await pool.query(`
        SELECT * FROM usuario WHERE username = $1
    `, [username]);
    if (result.rows.length > 0) {
        let user = result.rows[0];
        const passwordIsValid = await loginHelper.compararPassword(password, user.pass);
        if (!passwordIsValid) {
            return done(null, false, req.flash("message", "Contraseña incorrecta!"));
        }
        done(null, user);

    } else {
        return done(null, false, req.flash("message", "Usuario no encontrado!"));
    }
}));

passport.serializeUser((user, done) => {
    done(null, user.id_usuario);
});

passport.deserializeUser(async (id_usuario, done) => {
    const result = await pool.query("SELECT * FROM usuario WHERE id_usuario = $1", [id_usuario]);
    const user = result.rows[0]
    const rol = await pool.query(`SELECT tipo FROM rol WHERE id_rol =  $1`, [user.id_rol])
    const nuevoUsuario = {
        id_usuario: user.id_usuario,
        id_persona: user.id_persona,
        id_rol: user.id_rol,
        username: user.username,
        fecha_cre: user.fecha_cre,
        path_foto: user.path_foto,
        rol: rol.rows[0].tipo
    }
    // done(null, result.rows[0]);
    done(null, nuevoUsuario)
});