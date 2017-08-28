(function() {
  document.addEventListener('turbolinks:load', function() {
    var validate;
    validate = function(input, div, error) {
      var error_class, sucess_calss;
      error_class = 'has-error has-feedback';
      sucess_calss = 'has-success has-feedback';
      input.blur(function() {
        if (input.val().length === 0) {
          input.removeClass('error');
          div.find('.has-error').hide();
          div.removeClass(sucess_calss).addClass(error_class);
          error.text('não pode ficar em branco.').show();
        } else {
          input.removeClass('error');
          div.find('.has-error').hide();
          div.removeClass(error_class).addClass(sucess_calss);
          error.hide();
        }
      });
    };
    $('#ficha_search input').keyup(function() {
      $.get($('#ficha_search').attr('action'), $('#ficha_search').serialize(), null, 'script');
      return false;
    });
    $('#ficha_search select, #yours_checkbox').change(function() {
      $.get($('#ficha_search').attr('action'), $('#ficha_search').serialize(), null, 'script');
      return false;
    });
    validate($('textfield#ficha_team'), $('#div_team'), $('#team_error'));
  });

}).call(this);
