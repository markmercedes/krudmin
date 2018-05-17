function initializeDateTimePickers(container) {
  container = container || "*";

  var inputDefaults = {
    singleDatePicker: true,
    showDropdowns: true,
    autoApply: true,
    cancelClass: "btn-danger",
    autoUpdateInput: false,
  };

  $(container).find('.datetimepicker').each(function (_, inputControl) {
    var inputFormat = $(this).data('date-format') || KRUDMIN_OPTIONS.DEFAULT_DATETIME_FORMAT;

    $(inputControl).daterangepicker(
      $.extend({
        timePicker: true,
        locale: {
          format: inputFormat
        }
      }, inputDefaults), function (inputValue) {
        this.element.val(inputValue.format(inputFormat));
      });
  });

  $(container).find('.datepicker').each(function (_, inputControl) {
    var inputFormat = $(this).data('date-format') || KRUDMIN_OPTIONS.DEFAULT_DATE_FORMAT;

    $(inputControl).daterangepicker(
      $.extend({
        locale: {
          format: inputFormat
        }
      }, inputDefaults),
      function (inputValue) {
        this.element.val(inputValue.format(inputFormat));
      }
    );
  });
}

$(document).on('turbolinks:load', function () {
  initializeDateTimePickers();
});

$(document).on("krudmin:updateControls", function (e) {
  initializeDateTimePickers(e.detail.selector);
});
