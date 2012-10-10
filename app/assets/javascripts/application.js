// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require pwn-fx
//= require_tree .
//= require jquery.purr
//= require best_in_place

$(document).ready(function() {
  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place()
                    .bind('ajax:success', function(e) {
                        console.log(e);
                        $(this).closest('tr').effect('highlight', {}, 2000);
                     })
                    .bind('best_in_place:error', function(e, error) {
                        var errors = $.parseJSON(error.responseText);
                        $('.validation-errors').html("Error: "+errors);
                        $(this).closest('tr').effect('highlight', {color: 'red'}, 2000);
                     });
});