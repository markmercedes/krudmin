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

    var container = $(this).parent('.belongs-to-one-container');
    var formFields = container.data('form-fields');
    var fieldsContainer = container.find('.form-fields');
    var content = $.trim(container.find('.form-fields').html());

    if (content == "") {
      fieldsContainer.html(formFields);
    }

    fieldsContainer.show();
    container.find('.destroy_model_check').val(false);

    $(this).addClass('hidden');
    $(container).find('.delete-form-fields').removeClass('hidden');
  });

  $(document).on('click', '.delete-form-fields', function (e) {
    e.preventDefault();

    var container = $(this).parent('.belongs-to-one-container');
    var formFields = container.data('form-fields');

    container.find('.form-fields').hide();
    container.find('.destroy_model_check').val(true);

    $(this).addClass('hidden');
    $(container).find('.add-form-fields').removeClass('hidden');

    updateKrudminControlsOn(container, e);
  });
});
