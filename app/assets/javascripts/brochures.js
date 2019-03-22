
function doPost(data) {
   var url = '/api/spots';
   var xhr = new XMLHttpRequest();
   xhr.open("POST", url);
   xhr.setRequestHeader("Content-Type", "application/json");
   xhr.onload = () => {
     console.log(xhr.status);
     console.log("success!");
     location.reload();
   };
   xhr.onerror = () => {
     console.log(xhr.status);
     console.log("error!");
   };
   // CSRF-Token
   var csrfToken = document.head.querySelector('meta[name="csrf-token"]').content;
   xhr.setRequestHeader('X-CSRF-Token', csrfToken);
   xhr.send(JSON.stringify(data));
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
        animation: google.maps.Animation.DROP,
        label: (numDay+1).toString()
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

  var pinColor = 'ffffff'; // マーカーの色を指定
  var pinImage = new google.maps.MarkerImage('http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|' + pinColor);

  [...dataSpots[numBtnDay]].map((_, i) => {
    markers.push(new google.maps.Marker({
      position: {
        lat: Number(dataSpots[numBtnDay][i].lat),
        lng: Number(dataSpots[numBtnDay][i].lng)
      },
      map: map,
      animation: google.maps.Animation.DROP,
      // icon: pinImage,
      label: (numBtnDay+1).toString()
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
    var marker;

    map.addListener('click', function(e) {
      marker = new google.maps.Marker({
        position: e.latLng,
        map: map,
        animation: google.maps.Animation.DROP
      });


      var wantDay = [];
      btnDays.forEach(function(btnDay, numBtnDay) {
        var dayId = btnDays[numBtnDay].dataset.dayId;
        var day = numBtnDay + 1;
        var params = {
          lat: e.latLng.lat(),
          lng: e.latLng.lng(),
          day_id: dayId
        }
        wantDay[numBtnDay] = "<ol onclick='doPost(" + JSON.stringify(params) + ")'>"+ day +"日目</ol>";
      });
      var olWantDay = wantDay.join('');

      var infoWindow = new google.maps.InfoWindow({
        // content: e.latLng.toString() + "<ul><li>いきたい場所<ol onclick='setDeparture(" +  e.latLng.lat() + ', ' + e.latLng.lng() + ")'>1日目</ol></li><li>マーカーを外す</li></ul>"
        content: e.latLng.toString() + "<ul><li>いきたい場所" + olWantDay + "</li><li>マーカーを外す</li></ul>"
      });
      marker.addListener('click', function() {
        infoWindow.open(map, marker);
      });
    });
  });
}
