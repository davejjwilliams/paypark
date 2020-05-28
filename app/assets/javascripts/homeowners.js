function setCords(marker){
    latlng = marker.getPosition();
    newlat = (Math.round(latlng.lat() * 1000000)) / 1000000;
    newlng = (Math.round(latlng.lng() * 1000000)) / 1000000;
    document.getElementById('homeowner_latitude').value = newlat;
    document.getElementById('homeowner_longitude').value = newlng;
    document.getElementById('homeowner_address').value = marker.title;
}

function initMapHO() {

    // Spawn map
    var map = new google.maps.Map(document.getElementById('map2'), {
        center: {lat: 51.241920, lng: -0.585900},
        zoom: 14,
    });

    infoWindow = new google.maps.InfoWindow;

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            infoWindow.setPosition(pos);
            infoWindow.setContent('Location found ~ 1 mile');
            infoWindow.open(map);
            map.setCenter(pos);
        }, function() {
            //Device may have location services turned off in OS settings
            handleLocationError(true, infoWindow, map.getCenter());
        });
    } else {
        // Browser doesn't support Geolocation
        handleLocationError(false, infoWindow, map.getCenter());
    }

    function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(browserHasGeolocation ?
            'Error: The Geolocation service failed.' :
            'Error: Your browser doesn\'t support geolocation.');
        infoWindow.open(map);
    }
    setTimeout(function(){infoWindow.close(map);}, '4000');

    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    //map.controls[google.maps.ControlPosition.BOTTOM_RIGHT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function() {
        searchBox.setBounds(map.getBounds());
    });

    // Everytime there is a new search
    var marker = new google.maps.Marker({});
    var rectangle = new google.maps.Rectangle({});
    searchBox.addListener('places_changed', function() {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        // For each place, get the icon, name and location.
        var bounds = new google.maps.LatLngBounds();
        places.forEach(function(place) {
            if (!place.geometry) {
                console.log("Returned place contains no geometry");
                return;
            }

            // Clear last marker and rectangle area
            marker.setMap(null);
            rectangle.setMap(null);

            // Drop marker
            marker = new google.maps.Marker({
                position: place.geometry.location,
                animation: google.maps.Animation.DROP,
                map: map,
                title: place.formatted_address,
                draggable: true
            }); setCords(marker);

            rectangle = new google.maps.Rectangle({
                strokeColor: '#ff0000',
                strokeOpacity: 0.9,
                strokeWeight: 2,
                fillColor: '#FF0000',
                fillOpacity: 0.35,
                map: map,
                bounds: {
                    north: place.geometry.location.lat() + 0.0000625,
                    south: place.geometry.location.lat() - 0.0000625,
                    east: place.geometry.location.lng() + 0.0001,
                    west: place.geometry.location.lng() - 0.0001
                }
            });

            // when marker is dragged update input values
            marker.addListener('drag', function () {
                setCords(marker);
            });

            // When drag ends, center (pan) the map on the marker position
            marker.addListener('dragend', function () {
                if((Math.abs(marker.position.lat() - place.geometry.location.lat()) > 0.0000625) || (Math.abs(marker.position.lng() - place.geometry.location.lng()) > 0.0001)){
                    // Put marker back to beginning position
                    marker.setPosition(place.geometry.location);
                    map.panTo(marker.getPosition());
                    setCords(marker);
                }
                else{ // When drag within limit
                    map.panTo(marker.getPosition());
                }
            });

            //zoom level fitting to the bounds
            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        });
        map.fitBounds(bounds);
    });
}