document.addEventListener('turbolinks:load', function() {

  $('#option_search input').keyup(function() {
    $.get($('#option_search').attr('action'), $('#option_search').serialize(), null, 'script');
    return false;
  });

  return $('#option_search select').change(function() {
    $.get($('#option_search').attr('action'), $('#option_search').serialize(), null, 'script');
    return false;
  });
});
