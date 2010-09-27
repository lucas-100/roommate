// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$('#houseEditLink').click(function(e){
  $('#house_name_home').toggle();
  $('#house_name').toggle();
  
  return false;
});