document.addEventListener('turbolinks:load', function() {

  $('#course_search input').keyup(function() {
    $.get($('#course_search').attr('action'), $('#course_search').serialize(), null, 'script');
    return false;
  });

  return $('#course_search select').change(function() {
    $.get($('#course_search').attr('action'), $('#course_search').serialize(), null, 'script');
    return false;
  });
});
