// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//= require jquery
//= require jquery_ujs
//= require bootstrap/bootstrap-tooltip
//= require bootstrap
//= require_tree .
//= require jquery.purr
//= require best_in_place
//= require jquery-minicolors
//= require jquery-minicolors-simple_form
//= require tinymce
//= require jquery.tokeninput
//= require rails.validations
//= require rails.validations.simple_form



$(function() {
  $(".pagination").on("click", function() {
    $(".pagination").html("Page is loading...");
    $.getScript(this.href);
    return false;
  });
});

$(".alert-success").alert();
window.setTimeout(function() { $(".alert-success").alert('close'); }, 5000);
$(".alert-notice").alert();
window.setTimeout(function() { $(".alert-notice").alert('close'); }, 5000);

$(function(){
  $(".collapse li a").tooltip();
  
})

$(document).ready(function () {
    $("#slideshow1").sliders({ interval: 5000 });
});


$(document).ready(function(){
    var frames = document.getElementsByTagName("iframe");
    for (var i = 0; i < frames.length; i++) {
        frames[i].src += "?wmode=opaque;"

    }

});