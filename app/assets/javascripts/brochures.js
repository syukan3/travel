
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

      var infoWindow = new google.maps.InfoWindow({
        content: e.latLng.toString() + "<ul><li>出発地</li><li>いきたい場所</li><li>解散場所</li><li>マーカーを外す</li></ul>"
      });
      // var infowindow = new google.maps.InfoWindow();
      // var infowindowContent = document.getElementById('infowindow-content');
      // infowindow.setContent(infowindowContent);
      marker.addListener('click', function() {
        infoWindow.open(map, marker);
      });
    });

    autocomplete.addListener('place_changed', function() {
              infowindow.close();
              marker.setVisible(false);
              var place = autocomplete.getPlace();
              if (!place.geometry) {
                // User entered the name of a Place that was not suggested and
                // pressed the Enter key, or the Place Details request failed.
                window.alert("No details available for input: '" + place.name + "'");
                return;
              }

              // If the place has a geometry, then present it on a map.
              if (place.geometry.viewport) {
                map.fitBounds(place.geometry.viewport);
              } else {
                map.setCenter(place.geometry.location);
                map.setZoom(17);  // Why 17? Because it looks good.
              }
              marker.setPosition(place.geometry.location);
              marker.setVisible(true);
              var address = '';
          if (place.address_components) {
            address = [
              (place.address_components[0] && place.address_components[0].short_name || ''),
              (place.address_components[1] && place.address_components[1].short_name || ''),
              (place.address_components[2] && place.address_components[2].short_name || '')
            ].join(' ');
          }

          infowindowContent.children['place-icon'].src = place.icon;
          infowindowContent.children['place-name'].textContent = place.name;
          infowindowContent.children['place-address'].textContent = address;
          infowindow.open(map, marker);
        });

  });
}
