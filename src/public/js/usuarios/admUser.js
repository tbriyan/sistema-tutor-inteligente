$(function () {
    listUsers(1);
});
function listUsers(page) {
    limpiarBuscar();
    $.ajax({
        type: "GET",
        url: `/user/list?page=${page}`,
        success: function (response) {
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
                    <td>${user.username}</td>
                    <td>Profesor</td>
                    <td>${user.telefono}</td>
                    <td class="text-center">${user.sexo}</td>
                    <td>${dateTransform(user.fecha_cre)}</td>
                    <td class="text-end">
                        <button onclick="getUser(${user.id_usuario})" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalUsuario">
                            Editar
                            <i>
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                          </svg>
                            </i>
                        </button>
                        <button onclick="deleteUser(${user.id_usuario})" class="btn btn-sm btn-danger">
                            Eliminar
                            <i>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                                <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
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
            }
        }
    });
}

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
            sexo: $("#sexo").val()
        },
        success: function (response) {
            if (response.success) alertify.success(response.success);
            if (response.fail) alertify.error(response.fail);
            listUsers(sessionStorage.getItem("index"));
        }
    });
}

function getUser(id) {
    $.ajax({
        type: "GET",
        url: `/user/${id}/get`,
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

//find by name
$("#buscar").keyup(function (e) {
    if($("#buscar").val().length>0){
        $.ajax({
            type: "POST",
            url: "/user/find",
            data: { args : $("#buscar").val() },
            success: function (response) {
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
                            <button onclick="getUser(${user.id_usuario})" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalUsuario">
                            Editar
                            <i>
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
                            <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
                            <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
                            </svg>
                            </i>
                            </button>
                            <button onclick="deleteUser(${user.id_usuario})" class="btn btn-sm btn-danger">
                            Eliminar
                            <i>
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                                <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
                                </svg>
                            </i>
                            </button>
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
//Aun sin funcionalidad 
function deleteUser(id) {
    alertify.confirm("Eliminar Profesor",`
    <strong style="color:orange;">Se eliminará toda la información relacionada con el Profesor</strong>
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
                }
            })
        },
        function () {
            alertify.error('Se canceló la operación!');
        });
}





//Funciones Auxiliares
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
    $("#message-modal").attr("hidden", "");
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