document.addEventListener('turbolinks:load', function (event) {
  $('.belongs-to-one-container').each(function (index, element) {
    var modelId = $(element).data('model-id');

    if (modelId) {
      $(element).find('.delete-form-fields').removeClass('hidden');
    } else {
      $(element).find('.add-form-fields').removeClass('hidden');
    }
  });

  $(document).on('click', '.add-form-fields', function (e) {
    e.preventDefault();

    var container = $(this).closest('.belongs-to-one-container');
    var formFields = container.data('form-fields');
    var fieldsContainer = container.find('.form-fields .editable-attributes');

    if ( fieldsContainer.length == 0 ) {
      container.find('.form-fields').html(formFields);
    } else {
      var domElement = new DOMParser().parseFromString(formFields, "text/html");
      var editableAttributes = $(domElement).find('.editable-attributes').html();
      fieldsContainer.html(editableAttributes);
    }

    fieldsContainer.show();
    container.find('.destroy_model_check').val(false);

    $(this).addClass('hidden');
    $(container).find('.delete-form-fields').removeClass('hidden');

    updateKrudminControlsOn(container, e);
  });

  $(document).on('click', '.delete-form-fields', function (e) {
    e.preventDefault();

    var container = $(this).closest('.belongs-to-one-container');
    var formFields = container.data('form-fields');

    container.find('.form-fields .editable-attributes').html('');
    container.find('.destroy_model_check').val(true);

    $(this).addClass('hidden');
    $(container).find('.add-form-fields').removeClass('hidden');
  });
});
