$(document).ready(function() {
	// put all your jQuery goodness in here.

	$("#div_hiveControls_grabber").load("/LoginServlet");

	// hide the historical data to start
	$("#div_historicalData").hide();

	loadHistoricalDataDiv("");
	$("#grabber_historicalData").click(function() {
		if ($("#div_historicalData").is(':visible')) {
			$("#div_historicalData").hide('blind');
		} else {
			$("#div_historicalData").show("blind");

		}

	});

  $("#div_hiveControls").hide();

});

// map functions
function loadMarkersFromHiddenDivs() {

	// build map
	var myOptions = {
		center : new google.maps.LatLng(38.1569, -98.6133),
		zoom : 5,
		mapTypeId : google.maps.MapTypeId.TERRAIN
	};
	var map = new google.maps.Map(document.getElementById("div_map_container"),
			myOptions);

	// var image = new google.maps.MarkerImage('images/beeico.png',
	// new google.maps.Size(20, 32),
	// The origin for this image is 0,0.
	// new google.maps.Point(0,0),
	// The anchor for this image is the base of the flagpole at 0,32.
	// new google.maps.Point(0, 32));

	var image = new google.maps.MarkerImage('images/beeico.png');

	// var myLatLng = new google.maps.LatLng(42.9634,-85.6681);
	// var marker = new google.maps.Marker({
	// position: myLatLng,
	// map: map,
	// icon: image
	//          
	// });
	// Creating an InfoWindow object
	// var infowindow = new google.maps.InfoWindow({
	// // content: "<div class='div_infoWindow'>Hello world</div>"
	// });

	// google.maps.event.addListener(marker, 'mouseover', function() {
	// infowindow.open(map, marker);
	// });

	// get all hiverecord divs
	$(".hiveRecord")
			.each(
					function() {
						// get hiveid
						var hiveID = $(this).children(".hiveRecord_hiveID")
								.text();
						var loc_lat = $(this).children(".hiveRecord_loc_lat")
								.text();
						var loc_long = $(this).children(".hiveRecord_loc_long")
								.text();
						var weight = $(this).children(".hiveRecord_weight")
								.text();
						var temperature = $(this).children(
								".hiveRecord_temperature").text();

						// create lat long
						var markLatLong = new google.maps.LatLng(loc_lat,
								loc_long);
						// make marker
						var marker = new google.maps.Marker({
							position : markLatLong,
							map : map,
							icon : image

						});

						var infowindow = new google.maps.InfoWindow(
								{
									content : "<div class='div_infoWindow'><div style='z-index:99' class='clickable_hiveID'>"
											+ hiveID
											+ "</div><br />"
											+ "T:"
											+ temperature
											+ "<br />"
											+ "W:"
											+ weight + "<br />" + "</div>"
								});

						// add open listener
						google.maps.event.addListener(marker, 'mouseover',
								function() {
									infowindow.open(map, marker);
								});
						// add close listener
						google.maps.event.addListener(marker, 'mouseout',
								function() {
									infowindow.close(map, marker);
								});

						// show the historical information
						google.maps.event.addListener(marker, 'click',
								function() {
									setParamHiveID(hiveID);
									loadHistoricalDataDiv(hiveID);
									$("#div_historicalData").show("blind");

								});

					});

}

function setParamHiveID(hiveID) {
	// get the element

	window.location.hash = "hiveID=" + hiveID;

}

function getWindowHash() {
	alert(window.location.hash);
	return window.location.hash;

}

function getUrlVars() {
	var vars = [], hash;
	var hashes = window.location.href.slice(
			window.location.href.indexOf('#') + 1).split('&');
	for ( var i = 0; i < hashes.length; i++) {
		hash = hashes[i].split('=');
		vars.push(hash[0]);
		vars[hash[0]] = hash[1];
	}
	return vars;
}

function loadHistoricalDataDiv(hiveID) {

	$("#div_historicalData").load(
			"includes/historicalData.jsp?hiveID=" + hiveID);

}

function historicalDivActions() {
	// setup historical data listeners
	// hide max to start
	$("#div_historicalData_maxAndMins").hide();

	$("#tab_historicalData_previousRecords").click(function() {

		// hide other divs
		$("#div_historicalData_maxAndMins").hide();

		// show previous records div
		$("#div_historicalData_previousRecords").show();

	});

	$("#tab_historicalData_maxAndMins").click(function() {
		// hide other divs
		$("#div_historicalData_previousRecords").hide();

		// show max and mins
		$("#div_historicalData_maxAndMins").show();
	});

}
