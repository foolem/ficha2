document.addEventListener 'turbolinks:load', ->

  $('#option_search input').keyup ->
    $.get $('#option_search').attr('action'), $('#option_search').serialize(), null, 'script'
    false

  $('#option_search select').change ->
    $.get $('#option_search').attr('action'), $('#option_search').serialize(), null, 'script'
    false

return
