$(function () {
    if (sessionStorage.getItem("curso")) {
        listUsers(1);
    } else {
        $("#filtrar").removeAttr("hidden");
        $("#body").attr("hidden", "");
        $.ajax({
            type: "get",
            url: "/course/list",
            success: function (response) {
                let template = "";
                response.forEach(curso => {
                    template += `
                <option class="text-uppercase" value="${curso.id_curso}">${curso.grado} ${curso.paralelo}</option>
                `;
                });
                $("#grado-curso-usuario").html(template);
                $("#grado-curso-usuario").val("");
            }
        });
    }
});

function listUsers(page) {
    $("#body").removeAttr("hidden");
    let id_curso = sessionStorage.getItem("curso");
    getCourse(id_curso);
    limpiarBuscar();
    $.ajax({
        type: "get",
        url: `/user/list?curso=${id_curso}&page=${page}`,
        success: function (response) {
            //console.log(response);
            let usuarios = response.usuarios;
            let index = response.page;
            sessionStorage.setItem("index", index?index:1);
            let total = response.total;
            if (usuarios) {
                let template = ""; let i = 1
                usuarios.forEach(user => {
                    template += `
                  <tr>
                    <th scope="row">${i}</th>
                    <td style="text-transform: capitalize;">${user.nombre + " " + user.apellido1 + " " + user.apellido2}</td>
                    <td class="text-center">${user.username}</td>
                    <td class="text-center">Estudiantes</td>
                    <td class="text-center">${user.telefono}</td>
                    <td class="text-center">${user.sexo}</td>
                    <td class="text-center">${dateTransform(user.fecha_cre)}</td>
                    <td class="text-end">
                        <button onclick="getUser(${user.id_usuario})" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalUsuario">
                        <i>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                          <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                          <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                        </svg>
                        </i>
                        </button>
                        <button onclick="deleteUser(${user.id_usuario})" class="btn btn-sm btn-danger">
                        <i>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                          <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
                        </svg>
                        </i>
                        </button>
                        <button onclick="getS1(${user.id_usuario})" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#modalNotaEst">
                        <i>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                          <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                          <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                        </svg>
                        </i>
                        </button>
                    </td>
                  </tr>`;
                    i++;
                });
                $("#table-rows").html(template);
                let template_pag = "";
                for (let i = 0; i < total; i++) {
                    template_pag += `
                    <li class="page-item" id="pag${i + 1}">
                    <a class="page-link" type="button" onclick="listUsers(${i + 1})">${i + 1}</a>
                    </li>`;
                }
                $("#paginas").html(`
                    <li id="page_anterior" class="page-item disabled">
                    <a class="page-link" type="button" onclick="pageAnterior(${index})">&laquo;</a>
                    </li>
                    ${template_pag}
                    <li id="page_siguiente" class="page-item disabled">
                    <a class="page-link" type="button" onclick="pageSiguiente(${index}, ${total})">&raquo;</a>
                    </li>
                `);
                $("#pagination").removeAttr("hidden");
                $("#origin-table").attr("hidden", "");
                $(`#pag${index}`).addClass("active");
                $(".table").removeAttr("hidden");
                $("#msg-notUsers").attr("hidden", "");
                if (index > 1) $("#page_anterior").removeClass("disabled");
                if (index < total) $("#page_siguiente").removeClass("disabled");
            } else {
                $(".table").attr("hidden", "");
                $("#msg-notUsers").removeAttr("hidden");
                $("#pagination").attr("hidden", "");
            }
        }
    });
    //si existe curso en session listamos automaticamente y mandamso curso de session
    //si no existe curso en session no listamos en cambio listamos cuando se haga click en boton

}
//poneaskdfasdfasdfasdfd

function saveUser() {
    $.ajax({
        type: "POST",
        url: "/user/save",
        data: {
            id_usuario: ($("#id").val()).toLowerCase(),
            nombre: ($("#nombre").val()).toLowerCase(),
            apellido1: ($("#apellido1").val()).toLowerCase(),
            apellido2: ($("#apellido2").val()).toLowerCase(),
            telefono: $("#telefono").val(),
            sexo: $("#sexo").val(),
            id_curso: sessionStorage.getItem("curso")
        },
        success: function (response) {
            if (response.success) alertify.success(response.success);
            listUsers(sessionStorage.getItem("index"));
            //console.log(response.success);
        }
    });
}

