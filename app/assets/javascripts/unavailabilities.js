function validateComment(){
  if (!$.trim($("#comment").val())) {
    alert("Comentário não deve ficar em branco");
    return false;
  }
}
