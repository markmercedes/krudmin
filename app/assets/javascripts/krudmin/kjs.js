var kJs = function () {
  function inValidAction(_controller, _action) {
    var controller = $.isArray(_controller) ? _controller : [_controller];
    var actions = $.isArray(_action) ? _action : [_action];

    return controller.includes(document.body.dataset.controller) && actions.includes(document.body.dataset.action);
  }

  function inValidContext(controller, context) {
    var actions = [];

    switch (context) {
      case "form":
        actions = ["edit", "new", "create", "update"];
        break;

      case "list":
        actions = ["index"];
        break;

      case "show":
        actions = ["show"];
        break;
    }

    return inValidAction(controller, actions);
  }

  function bodyLoaded() {
    return $("body").data("controller") && $("body").data("action");
  }

  function loadContextualJS(controller, context, loads, unloads) {
    var func = function () {
      if (inValidContext(controller, context)) {
        loads();
      } else if (unloads) {
        unloads();
      }
    };

    var intervalReference = setInterval(function () {
      if (bodyLoaded()) {
        clearInterval(intervalReference);

        document.addEventListener("turbolinks:load", func);

        loads();
      }
    }, 1);
  }

  return {
    bodyLoaded: bodyLoaded,
    loadContextualJS: loadContextualJS,
    inValidAction: inValidAction,
    inValidContext: inValidContext,
  };
}();
