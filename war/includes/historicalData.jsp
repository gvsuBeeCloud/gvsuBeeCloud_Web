<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>

<html>
<head>
<script type="text/javascript" src="../js/jquery-1.7.1.js"></script>
<script type="text/javascript"
	src="../js/jquery-ui-1.8.17.custom.min.js"></script>
<link rel="stylesheet" href="../css/style.css" type="text/css"></link>
<link rel="stylesheet"
	href="../css/smoothness/jquery-ui-1.8.17.custom.css" type="text/css"></link>

<script type="text/javascript" src="../js/highcharts.js"></script>
<script src="../js/modules/exporting.js" type="text/javascript"></script>





<script type="text/javascript">
	$(document).ready(function() {

		//alert("Script working");
		//setup historical data listeners
		//hide max to start
		$("#div_historicalData_maxAndMins").hide();

		$("#btn_historicalData_PreviousRecords").click(function() {

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

		Highcharts.setOptions({
			global : {
				useUTC : false
			}
		});

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

				formatter : function() {
					var unit = {
						'Weight' : 'lbs',
						'Exterior Temperature' : '°C',
						'Interior Temperature' : '°C'
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

		/*
		 combo_chart = new Highcharts.Chart({
		 chart : {
		 renderTo : 'container_weight'
		 },
		 title : {
		 text : 'Combination chart'
		 },
		 xAxis : {
		 categories : [ 'Apples', 'Oranges', 'Pears', 'Bananas',
		 'Plums' ]
		 },
		 tooltip : {
		 formatter : function() {
		 var s;
		 if (this.point.name) { // the pie chart
		 s = '' + this.point.name + ': ' + this.y
		 + ' fruits';
		 } else {
		 s = '' + this.x + ': ' + this.y;
		 }
		 return s;
		 }
		 },
		 labels : {
		 items : [ {
		 html : 'Total fruit consumption',
		 style : {
		 left : '40px',
		 top : '8px',
		 color : 'black'
		 }
		 } ]
		 },
		 series : [ {
		 type : 'column',
		 name : 'Jane',
		 data : [ 3, 2, 1, 3, 4 ]
		 }, {
		 type : 'column',
		 name : 'John',
		 data : [ 2, 3, 5, 7, 6 ]
		 }, {
		 type : 'column',
		 name : 'Joe',
		 data : [ 4, 3, 3, 9, 0 ]
		 }, {
		 type : 'spline',
		 name : 'Average',
		 data : [ 3, 2.67, 3, 6.33, 3.33 ]
		 }, {
		 type : 'pie',
		 name : 'Total consumption',
		 data : [ {
		 name : 'Jane',
		 y : 13,
		 color : highchartsOptions.colors[0]
		 // Jane's color
		 }, {
		 name : 'John',
		 y : 23,
		 color : highchartsOptions.colors[1]
		 // John's color
		 }, {
		 name : 'Joe',
		 y : 19,
		 color : highchartsOptions.colors[2]
		 // Joe's color
		 } ],
		 center : [ 100, 80 ],
		 size : 100,
		 showInLegend : false,
		 dataLabels : {
		 enabled : false
		 }
		 } ]
		 });
		
		 */

	});
</script>

<script type="text/javascript">
	//max and min table functionality

	$(document).ready(function() {

		//when page loads, show six month by default
		//hide all others
		$('.td_maxMin_twelve').hide();

		//if six month selected
		$('#rad_maxMin_6').click(function() {

			$('.td_maxMin_twelve').hide();
			$('.td_maxMin_six').show();

		});

		//if twelve month selected

		$('#rad_maxMin_12').click(function() {

			$('.td_maxMin_six').hide();
			$('.td_maxMin_twelve').show();

		});

		$("#datePicker_start").datepicker();
		$("#datePicker_end").datepicker();

		//if ....

	});
</script>
</head>
<body>

	<div id="tab_historicalData">
		<ul>
			<li name='prev' id='btn_historicalData_PreviousRecords'>Records</li>
			<li name='max' id='btn_historicalData_MaxMin'>MaxMin</li>
			<li name='charts' id='btn_historicalData_Charts'>Charts</li>
		</ul>

	</div>
	<div id='div_historicalData_previousRecords'>
		<%
			//get all the previous records
			String hiveID = request.getParameter("hiveID");
			//try querying
			DatastoreService datastore = DatastoreServiceFactory
					.getDatastoreService();
			Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
			// Run an ancestor query to ensure we see the most up-to-date
			// view of the Greetings belonging to the selected Guestbook.
			Query query = new Query("hiveRecord", hiveKey).addSort("hiveID",
					Query.SortDirection.DESCENDING);
			List<Entity> records = datastore.prepare(query).asList(
					FetchOptions.Builder.withLimit(5));

			//TODO: run query
			for (Entity record : records) {

				String tmpDate = "1.24.2012";
				String tmpTemp_interior = (String) record
						.getProperty("temperature_interior");
				String tmpTemp_exterior = (String) record
						.getProperty("temperature_exterior");
				String tmpWeight = (String) record.getProperty("weight");
		%>
		<div class='div_previousHiveRecord'>

			<div class='div_previousHiveRecord_title'>
				<%
					out.println(tmpDate);
				%>
			</div>
			<div class='div_previousHiveRecord_contents'>
				Weight:
				<%=tmpWeight%>
				<br /> Interior Temp:
				<%=tmpTemp_interior%>
				<br /> Exterior Temp:
				<%=tmpTemp_exterior%>
			</div>

			<div class='div_previousHiveRecord_footer'></div>

		</div>
		<%
			}
		%>
	</div>
	<%
		//build previous records tab

		//get parameter
		//	String hiveID=request.getParameter("hiveID");

		//for debug, echo param
		//out.println("HIVE ID: "+hiveID);
	%>
	<div id='div_historicalData_maxAndMins'>
		<div id='div_historicalData_maxAndMins_record_wrapper'>
			<div id='div_historicalData_maxAndMins_record'>
				<div id='div_historicalData_maxAndMins_record_title'>Record
					Highs and Lows</div>





				<div id='div_historicalData_maxAndMins_record_contents'>
					<div id='nav_historicalData_maxAndMins_record_contents'>
						<div class='rad_large' id='rad_maxMin_allTime' name='rad_maxMin'
							value='99'>All Time</div>

						<div class='rad_large'>
							Start <input type='text' id="datePicker_start">

						</div>
						<div class='rad_large'>

							End <input type='text' id="datePicker_end">

						</div>


					</div>


					<%
						//define any variables we need					

						//build the query
						//try querying
						datastore = DatastoreServiceFactory.getDatastoreService();
						hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
						// Run an ancestor query to ensure we see the most up-to-date
						// view of the Greetings belonging to the selected Guestbook.
						query = new Query("Hive", hiveKey).addSort("hiveID",
								Query.SortDirection.DESCENDING);
						query.addFilter("hiveID", Query.FilterOperator.EQUAL, hiveID);
						records = datastore.prepare(query).asList(
								FetchOptions.Builder.withLimit(999999999));

						if (records.isEmpty()) {
					%>
					<p>Records are empty</p>
					<%
						} else {
							for (Entity record : records) {
					%>
					<table id='table_historicalData_maxAndMins'>
						<tr>
							<th>Hive ID</th>
							<th class='td_maxMin_six'>Exterior Max Temperature</th>
							<th class='td_maxMin_six'>Exterior Min Temperature</th>
							<th class='td_maxMin_six'>Exterior Avg Temperature</th>
							<th class='td_maxMin_twelve'>Exterior Max Weight</th>
							<th class='td_maxMin_twelve'>Exterior Min Weight</th>
							<th class='td_maxMin_twelve'>Exterior Avg Weight</th>
							
						</tr>

						<tr>
							<td><%=record.getProperty("hiveID")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_exterior_max_six")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_exterior_min_six")%></td>
							
							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_exterior_min_six")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_exterior_max_twelve")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_exterior_min_twelve")%></td>
							
							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_exterior_min_twelve")%></td>

						</tr>
						

				

					</table>

					<%
						}
						}
					%>


				</div>

			</div>

		</div>

	</div>

	<div id='div_historicalData_Charts'>
		<div id='container_interiorTemperature'></div>



	</div>


</body>

</html>