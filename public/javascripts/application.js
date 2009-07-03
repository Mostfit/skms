$(document).ready(function(){
  $("ul#tabs li").click(function(event){
    $("div.tabbed div").addClass("hidden");
    $("div.tabbed div:eq(" + $('ul#tabs li').index(this)  + ")").removeClass("hidden");
  });
})
