
  $('#course_search input').keyup ->
    $.get $('#course_search').attr('action'), $('#course_search').serialize(), null, 'script'
    false

  $('#course_search select').change ->
    $.get $('#course_search').attr('action'), $('#course_search').serialize(), null, 'script'
    false
