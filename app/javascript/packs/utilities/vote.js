$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function (e) {
    var vote = e.detail[0];

    $(this).find('.score').html(vote['score']);
  });
});
