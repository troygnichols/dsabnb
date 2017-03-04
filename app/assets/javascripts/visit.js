(function() {
  function initVisitMap() {
    var marker;
    var circle;

    var latLng = new google.maps.LatLng(38.5, -96);
    var map = new google.maps.Map(document.getElementById("visit-map"), {
      zoom: 4,
      center: latLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    map.addListener('click', function(event) {
      var dist = document.getElementById('visit_distance').value;
      marker = addMarker(map, event.latLng, marker);
      circle = addCircle(map, event.latLng, dist, circle);
      setAddress(event.latLng);
    });

    var geocoder = new google.maps.Geocoder();

    document.getElementById('visit-map-search').addEventListener('click', function(event) {
      event.preventDefault();
      var address = document.getElementById('visit_location').value;
      geocodeAddress(address, geocoder, function (latLng) {
        var dist = document.getElementById('visit_distance').value;
        map.setCenter(latLng);
        marker = addMarker(map, latLng, marker);
        circle = addCircle(map, latLng, dist, circle);
      });
    });
  }

  function setAddress(latLng) {
    document.getElementById('visit_location').value = formatLatLng(latLng);
  }

  function geocodeAddress(address, geocoder, callback) {
    geocoder.geocode({address: address}, function(results, status) {
      if (status === 'OK') {
        callback(results[0].geometry.location);
      } else {
        alert('Could not find address, error: ' + status);
      }
    });
  }

  function formatLatLng(latLng) {
    return '' + latLng.lat() + ',' + latLng.lng()
  }

  function addMarker(map, latLng, oldMarker) {
    removeMarker(oldMarker);
    var marker = new google.maps.Marker({
      position: latLng,
      map: map
    });
    return marker;
  }

  function addCircle(map, latLng, radius, oldCircle) {
    removeCircle(oldCircle);
    var circle = new google.maps.Circle({
      strokeColor:   '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight:  2,
      fillColor:     '#FF0000',
      fillOpacity:   0.35,
      map:           map,
      center:        latLng,
      radius:        milesToMeters(radius)
    });
    return circle;
  }

  function removeMarker(marker) {
    if (marker) {
      marker.setMap(null);
    }
  }

  function removeCircle(circle) {
    if (circle) {
      circle.setMap(null);
    }
  }

  function milesToMeters(miles) {
    return miles * 1609.34;
  }

  google.maps.event.addDomListener(window, "load", initVisitMap);
})();
