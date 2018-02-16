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
//= require Chart.bundle
//= require chartkick
//= require_tree

document.addEventListener("turbolinks:load", function() {

  //Seta para voltar ao topo da página =>
  $(window).scroll(function() {
    if ($(this).scrollTop()) {
      $('#toTop').fadeIn();
    } else {
      $('#toTop').fadeOut();
    }
  });

  $("#toTop").click(function() {
    $("html, body").animate({
      scrollTop: 0
    }, 1000);
  });

  // Seleção de status da ficha =>
  $( document ).ready(function() {
    $("#ficha_status").hide();
  });


  $('body').on('click', 'button[name=btn_status]', function() {
    value = $(this).val();
    $('#hidden_status').val(value);
    $('button.active').removeClass('active');
    $(this).addClass('active');
  });
});


// Dinamic footer
document.addEventListener("turbolinks:load", function() {
  if($(window).scrollTop() + $(window).height() < $(document).height()) {
    $('footer').hide();
  }
});

$(document).ready(function() {
  $(window).scroll(function() {
    if($(window).scrollTop() + $(window).height() >= $(document).height()) {
      $('footer').slideDown(150);
    }
    else {
      $('footer').slideUp(150);
    }
  });
});


//-------------------------------------------------
$(document).on('change','#select_unite_matter', function() {

  var selected = $(this).find(":selected").attr('value');
  var unite =  $(this).data('group');
  alert('/unite_groups/choose/'+ unite +"/"+ selected);

  $.ajax({
        url: '/unite_groups/choose/'+ unite +"/"+ selected,
        type: 'GET',
        error: function () {
            alert("Erro ao carregar grupos pertencentes a esta união.");
        }
    });

});

$(document).on('change','#unite_group_groups', function() {
    var value = $('#unite_group_groups').find(":selected").val();
    var link = $('#add_group').attr('href');
    var times = link.length;
    var i = times;
    var old  = ""
    while (i >= 0) {
      if (link.charAt(i) != '/') {
        old = old + link.charAt(i);
      } else {
        break;
      }
      i--;
    }
    link = link.substring(0, (link.length-old.length))
    link = link + value;
    $('#add_group').attr('href', link);
});

document.addEventListener("turbolinks:load", function() {

    // Backup spinner
    $(document).on('click', '#perform_backup',function(){
      $("#form_backup").fadeOut(500);
      $("#perform_render").html("");
      $("#spinner").fadeIn(2000);
    });

    //Pagination ajax link
    $(document).on('click', '.pagination a',function(){
      $.getScript(this.href);
      return false;
    });

    $(document).on('click', '#add_message',function(){
      $.getScript(this.href);
      return false;
    });

    //Bootstrap alert message
    $(".alert")
      .fadeTo(2000, 500)
      .slideUp(500);

    //table highlight


    $(document).on('mouseenter', 'tr:not(:first)', function () {
      $(this).css("background", "#e3e3e3");
    });

    $(document).on('mouseleave', 'tr:not(:first)', function () {
      $(this).css("background", "");
    });

    $(document).on('mouseenter', '#nohover', function () {
      $(this).css("background", "");
    });

    $(document).on('mouseleave', '#nohover', function () {
      $(this).css("background", "");
    });
    // table row-link
    $(document).on('click', 'td', function () {
      var id = $(this).attr("id");
      var path_parent = $(this).parent("tr").data("href");
      if(id != "actions" && path_parent.length > 0){
          window.location = path_parent;
      }
    });

    // Add error class
    $('.error').parent('div').find('.col-lg-8').addClass('has-error has-feedback');
    $('.error').parent('div').find('.col-lg-9').addClass('has-error has-feedback');
    $('.error').parent('div').find('.col-lg-2').addClass('has-error has-feedback');

    //Change ficha status
    $(document).on('change', '#select_status select', function() {
      if($(this).val() != 'reproved'){
        $("#appraisal_show").slideUp(1000, function(){
          $('#ficha_appraisal').val('');
        });
      } else {
        $("#appraisal_show").slideDown(1000);
      }
      var val =  $('#select_status select').val();

      $('#ficha_status_icon i').removeClass($('#ficha_status_icon i').attr('class'));
      if($(this).val() == 'reproved'){
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-ban-circle').css("color","red");
      } else if ($(this).val() == 'sent') {
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-refresh').css("color","blue");
      } else if ($(this).val() == 'editing') {
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-pencil').css("color","black");
      } else {
        $('#ficha_status_icon i').addClass('glyphicon glyphicon-ok').css("color","green");
      }
    });
  });

  $(document).ready(function() {
    $(".spinner").hide();

    $(document).on('turbolinks:load', function() {

       $('form').on('click', '.remove_record', function(event) {
         $(this).prev('input[type=hidden]').val('1');
         $(this).closest('tr').hide();
         return event.preventDefault();
       });

       $('form').on('click', '.add_fields', function(event) {
         var regexp, time;
         time = new Date().getTime();
         regexp = new RegExp($(this).data('id'), 'g');
         $('.fields').append($(this).data('fields').replace(regexp, time));
         return event.preventDefault();
       });

    });
  });

  $(document).on('change', '#preference_selector', function() {
    $(this).closest('form').submit();
});
