$(document).ready(function(){
  $("ul#tabs li").click(function(event){
    $("div.tabbed div").addClass("hidden");
    $("div.tabbed div:eq(" + $('ul#tabs li').index(this)  + ")").removeClass("hidden");
  });

  $("li.status").hover(function(event){
    $(this).children("span.actions").removeClass("hidden");
  });
  $("li.status").mouseout(function(event){
    $(this).children("span.actions").addClass("hidden");
  });
})
