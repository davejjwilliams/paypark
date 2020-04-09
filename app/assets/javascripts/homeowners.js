// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

function initMap2() {

    var lat = document.getElementById('homeowner_latitude').value;
    var lng = document.getElementById('homeowner_longitude').value;

    // if not defined create default position
    if (!lat || !lng) {
        lat = 51.5;
        lng = -0.125;
        document.getElementById('homeowner_latitude').value = lat;
        document.getElementById('homeowner_longitude').value = lng;
    }
    var myCoords = new google.maps.LatLng(lat, lng);
    var mapOptions = {
        center: myCoords,
        zoom: 14
    };
    var map = new google.maps.Map(document.getElementById('map2'), mapOptions);
    var marker = new google.maps.Marker({
        position: myCoords,
        animation: google.maps.Animation.DROP,
        map: map,
        draggable: true
    });

    // refresh marker position and recenter map on marker
    function refreshMarker() {
        var lat = document.getElementById('homeowner_latitude').value;
        var lng = document.getElementById('homeowner_longitude').value;
        var myCoords = new google.maps.LatLng(lat, lng);
        marker.setPosition(myCoords);
        map.setCenter(marker.getPosition());
    }

    // when input values change call refreshMarker
    document.getElementById('homeowner_latitude').onchange = refreshMarker;
    document.getElementById('homeowner_longitude').onchange = refreshMarker;

    // when marker is dragged update input values
    marker.addListener('drag', function () {
        latlng = marker.getPosition();
        newlat = (Math.round(latlng.lat() * 1000000)) / 1000000;
        newlng = (Math.round(latlng.lng() * 1000000)) / 1000000;
        document.getElementById('homeowner_latitude').value = newlat;
        document.getElementById('homeowner_longitude').value = newlng;
    });
    // When drag ends, center (pan) the map on the marker position
    marker.addListener('dragend', function () {
        map.panTo(marker.getPosition());
    });
}

function setCords(marker){
    latlng = marker.getPosition();
    newlat = (Math.round(latlng.lat() * 1000000)) / 1000000;
    newlng = (Math.round(latlng.lng() * 1000000)) / 1000000;
    document.getElementById('homeowner_latitude').value = newlat;
    document.getElementById('homeowner_longitude').value = newlng;
    document.getElementById('homeowner_address').value = marker.title;
}

function initMap3() {

    // Spawn map
    var map = new google.maps.Map(document.getElementById('map2'), {
        center: {lat: 51.241920, lng: -0.585900},
        zoom: 14,
        mapTypeId: 'roadmap'
    });

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

            // Clear last marker
            marker.setMap(null);

            // Drop marker
            marker = new google.maps.Marker({
                position: place.geometry.location,
                animation: google.maps.Animation.DROP,
                map: map,
                title: place.name,
                draggable: true
            }); setCords(marker);

            // when marker is dragged update input values
            marker.addListener('drag', function () {
                setCords(marker);
            });

            // When drag ends, center (pan) the map on the marker position
            marker.addListener('dragend', function () {
                if((Math.abs(marker.position.lat() - place.geometry.location.lat()) > 0.00005) || (Math.abs(marker.position.lng() - place.geometry.location.lng()) > 0.0001)){
                    // Put marker back to beginning position
                    marker.setPosition(place.geometry.location);
                    map.panTo(marker.getPosition());
                    setCords(marker);
                }
                else{ // When drag within limit
                    map.panTo(marker.getPosition());
                }
            });

            // Not too sure, something to do with the zoom level fitting to the bounds
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
