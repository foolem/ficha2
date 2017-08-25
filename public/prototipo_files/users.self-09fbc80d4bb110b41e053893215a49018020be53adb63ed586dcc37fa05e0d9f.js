(function() {
  document.addEventListener('turbolinks:load', function() {
    return $('#user_search input').keyup(function() {
      $.get($('#user_search').attr('action'), $('#user_search').serialize(), null, 'script');
      return false;
    });
  });

  return;

}).call(this);
