
$.ajax({
  url: "https://maps.googleapis.com/maps/api/directions/json?origin=%E6%9D%B1%E4%BA%AC%E9%A7%85&destination=%E3%82%B9%E3%82%AB%E3%82%A4%E3%83%84%E3%83%AA%E3%83%BC&mode=walking&key=AIzaSyAmGfLiIHAbUNiquaRUxOR3DkVrbPeGLPI",
  cache: false,
  success: function(response){
    console.log(response)
  }
});


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
    var departureMarker = null;
    var arrivalMarker = null;

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
        map: map,
        animation: google.maps.Animation.DROP
      });
      var infoWindow = new google.maps.InfoWindow({
        // content: e.latLng.toString() + "<ul><li onclick='setDeparture(place)'>出発地</li><li>いきたい場所</li><li>解散場所</li><li>マーカーを外す</li></ul>"
        content: e.latLng.toString() + "<ul><li onclick='setDeparture(" +  e.latLng.lat() + ', ' + e.latLng.lng() + ")'>出発地</li><li>いきたい場所</li><li>解散場所</li><li>マーカーを外す</li></ul>"
      });
      // var infowindow = new google.maps.InfoWindow();
      // var infowindowContent = document.getElementById('infowindow-content');
      // infowindow.setContent(infowindowContent);
      marker.addListener('click', function() {
        infoWindow.open(map, marker);
      });
    });

    autocompleteDep.addListener('place_changed', function() {
      var place = autocompleteDep.getPlace();
      if (!place.geometry) {
        window.alert("No details available for input: '" + place.name + "'");
        return;
      }
      if (!!departureMarker) {
        departureMarker.setMap(null);
      }
      departureMarker = new google.maps.Marker({
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

    autocompleteArr.addListener('place_changed', function() {
      var place = autocompleteArr.getPlace();
      if (!place.geometry) {
        window.alert("No details available for input: '" + place.name + "'");
        return;
      }
      if (!!arrivalMarker) {
        arrivalMarker.setMap(null);
      }
      arrivalMarker = new google.maps.Marker({
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

    autocompleteSigh.addListener('place_changed', function() {
      var place = autocompleteSigh.getPlace();
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
