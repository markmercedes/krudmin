$.fn.bstooltip = $.fn.tooltip;

document.addEventListener('turbolinks:load', function (event) {
  $('[data-toggle="tooltip"]').bstooltip();
});