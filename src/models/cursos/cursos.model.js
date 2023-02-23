const pool = require("../../config/database")

module.exports = {
    getCourses : async function(id_usr_prf){
        let result = await pool.query(`
        select * from getCourses($1)`,
        [id_usr_prf]);
        for (const curso of result.rows) {
            let cant_estudiantes = await pool.query(`
            select count(*) from estudiante e where e.id_curso = $1 and e.disabled = false`,[curso.id_curso]);
            curso.total = cant_estudiantes.rows[0].count;
        }
        return result.rows;
    },
    saveCourse : async function(id_usr_prf, data){
        const result = await pool.query(`
        select * from saveCourse($1, $2, $3);`
        ,[id_usr_prf, data.grado, data.paralelo]);
        return result.rows[0];
    },
    changeColor : async function(data){
        const result = await pool.query(`
        select cambiarColor($1, $2);`
        ,[data.id_curso, data.color]);
        return result.rows[0].cambiarcolor;
    },
    getCourseById : async function(id_usr_prf, id_curso){
        const result = await pool.query(`
        select * from getCourseById($1, $2);`
        ,[id_usr_prf, id_curso]);
        return result.rows[0];
    },
    deleteCourseById : async function(id_usr, id_curso){
        const result = await pool.query(`
        select * from deleteCourse($1, $2);`
        ,[id_usr, id_curso]);
        return result.rows[0].deletecourse;
    },
    getCoursesPuntaje : async function(id_usr_adm){
        let profList = await pool.query(`
        select * from profesor 
        where id_adm = (select a.id_adm from administrador a where a.id_usuario = $1) and disabled = false
        order by id_prof asc`
        ,[id_usr_adm]);
        for (const prf of profList.rows) {
            let curso = await pool.query(`
            select * from curso c where c.id_prof = $1 and c.disabled = false order by id_curso asc`,[prf.id_prof]);
            let nombre = await pool.query(`
            select p.nombre||' '||p.apellido1||' '||p.apellido2 nombre from persona p, usuario u where u.id_persona = p.id_persona and u.id_usuario = $1`
            ,[prf.id_usuario]);
            prf.nombre = nombre.rows[0].nombre;
            prf.curso = curso.rows;
        }
        for (const prf of profList.rows) {
            for (const curso of prf.curso) {
                let progreso =  await pool.query(`
                select (sum(t.promedio)::numeric/count(*)::numeric)::decimal(4,2) total
                    from (
                    	select ee.id_estudiante, (sum(ee.puntaje)::numeric/2::numeric) promedio 
                    	from estudiante_ejercicio ee, estudiante e where e.id_estudiante = ee.id_estudiante and e.disabled = false and e.id_curso = $1 
                    	group by ee.id_estudiante 
                    ) t`
                ,[curso.id_curso]);
                if(parseFloat(progreso.rows[0].total)){
                    curso.progreso = parseFloat(progreso.rows[0].total);
                }else{
                    curso.progreso = 0;
                }
            }
        }
        return profList.rows;
    },
    get_est_by_curso : async function(id_usr_adm, id_curso){
        let listEst = await pool.query(`
        select e.id_estudiante, e.id_usuario from estudiante e 
        where e.id_curso = $1 and e.disabled = false order by e.id_estudiante asc`
        ,[id_curso]);
        for (const estudiante of listEst.rows) {
            let notasEvaluacion = await pool.query(`
            select ee.id_ejercicio, ee.puntaje  
                from estudiante_ejercicio ee where ee.id_estudiante = $1 order by ee.id_ejercicio asc`
            ,[estudiante.id_estudiante]);
            estudiante.notas_evaluacion = notasEvaluacion.rows;
            let promedio_evaluacion = await pool.query(`
                select (coalesce(sum(ee.puntaje), 0)::numeric/2::numeric)::decimal(4,2) promedio
                from estudiante_ejercicio ee 
                where ee.id_estudiante = $1
            `,[estudiante.id_estudiante]);
            estudiante.promedio_evaluacion = parseInt(promedio_evaluacion.rows[0].promedio);
            let notasEjercicios = await pool.query(`
            select cast(round(
                SUM(et.puntaje)/(select count(*) 
                from tema tt 
                where tt.id_leccion = t.id_leccion)
                ) as integer) as promedio
            from estudiante_tema et, tema t
            where et.id_estudiante = $1 and et.id_tema = t.id_tema
            group by t.id_leccion
            order by t.id_leccion asc
            `,[estudiante.id_estudiante]);
            notasEjercicios = notasEjercicios.rows;
            estudiante.notas_ejercicio = notasEjercicios;
            let promedio_ej_aux = 0;
            notasEjercicios.forEach(nota => {
                if(nota.promedio != null){
                    promedio_ej_aux += nota.promedio;
                }
            });
            promedio_ej_aux = promedio_ej_aux/notasEjercicios.length;
            estudiante.promedio_ejercicio = promedio_ej_aux;
            let nombre = await pool.query(`
            select p.nombre||' '||p.apellido1||' '||p.apellido2 nombre, p.sexo from persona p, usuario u where u.id_persona = p.id_persona and u.id_usuario = $1`
            ,[estudiante.id_usuario]);
            estudiante.persona = nombre.rows[0];
        }
        return listEst.rows;
    },
    get_point_est_by_id : async function(is_usr, id_usr_est){
        let estudiante = await pool.query(`
        select p.nombre, p.apellido1, p.apellido2, p.telefono, p.sexo, p.fecha_nac, e.id_estilo 
        from usuario u, persona p, estudiante e 
        where u.id_usuario  = $1 and u.id_persona = p.id_persona and u.id_usuario = e.id_usuario`
        ,[id_usr_est]);
        let foto = await pool.query(`
        select path_foto from usuario where id_usuario = $1`,[id_usr_est]);
        estudiante.rows[0].path_foto = foto.rows[0].path_foto;
        let notas = await pool.query(`
        select ee.id_ejercicio, ee.puntaje, ee.fecha from estudiante_ejercicio ee, estudiante e 
        where ee.id_estudiante = e.id_estudiante and e.id_usuario = $1
        order by ee.id_ejercicio asc`
        ,[id_usr_est]);
        let titulos = await pool.query(`
        select * from leccion order by id_leccion asc`);
        notas.rows.forEach((nota, index) => {
            nota.titulo = titulos.rows[index].titulo;
        });
        estudiante.rows[0].notas = notas.rows;
        let promedio = await pool.query(`
        select (sum(ee.puntaje)::numeric/2::numeric)::decimal(4,2) promedio from estudiante_ejercicio ee, estudiante e 
        where ee.id_estudiante = e.id_estudiante and e.id_usuario = $1`
        ,[id_usr_est]);
        estudiante.rows[0].promedio = promedio.rows[0].promedio;
        let hoja_estilo = await pool.query(`
        select ar, si, vv, sg from hoja_estilo 
        where id_estudiante = (select id_estudiante from estudiante where id_usuario = $1)`,[id_usr_est]);
        estudiante.rows[0].hoja_estilo = hoja_estilo.rows[0];
        return estudiante.rows[0];
    }
}