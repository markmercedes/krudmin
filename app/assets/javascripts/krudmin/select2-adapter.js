function initRemoteSelect(_element) {
  var element = _element;

  $(element).select2({
    width: '100%',
    ajax: {
      url: window.location,
      dataType: 'json',
      delay: 300,
      data: function (params) {
        return {
          search_term: params.term,
          fields: this.dataset.field,
          format: "json"
        };
      }.bind(element),
      processResults: function (data) {
        var textProperty = data[this.dataset.field].collection_label_field;

        var items = $.map(data[this.dataset.field].options, function (item) {
          return {
            id: item.id,
            text: item[textProperty]
          };
        });

        return {
          results: items
        };
      }.bind(element)
    }
  });
}

function initializeTurboSelect2(container) {
  container = container || "*";

  $.fn.select2.defaults.set("theme", "bootstrap");

  var selectControls = $(container).find("select.select2");

  selectControls.each(function(_, element) {
    if (element.dataset.remote && element.dataset.remote.toLowerCase() == "true") {
      initRemoteSelect(element);
    } else {
      $(element).select2({ width: '100%' });
    }
  });

  $(container).find("select.taglist").select2({ tags: true, width: '100%'  });

  $(container).find("select.select2-multiple[multiple]").select2({ multiple: true, width: '100%' });
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
