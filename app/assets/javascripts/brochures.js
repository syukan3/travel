
var markers = [];
function initMap() {
  if (!navigator.geolocation) {
    alert('Geolocation not supported');
    return;
  }

  // current location
  navigator.geolocation.getCurrentPosition(function(position) {
    var map = new google.maps.Map(document.getElementById('map'), {
      center: {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      },
      zoom: 15
    });

    // Auto complete
    var departure = document.getElementById('brochure_departure')
    var arrival = document.getElementById('brochure_arrival')
    var sightseeing = document.getElementById('brochure_sightseeing')
    var autocompleteDep = new google.maps.places.Autocomplete(departure);
    var autocompleteArr = new google.maps.places.Autocomplete(arrival);
    var autocompleteSigh = new google.maps.places.Autocomplete(sightseeing);

    autocompleteDep.bindTo('bounds', map);
    autocompleteArr.bindTo('bounds', map);
    autocompleteSigh.bindTo('bounds', map);

      // Set the data fields to return when the user selects a place.
    autocompleteDep.setFields(['address_components', 'geometry', 'icon', 'name']);
    autocompleteArr.setFields(['address_components', 'geometry', 'icon', 'name']);
    autocompleteSigh.setFields(['address_components', 'geometry', 'icon', 'name']);

    // Set markers when user inputs forms




    // Set markers when user touches maps
    map.addListener('click', function(e) {
      var marker = new google.maps.Marker({
        position: e.latLng,
        map: this,
        animation: google.maps.Animation.DROP
      });
      // var infoWindow = new google.maps.InfoWindow({
      //   content: e.latLng.toString() + "<ul><li>出発地</li><li>いきたい場所</li><li>解散場所</li><li>マーカーを外す</li></ul>"
      // });
      var infowindow = new google.maps.InfoWindow();
      var infowindowContent = document.getElementById('infowindow-content');
      infowindow.setContent(infowindowContent);
      marker.addListener('click', function() {
        infoWindow.open(map, marker);
      });
    });



  });
}
