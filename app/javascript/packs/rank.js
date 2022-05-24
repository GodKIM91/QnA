$(document).on('turbolinks:load', function() {
  $('.rank').on('ajax:success', function(e) {
      var xhr = e.detail[2]
      $('#rank', this).html(xhr.responseText)
  });
});