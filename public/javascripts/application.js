$(document).ready(function(){
  $("ul#tabs li").click(function(event){
    $("div.tabbed div").addClass("hidden");
    $("div.tabbed div:eq(" + $('ul#tabs li').index(this)  + ")").removeClass("hidden");
  });

  $('li.menu_title').mouseover(function(){
    $(this).children('ul.menu_body').slideToggle(300);
  });
})
