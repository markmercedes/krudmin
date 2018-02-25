//= require lazyload

document.addEventListener('turbolinks:load', function (event) {
  $('.lazy').lazy();

  $('#breed_name_search').keyup(function(e) {
    var searchTerm = $(this).val().toUpperCase();

    $(".dog-breeds-list tr").filter(function(_, row) {
      var tds = $(row).find('td');
      var breed = tds[0].innerHTML.toUpperCase();
      var subBreeds = tds[1].innerHTML.toUpperCase();

      var matches = breed.includes(searchTerm) || subBreeds.includes(searchTerm);

      $(row).css("display", matches ? "" : "none");
    });
  });
});
