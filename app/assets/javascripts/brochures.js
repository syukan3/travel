
function setDeparture(lat, lng) {
  console.log(lat);
  console.log(lng);
}

// var marker;
var markers = [];
var dataSpots = new Array;

function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}
function clearMarkers() {
  setMapOnAll(null);
}
function deleteMarkers() {
  clearMarkers();
  markers = [];
}

// var ready = function(map) {
function setMarkerAllDays(map) {
  deleteMarkers();
  var markDays = document.querySelectorAll('[id^=day_id]');
  markDays.forEach(function(markDay, numDay) {
    dataSpots[numDay] = new Array();
    var markSpots = JSON.parse(document.getElementById("spots_data_"+markDay.dataset.dayId).dataset.spots);
    markSpots.forEach(function(markSpot, numSpot) {
      dataSpots[numDay][numSpot] = markSpot;
      markers.push(new google.maps.Marker({
        position: {
          lat: Number(markSpot.lat),
          lng: Number(markSpot.lng)
        },
        map: map,
        animation: google.maps.Animation.DROP
      }));
    });
  });
}

function setMarkerDays(map, numBtnDay) {
  deleteMarkers();
  var markDays = document.querySelectorAll('[id^=day_id]');
  markDays.forEach(function(markDay, numDay) {
    dataSpots[numDay] = new Array();
    var markSpots = JSON.parse(document.getElementById("spots_data_"+markDay.dataset.dayId).dataset.spots);
    markSpots.forEach(function(markSpot, numSpot) {
      dataSpots[numDay][numSpot] = markSpot;
    });
  });

  [...dataSpots[numBtnDay]].map((_, i) => {
    markers.push(new google.maps.Marker({
      position: {
        lat: Number(dataSpots[numBtnDay][i].lat),
        lng: Number(dataSpots[numBtnDay][i].lng)
      },
      map: map,
      animation: google.maps.Animation.DROP
    }));
  });
}

// var markers = [];
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

    var btnAllDays = document.getElementById("btn_all_days");
    btnAllDays.addEventListener('click', function() {
      setMarkerAllDays(map);
    });

    var btnDays = document.querySelectorAll('[id^=btn_days_]');
    btnDays.forEach(function(btnDay, numBtnDay) {
      btnDay.addEventListener('click', function() {
        setMarkerDays(map, numBtnDay);
      });
    });

    // Auto complete
    var spots = document.querySelectorAll('[id^=spot_day_]');
    spots.forEach(function(spot) {
      var autocompleteSpot = new google.maps.places.Autocomplete(spot);
      autocompleteSpot.bindTo('bounds', map);
      // Set the data fields to return when the user selects a place.
      autocompleteSpot.setFields(['address_components', 'geometry', 'icon', 'name']);

      autocompleteSpot.addListener('place_changed', function() {
        var place = autocompleteSpot.getPlace();
        document.getElementById('spot_lat_'+spot.dataset.dayId).value = place.geometry.location.lat();
        document.getElementById('spot_lng_'+spot.dataset.dayId).value = place.geometry.location.lng();
        if (!place.geometry) {
          window.alert("No details available for input: '" + place.name + "'");
          return;
        }
        markers.push(new google.maps.Marker({
          position: place.geometry.location,
          map: map,
          animation: google.maps.Animation.DROP
        }));
        if (place.geometry.viewport) {
          map.fitBounds(place.geometry.viewport);
        } else {
          map.setCenter(place.geometry.location);
          map.setZoom(15);  // Why 17? Because it looks good.
        }
      });
    });

    // Set markers when user touches maps
    map.addListener('click', function(e) {
      markers.push(new google.maps.Marker({
        position: e.latLng,
        map: map,
        animation: google.maps.Animation.DROP
      }));
      var infoWindow = new google.maps.InfoWindow({
        // content: e.latLng.toString() + "<ul><li onclick='setDeparture(place)'>出発地</li><li>いきたい場所</li><li>解散場所</li><li>マーカーを外す</li></ul>"
        content: e.latLng.toString() + "<ul><li onclick='setDeparture(" +  e.latLng.lat() + ', ' + e.latLng.lng() + ")'>いきたい場所</li><li>マーカーを外す</li></ul>"
      });
      // var infowindow = new google.maps.InfoWindow();
      // var infowindowContent = document.getElementById('infowindow-content');
      // infowindow.setContent(infowindowContent);
      markers.addListener('click', function() {
        infoWindow.open(map, markers);
      });
    });
  });
}
