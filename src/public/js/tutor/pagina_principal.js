$(function () {
  listLecciones();
});
function listLecciones() {
  sessionStorage.removeItem("sizeLeccion");
  sessionStorage.removeItem("id_tema");
  sessionStorage.removeItem("id_leccion");
  $("#btn-tema-siguiente").removeAttr("hidden", "");
  $("#btn-tema-evaluacion").attr("hidden");
  $.ajax({
    type: "GET",
    url: "/tutor/list",
    success: function (response) {
      let temp_leccion = "";
      response.forEach((leccion) => {
        let temp_tema = "";
        let flag_tema_css = false;
        leccion.temas.forEach((tema) => {
          temp_tema += `
                    <div class="d-flex justify-content-between align-items-center mb-4">
                      <div class="d-flex ${
                        flag_tema_css ? "relative connect" : ""
                      }">
                        <div class="img-circle bg-warning me-3">
                          <img src="${
                            tema.path_img
                          }" alt="img-intro" class="me-3 img-circle-transform">
                        </div>
                        <a onclick="getTema(${
                          tema.id_tema
                        })" class="n-link" type="button" data-bs-toggle="modal" data-bs-target="#modal-tema">${
            tema.titulo
          }</a>
                      </div>
                      <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="" ${
                          tema.status == true ? "checked" : "disabled"
                        }>
                      </div>
                    </div>`;
          flag_tema_css = true;
        });
        console.log(leccion);
        temp_leccion += `
                    <div class="col-lg-6 mb-5 border-bottom">
                      <div class="d-flex justify-content-between border-bottom border-dark">
                        <p><strong>${leccion.titulo}</strong></p>
                      </div>
                      <div class="mt-5 mb-2">
                        ${temp_tema}
                      </div>
                      <div class="mb-5">
                        <div class="d-flex justify-content-between">
                          <p><strong>Practica</strong></p>
                          ${
                            leccion.ejercicio.status === true
                              ? '<a href="#"><span class="badge bg-success">Completado</span></a>'
                              : '<a href="#"><span class="badge bg-dark">Sin completar</span></a>'
                          }
                        </div>
                        <p class="border-top">${
                          leccion.ejercicio.descripcion
                        }</p>
                        <div class="text-end">
                          <button onclick="getEjercicio(${leccion.id_leccion})" class="btn btn-primary btn-sm"  data-bs-toggle="modal" data-bs-target="#modal-evaluacion">Practica</button>
                        </div>
                      </div>
                    </div>
              `;
        //clas-text.end === >onclick="getEjercicio(${leccion.id_leccion})"                ${aux_verificar_temas(leccion.temas)?'':'disabled'}
      });
      $("#leccion").html(temp_leccion);
    },
  });
}
let contarTema = 0;
function getTema(id_tema) {
  contarTema += 1;
  console.log("cont : "+contarTema);
  $.ajax({
    type: "GET",
    url: `/tutor/${id_tema}/tema`,
    success: function (response) {
      console.log(response);
      let tema = response.tema;
      sessionStorage.setItem("titulo_tema", tema.titulo);
      if (contarTema == tema.sizeLeccion || tema.es_ultimo == true) {
        $("#btn-tema-siguiente").attr("hidden", "");
        $("#btn-tema-evaluacion").removeAttr("hidden");
      }
      console.log(response);
      $("#titulo-tema").html(`<strong>${tema.titulo}</strong>`);
      if (response.tema.estilo == "VA") {
        $("#video").html(response.tema.path_video);
      } else if (response.tema.estilo == "VB") {
        $("#video").html(`${response.tema.contenido}`); //Arreglarrrrrr
      }
      sessionStorage.setItem("sizeLeccion", tema.sizeLeccion);
      console.log("tam-leccion :"+tema.sizeLeccion);
      sessionStorage.setItem("id_tema", tema.id_tema);
      sessionStorage.setItem("id_leccion", tema.id_leccion);
    },
  });
}
function siguienteTema() {
  contarTema += 1;
  console.log("cont : "+contarTema);
  let id_tema = parseInt(sessionStorage.getItem("id_tema"));
  let sizeLeccion = parseInt(sessionStorage.getItem("sizeLeccion"));
  console.log("tam-leccion :"+sizeLeccion);
  if (contarTema <= sizeLeccion) {
    $.ajax({
      type: "GET",
      url: `/tutor/${id_tema + 1}/tema`,
      success: function (response) {
        let tema = response.tema;
        sessionStorage.setItem("titulo_tema", tema.titulo);
        $("#titulo-tema").html(`<strong>${tema.titulo}</strong>`);
        if (response.tema.estilo == "VA") {
          $("#video").html(response.tema.path_video);
        } else if (response.tema.estilo == "VB") {
          $("#video").html(`${response.tema.contenido}`); //Arreglarrrrrr
        }

        if (contarTema == sizeLeccion || tema.es_ultimo == true) {
          $("#btn-tema-siguiente").attr("hidden", "");
          $("#btn-tema-evaluacion").removeAttr("hidden");
        }
        sessionStorage.removeItem("id_tema");
        sessionStorage.setItem("id_tema", response.tema.id_tema);
      },
    });
  }
}

