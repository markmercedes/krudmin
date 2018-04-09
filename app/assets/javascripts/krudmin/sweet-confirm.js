(function () {
   function handleConfirm (element, event) {
    if (!allowAction(element, event)) {
      Rails.stopEverything(event);
    }
  }

   function allowAction(element, event) {
    if (element.getAttribute('data-sweet-confirm') === null) {
      return true
    }

    showConfirmationDialog(element, event);
    return false
  }

   function showConfirmationDialog(element, event) {
    var title = $(element).data("title");
    var text = $(element).data("sweet-confirm");
    var icon = $(element).data('confirm-icon') || "warning";
    var className = ["sweet", $(element).data("confirm-class")].join('-');

    swal({
      title: title,
      text: text,
      icon: icon,
      className: className,
      buttons: true,
    }).then(function (result) {
      if (result) {
        var element = event.target.dataset.sweetConfirm ? event.target : $(event.target).closest('*[data-sweet-confirm]').get(0);

        element.dataset.sweetConfirmTemp = element.dataset.sweetConfirm;
        delete element.dataset.sweetConfirm;
        element.click();
        element.dataset.sweetConfirm = element.dataset.sweetConfirmTemp;
      }
    }.bind(event));
  }

  document.addEventListener("turbolinks:load", function () {
    $('*[data-sweet-confirm]').click(function (e) {
      e.preventDefault();

      handleConfirm(this, e);
    });
  })

}).call(this);
