var markers = []; //used to store markers found to be in bounds

function initMap() {

    //SPAWN MAP
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 51.241920, lng: -0.585900},
        zoom: 14,
    });

    //GEOLOCATION
    infoWindow = new google.maps.InfoWindow;
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            infoWindow.setPosition(pos);
            infoWindow.setContent('Your location');
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

    //PLACE MARKERS
    var marker, contentString;
    var infowindowDriver = new google.maps.InfoWindow({
        //content: contentString
    });
    gon.driveways.forEach(myFunction);
    function myFunction(item, index){
        marker = new google.maps.Marker({
            position: {lat: parseFloat(gon.driveways[index].latitude), lng: parseFloat(gon.driveways[index].longitude)},
            map: map,
            title: gon.driveways[index].address,
            id: gon.driveways[index].id
        });
        var link = "/bookings/new?dvwid=".concat(gon.driveways[index].id);
        google.maps.event.addListener(marker, 'click', (function (marker) {
            return function () {
                var rating = 0;
                if (parseInt(gon.driveways[index].number_ratings) > 0) {
                    rating = parseFloat(gon.driveways[index].total_ratings) / parseInt(gon.driveways[index].number_ratings);
                }
                infowindowDriver.setContent(
                    gon.driveways[index].address + '<br>' + '<br>' +
                    '£' + parseFloat(gon.driveways[index].driveway_price) + ' per hour' + '<br>' +
                    'Rating: ' + rating.toFixed(2) + '/5<br>' +
                    gon.driveways[index].driveway_description + '<br><a style="text-decoration: underline" class="has-text-primary has-text-weight-bold is-size-5" href="' + link + '">Book now</a>');
                infowindowDriver.open(map, marker);
            }
                ;
        })(marker));
        markers.push(marker); //store markers to found to be in bounds later
    }

    //CHECK MARKERS IN BOUNDS
    map.addListener('idle', function() {
        showVisibleMarkers();
    });

    //SEARCH BOX
    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    //map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);

    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function() {
        searchBox.setBounds(map.getBounds());
    });

    // Everytime there is a new search
    var markerSearch = new google.maps.Marker({});
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
            markerSearch.setMap(null);

            // Drop marker
            markerSearch = new google.maps.Marker({
                position: place.geometry.location,
                animation: google.maps.Animation.DROP,
                map: map,
                icon: 'http://maps.google.com/mapfiles/ms/icons/purple-dot.png'
            });

            // zoom level fitting to the bounds
            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        });
        map.fitBounds(bounds);
    });

    //LIST MARKERS IN BOUNDS
    function showVisibleMarkers() {
        var local = [];
        for (var i = 0; i < markers.length; i++) {
            if (map.getBounds().contains(markers[i].getPosition()) === true) {
                local.push(markers[i].title)
            }
        }
        displayLocals(local);
    }
}

function displayLocals(local)
{
    document.getElementById('localsList').children[0].innerHTML = "";
    for(var i = 0; i < local.length; i++){
        document.getElementById("localsList").children[0].innerHTML += "<li>"+local[i]+"</li>"+"&nbsp";
    }
}