$(function() {

$('#submit-name-button').click(function(){

  $.ajax ({
    type: 'GET',
    url: '/bet'
  }).done(function(msg){
    alert(msg);
});

});
