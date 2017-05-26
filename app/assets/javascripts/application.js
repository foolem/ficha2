// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree

document.addEventListener("turbolinks:load", function() {

    $(document).on('click', '.pagination a',function(){
      $.getScript(this.href);
      return false;
    });

    $('#matter_search input').keyup(function() {
      $.get($("#matter_search").attr("action"), $("#matter_search").serialize(), null, "script");
      return false;
    });

    $('#user_search input').keyup(function() {
      $.get($("#user_search").attr("action"), $("#user_search").serialize(), null, "script");
      return false;
    });

    $('#teacher_search input').keyup(function() {
      $.get($("#teacher_search").attr("action"), $("#teacher_search").serialize(), null, "script");
      return false;
    });

    $('#ficha_search input').keyup(function() {
      $.get($("#ficha_search").attr("action"), $("#ficha_search").serialize(), null, "script");
      return false;
    });

    $(".alert")
      .fadeTo(1000, 500)
      .slideUp(500);




    validate($('input#matter_name'), $('#div_name'), $('#name_error'), "O nome");

    validate($('input#matter_code'), $('#div_code'), $('#code_error'), "O código");

    validate($('textarea#matter_menu'), $('#div_menu'), $('#menu_error'), "A ementa");



    validate($('textarea#ficha_program'), $('#div_program'), $('#program_error'), "O Programa");

    validate($('textarea#ficha_general_objective'), $('#div_objective'), $('#objective_error'), "O objetivo geral");

    validate($('textarea#ficha_specific_objective'), $('#div_specific_objective'), $('#specific_objective_error'), "O objetivo específico");

    validate($('textarea#ficha_didactic_procedures'), $('#div_procedures'), $('#procedures_error'), "O procedimento");

    validate($('textarea#ficha_evaluation'), $('#div_evaluation'), $('#evaluation_error'), "A avaliação");

    validate($('textarea#ficha_basic_bibliography'), $('#div_basic_bibliography'), $('#basic_bibliography_error'), "A bilbiografia básica");

    validate($('textarea#ficha_bibliography'), $('#div_bibliography'), $('#bibliography_error'), "A bilbiografia complementar");
//  <span id="code_error" class="error_mensage" role="alert"> </span>

    function validate(input, div, error, field){

      error_class = 'has-error has-feedback';
      sucess_calss = 'has-success has-feedback';

      input.blur(function() {

        if(input.val().length == 0){

          div
            .removeClass(sucess_calss)
            .addClass(error_class);

          error
            .text(field +" não pode ficar em branco.")
            .show();

        } else {

          div
            .removeClass(error_class)
            .addClass(sucess_calss);

          error
            .hide();
        }
      });
    }



});
