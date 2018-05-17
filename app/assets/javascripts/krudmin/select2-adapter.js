function initializeTurboSelect2(container) {
  container = container || "*";

  $.fn.select2.defaults.set("theme", "bootstrap");

  $(container).find("select.select2").select2({ width: '100%' });

  $(container).find("select.taglist").select2({ tags: true, width: '100%'  });

  $(container).find("select.select2-multiple[multiple]").select2({ multiple: true, width: '100%'  });
}

$(document).on('turbolinks:load', function () {
  initializeTurboSelect2();
});

$(document).on("turbolinks:before-cache", function () {
  $("select.select2-hidden-accessible").select2('destroy');
});

$(document).on("krudmin:updateControls", function (e) {
  initializeTurboSelect2(e.detail.selector);
});
