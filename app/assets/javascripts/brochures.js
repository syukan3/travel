
var markers = [];
function initMap() {
  if (!navigator.geolocation) {
    alert('Geolocation not supported');
    return;
  }

  navigator.geolocation.getCurrentPosition(function(position) {
    var map = new google.maps.Map(document.getElementById('map'), {

      center: {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      },
      zoom: 15
    });

    var input = document.getElementById('pac-input')
    var autocomplete = new google.maps.places.Autocomplete(input);

    autocomplete.bindTo('bounds', map);

    // Set the data fields to return when the user selects a place.
    autocomplete.setFields(
        ['address_components', 'geometry', 'icon', 'name']);

    var geocoder = new google.maps.Geocoder();

    map.addListener( "center_changed", function ( argument ) {
      var centerPosition = map.getCenter();
      document.getElementById('center_lat').value = centerPosition.lat();
      document.getElementById('center_lng').value = centerPosition.lng();

      for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
      }

      marker = new google.maps.Marker({
        position: centerPosition,
        map: map
      });
      markers.push(marker);
    });

    map.addListener( "dragend", function ( argument ) {
      var centerPosition = map.getCenter();
      geocoder.geocode({
        location: centerPosition
      }, function(results, status) {
        if (status !== 'OK') {
          alert('Failed: ' + status);
          return;
        }
        // results[0].formatted_address
        if (results[0]) {
          document.getElementById('center').value = results[0].formatted_address;
        } else {
          alert('No results found');
          return;
        }
      });
    });
  }, function() {
    alert('Geolocation failed!');
    return;
  });
}
