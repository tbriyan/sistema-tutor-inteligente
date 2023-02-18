$(()=>{
    get_avance();
});
function get_avance(){
    $.ajax({
        type: "GET",
        url: "/tutor/avance-general",
        success: function (response) {
            console.log(response);
            let temp_leccion = "";
            response.lecciones.forEach(leccion => {
                let temp_tema = "";
                response.temas.forEach(tema => {
                    if(tema.id_leccion == leccion.id_leccion){
                        temp_tema += `
                            <li class="list-group-item">
                                <div class="d-flex justify-content-between">
                                    <div>${tema.titulo}</div>
                                    ${tema.estado_tema==true?
                                    '<div><span class="badge rounded-pill bg-success">Completado</span></div>'
                                    :
                                    '<div><span class="badge rounded-pill bg-warning">Sin Completar</span></div>'}
                                </div>
                            </li>
                        `;
                    }

                });
                temp_leccion += `
                <div class="col-lg-6">
                <div class="mb-2">
                    <h5 class="mt-3"><strong>${leccion.titulo}</strong></h5>
                    <ul class="list-group">
                        ${temp_tema}
                    </ul>
                    <div class="card mt-2">
                        <div class="card-body text-center">
                            <div class="d-flex justify-content-between">
                                <div><strong>Practica</strong></div>
                                ${leccion.puntaje?
                                    '<div><span class="badge rounded-pill bg-success">Completado</span></div>'
                                    :
                                    '<div><span class="badge rounded-pill bg-danger">Sin completar</span></div>'}
                                
                            </div>
                            <div class="text-center">
                                Puntaje : ${leccion.puntaje?leccion.puntaje:0}
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                `;
            });
            $("#show-avance").html(temp_leccion);
        }
    });
}