<html>
<head>
<script type="text/javascript" src="../js/jquery-1.7.1.js"></script>
<link rel="stylesheet" href="../css/style.css" type="text/css"></link>
<script type="text/javascript" src="../js/highcharts.js"></script>




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

		//show and hide historical data div

	});

	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	var chart_interiorTemperature;
	$(document).ready(
			function() {
				chart_interiorTemperature = new Highcharts.Chart({
					chart : {
						backgroundColor : "#dddddd",
						renderTo : 'container_interiorTemperature',
						defaultSeriesType : 'spline',
						marginRight : 10,
						events : {
							load : function() {

								// set up the updating of the chart each second
								var series = this.series[0];
								setInterval(function() {
									var x = (new Date()).getTime(), // current time
									y = Math.random();
									series.addPoint([ x, y ], true, true);
								}, 5000);
							}
						}
					},
					title : {
						text : 'Interior Temperature'
					},
					xAxis : {
						type : 'datetime',
						tickPixelInterval : 150
					},
					yAxis : {
						title : {
							text : 'Value'
						},
						plotLines : [ {
							value : 0,
							width : 1,
							color : '#808080'
						} ]
					},
					tooltip : {
						formatter : function() {
							return '<b>'
									+ this.series.name
									+ '</b><br/>'
									+ Highcharts.dateFormat(
											'%Y-%m-%d %H:%M:%S', this.x)
									+ '<br/>'
									+ Highcharts.numberFormat(this.y, 2);
						}
					},
					legend : {
						enabled : false
					},
					exporting : {
						enabled : false
					},
					series : [ {
						name : 'Random data',
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
					} ]
				});

			});
</script>

<script>
	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	var chart_exteriorTemperature;
	$(document).ready(
			function() {
				chart_exteriorTemperature = new Highcharts.Chart({
					chart : {
						backgroundColor : "#dddddd",
						renderTo : 'container_exteriorTemperature',
						defaultSeriesType : 'spline',
						marginRight : 10,
						events : {
							load : function() {

								// set up the updating of the chart each second
								var series = this.series[0];
								setInterval(function() {
									var x = (new Date()).getTime(), // current time
									y = Math.random();
									series.addPoint([ x, y ], true, true);
								}, 5000);
							}
						}
					},
					title : {
						text : 'Exterior Temperature'
					},
					xAxis : {
						type : 'datetime',
						tickPixelInterval : 150
					},
					yAxis : {
						title : {
							text : 'Value'
						},
						plotLines : [ {
							value : 0,
							width : 1,
							color : '#808080'
						} ]
					},
					tooltip : {
						formatter : function() {
							return '<b>'
									+ this.series.name
									+ '</b><br/>'
									+ Highcharts.dateFormat(
											'%Y-%m-%d %H:%M:%S', this.x)
									+ '<br/>'
									+ Highcharts.numberFormat(this.y, 2);
						}
					},
					legend : {
						enabled : false
					},
					exporting : {
						enabled : false
					},
					series : [ {
						name : 'Random data',
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
					} ]
				});

			});
</script>

<script>
	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	var chart_weight;
	$(document).ready(
			function() {
				chart_weight = new Highcharts.Chart({
					chart : {
						backgroundColor : "#dddddd",
						renderTo : 'container_weight',
						defaultSeriesType : 'spline',
						marginRight : 10,
						events : {
							load : function() {

								// set up the updating of the chart each second
								var series = this.series[0];
								setInterval(function() {
									var x = (new Date()).getTime(), // current time
									y = Math.random();
									series.addPoint([ x, y ], true, true);
								}, 5000);
							}
						}
					},
					title : {
						text : 'Weight'
					},
					xAxis : {
						type : 'datetime',
						tickPixelInterval : 150
					},
					yAxis : {
						title : {
							text : 'Value'
						},
						plotLines : [ {
							value : 0,
							width : 1,
							color : '#808080'
						} ]
					},
					tooltip : {
						formatter : function() {
							return '<b>'
									+ this.series.name
									+ '</b><br/>'
									+ Highcharts.dateFormat(
											'%Y-%m-%d %H:%M:%S', this.x)
									+ '<br/>'
									+ Highcharts.numberFormat(this.y, 2);
						}
					},
					legend : {
						enabled : false
					},
					exporting : {
						enabled : false
					},
					series : [ {
						name : 'Random data',
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
					} ]
				});

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
			//TODO: run query
			for (int i = 0; i < 5; i++) {

				String tmpDate = "1.24.2012";
				String tmpTemp = "50";
				String tmpWeight = "200";
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
				<br /> Temp:
				<%=tmpTemp%>
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
	<div id='div_historicalData_maxAndMins'>high and lows</div>

	<div id='div_historicalData_Charts'>
		<div id='container_interiorTemperature'></div>

		<div id='container_exteriorTemperature'></div>

		<div id='container_weight'></div>

	</div>


</body>

</html>