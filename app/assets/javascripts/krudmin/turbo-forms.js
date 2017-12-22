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

$(document).on('submit', '.turbo-form[method=get]', function(e) {
  e.preventDefault();

  var obj = objectifyForm($(this).serializeArray());

  obj.utf8 = null;

  obj.submit = null;

  var onlyWithValues = extractPropertiesWithValuesOnly(obj);

  var actionPath = $(this).find('select[data-action-path="true"]').val();

  var route = null;

  if(actionPath) {
    route = $(this).find('select[data-action-path="true"]').val();
  } else {
    route = $(this).attr('action');
  }

  Turbolinks.visit(
    [
      route,
      $.param(onlyWithValues)
    ].join('?')
  );
});

$(document).on('submit', '.turbo-form[method=post],.turbo-form[method=put]', function(e) {
  e.preventDefault();

  var obj = objectifyForm($(this).serializeArray());

  var actionPath = $(this).find('select[data-action-path="true"]').val();

  var route = null;

  if(actionPath) {
    route = $(this).find('select[data-action-path="true"]').val();
  } else {
    route = $(this).attr('action');
  }

  $.ajax({
    url: route,
    type: this.method.toUpperCase(),
    data: obj,
    success: function(data) {
      var form = $($.parseHTML(data)).find('.turbo-form-container').html()
      $('.turbo-form-container').html(form);

      var event = new CustomEvent("turbofroms:updated", {
        doc: data,
        form: form
      });

      document.dispatchEvent(event);
    }
  });

  return false;
});
