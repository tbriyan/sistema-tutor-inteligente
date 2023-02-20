$(()=>{
    get_puntaje_gral();
  });
  function get_puntaje_gral(){
    $.ajax({
      type: "GET",
      url: "/tutor/puntaje",
      success: function (response) {
        //console.log(response);
        let temp_puntaje = "";
        response.forEach((element, index) => {
          temp_puntaje += `
            <tr>
              <td class="text-center">${index+1}</td>
              <td>${element.titulo}</td>
              <td class="text-center ${element.puntaje?
              element.puntaje>50?'':'text-danger':''}"><strong>${element.puntaje?element.puntaje:0}</strong></td>
            </tr>
          `;
        });
        $("#table-data").html(temp_puntaje);
        //console.log(response);
      }
    });
  }