require('dotenv').config()
const express = require("express");
const app = express();
const path = require("path");
const session = require("express-session");
const passport = require("passport");
const flash = require("connect-flash");
//const multer = require("multer");
//Imports
const loginRouter = require("./router/login/login.route");
const usuariosRouter = require("./core/usuarios/usuarios.route");
const cursosRouter = require("./core/cursos/cursos.route");
const tutorRouter = require("./core/tutor/tutor.route");
//Inicializaciones
require("./config/passport");
//Settings
app.set("port", process.env.PORT || 80);
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");
//Middlewares
app.use(express.static(path.join(__dirname, "public")));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(flash());
app.use(session({
    secret: "sti-fni",
    resave: false,
    saveUninitialized: false
}));
app.use(passport.initialize());
app.use(passport.session());
//Global Variables
app.use((req, res, next) => {
    app.locals.user = req.user;
    next()
})
//Routes
app.use("/", loginRouter);
app.use("/user", usuariosRouter);
app.use("/course", cursosRouter);
app.use("/tutor", tutorRouter);

app.listen(app.get("port"), () => {
    console.log("Server on port : " + app.get("port"));
})