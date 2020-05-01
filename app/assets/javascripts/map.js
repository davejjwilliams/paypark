function initMap() {
    var cen = {lat: 51.5, lng: -0.13};
    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 14,
        center: cen
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

    var marker, count, contentString;
    var infowindow = new google.maps.InfoWindow({
        //content: contentString
    });

    gon.driveways.forEach(myFunction);
    function myFunction(item, index){
        marker = new google.maps.Marker({
            position: {lat: parseFloat(gon.driveways[index].latitude), lng: parseFloat(gon.driveways[index].longitude)},
            map: map,
        });
        //var link = "/homeowners/".concat(gon.driveways[index].id);
        var link = "/bookings/new?dvwid=".concat(gon.driveways[index].id);
        google.maps.event.addListener(marker, 'click', (function (marker) {
            return function () {
                var str = "Book";
                var result = str.link(link);
                infowindow.setContent(
                    gon.driveways[index].address + '<br>' + '<br>' +
                    '£' + parseFloat(gon.driveways[index].driveway_price) + ' per hour' + '<br><br>' +
                    gon.driveways[index].driveway_description + '<br>' + result);
                infowindow.open(map, marker);
            }
                ;
        })(marker, count));
    }

    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    //map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);

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
                icon: 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png'
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
