  // Create an array of styles.
  var map_styles = [
    {
    "featureType": "poi.attraction",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.business",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.place_of_worship",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "transit.line",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.attraction",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.medical",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.school",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "landscape.man_made",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      { "lightness": 41 }
    ]
  },{
    "featureType": "transit.station.airport",
    "stylers": [
      { "lightness": 49 }
    ]
  },{
    "featureType": "administrative",
    "elementType": "labels.text.fill",
    "stylers": [
      { "saturation": -100 },
      { "lightness": 24 }
    ]
  },{
    "featureType": "road.highway",
    "stylers": [
      { "lightness": 26 }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      { "visibility": "simplified" },
      { "color": "#d6cfc6" },
      { "lightness": 43 }
    ]
  },{
    "featureType": "road.local",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#d6cfc6" },
      { "lightness": 42 }
    ]
  },{
    "featureType": "road.local",
    "elementType": "geometry.stroke",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "geometry.stroke",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      { "visibility": "on" }
    ]
  },{
    "featureType": "poi.park",
    "elementType": "labels",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "transit.station.rail",
    "elementType": "labels",
    "stylers": [
      { "saturation": -73 },
      { "lightness": 27 }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      { "visibility": "on" },
      { "lightness": -5 }
    ]
  },{
    "featureType": "administrative.land_parcel",
    "stylers": [
      { "visibility": "off" }
    ]
  },{
  }
];

var Marker = function(options) {
  google.maps.Marker.apply(this, arguments);
  if (options.label) {
    this.MarkerLabel = new MarkerLabel({
      map: this.map,
      marker: this,
      text: options.label
    });
    this.MarkerLabel.bindTo('position', this, 'position');
  }
};

// Define Marker Shapes
var MAP_HOME = 'M 239.96,415.88L 23.72,199.6L 96.52,199.56L 96.52,0.080L 383.4,0.080L 383.4,199.52L 456.28,199.52 z';
var MAP_PIN = 'M 314.692,279.496c0,80.988-65.892,146.88-146.88,146.88S 20.933,360.496, 20.933,279.496c0-74.868, 56.364-136.704, 128.88-145.62 l0-144.252 l 36,0 L 185.813,133.876 C 258.317,142.792, 314.692,204.64, 314.692,279.496z';

// Create Custom Marker Object
Marker.prototype = new google.maps.Marker();

// Custom Marker SetMap
Marker.prototype.setMap = function() {
  google.maps.Marker.prototype.setMap.apply(this, arguments);
  (this.MarkerLabel) && this.MarkerLabel.setMap.apply(this.MarkerLabel, arguments);
};
 
// Marker Label Overlay
var MarkerLabel = function(options) {
  var self = this;
  this.setValues(options);
  
  // Create the label container
  this.div = document.createElement('div');
  this.div.className = 'marker-label';
  var span = document.createElement('span');
  span.className = "marker-icon";
  this.div.appendChild(span);
 
  // Trigger the marker click handler if clicking on the label
  google.maps.event.addDomListener(this.div, 'click', function(e){
    (e.stopPropagation) && e.stopPropagation();
    google.maps.event.trigger(self.marker, 'click');
  });
};

// Create MarkerLabel Object
MarkerLabel.prototype = new google.maps.OverlayView;

// Marker Label onAdd
MarkerLabel.prototype.onAdd = function() {
     var pane = this.getPanes().overlayImage.appendChild(this.div);
     var self = this;
     this.listeners = [
          google.maps.event.addListener(this, 'position_changed', function() { self.draw(); }),
          google.maps.event.addListener(this, 'text_changed', function() { self.draw(); }),
          google.maps.event.addListener(this, 'zindex_changed', function() { self.draw(); })
     ];
};
 
// Marker Label onRemove
MarkerLabel.prototype.onRemove = function() {
     this.div.parentNode.removeChild(this.div);
     for (var i = 0, I = this.listeners.length; i < I; ++i) {
          google.maps.event.removeListener(this.listeners[i]);
     }
};
 
// Implement draw
MarkerLabel.prototype.draw = function() {
     var projection = this.getProjection();
     var position = projection.fromLatLngToDivPixel(this.get('position'));
     var div = this.div;
     div.style.left = position.x + 'px';
     div.style.top = position.y + 'px';
     div.style.display = 'block';
     div.style.zIndex = this.get('zIndex'); //ALLOW LABEL TO OVERLAY MARKER
     this.div.innerHTML = this.get('text').toString();
};