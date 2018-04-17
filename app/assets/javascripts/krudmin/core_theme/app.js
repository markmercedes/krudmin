/*****
* CONFIGURATION
*/

$.panelIconOpened = 'icon-arrow-up';
$.panelIconClosed = 'icon-arrow-down';

//Default colours
$.brandPrimary =  '#20a8d8';
$.brandSuccess =  '#4dbd74';
$.brandInfo =     '#63c2de';
$.brandWarning =  '#f8cb00';
$.brandDanger =   '#f86c6b';

$.grayDark =      '#2a2c36';
$.gray =          '#55595c';
$.grayLight =     '#818a91';
$.grayLighter =   '#d1d4d7';
$.grayLightest =  '#f8f9fa';

'use strict';

function initScripts() {
}

function controllerPath() {
  return [$('body').data('controller'), $('body').data('action')].join("-");
}

function panelNameFor(cardEl) {
  var cPath = controllerPath();
  var panelName = cardEl.data("card-panel");

  return [cPath, panelName].join("-");
}

document.addEventListener("turboforms:updated", function(e) {
  setTimeout(function() {
    Turbolinks.dispatch("turbolinks:load");
  }, 100);
});

document.addEventListener('turbolinks:load', function(event) {
  var inputDefaults = {
    singleDatePicker: true,
    showDropdowns: true,
    autoApply: true,
    cancelClass: "btn-danger",
    autoUpdateInput: false,
  };

  $('.datetimepicker').each(function (_, inputControl) {
    var inputFormat = $(this).data('date-format') || KRUDMIN_OPTIONS.DEFAULT_DATETIME_FORMAT;

    $(inputControl).daterangepicker(
      $.extend({
        timePicker: true,
        locale: {
          format: inputFormat
        }
      }, inputDefaults)
    , function(inputValue) {
      this.element.val(inputValue.format(inputFormat));
    });
  });

  $('.datepicker').each(function(_, inputControl) {
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
});

document.addEventListener('turbolinks:load', function(event) {
  $('.card-collapser').each(function(_, collapser) {
    var cardEl = $(collapser).closest('.card');
    var iconEl = $(collapser).find('i').get(0);
    var panelName = panelNameFor(cardEl);

    if (sessionStorage.getItem(panelName)) {
      $(cardEl).find('.card-body').hide();
      iconEl.className = iconEl.className.replace('fa-chevron-up', 'fa-chevron-down');
    }
  });

  initScripts();
  //Main navigation
  $.navigation = $('nav > ul.nav');


  if(!$.navigation.hasClass("initialized")) {
    // Add class .active to current link - AJAX Mode off
    $.navigation.find('a').each(function(){

      var cUrl = String(window.location).split('?')[0];

      if (cUrl.substr(cUrl.length - 1) == '#') {
        cUrl = cUrl.slice(0,-1);
      }

      if ($($(this))[0].href==cUrl) {
        $(this).addClass('active');

        $(this).parents('ul').add(this).each(function(){
          $(this).parent().addClass('open');
        });
      }
    });

    // Dropdown Menu
    $.navigation.on('click', 'a', function(e){
      if ($(this).hasClass('nav-dropdown-toggle')) {
        $(this).parent().toggleClass('open');
        resizeBroadcast();
      }
    });
  }

  $.navigation.addClass("initialized");

  function resizeBroadcast() {
    var timesRun = 0;
    var interval = setInterval(function () {
      timesRun += 1;
      if (timesRun === 5) {
        clearInterval(interval);
      }
      window.dispatchEvent(new Event('resize'));
    }, 62.5);
  }

  $('.card-collapser').click(function (e) {
    e.preventDefault();

    var cPath = controllerPath();
    var iconEl = $(this).find('i').get(0);
    var cardEl = $(this).closest('.card');
    var panelName = cardEl.data("card-panel");
    var panelPath = [cPath, panelName].join('-');
    var cardBody = cardEl.find('.card-body');
    var goesUp = iconEl.classList.contains("fa-chevron-up");

    if (goesUp) {
      cardBody.slideUp();
      iconEl.className = iconEl.className.replace('fa-chevron-up', 'fa-chevron-down');
      sessionStorage.setItem(panelPath, 'true');
    } else {
      cardBody.slideDown();
      iconEl.className = iconEl.className.replace('fa-chevron-down', 'fa-chevron-up');
      sessionStorage.removeItem(panelPath);
    }
  });

  /* ---------- Main Menu Open/Close, Min/Full ---------- */
  $('.sidebar-toggler').click(function(){
    $('body').toggleClass('sidebar-hidden');
    Cookies.set('sidebar-hidden', $('body').hasClass('sidebar-hidden'));
    resizeBroadcast();
  });

  $('.sidebar-minimizer').click(function(){
    $('body').toggleClass('sidebar-minimized');
    Cookies.set('sidebar-minimized', $('body').hasClass('sidebar-minimized'));
    resizeBroadcast();
  });

  $('.brand-minimizer').click(function(){
    $('body').toggleClass('brand-minimized');
    Cookies.set('brand-minimized', $('body').hasClass('brand-minimized'));
  });

  $('.aside-menu-toggler').click(function(){
    $('body').toggleClass('aside-menu-hidden');
    resizeBroadcast();
  });

  $('.search-panel-displayer').click(function () {
    $('.search-panel').show('fast');
    resizeBroadcast();

    $("html, body").animate({ scrollTop: 0 }, "fast");
  });

  $('.search-panel-toggler').click(function () {
    $('.search-panel').slideToggle('fast');
    resizeBroadcast();

    $("html, body").animate({ scrollTop: 0 }, "fast");
  });

  $('.mobile-sidebar-toggler').click(function(){
    $('body').toggleClass('sidebar-mobile-show');
    resizeBroadcast();
  });

  $('.sidebar-close').click(function(){
    $('body').toggleClass('sidebar-opened').parent().toggleClass('sidebar-opened');
  });

  /* ---------- Disable moving to top ---------- */
  $('a[href="#"][data-top!=true]').click(function(e){
    e.preventDefault();
  });

});

/****
* CARDS ACTIONS
*/

$(document).on('click', '.card-actions a', function(e){
  e.preventDefault();

  if ($(this).hasClass('btn-close')) {
    $(this).parent().parent().parent().fadeOut();
  } else if ($(this).hasClass('btn-minimize')) {
    var $target = $(this).parent().parent().next('.card-body');
    if (!$(this).hasClass('collapsed')) {
      $('i',$(this)).removeClass($.panelIconOpened).addClass($.panelIconClosed);
    } else {
      $('i',$(this)).removeClass($.panelIconClosed).addClass($.panelIconOpened);
    }

  } else if ($(this).hasClass('btn-setting')) {
    $('#myModal').modal('show');
  }

});

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

function init(url) {

  /* ---------- Tooltip ---------- */
  $('[rel="tooltip"],[data-rel="tooltip"]').tooltip({"placement":"bottom",delay: { show: 400, hide: 200 }});

  /* ---------- Popover ---------- */
  $('[rel="popover"],[data-rel="popover"],[data-toggle="popover"]').popover();

}

function blinkHighlight(el, from, to) {
  if (!from) { from = 0.5; }
  if (!to) { to = 1.0; }

  $(el).fadeTo(100, from).fadeTo(200, to);
}

toastr.options = {
  "closeButton": true,
  "newestOnTop": true,
  "preventDuplicates": true,
  "timeOut": 3000,
  closeDuration: 100,
  "positionClass": "toast-top-center",
}

function displayToast(type, msg, position) {
  var positionClass = position || "toast-top-center";

  switch (type) {
    case "error": {
      toastr.error(msg, "", { timeOut: 5000, positionClass: positionClass});
      break;
    }

    case "warning": {
      toastr.warning(msg, "", {positionClass: positionClass});
      break;
    }

    case "success": {
      toastr.success(msg, "", {positionClass: positionClass});
      break;
    }

    default: {
      toastr.info(msg, "", {positionClass: positionClass});
      break;
    }
  }
}

function clearToasts() {
  $("#toast-container").html('');
}
