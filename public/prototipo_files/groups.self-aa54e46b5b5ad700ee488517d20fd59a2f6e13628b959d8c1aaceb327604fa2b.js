(function() {
  document.addEventListener('turbolinks:load', function() {
    var validate;
    validate = function(input, div, error) {
      var error_class, sucess_calss;
      error_class = 'has-error has-feedback';
      sucess_calss = 'has-success has-feedback';
      input.blur(function() {
        if (input.attr('readonly') !== 'readonly') {
          if (input.val().length === 0) {
            input.removeClass('error');
            div.find('.has-error').hide();
            div.removeClass(sucess_calss).addClass(error_class);
            error.text('Não pode ficar em branco.').show();
          } else {
            input.removeClass('error');
            div.find('.has-error').hide();
            div.removeClass(error_class).addClass(sucess_calss);
            error.hide();
          }
          return;
        }
      });
    };
    $('#group_search input').keyup(function() {
      $.get($('#group_search').attr('action'), $('#group_search').serialize(), null, 'script');
      return false;
    });
    $('#group_search select').change(function() {
      $.get($('#group_search').attr('action'), $('#group_search').serialize(), null, 'script');
      return false;
    });
  });

}).call(this);
