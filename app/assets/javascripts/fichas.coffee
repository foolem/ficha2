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

  $('#ficha_search input').keyup ->
    $.get $('#ficha_search').attr('action'), $('#ficha_search').serialize(), null, 'script'
    false

  $('#ficha_search select').change ->
    $.get $('#ficha_search').attr('action'), $('#ficha_search').serialize(), null, 'script'
    false

  validate $('textarea#ficha_program'), $('#div_program'), $('#program_error'), 'O Programa'
  validate $('textarea#ficha_general_objective'), $('#div_objective'), $('#objective_error'), 'O objetivo geral'
  validate $('textarea#ficha_specific_objective'), $('#div_specific_objective'), $('#specific_objective_error'), 'O objetivo específico'
  validate $('textarea#ficha_didactic_procedures'), $('#div_procedures'), $('#procedures_error'), 'O procedimento'
  validate $('textarea#ficha_evaluation'), $('#div_evaluation'), $('#evaluation_error'), 'A avaliação'
  validate $('textarea#ficha_basic_bibliography'), $('#div_basic_bibliography'), $('#basic_bibliography_error'), 'A bilbiografia básica'
  validate $('textarea#ficha_bibliography'), $('#div_bibliography'), $('#bibliography_error'), 'A bilbiografia complementar'
  return
