
function setDeparture(lat, lng) {
  console.log(lat);
  console.log(lng);
}


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

    // var departureMarker = null;
    // var arrivalMarker = null;

    // Directions Service
    // var directionsService = new google.maps.DirectionsService;
    // var directionsDisplay = new google.maps.DirectionsRenderer;
    // directionsDisplay.setMap(map);
    // var onChangeHandler = function() {
    //   calculateAndDisplayRoute(directionsService, directionsDisplay);
    // };
    // document.getElementById('brochure_departure').addEventListener('change', onChangeHandler);
    // document.getElementById('brochure_arrival').addEventListener('change', onChangeHandler);
    //
    // function calculateAndDisplayRoute(directionsService, directionsDisplay) {
    //   directionsService.route({
    //     origin: document.getElementById('brochure_departure').value,
    //     destination: document.getElementById('brochure_arrival').value,
    //     travelMode: 'DRIVING'
    //   }, function(response, status) {
    //     if (status === 'OK') {
    //       directionsDisplay.setDirections(response);
    //     }
    //     } else if (departure === null || arrival === null) {
    //       console.log("NG")
    //       continue;
    //     }
    //     else {
    //       window.alert('Directions request failed due to ' + status);
    //     }
    //   });
    // }

    // Auto complete
    var spot = document.getElementById('spot')
    var autocompleteSpot = new google.maps.places.Autocomplete(spot);
    autocompleteSpot.bindTo('bounds', map);

      // Set the data fields to return when the user selects a place.
    autocompleteSpot.setFields(['address_components', 'geometry', 'icon', 'name']);

    // Set markers when user inputs forms




    // Set markers when user touches maps
    map.addListener('click', function(e) {
      var marker = new google.maps.Marker({
        position: e.latLng,
        map: map,
        animation: google.maps.Animation.DROP
      });
      var infoWindow = new google.maps.InfoWindow({
        // content: e.latLng.toString() + "<ul><li onclick='setDeparture(place)'>出発地</li><li>いきたい場所</li><li>解散場所</li><li>マーカーを外す</li></ul>"
        content: e.latLng.toString() + "<ul><li onclick='setDeparture(" +  e.latLng.lat() + ', ' + e.latLng.lng() + ")'>出発地</li><li>いきたい場所</li><li>マーカーを外す</li></ul>"
      });
      // var infowindow = new google.maps.InfoWindow();
      // var infowindowContent = document.getElementById('infowindow-content');
      // infowindow.setContent(infowindowContent);
      marker.addListener('click', function() {
        infoWindow.open(map, marker);
      });
    });

    autocompleteSpot.addListener('place_changed', function() {
      var place = autocompleteSpot.getPlace();
      document.getElementById('spot_lat').value = place.geometry.location.lat();
      document.getElementById('spot_lng').value = place.geometry.location.lng();
      if (!place.geometry) {
        window.alert("No details available for input: '" + place.name + "'");
        return;
      }
      var marker = new google.maps.Marker({
        position: place.geometry.location,
        map: map,
        animation: google.maps.Animation.DROP
      });
      if (place.geometry.viewport) {
        map.fitBounds(place.geometry.viewport);
      } else {
        map.setCenter(place.geometry.location);
        map.setZoom(15);  // Why 17? Because it looks good.
      }
    });
  });
}
