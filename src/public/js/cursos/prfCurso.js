$(function () {
    listCourses();
});
function listCourses() {
    $.ajax({
        type: "get",
        url: "/course/list",
        success: function (response) {
            let template = "";
            response.forEach(curso => {
                template += `
                <div class="col-lg-3 mb-5">
                        <div class="card">
                            <div class="card-body text-light pt-2 pb-2" id="card-body${curso.id_curso}"
                            style="background-color: ${curso.color ? curso.color : "#158CBA"};">
                                <div class="d-flex justify-content-between">
                                    <h5 style="text-transform: uppercase;">${curso.grado} "${curso.paralelo}"</h5>
                                    <i id="set-color${curso.id_curso}" onmouseover="changeColor(${curso.id_curso})" title="Color">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-palette-fill" viewBox="0 0 16 16">
                                      <path d="M12.433 10.07C14.133 10.585 16 11.15 16 8a8 8 0 1 0-8 8c1.996 0 1.826-1.504 1.649-3.08-.124-1.101-.252-2.237.351-2.92.465-.527 1.42-.237 2.433.07zM8 5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zm4.5 3a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3zM5 6.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm.5 6.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3z"/>
                                    </svg>
                                    </i>
                                </div>
                                <div>
                                    <div>
                                        <h2 class="text-end"><strong>${curso.total}</strong></h2>
                                        <h5 class="text-end">Estudiantes</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer d-flex justify-content-between">
                                <div class="d-flex">
                                    <div id="editar" title="Editar" hidden>
                                        <a style="cursor:pointer;"><i class="bi bi-pencil-square h5 me-1"></i></a>
                                    </div>
                                    <div id="eliminar" title="Eliminar">
                                        <a style="cursor:pointer;" onclick="eliminarCurso(${curso.id_curso})">
                                        <i class="h5">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
                                          <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
                                        </svg>
                                        </i>
                                        </a>
                                    </div>
                                </div>
                                <div id="estudiantes">
                                    <a href="/user" onclick="crearSession(${curso.id_curso})" class="text-decoration-none d-flex align-center"
                                    style="color: ${curso.color ? curso.color : "#158CBA"};"><span class="me-1">Ver Estudiantes</span>
                                    <i>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-arrow-right-circle-fill" viewBox="0 0 16 16">
                                      <path d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0zM4.5 7.5a.5.5 0 0 0 0 1h5.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H4.5z"/>
                                    </svg>
                                    </i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            });
            $("#dash-cursos").html(template);
        }
    });
}

function saveCourse() {
    $.ajax({
        type: "post",
        url: "/course/save",
        data: {
            grado: $("#grado").val(),
            paralelo: $("#paralelo").val()
        },
        success: function (response) {
            if (response.success) {
                listCourses();
                alertify.success(response.success);
            }
            limpiar();
        }
    });
}
function eliminarCurso(id_curso) {
    alertify.confirm("ESta seguro de eliminar el curso?.",
        function () {
            $.ajax({
                type: "GET",
                url: `/course/${id_curso}/delete`,
                success: function (response) {
                    alertify.success(response);
                    listCourses();
                }
            });
            
        },
        function () {
            alertify.error('Operacion cancelada');
        }
    );

    //Aqui hacer llamado para eliminar pero con estado
    //Tambien hacer para el editar aunque no es necesario
}



//Others
function crearSession(id_curso) {
    sessionStorage.setItem("curso", id_curso);
}
function deleteSession() {
    sessionStorage.removeItem("curso");
}
function limpiar() {
    $("#grado").val("");
    $("#paralelo").val("");
}
//Colors
function changeColor(id) {
    const pickr = Pickr.create({
        el: `#set-color${id}`,
        theme: 'nano', // or 'monolith', or 'nano'
        useAsButton: true,
        position: 'bottom-middle',
        default: '#158CBA',
        swatches: [
            '#FF851B', //orange
            '#F1C40F',
            '#EC7063',
            '#FF4136', //red
            '#158CBA', //blue
            '#28B62C',
            '#31E18C',
            '#0D7442', //green
            '#6E0566', //purpura
            '#AF7AC5',
            '#476657', //green cake
            '#85929E',
            '#5DADE2 ',
            '#48C9B0 ',
        ],

        components: {
            // Main components
            preview: true,
            opacity: true,
            hue: true,
            // Input / output Options
            interaction: {
                save: true
            }
        }

    });

    pickr.on('change', (color, instance) => {
        let set = color.toHEXA().toString();
        document.querySelector(`#card-body${id}`).style.background = set;
        //informar que no se guardará si no da click en save
    });
    pickr.on('save', (color, instance) => {
        //guardar en la bd cuando se presione
        let set = color.toHEXA().toString();
        document.querySelector(`#card-body${id}`).style.background = set;
        $.ajax({
            type: "post",
            url: "/course/color",
            data: {
                id_curso: id,
                color: set
            },
            success: function (response) {
                if (response.success) {
                    alertify.success(response.success);
                }
            }
        });
        pickr.hide();
    });
}