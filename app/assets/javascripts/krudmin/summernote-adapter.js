function initializeSummerNoteControls(container) {
  container = container || "*";

  $(container).find('[data-provider="summernote"]').each(function () {
    return $(this).summernote();
  });
}

$(document).on('turbolinks:load', function () {
  initializeSummerNoteControls();
});

$(document).on("krudmin:updateControls", function (e) {
  initializeSummerNoteControls(e.detail.selector);
});
