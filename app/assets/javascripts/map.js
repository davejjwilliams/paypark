function initMap() {
    var locations = [[51.5,-0.125, 'name'],[51.5,-0.135,'name']]
    var cen = {lat: 51.5, lng: -0.13};
    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 14,
        center: cen
    });

    var marker, count, contentString;
    var infowindow = new google.maps.InfoWindow({
        //content: contentString
    });

    for (count = 0; count < locations.length; count++) {
        marker = new google.maps.Marker({
            position: {lat: (locations[count][0]), lng: (locations[count][1])},
            map: map,
        });
        google.maps.event.addListener(marker, 'click', (function (marker, count) {
            return function () {
                infowindow.setContent((locations[count][2]) + '<p></p><a href="https://developers.google.com/maps/documentation/javascript/infowindows">' +
                    'Book</a>');
                infowindow.open(map, marker);
            }
        })(marker, count));
    }
}