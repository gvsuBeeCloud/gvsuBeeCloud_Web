//Retrieve the start and end dates specified by the user, as
//well as the checkboxes that have been selected
function datQuery(hiveID,alias){

 	    //get the start and end date parameters
	    var startDate=$("#datePicker_start").val();
		var endDate=$("#datePicker_end").val();
		setParamByName("dp_start",startDate);
		setParamByName("dp_end",endDate);
		
		//identify the checkboxes that were checked
		var listOfChecked = $(":checked");
		for(var i=0; i < listOfChecked.length; i++)
		{
			var identifier = getElementIDByObject(listOfChecked[i]);
			
			setParamByName(identifier,"1");
		}
			  
	    //reload the historical data div with the new URL
		loadHistoricalDataDiv(hiveID,alias,startDate,endDate,"blah");

		//Remove old query information from the URL another query can
		//be performed.
		window.location = clrURLForQuery();
		
		
		
		

}

function getElementIDByObject(elementObjectRef){
	return $(elementObjectRef).attr('id');
}

$(document).ready(function() {
	
	// put all your jQuery goodness in here.


	// hide the historical data to start
	//$("#div_historicalData").hide();

	/*
	$("#grabber_historicalData").click(function() {
		if ($("#div_historicalData").is(':visible')) {
			$("#div_historicalData").hide('blind');
		} else {
			$("#div_historicalData").show("blind");
			
		}

	});
	*/
  $("#div_hiveControls").hide();
  $("#div_login").hide();
  

  setup();
  loadHistoricalDataDiv();
  
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

	var image = new google.maps.MarkerImage('images/beeico.gif');

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
					
						var alias = $(this).children(".hiveRecord_aliasID")
						.text();
						
						var timestamp = $(this).children(".hiveRecord_timeStamp")
						.text();
	
						var loc_lat = $(this).children(".hiveRecord_loc_lat")
								.text();
						var loc_long = $(this).children(".hiveRecord_loc_long")
								.text();
						var weight = $(this).children(".hiveRecord_weight")
								.text();
						var iTemperature = $(this).children(
								".hiveRecord_iTemperature").text();
						var eTemperature = $(this).children(
							".hiveRecord_eTemperature").text();
						var battery = $(this).children(
						".hiveRecord_battery").text();

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
											+ "<br />"
											+ alias
											+ "<br />"
											+ timestamp
											+ "</div><br />"
											+ "iT: " + iTemperature + " Â°C"
											+ "<br />"
											+ "eT: " + eTemperature + " Â°C"
											+ "<br />"
											+ "W: "+ weight + " lbs."
											+ "<br />"
											+ "B: " + battery + " %"
											+"</div>"
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
						
									//get start and end dates from url...
									window.location.hash="";
							
									setParamByName("hiveID",hiveID);
									setParamByName("alias",alias);
								

									loadHistoricalDataDiv();
									//$("#div_historicalData").show("blind");
								});

					});

}


function setParamByName(name,value){
	window.location.hash += "&"+name+"="+value;
	
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

//get the parent vars. Meaning do not look at the hash...I think...
function getParentUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

function clrURLForQuery()
{
	var str = window.location.hash;
	var urlStr = "";
	var count = 0;
	for(var i = 0; i < str.length; i++)
	{
		if(str.charAt(i) == '&')
		{
			count++;
		}
		if(count > 2)
		{
			break;
		}
		else
		{
			urlStr = urlStr + str.substring(i,i+1);
		}
	}
	//alert(urlStr);
	return urlStr;
}


function loadHistoricalDataDiv(hiveID,alias,startDate,endDate,checkbox_status) {
	var str = window.location.hash;
	//alert(str.substring(1,str.length));
	$("#div_historicalData").load("includes/historicalData.jsp?"+str.substring(1,str.length));
	//window.location.href.replace("includes/historicalData.jsp?"+str.substring(1,str.length), "includes/historicalData.jsp?" + clrURLForQuery() );

}
function loadHistoricalDataDiv() {
	var str = window.location.hash;
	//alert(str.substring(1,str.length));
	$("#div_historicalData").load('includes/historicalData.jsp?'+str.substring(1,str.length +'#include_wrapper'));
	//window.location.href.replace("includes/historicalData.jsp?"+str.substring(1,str.length), "includes/historicalData.jsp?" + clrURLForQuery() );

}





function setup(){
	
	

	//alert("Script working");
	//setup historical data listeners
	//hide max to start
	$("#div_historicalData_maxAndMins").hide();
	$("#div_historicalData_previousRecords").hide();
	$("#div_historicalData_Charts").show();
	alert("before date");
	$(".datePick").datepicker();
	alert("changes");
	$("#btn_historicalData_previousRecords").click(function() {

		//hide other divs
		$("#div_historicalData_maxAndMins").hide();
		$("#div_historicalData_Charts").hide();

		//show previous records div
		$("#div_historicalData_previousRecords").show();

	});

	$("#btn_historicalData_MaxMin").click(function() {
		//hide other divs
		$("#div_historicalData_previousRecords").hide();
		$("#div_historicalData_Charts").hide();

		//show max and mins
		$("#div_historicalData_maxAndMins").show();
	});

	$("#btn_historicalData_Charts").click(function() {
		//hide other divs
		$("#div_historicalData_maxAndMins").hide();
		$("#div_historicalData_previousRecords").hide();

		//show charts
		$("#div_historicalData_Charts").show();

	});
	

//alert("this far");
	
	
	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});
	//alert("after");
