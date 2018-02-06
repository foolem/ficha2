validate = (input, div, error) ->
    error_class = 'has-error has-feedback'
    sucess_calss = 'has-success has-feedback'
    input.blur ->
      if input.val().length == 0
        input.removeClass('error')
        div.find('.has-error').hide()
        div.removeClass(sucess_calss).addClass error_class
        error.text('não pode ficar em branco.').show()
      else
        input.removeClass('error')
        div.find('.has-error').hide()
        div.removeClass(error_class).addClass sucess_calss
        error.hide()
      return
    return

  $('#ficha_search input').keyup ->
    $.get $('#ficha_search').attr('action'), $('#ficha_search').serialize(), null, 'script'
    false


  $('#ficha_search select, #yours_checkbox').change ->
    $.get $('#ficha_search').attr('action'), $('#ficha_search').serialize(), null, 'script'
    false

  validate $('textfield#ficha_team'), $('#div_team'), $('#team_error')

  
