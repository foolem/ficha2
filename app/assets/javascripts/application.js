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
});
