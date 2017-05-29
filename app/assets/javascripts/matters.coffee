document.addEventListener 'turbolinks:load', ->

  validate = (input, div, error, field) ->
    error_class = 'has-error has-feedback'
    sucess_calss = 'has-success has-feedback'
    input.blur ->
      if input.val().length == 0
        div.removeClass(sucess_calss).addClass error_class
        error.text(field + ' não pode ficar em branco.').show()
      else
        div.removeClass(error_class).addClass sucess_calss
        error.hide()
      return
    return

  $('#matter_search input').keyup ->
    $.get $('#matter_search').attr('action'), $('#matter_search').serialize(), null, 'script'
    false


  validate $('input#matter_name'), $('#div_name'), $('#name_error'), 'O nome'
  validate $('input#matter_code'), $('#div_code'), $('#code_error'), 'O código'
  validate $('textarea#matter_menu'), $('#div_menu'), $('#menu_error'), 'A ementa'
  return