function getUser(id){
    let id_curso = sessionStorage.getItem("curso");
    $.ajax({
        type: "GET",
        url: `/user/${id}/get?curso=${id_curso}`,
        success: function (response) {
            $("#nombre").val(response.nombre);
            $("#apellido1").val(response.apellido1);
            $("#apellido2").val(response.apellido2);
            $("#telefono").val(response.telefono);
            $("#sexo").val(response.sexo);
            $("#id").val(response.id_usuario);
        }
    });
}

function resetear() {
    if($("#reset").val().length>0){
        $.ajax({
            type: "POST",
            url: "/user/reset",
            data: { username: ($("#reset").val()).toLowerCase() },
            success: function (response) {
                if (response.success) {
                    $("#reset").val("");
                    alertify.success(response.success);
                }
                if (response.fail) {
                    alertify.error(response.fail);
                }
            }
        });
    }else{
        alertify.warning("Ingrese un Usuario!");
    }
    
}

$("#buscar").keyup(function (e) {
    let id_usuario = sessionStorage.getItem("curso");
    if($("#buscar").val().length>0){
        $.ajax({
            type: "POST",
            url: "/user/find",
            data: { args : $("#buscar").val(),
                    curso :  id_usuario},
            success: function (response) {
                //console.log(response);
                let template = "";let i = 1
                    response.forEach(user => {
                        template += `
                      <tr>
                        <th scope="row">${i}</th>
                        <td style="text-transform: capitalize;">${user.nombre + " " + user.apellido1 + " " + user.apellido2}</td>
                        <td>${user.username}</td>
                        <td>Profesor</td>
                        <td>${user.telefono}</td>
                        <td class="text-center">${formatearSexo(user.sexo)}</td>
                        <td>${dateTransform(user.fecha_cre)}</td>
                        <td class="text-end">
                            <button onclick="getUser(${user.id_usuario})" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalUsuario">Editar<i class="ms-1 bi bi-pencil-square"></i></button>
                            <button onclick="deleteUser(${user.id_usuario})" class="btn btn-sm btn-danger">Eliminar<i class="ms-1 bi bi-trash-fill"></i></button>
                        </td>
                      </tr>`;
                        i++;
                    });
                    $("#table-rows").html(template);
                    $("#origin-table").removeAttr("hidden");
                    $("#pagination").attr("hidden", "");
            }
        })
    }else{
        listUsers(1);
    }
});

function deleteUser(id){
    alertify.confirm("Eliminar Estudiante",`
    <strong style="color:orange;">Se eliminará toda la información relacionada con el estudiante</strong>
    </br>
    </br>
    <p>¿Esta seguro(a) de continuar?</p>`,
        function () {
            $.ajax({
                type: "GET",
                url: `/user/${id}/delete`,
                success: function (response) {
                    alertify.success(response);
                    listUsers(sessionStorage.getItem("index"));
                    //console.log(sessionStorage.getItem("indexPage"));
                }
            })
        },
        function () {
            alertify.error('Se canceló la operación!');
        });
}

function getCourse(id){
    $.ajax({
        type: "get",
        url: `/course/${id}/get`,
        success: function (response) {
            //console.log(response);
            $("#titulo-curso").html(`
            <span class="ms-1 text-center badge bg-success">${response.grado} ${response.paralelo}</span>`);
        }
    });
}

