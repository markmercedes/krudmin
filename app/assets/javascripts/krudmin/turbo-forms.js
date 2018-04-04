function extractPropertiesWithValuesOnly(obj) {
  var onlyWithValues = {}

  for(prop in obj) {
    var propValue = obj[prop] || "";

    if (propValue.trim() != "") {
      onlyWithValues[prop] = propValue;
    }
  }

  return onlyWithValues;
}

function objectifyForm(formArray) {
  var returnArray = {};
  for (var i = 0; i < formArray.length; i++){
    returnArray[formArray[i]['name']] = formArray[i]['value'];
  }
  return returnArray;
}

$(document).on('submit', '.no-submit', function(e) {
  e.preventDefault();
});

function extractTurboActionPathFrom(context, actionPath) {
  return actionPath ? context.find('select[data-action-path="true"]').val() : context.attr('action');
}

$(document).on('submit', '.turbo-form[method=get]', function(e) {
  e.preventDefault();

  var context = $(this);

  var obj = objectifyForm(context.serializeArray());

  obj.utf8 = null;

  obj.submit = null;

  var onlyWithValues = extractPropertiesWithValuesOnly(obj);

  var actionPath = context.find('select[data-action-path="true"]').val();

  var route = extractTurboActionPathFrom(context, actionPath);

  Turbolinks.visit(
    [
      route,
      $.param(onlyWithValues)
    ].join('?')
  );
});

$(document).on('click', 'button[formaction]', function(e) {
  $(this).closest('form').attr('action', $(this).attr('formaction'));
  e.preventDefault();
  $(this).closest('form').submit();
});

$(document).on('submit', '.turbo-form[method=post],.turbo-form[method=put]', function(e) {
  e.preventDefault();

  var context = $(this);
  var obj =  context.serialize();
  var actionPath = context.find('select[data-action-path="true"]').val();
  var route = extractTurboActionPathFrom(context, actionPath);
  var selector = e.target.dataset.target || "body";

  $.ajax({
    url: route,
    type: this.method.toUpperCase(),
    data: obj,
    success: function(data) {
      var domElement = new DOMParser().parseFromString(data, "text/html");
      var form = $(domElement).find(selector).html();

      $(selector).html(form);

      var event = new CustomEvent("turboforms:updated", {
        doc: data,
        form: form
      });

      $("html, body").animate({ scrollTop: 0 }, "slow");

      document.dispatchEvent(event);
    }
  });

  return false;
});
