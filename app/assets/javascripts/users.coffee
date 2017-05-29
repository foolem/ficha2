document.addEventListener 'turbolinks:load', ->

  $('#user_search input').keyup ->
    $.get $('#user_search').attr('action'), $('#user_search').serialize(), null, 'script'
    false
    
return
