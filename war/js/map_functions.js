//Retrieve the start and end dates specified by the user, as
/*//well as the checkboxes that have been selected

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
*/
$(document).ready(function() {
	
//add historical data listeners
  addListeners();
  
  //load historical data divs
  loadAllDivs();

  //debug
 
});
function loadAllDivs(){
	//$("#data").load("includes/maxMin.jsp");
	
	//setupCharts();
}
function addListeners(){

	//setup historical data listeners
	
	//$("#div_historicalData_maxAndMins").hide();
//	$("#div_historicalData_Charts").hide();
	
	$("#div_map_container").hide();
	$(".content_wrapper").hide();
	$(".datePick").datepicker();
	$("#test").hide();
	
	determineView();

	

	$("#btn_historicalData_MaxMin").click(function() {
		//hide other divs
		$("#div_historicalData_Charts").hide();

		//show max and mins
		$("#div_historicalData_maxAndMins").show();
	});

	$("#btn_historicalData_Charts").click(function() {
		//hide other divs
		$("#div_historicalData_maxAndMins").hide();

		//show charts
		$("#div_historicalData_Charts").show();

	});
	

	createChart();
	
	
	
	///
	
	$("#nav_data").click(function(){
		$(".content_wrapper").hide();
		$("#div_map_container").hide();

		$("#data").show();
	});
	
	$("#nav_charts").click(function(){
		$(".content_wrapper").hide();
		$("#div_map_container").hide();

		$("#charts").show();
	});
	

	$("#nav_map").click(function(){
		$(".content_wrapper").hide();
		//$("#div_map_container").hide();

		$("#div_map_container").show();
	});
}

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
/*
						var infowindow = new google.maps.InfoWindow(
								{
									content : "<div class='div_infoWindow'><div style='z-index:99' class='clickable_hiveID'>"
											+ hiveID
											+ "<br />"
											+ alias
											+ "<br />"
											+ timestamp
											+ "</div><br />"
											+ "iT: " + iTemperature + " °C"
											+ "<br />"
											+ "eT: " + eTemperature + " °C"
											+ "<br />"
											+ "W: "+ weight + " lbs."
											+ "<br />"
											+ "B: " + battery + " %"
											+"</div>"
								});
								
								*/
						//infowindow.open(map);

						// add open listener
						google.maps.event.addListener(marker, 'mouseover',
								function(event) {
							var overlay = new google.maps.OverlayView();
							overlay.draw = function() {};
							overlay.setMap(map);
							//alert("mouse");
							
							var projection = overlay.getProjection(); 
						    var pixel = projection.fromLatLngToContainerPixel(marker.getPosition());
						    
						    var mouseX=pixel.x;
						    var mouseY=pixel.y;
						    
						    $('#hive'+hiveID).css("left",$('#div_map_container').offset().left);
						    $('#hive'+hiveID).css("top",$('#div_map_container').offset().top);
						    $('#hive'+hiveID).css("z-index","99");
						   // alert($('#div_map_container').offset().left);

						    
						//    alert($('#hive'+hiveID).css("left"));
						    
						    $(".hiveRecord").hide();
						    if($('#hive'+hiveID).is(":visible")){
						    	
						    }
						    $('#hive'+hiveID).slideDown();
						  //  alert('#hive'+hiveID);
					
								
							
							

								});
						// add close listener
						google.maps.event.addListener(marker, 'mouseout',
								function() {
					       $('#hive'+hiveID).hide();

								});
/*
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
								
							*/

					});
					

}


function setParamByName(name,value){
	window.location.hash += "&"+name+"="+value;
	
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


function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
        //alert("keY: "+ hash[0]+"	val: "+hash[1]);
    }
    return vars;
}

function determineView(){
	var vars= getUrlVars();
	var view="unknown";

	if(vars["view"]!=null){
		view=vars["view"];
	}
	if(view == "data"){
		$("#data").show();
	}else if(view == "charts"){
		$("#charts").show();
		
	}else{
		//show map by default
		$("#div_map_container").show();
	}
}

function getAllValuesByName(series,name){
	var values=[];
	$("."+name).each(function(){
		alert("found : "+ name);
		alert("text"+ $(this).text());
		values.push($(this).text());
		
		//alert("in");
	});
	
	return values;
}

function setupCharts(){
	alert("here");
	//determine if all necessary information is present
	if($(".div_chart_hiveRecord").length >0){
		alert("found "+ $(".div_chart_hiveRecord").length +"records");
		//alert("found "+ getAllValuesByName("chart_intTemp").length +"intTemp");
		//alert("found "+ getAllValuesByName("chart_extTemp").length +"extTemp");
		//alert("found "+ getAllValuesByName("chart_weight").length +"weight");
	
	
		

	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});
	
	     var chart1 = new Highcharts.Chart({
	         chart: {
	            renderTo: 'container_interiorTemperature',
	            type: 'spline',
	         },
	         title: {
	            text: 'Hive Metrics'
	         },
	         xAxis: {
	            categories: ['4/13','4/14','4/15','4/16', '4/17', '4/18']
	         },
	         yAxis: {
	            title: {
	               text: 'Relevant unit of measure (degree or lbs)'
	            }
	         },
	         series: [{
	            name: 'Weight',
	            data: []
	         }, {
	            name: 'Int Temperature',
	            data: []
	         },{
		            name: 'Ext Temperature',
		            data: []
		         }]
	      });

	
			$(".intTemp").each(function(){
				//alert("found : "+ name);
				//alert("text"+ $(this).text());
				//values.push($(this).text());
				chart1.options.series[1].data.push($(this).text());
				//alert("in");
			});
			$(".extTemp").each(function(){
			//	alert("found : "+ name);
			//	alert("text"+ $(this).text());
			//	values.push($(this).text());
				chart1.options.series[2].data.push($(this).text());

				//alert("in");
			});
			
			$(".weight").each(function(){
				//alert("found : "+ name);
				//alert("text"+ $(this).text());
				//values.push($(this).text());
				chart1.options.series[0].data.push($(this).text());

				
				
				//alert("in");
			});
	
	     chart1.setSize(960,800);
	
	

		

	//var box=$('#datePicker_start');
//	box.datepicker();
	//alert("hello")
	}else{
		alert("no records found");
	}
}

function createChart(){
	setupCharts();
}

