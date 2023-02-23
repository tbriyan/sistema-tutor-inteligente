$(function () {
    getCursosByPrf();
});

function getCursosByPrf() {
    $.ajax({
        type: "GET",
        url: "/course/list-r1-listCursos",
        success: function (response) {
            let temp_profesor = "";
            response.forEach(element => {
                let temp_curso = "";
                element.curso.forEach((curso, index) => {
                    let nombre_curso = curso.grado+" "+curso.paralelo;
                    temp_curso += `
                    <tr>
                        <td class="text-center">${index+1}</td>
                        <td class="text-center text-capitalize">${curso.grado} ${curso.paralelo}</td>
                        <td class="text-center"><span class="badge ${curso.progreso>50?'bg-success':'bg-warning'}">${curso.progreso}%</span></td>
                        <td class="text-center">
                            <a onclick="getS(${curso.id_curso}, '${nombre_curso}', '${element.nombre}')" class="text-primary" href="#" title="Puntaje General" data-bs-toggle="modal" data-bs-target="#exampleModal">
                            <i>
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                              <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/>
                              <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>
                            </svg>
                            </i>
                            </a>
                            <a class="text-warning ms-2" href="#" title="Ver Analíticas">
                            <i>
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bar-chart-fill" viewBox="0 0 16 16">
                            <path d="M1 11a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1v-3zm5-4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1V7zm5-5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1V2z"/>
                            </svg>
                            </i>
                            </a>
                        </td>
                    </tr>
                    `;
                });

                temp_profesor += `
                <div class="col-lg-3"></div>
                <div class="col-lg-6 mb-5" ${element.curso.length>0?'':'hidden'}>
                    <div class="card">
                        <div class="card-header">
                            <strong class="text-capitalize">Prof. ${element.nombre}</strong>
                        </div>
                        <div class="card-body">
                            <table class="table">
                                <thead class="table-dark">
                                    <tr>
                                        <th class="text-center">N°</th>
                                        <th class="text-center">Curso</th>
                                        <th class="text-center">Progreso</th>
                                        <th class="text-center">Opciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${temp_curso}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3"></div>
            `;
            });
            $("#cursos").html(temp_profesor);
        }
    });
}
function getS(id_curso, nombre_curso, nombre_profesor) {
    $("#exampleModalLabel").html(nombre_profesor);
    $("#quote_curso").html(nombre_curso);
    $("#descargar_reporte").attr("hidden", "");
    $("#generar_reporte").removeAttr("hidden");
    sessionStorage.setItem("id_curso", id_curso);
    $.ajax({
        type: "GET",
        url: `/course/${id_curso}/list-r1-estudiantes`,
        success: function (response) {
            let temp_estudiante = "";
            response.forEach((estudiante, index) => {
                temp_nota_ejercicio = "";
                estudiante.notas_ejercicio.forEach(nota => {
                    temp_nota_ejercicio += `
                        <td class="text-center">${nota.promedio?nota.promedio:0}</td>
                    `;
                });
                temp_nota_evaluacion = "";
                estudiante.notas_evaluacion.forEach(nota => {
                    temp_nota_evaluacion += `
                        <td class="text-center">${nota.puntaje?nota.puntaje:0}</td>
                    `;
                });
                temp_estudiante += `
                <tr>
                    <td class="text-center">${index+1}</td>
                    <td class="ps-3 text-capitalize">${estudiante.persona.nombre}</td>
                    ${temp_nota_ejercicio}
                    <td class="text-center">${estudiante.promedio_ejercicio?estudiante.promedio_ejercicio:0}</td>
                    ${temp_nota_evaluacion}
                    <td class="text-center">${estudiante.promedio_evaluacion?estudiante.promedio_evaluacion:0}</td>
                </tr>
                `;
            });
            $("#tabla_notas").html(temp_estudiante);
        }
    });
}
async function g_report0(){
    let id_curso = parseInt(sessionStorage.getItem("id_curso"));
    console.log(id_curso);
    $("#generar_reporte").attr("hidden", "");
    $("#esperar_reporte").removeAttr("hidden");
    let result =  await $.ajax({
        type: "get",
        url : `/course/${id_curso}/report0`
    });
    if(result){
        $("#esperar_reporte").attr("hidden", "");
        $("#descargar_reporte").removeAttr("hidden");
        $("#descargar_reporte").attr("href", "/docs/"+result);
    }
}