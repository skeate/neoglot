$("nav > div").on("click", function(e){
  e.preventDefault();
  $("nav").toggleClass("open");
});
