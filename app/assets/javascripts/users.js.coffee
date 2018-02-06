$('#user_search input').keyup ->
    $.get $('#user_search').attr('action'), $('#user_search').serialize(), null, 'script'
    false

  $('#user_search select').change ->
    $.get $('#user_search').attr('action'), $('#user_search').serialize(), null, 'script'
    false
