// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Read values passed from javascript through URL
function readValuesFromURL() {
  document.getElementById("homeowner_field").value = window.location.search.substring(1).split(";")[0].split("=")[1];
  document.getElementById("price_field").value = window.location.search.substring(1).split(";")[1].split("=")[1];
};

// Values need to be read from URL on page refresh as well
$(document).ready(function() {
  readValuesFromURL();
});
