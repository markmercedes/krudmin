function handleSweetConfirm(element) {
  showSweetConfirmationDialog(element);
}

function showSweetConfirmationDialog(element) {
  var title = $(element).data("title");
  var text = $(element).data("sweet-confirm");
  var icon = $(element).data("confirm-icon") || "warning";
  var className = ["sweet", $(element).data("confirm-class")].join("-");

  swal({
    title: title,
    text: text,
    icon: icon,
    className: className,
    buttons: true
  }).then(
    function(result) {
      if (result) {
        this.dataset.sweetConfirmTemp = this.dataset.sweetConfirm;
        delete this.dataset.sweetConfirm;
        this.click();
        this.dataset.sweetConfirm = element.dataset.sweetConfirmTemp;
      }
    }.bind(element)
  );
}

function initializeSweetConfirm() {
  $("*[data-sweet-confirm]").click(function(e) {
    var element =
      e.target.getAttribute("data-sweet-confirm") != null
        ? e.target
        : $(e.target)
            .closest("*[data-sweet-confirm]")
            .get(0);

    if (element != null) {
      e.preventDefault();

      Rails.stopEverything(e);

      handleSweetConfirm(element);
    }
  });
}
