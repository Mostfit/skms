$(document).ready(function(){
  $(".tab-menu li").click(function(event){
    var search = '#fragment'+ $('.tab-menu li').index(this);
    $("div.fragment").addClass("hidden");
    $(search).removeClass("hidden");
  });

  $('li.menu_title').mouseover(function(){
    $(this).children('ul.menu_body').slideToggle(300);
  });
})
