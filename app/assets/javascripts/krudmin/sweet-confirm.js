(function () {
  function handleConfirm (element) {
    showConfirmationDialog(element);
  }

   function showConfirmationDialog(element) {
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
        this.dataset.sweetConfirmTemp = this.dataset.sweetConfirm;
        delete this.dataset.sweetConfirm;
        this.click();
        this.dataset.sweetConfirm = element.dataset.sweetConfirmTemp;
      }
    }.bind(element));
  }

  document.addEventListener("turbolinks:load", function () {
    $('*[data-sweet-confirm]').click(function (e) {
      e.preventDefault();

      var element = e.target.getAttribute('data-sweet-confirm') != null ? e.target : $(e.target).closest('*[data-sweet-confirm]').get(0);

      if (element != null) {
        Rails.stopEverything(e);

        handleConfirm(element);
      }
    });
  });
}).call(this);
