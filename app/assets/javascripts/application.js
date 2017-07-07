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

    $(".alert")
      .fadeTo(1000, 500)
      .slideUp(500);

      $(document).on('mouseenter', 'tr:not(:first)', function () {
        $(this).css("background", "#7a9ec3");
      });

      $(document).on('mouseleave', 'tr:not(:first)', function () {
        $(this).css("background", "");
      });

    $(document).on('click', 'td', function () {
      var id = $(this).attr("id");
      var path_parent = $(this).parent("tr").data("href");
      if(id != "actions" && path_parent.length > 0){
          window.location = path_parent;
      }
    });

    $('.error').parent('div').find('.col-lg-8').addClass('has-error has-feedback');
    $('.error').parent('div').find('.col-lg-9').addClass('has-error has-feedback');

    $(document).on('change', '#select_status select', function() {
      if($(this).val() != 'Reprovado'){
        $("#appraisal_show").slideUp(1000, function(){
          $('#ficha_appraisal').val('');
        });
      } else {
        $("#appraisal_show").slideDown(1000);
      }
      var val =  $('#select_status select').val();

      $('#ficha_status_icon i').removeClass($('#ficha_status_icon i').attr('class'));
      if($(this).val() == 'Reprovado'){
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-ban-circle').css("color","red");
      } else if ($(this).val() == 'Enviado') {
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-refresh').css("color","blue");
      } else if ($(this).val() == 'Editando') {
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-pencil').css("color","black");
      } else {
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-ok').css("color","green");
      }

    });

    $(document).on('click', '.nav-tabs li', function() {
      $("#matters_nav").removeClass('active');
      $("#teachers_nav").removeClass('active');
      $("#fichas").removeClass('active');
      $(this).addClass('active');

      var id = $(this).attr('id');
      if(id == 'matters_nav'){
        $("#matters_import").show();
        $("#teachers_import").hide();
        $("#imports_partial").hide();
      } else if (id == 'teachers_nav') {
        $("#matters_import").hide();
        $("#teachers_import").show();
        $("#imports_partial").hide();
      } else {
        $("#matters_import").hide();
        $("#teachers_import").hide();
        $("#imports_partial").show();
      }

    });

    $('#loading-indicator').hide();

  });



  $( document ).ready(function() {
    $(".spinner").hide();

    $(document).on('click', '#import_btn', function() {
      $('#loading-indicator').slideDown(1000);
    });

    $(document).on('click', '#yours_checkbox', function(){

      if($('#q_status_cont').hasClass('showing')) {
        $('#q_status_cont').hide().removeClass('showing');
      } else {
        $('#q_status_cont').show().addClass('showing');
      }
      var yourSelect = document.getElementById( "q_status_cont" );
      yourSelect.selectedIndex = 0;

    });
  });

  $(document).on("click", ".header", function() {

    var details =  $(this).parent('div').find("#details");

    if(!details.hasClass("show")){
      details.addClass('show').slideDown(2000);
    } else {
      details.removeClass('show').slideUp(2000);
    }
  });
