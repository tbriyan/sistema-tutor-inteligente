const pool = require("../../config/database");
module.exports = {
    //show Panel and Select Temas
    getLecciones: async function (id_usr) {
        let result = await pool.query(`
        select * from get_lecciones_by_id_usr($1)`, [id_usr]);
        result = result.rows;
        let array = [];
        result.forEach(item => {
            array.push(item.id_leccion);
        });
        let i = 0;
        for (const id of array) {
            let query = await pool.query(`
            select * from get_temas_by_leccion($1, $2)`, [id_usr, id]);
            result[i].temas = query.rows;
            i += 1;
        }
        i = 0;
        for (const id of array) {
            let query = await pool.query(`
            select * from get_ejercicio_by_leccion($1, $2)`, [id_usr, id]);
            result[i].ejercicio = query.rows[0];
            i += 1;
        }
        return result;
    },
    getSizeLeccion : async function(id_tema){
        const result = await pool.query(`
        select count(*) from tema t 
        where t.id_leccion = (select id_leccion from tema te where te.id_tema = $1); `,[id_tema]);
        return result.rows[0];
    },
    getTema: async function (id_tema) {
        const result = await pool.query(`
        select * from obtener_tema($1)`, [id_tema]);
        return result.rows[0];
    },
    getEstadoLeccion : async function(id_usr, id_leccion){
        //PEDIR TEMAS POR LECCION
        let temas = await pool.query(`
        select * from getStatusTemas($1, $2) `,[id_usr, parseInt(id_leccion)]);
        temas = temas.rows;
        let flag = true;
        temas.forEach(tema => {
            if(!tema.estado){
                flag = false;
            }
        });
        if(flag == true){
            await pool.query(`
            select updateStatusLeccion($1, $2, $3)`,
            [id_usr, id_leccion, Boolean(true)]);
            return true;
        }
        return false;

    },
    setStatusTema : async function(id_usr, data){
        const result = await pool.query(`
        select setStatusTema($1, $2, $3)`,[id_usr, parseInt(data.id_tema), Boolean(data.status)]);
        return result.rows[0].setstatustema;
    },

    //Funciones de ejercicio
    get_ejer_by_id : async function(id_ejer){
        const result = await pool.query("select count(*) from pregunta p where p.id_ejercicio = $1"
        ,[id_ejer])
        //console.log(result.rows[0].count);
        return result.rows[0].count;
    },
    get_pregunta_from_leccion : async function(id_lec, num){
        let result = await pool.query(`select * from pregunta where id_ejercicio = $1`,[id_lec]);
        delete result.rows[num].pregunta.respuesta;
        return result.rows[num];
    },
    get_bool_respuesta : async function(data){
        const result = await pool.query(`
        select p.pregunta from pregunta p where p.id_pregunta = $1 and p.id_ejercicio = $2`,[data.id_preg, data.leccion]);
        //console.log(result.rows[0]);
        if(result.rows[0].pregunta.respuesta == data.opc){
            return {obj:result.rows[0].pregunta, state : true};
        }else{
            return {obj:result.rows[0].pregunta, state : false};
        }
    },
    save_points : async function (id_usr, data){
        let puntaje = parseInt(data.c)/parseInt(data.size);
        puntaje = puntaje.toFixed(2)*100; //Se redondea a un numero alto, bono para estudiante :)
        const result = await pool.query(`
        select * from savePuntaje($1,$2,$3)`,[id_usr, parseInt(data.id_leccion), puntaje]);
        console.log(result.rows[0]);
        return result.rows[0].savepuntaje;
    },
    //Modelo de Vista Evaluaciones
    get_puntaje : async function(id_usr){
        const result = await pool.query(`
        select * from getPuntajeDeLecciones($1)`,[id_usr]);
        return result.rows;
    },
    //Modelo de Vista Avance
    get_avance : async function(id_usr){
        const temas = await pool.query(`
        select * from getAvanceDeTemas($1)
        `,[id_usr]);
        const lecciones = await pool.query(`
        select * from getPuntajeDeLecciones($1)`,[id_usr]);
        //console.log(temas.rows);
        //console.log(lecciones.rows);
        return {temas : temas.rows, lecciones : lecciones.rows};
    },
    //Estilo de aprendizaje
    get_learning_style : async function(id_usr){
        const result = await pool.query(`
        select ea.estilo from estudiante e, estilo_aprendizaje ea where e.id_usuario = $1 and e.id_estilo = ea.id_estilo
        `,[id_usr]);
        if(result.rows[0]){
            return result.rows[0];
        }else{
            return false;
        }
    },
    set_learning_style : async function(id_usr, data){
        //Obtener el tamaño de data
        let dataSize = Object.keys(data).length;
        //console.log(data);
        let AR = [0,0];
        let SI = [0,0];
        let VV = [0,0];
        let SG = [0,0];
        for (let i = 0; i < dataSize; i++) {
            //Determinando estilo de aprendizaje [Felder-Silverman]
            //activo-reflexivo 
            if((i+1)==1||(i+1)==5||(i+1)==9||(i+1)==13||(i+1)==17||(i+1)==21||(i+1)==25||(i+1)==29||(i+1)==33||(i+1)==37||(i+1)==41){
                //console.log(data[1]);
                if(data[i+1]=='a'){
                    AR[0] += 1;
                }else if(data[i+1]=='b'){
                    AR[1] += 1;
                }
            }
            //sensorial-intuitivo
            if((i+1)==2||(i+1)==6||(i+1)==10||(i+1)==14||(i+1)==18||(i+1)==22||(i+1)==26||(i+1)==30||(i+1)==34||(i+1)==38||(i+1)==42){
                if(data[i+1]=='a'){
                    SI[0] += 1;
                }else if(data[i+1]=='b'){
                    SI[1] += 1;
                }
            }
            //visual-verbal
            if((i+1)==3||(i+1)==7||(i+1)==11||(i+1)==15||(i+1)==19||(i+1)==23||(i+1)==27||(i+1)==31||(i+1)==35||(i+1)==39||(i+1)==43){
                if(data[i+1]=='a'){
                    VV[0] += 1;
                }else if(data[i+1]=='b'){
                    VV[1] += 1;
                }
            }
            //secuencial-global
            if((i+1)==4||(i+1)==8||(i+1)==12||(i+1)==16||(i+1)==20||(i+1)==24||(i+1)==28||(i+1)==32||(i+1)==36||(i+1)==40||(i+1)==44){
                if(data[i+1]=='a'){
                    SG[0] += 1;
                }else if(data[i+1]=='b'){
                    SG[1] += 1;
                }
            }
        }
        //console.log(AR[0]>AR[1]?(AR[0]-AR[1])+"A":(AR[1]-AR[0])+"B");
        const result = await pool.query(`
        select * from guardarEstilo($1, $2, $3, $4, $5)`,
        [id_usr, AR[0]>AR[1]?(AR[0]-AR[1])+"A":(AR[1]-AR[0])+"B",
        SI[0]>SI[1]?(SI[0]-SI[1])+"A":(SI[1]-SI[0])+"B",
        VV[0]>VV[1]?(VV[0]-VV[1])+"A":(VV[1]-VV[0])+"B",
        SG[0]>SG[1]?(SG[0]-SG[1])+"A":(SG[1]-SG[0])+"B",]);
        return result.rows[0].guardarestilo;
    },


    //Ejercicio0
    obtenerEjercicioTema : async function(id_tema){
        const result = await pool.query(`
        SELECT * from ejercicio0 where id_ejercicio0 = $1`, [id_tema]);
        return result.rows[0];
    }
}   
//