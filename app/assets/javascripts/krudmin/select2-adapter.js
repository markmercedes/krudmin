function initializeTurboSelect2() {
  $.fn.select2.defaults.set("theme", "bootstrap");

  $("select.select2").select2({});

  $("select.taglist").select2({ tags: true });

  $("select.select2-multiple[multiple]").select2({ multiple: true });
}

$(document).on('turbolinks:load', function () {
  initializeTurboSelect2();
});

$(document).on("turbolinks:before-cache", function () {
  $("select.select2-hidden-accessible").select2('destroy');
});