//==========================================Ultima actualizacion
function getS1(id_usuario) {
    $.ajax({
        type: "GET",
        url: `/course/${id_usuario}/get-est`,
        success: function (response) {
            //console.log(response);
            let temp_notas = "";
            let hoja = response.hoja_estilo;
            response.notas.forEach((nota, index) => {
                temp_notas += `
                <tr>
                    <td class="text-center">${index + 1}</td>
                    <td class="text-start">L${index + 1} - ${nota.titulo}</td>
                    <td class="text-center">${nota.puntaje ? nota.puntaje : 0}</td>
                    <td class="text-center">${nota.fecha ? dateTransform(nota.fecha) : ' '}</td>
                </tr>`;
            });
            if(response.hoja_estilo){
                $("#detalles-est").html(`
                <div class="row">
                    <div class="col-lg-8">
                        <h5 class="mb-2"><strong>Datos del estudiante</strong></h5>
                        <p class="my-0 text-capitalize"><strong>Nombre</strong> : ${response.nombre}</p>
                        <p class="my-0 text-capitalize"><strong>Apellido Paterno</strong> : ${response.apellido1}</p>
                        <p class="my-0 text-capitalize"><strong>Apellido Materno</strong> : ${response.apellido2}</p>
                        <p class="my-0"><strong>Telefono</strong> : ${response.telefono}</p>
                        <p class="my-0"><strong>Genero</strong> : ${response.sexo == "M" ? 'Masculino' : 'Femenino'}</p>
                        <p class="my-0"><strong>Año de nacimiento</strong> : ${response.fecha_nac ? response.fecha_nac : '<span class="text-danger">Pedir que actualice datos</span>'}</p>
                        <br>    
                    </div>
                    <div class="col-lg-4 d-flex justify-content-center align-items-center">
                        <img src="${response.path_foto?response.path_foto:'/img/profile.jpg'}" alt="" width="150px" height="150px" style="border-radius: 50%; object-fit: cover;">
                    </div>
                </div>
            <h5 class="mb-2"><strong>Progreso del Estudiante</strong></h5>
            <div class="row mt-3">
                <div class="col-lg-9">
                    <table class="table">
                        <thead class="table-success">
                            <tr>
                                <th class="text-center">N°</th>
                                <th class="text-start">Practica - Leccion</th>
                                <th class="text-center">Puntaje</th>
                                <th class="text-center">Fecha de Realización</th>
                            </tr>
                        </thead>
                        <tbody>
                        ${temp_notas}
                        </tbody>
                    </table>
                </div>
                <div class="col-lg-3">
                    <table class="table table-bordered border-primary">
                        <thead class="table-primary">
                            <tr>
                                <th class="text-center">Promedio Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center">${response.promedio ? response.promedio : 0}</td>
                            </tr>
                        </tbody>
                    </table>
                
                </div>
            </div>
                <h5 class="mb-3"><strong>Hoja de Perfil - Estilo de Aprendizaje</strong></h5>
                <table class="table table-sm table-bordered">
                        <tr><td></td>
                            <td class="text-center">11</td>
                            <td class="text-center">9</td>
                            <td class="text-center">7</td>
                            <td class="text-center">5</td>
                            <td class="text-center">3</td>
                            <td class="text-center">1</td>
                            <td class="text-center">1</td>
                            <td class="text-center">3</td>
                            <td class="text-center">5</td>
                            <td class="text-center">7</td>
                            <td class="text-center">9</td>
                            <td class="text-center">11</td>
                            <td></td>
                        <tr>
                        </tr>
                        <tr>
                            <td class="text-center">ACTIVO</td>
                            <td class="text-center">${
                                hoja.ar.length>1?
                                hoja.ar.substring(0,2)=="11"&&hoja.ar.charAt(hoja.ar.length-1)=="A"?"<strong>X</strong>":""
                                :
                                ""
                            }</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="9"&&hoja.ar.charAt(hoja.ar.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="7"&&hoja.ar.charAt(hoja.ar.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="5"&&hoja.ar.charAt(hoja.ar.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="3"&&hoja.ar.charAt(hoja.ar.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="1"&&hoja.ar.charAt(hoja.ar.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="1"&&hoja.ar.charAt(hoja.ar.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="3"&&hoja.ar.charAt(hoja.ar.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="5"&&hoja.ar.charAt(hoja.ar.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="7"&&hoja.ar.charAt(hoja.ar.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.ar.length<3?hoja.ar.charAt(0)=="9"&&hoja.ar.charAt(hoja.ar.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${
                                hoja.ar.length>1?
                                hoja.ar.substring(0,2)=="11"&&hoja.ar.charAt(hoja.ar.length-1)=="B"?"<strong>X</strong>":""
                                :
                                ""}</td>
                            <td class="text-center">REFLEXIVO</td>
                        </tr>
                        <tr>
                            <td class="text-center">SENSORIAL</td>
                            <td class="text-center">${
                                hoja.si.length>1?
                                hoja.si.substring(0,2)=="11"&&hoja.si.charAt(hoja.si.length-1)=="A"?"<strong>X</strong>":""
                                :
                                ""
                            }</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="9"&&hoja.si.charAt(hoja.si.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="7"&&hoja.si.charAt(hoja.si.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="5"&&hoja.si.charAt(hoja.si.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="3"&&hoja.si.charAt(hoja.si.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="1"&&hoja.si.charAt(hoja.si.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="1"&&hoja.si.charAt(hoja.si.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="3"&&hoja.si.charAt(hoja.si.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="5"&&hoja.si.charAt(hoja.si.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="7"&&hoja.si.charAt(hoja.si.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.si.length<3?hoja.si.charAt(0)=="9"&&hoja.si.charAt(hoja.si.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${
                                hoja.si.length>1?
                                hoja.si.substring(0,2)=="11"&&hoja.si.charAt(hoja.si.length-1)=="B"?"<strong>X</strong>":""
                                :
                                ""}</td>
                            <td class="text-center">INTUITIVO</td>
                        </tr>
                        <tr>
                            <td class="text-center">VISUAL</td>
                            <td class="text-center">${
                                hoja.vv.length>1?
                                hoja.vv.substring(0,2)=="11"&&hoja.vv.charAt(hoja.vv.length-1)=="A"?"<strong>X</strong>":""
                                :
                                ""
                            }</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="9"&&hoja.vv.charAt(hoja.vv.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="7"&&hoja.vv.charAt(hoja.vv.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="5"&&hoja.vv.charAt(hoja.vv.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="3"&&hoja.vv.charAt(hoja.vv.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="1"&&hoja.vv.charAt(hoja.vv.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="1"&&hoja.vv.charAt(hoja.vv.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="3"&&hoja.vv.charAt(hoja.vv.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="5"&&hoja.vv.charAt(hoja.vv.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="7"&&hoja.vv.charAt(hoja.vv.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.vv.length<3?hoja.vv.charAt(0)=="9"&&hoja.vv.charAt(hoja.vv.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${
                                hoja.vv.length>1?
                                hoja.vv.substring(0,2)=="11"&&hoja.vv.charAt(hoja.vv.length-1)=="B"?"<strong>X</strong>":""
                                :
                                ""}</td>
                            <td class="text-center">VERBAL</td>
                        </tr>
                        <tr>
                            <td class="text-center">SECUENCIAL</td>
                            <td class="text-center">${
                                hoja.sg.length>1?
                                hoja.sg.substring(0,2)=="11"&&hoja.sg.charAt(hoja.sg.length-1)=="A"?"<strong>X</strong>":""
                                :
                                ""
                            }</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="9"&&hoja.sg.charAt(hoja.sg.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="7"&&hoja.sg.charAt(hoja.sg.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="5"&&hoja.sg.charAt(hoja.sg.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="3"&&hoja.sg.charAt(hoja.sg.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="1"&&hoja.sg.charAt(hoja.sg.length-1)=="A"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="1"&&hoja.sg.charAt(hoja.sg.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="3"&&hoja.sg.charAt(hoja.sg.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="5"&&hoja.sg.charAt(hoja.sg.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="7"&&hoja.sg.charAt(hoja.sg.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${hoja.sg.length<3?hoja.sg.charAt(0)=="9"&&hoja.sg.charAt(hoja.sg.length-1)=="B"?"<strong>X</strong>":"":""}</td>
                            <td class="text-center">${
                                hoja.sg.length>1?
                                hoja.sg.substring(0,2)=="11"&&hoja.sg.charAt(hoja.sg.length-1)=="B"?"<strong>X</strong>":""
                                :
                                ""}</td>
                            <td class="text-center">GLOBAL</td>
                        </tr>
                </table>`);
        
            }else{
                $("#detalles-est").html(`  
            <div class="row">
                <div class="col-lg-8">
                    <h5 class="mb-2"><strong>Datos del estudiante</strong></h5>
                    <p class="my-0 text-capitalize"><strong>Nombre</strong> : ${response.nombre}</p>
                    <p class="my-0 text-capitalize"><strong>Apellido Paterno</strong> : ${response.apellido1}</p>
                    <p class="my-0 text-capitalize"><strong>Apellido Materno</strong> : ${response.apellido2}</p>
                    <p class="my-0"><strong>Telefono</strong> : ${response.telefono}</p>
                    <p class="my-0"><strong>Genero</strong> : ${response.sexo == "M" ? 'Masculino' : 'Femenino'}</p>
                    <p class="my-0"><strong>Año de nacimiento</strong> : ${response.fecha_nac ? response.fecha_nac : '<span class="text-danger">Pedir que actualice datos</span>'}</p>
                    <br>    
                </div>
                <div class="col-lg-4">
                    <div class="col-lg-4 d-flex justify-content-center align-items-center">
                        <img src="${response.path_foto?response.path_foto:'/img/profile.jpg'}" alt="" width="150px" height="150px" style="border-radius: 50%; object-fit: cover;">
                    </div>
                </div>
            </div>
            <h5 class="mb-2"><strong>Progreso del Estudiante</strong></h5>
            <div class="row mt-3">
                <div class="col-lg-9">
                    <table class="table">
                        <thead class="table-success">
                            <tr>
                                <th class="text-center">N°</th>
                                <th class="text-start">Practica - Leccion</th>
                                <th class="text-center">Puntaje</th>
                                <th class="text-center">Fecha de Realización</th>
                            </tr>
                        </thead>
                        <tbody>
                        ${temp_notas}
                        </tbody>
                    </table>
                </div>
                <div class="col-lg-3">
                    <table class="table table-bordered border-primary">
                        <thead class="table-primary">
                            <tr>
                                <th class="text-center">Promedio Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center">${response.promedio ? response.promedio : 0}</td>
                            </tr>
                        </tbody>
                    </table>
                
                </div>
            </div>`);
            }
            }
    });
}
function getS() {
    $("#descargar_reporte").attr("hidden", "");
    $("#generar_reporte").removeAttr("hidden");
    let id_curso = parseInt(sessionStorage.getItem("curso"));
    //console.log(typeof (id_curso));
    $.ajax({
        type: "GET",
        url: `/course/${id_curso}/list-r1-estudiantes`,
        success: function (response) {
            let temp_estudiante = "";
            response.forEach((element, index) => {
                let temp_nota = "";
                element.notas.forEach(nota => {
                    temp_nota += `
                    <td class="text-center">${nota.puntaje ? nota.puntaje : 0}</td>`;
                });
                temp_estudiante += `
                    <tr>
                        <td class="text-center"><strong>${index + 1}</strong></td>
                        <td class="text-start text-capitalize">${element.persona.nombre}</td>
                        <td class="text-center">
                            <strong>${element.persona.sexo}</strong>
                        </td>
                        ${temp_nota}
                        <td class="text-center ${element.promedio > 50 ? 'text-success' : 'text-danger'}">
                            <strong>${element.promedio ? element.promedio : 0}</strong>
                        </td>
                    </tr>
                `;
            });
            $("#table-modal-body").html(temp_estudiante);
        }
    });
}


//==============================================others
function listUsersByFilter(page, id_curso) {
    sessionStorage.setItem("curso", id_curso);
    sessionStorage.removeItem("index");
    listUsers(page);
    limpiarBuscar();
}
function deleteSession() {
    sessionStorage.removeItem("curso");
    sessionStorage.removeItem("index");
}
function pageAnterior(page_actual) {
    if (page_actual > 1) {
        listUsers(page_actual - 1);
    }
}
function pageSiguiente(page_actual, page_size) {
    if (page_actual < page_size) {
        listUsers(page_actual + 1);
    }
}
function formatearSexo(valor) {
    if (valor == "M") {
        return "Masculino";
    } else if (valor == "F") {
        return "Femenino";
    }
}
function limpiarModal() {
    $("#nombre").val("");
    $("#apellido1").val("");
    $("#apellido2").val("");
    $("#telefono").val("");
    $("#sexo").val("");
    $("#id").val("");
}
function limpiarBuscar() {
    $("#buscar").val("");
}
function dateTransform(date) {
    const months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    date = date.split("T");
    let newDate = date[0].split("-");
    return newDate[2] + " de " + months[parseInt(newDate[1] - 1)];
}