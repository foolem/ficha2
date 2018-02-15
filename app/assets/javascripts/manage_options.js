$(document).ready(function(){

    $(document).on("click", "#options_generate, #options_start, #options_remove, #options_send_email, #options_end", function(){
      $("#manage_actions").fadeOut(200, function() {
        $(this).html();
      });
      var content = $(this).attr('data-load');
      $('#loading-action').html(content);
      $('#spinner').fadeIn(2000);
    });

    $("#teachers, #matters, #final").on('click', function(){
        $('#selected').val(this.id);
        this.closest('form').submit();
      });


});
