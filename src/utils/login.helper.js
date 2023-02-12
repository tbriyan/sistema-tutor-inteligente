const bcrypt = require("bcryptjs");
const pool = require("../config/database");
module.exports = {
    isLoggedIn(req, res, next) {
        if (req.isAuthenticated()) {
            return next();
        }
        res.redirect("/login");
    },
    isNotLoggedIn(req, res, next) {
        if (!req.isAuthenticated()) {
            return next();
        }
        res.redirect("/");
    },
    encriptarPassword: async (password) => {
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(password, salt);
        return hash;
    },
    compararPassword: async (password, savedPassword) => {
        return await bcrypt.compare(password, savedPassword);
    },
    obtenerRol: async (id_usuario) => {
        const result = await pool.query(`
        SELECT tipo FROM rol as r, usuario as u 
        WHERE u.id_usuario = $1 AND u.id_rol = r.id_rol`,
            [id_usuario]);
        return result.rows[0].tipo;
    },
    obtenerEstilo: async (id_usuario)=>{
        const result = await pool.query(`
        SELECT ea.estilo FROM estudiante e, estilo_aprendizaje ea 
        WHERE e.id_usuario = $1 and e.id_estilo = ea.id_estilo `,[id_usuario]);
        return result.rows[0];
    }
}