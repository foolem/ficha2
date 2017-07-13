document.addEventListener 'turbolinks:load', ->

  validate = (input, div, error) ->
    error_class = 'has-error has-feedback'
    sucess_calss = 'has-success has-feedback'
    input.blur ->

      if input.attr('readonly') != 'readonly'
        if input.val().length == 0
          input.removeClass('error')
          div.find('.has-error').hide()
          div.removeClass(sucess_calss).addClass error_class
          error.text('Não pode ficar em branco.').show()
        else
          input.removeClass('error')
          div.find('.has-error').hide()
          div.removeClass(error_class).addClass sucess_calss
          error.hide()
        return
      return
    return

  validate $('input#matter_name'), $('#div_name'), $('#name_error')
  validate $('input#matter_code'), $('#div_code'), $('#code_error')
  validate $('textarea#matter_menu'), $('#div_menu'), $('#menu_error')

  $('#matter_search input').keyup ->
    $.get $('#matter_search').attr('action'), $('#matter_search').serialize(), null, 'script'
    false

  $('#matter_prerequisite').blur ->
    if $(this).attr('readonly') != 'readonly' and $(this).val().length == 0
        $(this).val('Nenhum')

  $('#matter_corequisite').blur ->
    if $(this).attr('readonly') != 'readonly' and $(this).val().length == 0
        $(this).val('Nenhum')

  $('#matter_prerequisite').focus ->
    if $(this).attr('readonly') != 'readonly' and $(this).val() == 'Nenhum'
        $(this).val('')

  $('#matter_corequisite').focus ->
    if $(this).attr('readonly') != 'readonly' and $(this).val() == 'Nenhum'
        $(this).val('')

  return