/*
	//make charts
	chart_combo = new Highcharts.Chart({
		chart : {

			renderTo : 'container_interiorTemperature',
			defaultSeriesType : 'spline',
			marginRight : 100,
			marginTop : 100,
			events : {
				load : function() {

					// set up the updating of the chart each second
					var series = this.series[0];
					setInterval(function() {
						var x = (new Date()).getTime(), // current time
						y = Math.random();
						series.addPoint([ x, y ], true, true);
					}, 5000);

					// set up the updating of the chart each second
					var series2 = this.series[1];

					setInterval(function() {
						var x = (new Date()).getTime(), // current time
						y = Math.random();
						series2.addPoint([ x, y ], true, true);
					}, 5000);

					// set up the updating of the chart each second
					var series3 = this.series[2];

					setInterval(function() {
						var x = (new Date()).getTime(), // current time
						y = Math.random() * 200;
						series3.addPoint([ x, y ], true, true);
					}, 5000);

				}
			}
		},
		title : {
			text : "Hive Metrics"
		},

		// exporting module
		exporting : {
			buttons : {
				exportButton : {
					hoverSymbolFill : "#768F3E",
					//	onclick: ,
				    menuItems: null,
					symbol : "exportIcon",
					symbolFill : "#A8BF77",
					x : 10,
					align : "right",
					backgroundColor: "#000000",
					borderColor : "#B0B0B0",
					borderRadius : 3,
					borderWidth : 1,
					enabled : true,
					height : 20,
					hoverBorderColor : "#909090",
					hoverSymbolStroke : "#4572A5",
					symbolSize : 12,
					symbolStroke : "#A0A0A0",
					symbolStrokeWidth : 1,
					symbolX : 11.5,
					symbolY : 10.5,
					verticalAlign : "top",
					width : 24,
					y : 10
				},
				printButton : {
					hoverSymbolFill : "#779ABF",
					//	onclick: ,
					symbol : "printIcon",
					symbolFill : "#B5C9DF",
					x : -36,
					align : "right",
					//	backgroundColor: ,
					borderColor : "#B0B0B0",
					borderRadius : 3,
					borderWidth : 1,
					enabled : true,
					height : 20,
					hoverBorderColor : "#909090",
					hoverSymbolStroke : "#4572A5",
					symbolSize : 12,
					symbolStroke : "#A0A0A0",
					symbolStrokeWidth : 1,
					symbolX : 11.5,
					symbolY : 10.5,
					verticalAlign : "top",
					width : 24,
					y : 10
				}
			},
			enabled : true,
			enableImages : false,
			filename : "chart",
			type : "image/png",
			url : "http://export.highcharts.com",
			width : 800
		},
		navigation: {
		//	menuStyle: ,
		//  menuItemStyle: ,
		//	menuItemHoverStyle: ,
			buttonOptions: {
			align: "right",
		//	backgroundColor: ,
			borderColor: "#B0B0B0",
			borderRadius: 3,
			borderWidth: 1,
			enabled: true,
			height: 20,
			hoverBorderColor: "#909090",
			hoverSymbolFill: "#81A7CF",
			hoverSymbolStroke: "#4572A5",
			symbolFill: "#E0E0E0",
			symbolSize: 12,
			symbolStroke: "#A0A0A0",
			symbolStrokeWidth: 1,
			symbolX: 11.5,
			symbolY: 10.5,
			verticalAlign: "top",
			width: 24,
			y: 10
			}
			},

		xAxis : {
			type : 'datetime',
			tickPixelInterval : 150
		},
		yAxis : [ {
			title : {
				text : 'Temperature'
			},
			opposite : false,

			plotLines : [ {
				value : 0,
				width : 1,
				color : '#808080'
			} ]
		}, { //secondary y axis 
			title : {
				text : 'Weight'
			},
			opposite : true,
			plotLines : [ {
				value : 0,
				width : 1,
				color : '#333aaa'
			} ]

		}

		],
		tooltip : {
			
			
			*/
			/*formatter : function() {
				return '<b>'
						+ this.series.name
						+ '</b><br/>'
						+ Highcharts.dateFormat(
								'%Y-%m-%d %H:%M:%S', this.x)
						+ '<br/>'
						+ Highcharts.numberFormat(this.y, 2);
			}
			}*/

			
			/*
		
			formatter : function() {
				var unit = {
					'Weight' : 'lbs',
					'Exterior Temperature' : '¡C',
					'Interior Temperature' : '¡C'
				}[this.series.name];

				return '' + this.x + ': ' + this.y + ' ' + unit;
			}
		},
		legend : {
			enabled : false
		},
		exporting : {
			enabled : false
		},
		series : [ {
			name : 'Interior Temperature',
			data : (function() {
				// generate an array of random data
				var data = [], time = (new Date()).getTime(), i;

				for (i = -19; i <= 0; i++) {
					data.push({
						x : time + i * 1000,
						y : Math.random()
					});
				}
				return data;
			})()
		}, {

			name : 'Exterior Temperature',
			data : (function() {
				// generate an array of random data
				var data = [], time = (new Date()).getTime(), i;

				for (i = -19; i <= 0; i++) {
					data.push({
						x : time + i * 1000,
						y : Math.random()
					});
				}
				return data;
			})()
		}, {
			type : 'spline',
			name : 'Weight',
			yAxis : 1,
			data : (function() {
				// generate an array of random data
				var data = [], time = (new Date()).getTime(), i;

				for (i = -19; i <= 0; i++) {
					data.push({
						x : time + i * 1000,
						y : Math.random() * 200
					});
				}
				return data;
			})()
		}

		],
		center : [ 100, 80 ],
		size : 100
	});
	*/

	//alert("now here");
	var box=$('#datePicker_start');
	box.datepicker();
	//alert("hello");
}

