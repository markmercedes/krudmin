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
  $('.alert.alert-info').delay( 5000 ).fadeOut( 400 );
}

document.addEventListener("turbofroms:updated", function(e) {
});

document.addEventListener('turbolinks:load', function(event) {
  var inputDefaults = {
    singleDatePicker: true,
    showDropdowns: true,
    autoApply: true,
    cancelClass: "btn-danger",
    autoUpdateInput: false,
  };

  $('.datetimepicker').daterangepicker(
    $.extend({
      timePicker: true,
      locale: {
        format: "MM/DD/YYYY hh:mm A"
      }
    }, inputDefaults)
  , function(inputValue) {
    this.element.val(inputValue.format("MM/DD/YYYY hh:mm A"));
  });

  $('.datepicker').daterangepicker(
    $.extend({
      locale: {
        format: "MM/DD/YYYY"
      }
    }, inputDefaults),
    function(inputValue) {
      this.element.val(inputValue.format("MM/DD/YYYY"));
    }
  );
});

document.addEventListener('turbolinks:load', function(event) {
  $('.alert-story-chk').prop('disabled', true);

  $('.business-category-checker').each(function(el) {
    var checked = $(this).prop('checked') == true;

    if(checked) {
      $(this).closest('tr').find('.alert-story-chk').prop('disabled', false);
    }
  });

  $(document).on('click', '.business-category-checker', function() {
    var checked = $(this).prop('checked') == true;
    console.warn(checked);

    if(checked) {
      $(this).closest('td').find('.destroy-indicator').val(0);
      $(this).closest('tr').find('.alert-story-chk').prop('disabled', false);
    } else {
      $(this).closest('td').find('.destroy-indicator').val(1);
    }
  });

  initScripts();
  //Main navigation
  $.navigation = $('nav > ul.nav');

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

  function resizeBroadcast() {

    var timesRun = 0;
    var interval = setInterval(function(){
      timesRun += 1;
      if(timesRun === 5){
        clearInterval(interval);
      }
      window.dispatchEvent(new Event('resize'));
    }, 62.5);
  }

  /* ---------- Main Menu Open/Close, Min/Full ---------- */
  $('.sidebar-toggler').click(function(){
    $('body').toggleClass('sidebar-hidden');
    resizeBroadcast();
  });

  $('.sidebar-minimizer').click(function(){
    $('body').toggleClass('sidebar-minimized');
    resizeBroadcast();
  });

  $('.brand-minimizer').click(function(){
    $('body').toggleClass('brand-minimized');
  });

  $('.aside-menu-toggler').click(function(){
    $('body').toggleClass('aside-menu-hidden');
    resizeBroadcast();
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