function getEjercicio(id_leccion) {
  $.ajax({
    type: "GET",
    url: `/tutor/${id_leccion}/ejercicio`,
    success: function (response) {
      sessionStorage.setItem("total", response.count);
      console.log(response);
      $("#titulo_evaluacion").html(response.titulo);
      $("#contenido-evaluacion").html(`
        <div class="text-center">
          <h1>
            <strong
              >Felicidades por aventurarte a realizar la evaluación...</strong
            >
          </h1>
            <div id="presentacion-evaluacion" class="mt-5">
                <div class="img-presentacion">
                    <img src="/img/sticker-1.png" />
                </div>
                <div class="b-presentacion">
                    <h5>
                        Haz realizado un recorrido por los temas de esta leccion, sientete preparado para tomar la evalución, recuerda tener a mano tu tabla de valencias.
                    </h5>
                    <div class="frase">
                        <p>"Mantén la calma y confía en ti mismo"</p>
                    </div>
                    <h4>Total de preguntas : <strong>${response.count}</strong></h4>
                    <button onclick="getP(${id_leccion})" class="btn btn-primary mt-3">Comenzar</button>
                </div>
            </div>
        </div>`);
    },
  });
}

//Crear una variable global de preguntas_pedidos
let lista = [];
let flag = false;
let preguntas = [];
async function getP(id_leccion) {
  let total_preguntas = parseInt(sessionStorage.getItem("total"));
  if (lista.length <= 0 && flag == false) {
    for (let i = 0; i < total_preguntas; i++) {
      lista.push(i);
    }
    lista = lista.sort(function () {
      return Math.random() - 0.5;
    });
    flag = true;
  }
  //let contador = 1;
  if (lista.length > 0) {
    let num = lista.pop();
    $.ajax({
      type: "POST",
      url: "/tutor/pregunta",
      data: { id_leccion, num },
      success: function (response) {
        preguntas.push(response.pregunta);
        $("#contenido-evaluacion").html(`
          <div class="text-center">
            <h3><strong>${response.pregunta.pregunta}</strong></h3>
            <br>
            <div class="opciones" id="opc">
            </div>
            <div class="mt-5">
                <span><strong>${
                  total_preguntas - lista.length
                } of ${total_preguntas} preguntas</strong></span>
            </div>
          </div>`);
        let template = "";
        response.pregunta.opciones.forEach((opcion) => {
          template += `<button class="btn btn-primary mb-3 py-2" onclick="verificar(${id_leccion}, ${response.id_pregunta}, '${opcion}')" >${opcion}</button>`;
        });
        $("#opc").html(template);
        $("#contenido-evaluacion").addClass("custom-contenido-evaluacion");
        //Muestro ok? cuando lo haga y haga click llama otra funcion donde marca la respuesta y esa llama de nuevo esta
        //En el server verifico la respuesta y sumo puntos no se donde pero lo hago.
      },
    });
  } else {
    $("#contenido-evaluacion").removeClass("custom-contenido-evaluacion");
    let size = puntos.length;
    let c = 0;
    puntos.forEach((x) => {
      if (x == 1) {
        c += 1;
      }
    });
    let result = $.ajax({
      type: "POST",
      url: "/tutor/sp",
      data: { size, c, id_leccion },
      success: function (response) {
        console.log(response);
        
        $("#contenido-evaluacion").html(`
          <div class="text-center bg-light pt-3" style="color: black;">
              <h1 class="mt-5"><strong>Felicidades completaste la Unidad!</strong></h1>
              <p>El éxito es la suma de pequeños esfuerzos repetidos día tras día.</p>
              <p class="mb-0 mt-5">Acertaste en</p>
              <h1 class="my-0"><strong>${c} de ${size}</strong></h1>
              <h1 class="text-success"><strong>Nota : ${(c/size).toFixed(2)*100}</strong></h1>
              <br>
              <div id="quiz-pregunta"></div>              
              <div class="mt-5 pb-5 text-center">
                <a href="/" class="btn btn-primary">salir</a>
              </div>
            </div>
          `);
        let temp_pregunta = "";
        arr_r.forEach((element) => {
          let temp_opciones = "";
          element.preg_resp.obj.opciones.forEach((opc) => {
            if (element.preg_resp.state) {
              if (element.selected == opc) {
                temp_opciones += `
                  <li class="list-group-item list-group-item-success">${opc}<span style="float: right;">
                    <i>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                      <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>
                    </i></span>
                  </li>`;
              } else {
                temp_opciones += `
                   <li class="list-group-item">${opc}<span style="float: right;">
                   <i style="color:transparent;">
                   <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                   <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>
                   </i></span></li>
                   `;
              }
            } else {
              if (element.selected == opc) {
                temp_opciones += `
                  <li class="list-group-item list-group-item-danger">${opc}<span style="float: right;"><i>
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle-fill" viewBox="0 0 16 16">
                  <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/>
                    </svg>
                  </i></span></li>`;
              } else {
                if (element.preg_resp.obj.respuesta == opc) {
                  temp_opciones += `
                    <li class="list-group-item list-group-item-success">${opc}<span style="float: right;">
                    <i>
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>  
                    </i></span></li>`;
                } else {
                  temp_opciones += `
                    <li class="list-group-item">${opc}<span style="float: right;">
                    <i style="color:transparent;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                    </svg>
                    </i></span></li>
                   `;
                }
              }
            }

            /*temp_opciones += `
                        <li class="list-group-item">${opc}</li>
                        `;*/
          });
          temp_pregunta += `
              <div class="mb-5">
                <h3>${element.preg_resp.obj.pregunta}</h3>
                <ul class="list-group">
                  ${temp_opciones}
                </ul>
              </div>
            `;
        });
        $("#quiz-pregunta").html(temp_pregunta);
        $("#quiz-pregunta").addClass("quiz-padding");
      },
    });
    //COntar el puntaje sacar nota
    //console.log(puntos);
    //Subir la nota promediada a la bd
    //Usar el puntaje del frontend para mostrar resultados
    //Usar el tamaño para responder
  }
}

let puntos = [];
let arr_r = [];
async function verificar(leccion, id_preg, opc) {
  const result = await $.ajax({
    type: "POST",
    url: "/tutor/verif",
    data: { leccion, id_preg, opc },
    success: function (response) {},
  });
  if (result.state) {
    puntos.push(1);
  } else {
    puntos.push(0);
  }
  arr_r.push({ preg_resp: result, selected: opc });
  getP(leccion);
}
function aux_verificar_temas(arr) {
  let flag = true;
  arr.forEach((element) => {
    if (element.status != true) {
      flag = false;
    }
  });
  return flag;
  //console.log(flag);
  //console.log(arr);
}
