# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

  $('#course_search input').keyup ->
    $.get $('#course_search').attr('action'), $('#course_search').serialize(), null, 'script'
    false

  $('#course_search select').change ->
    $.get $('#course_search').attr('action'), $('#course_search').serialize(), null, 'script'
    false
