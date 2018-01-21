document.addEventListener('turbolinks:load', function() {

  $('#user_search input').keyup(function() {
    $.get($('#user_search').attr('action'), $('#user_search').serialize(), null, 'script');
    return false;
  });

  return $('#user_search select').change(function() {
    $.get($('#user_search').attr('action'), $('#user_search').serialize(), null, 'script');
    return false;
  });
});
