function toggleName(){
    $("#name-before").toggleClass("d-none");
    $("#name-after").toggleClass("d-none");
}
function toggleFecha(){
    $("#fecha-before").toggleClass("d-none");
    $("#fecha-after").toggleClass("d-none");
}
function toggleSexo(){
    $("#sexo-before").toggleClass("d-none");
    $("#sexo-after").toggleClass("d-none");
}
function toggleContacto(){
    $("#contacto-before").toggleClass("d-none");
    $("#contacto-after").toggleClass("d-none");
}
function togglePassword(){
    $("#password-before").toggleClass("d-none");
    $("#password-after").toggleClass("d-none");
}


$("#show-profile").mouseover(function () { 
    $("#photo-profile-over").removeClass("d-none");
});
$("#show-profile").mouseout(function () { 
    $("#photo-profile-over").addClass("d-none");
});


$("#photo-profile-over").click(function (e) { 
    e.preventDefault();
    $("#photo-upload").click();
});
$("#photo-upload").change(function (e) { 
    e.preventDefault();
    let photo = document.getElementById("photo-upload");
    const element_url = URL.createObjectURL(photo.files[0]);
    $("#photo-profile").attr("src", element_url);
    $("#form-profile").removeClass("d-none");
});
