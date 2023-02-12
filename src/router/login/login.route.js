const express = require("express");
const router = express.Router();
const passport = require("passport");
const pool = require("../../config/database");
//Imports
const { isLoggedIn, isNotLoggedIn, obtenerRol } = require("../../utils/login.helper");
const { getSelf } = require("../../models/usuarios/usuarios.model");
const { get_learning_style } = require("../../models/tutor/Model_pagina_principal");
//Rutas
router.get("/login", isNotLoggedIn, (req, res)=>{
    let message = req.flash("fail");
    res.render("index");
});
router.post("/login", isNotLoggedIn, (req, res, next)=>{
    passport.authenticate("login", {
        successRedirect : "/",
        failureRedirect : "/login",
        failureFlash : true
    })
    (req, res, next)
});
router.get("/", isLoggedIn, async(req, res)=>{
    const rol = await obtenerRol(req.user.id_usuario);
    if(rol == "ADM"){
        const user = await getSelf(req.user.id_usuario);
        res.render("usuarios/admUser", { user });
    }else if(rol == "PRF"){
        const user = await getSelf(req.user.id_usuario);
        res.render("cursos/prfCurso", { user });
    }else if(rol == "EST"){
        const user = await getSelf(req.user.id_usuario);
        const style = await get_learning_style(req.user.id_usuario);
        if(style){
            res.render("tutor/pagina_principal", { user });
        }else{
            res.render("tutor/pagina_learning_style");
        }
    }
});
router.get("/logout", isLoggedIn,  (req, res)=>{
    req.logout(()=>{
        res.redirect("/");
    });
})
module.exports = router;