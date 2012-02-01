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




	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	var chartNames = new Array();
	chartNames[0]="Interior Temperature";
	chartNames[1]="Exterior Temperature";
	chartNames[2]="Weight";
	
	var chartContainers= new Array();
	chartContainers[0] = "container_interiorTemperature";
	chartContainers[1] = "container_exteriorTemperature";
	chartContainers[2] = "container_weight";
	

	for(var i=0;i<3;i++){
		//make charts
		chart_interiorTemperature = new Highcharts.Chart({
			chart : {
				backgroundColor : "#dddddd",
				renderTo : chartContainers[i],
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
				text : chartNames[i]
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
		
		}

	});

		
		
	
	
</script>

<script type="text/javascript">
	//max and min table functionality
	
	$(document).ready(function(){
		
		//when page loads, show six month by default
		//hide all others
		$('.td_maxMin_twelve').hide();
		
		//if six month selected
		$('#rad_maxMin_6').click(function(){
			
			$('.td_maxMin_twelve').hide();
			$('.td_maxMin_six').show();
			
			
		});
		
		//if twelve month selected
		
		$('#rad_maxMin_12').click(function(){
			
			$('.td_maxMin_six').hide();
			$('.td_maxMin_twelve').show();

			
			
		});
		
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
					<div class='rad_large' id='rad_maxMin_6' name='rad_maxMin' value='6' > 6 Month</div>
				    <div class='rad_large' id='rad_maxMin_12'  name='rad_maxMin' value='12' > 12 Month </div>
				    <div class='rad_large' id='rad_maxMin_allTime' name='rad_maxMin' value='99' > All Time</div>
					
					
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
							<th class='td_maxMin_six'>Exterior Max Temperature(6)</th>
							<th class='td_maxMin_six'>Exterior Min Temperature(6)</th>
							<th class='td_maxMin_twelve'>Exterior Max Temperature(12)</th>
							<th class='td_maxMin_twelve'>Exterior Min Temperature(12)</th>
						</tr>
						
						<tr>
							<td><%=record.getProperty("hiveID")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_exterior_max_six")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_exterior_min_six")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_exterior_max_twelve")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_exterior_min_twelve")%></td>

						</tr>
						
						<tr>
							<th>Hive ID</th>
							<th class='td_maxMin_six'>Interior Max Temperature(6)</th>
							<th class='td_maxMin_six'>Interior Min Temperature(6)</th>
							<th class='td_maxMin_twelve'>Interior Max Temperature(12)</th>
							<th class='td_maxMin_twelve'>Interior Min Temperature(12)</th>
						</tr>
						
						<tr>
							<td><%=record.getProperty("hiveID")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_interior_max_six")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("temperature_interior_min_six")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_interior_max_twelve")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("temperature_interior_min_twelve")%></td>

						</tr>
						 <tr>
							<th>Hive ID</th>
							<th class='td_maxMin_six'>Max Weight(6)</th>
							<th class='td_maxMin_six'>Min Weight(6)</th>
							<th class='td_maxMin_twelve'>Max Weight(12)</th>
							<th class='td_maxMin_twelve'>Min Weight(12)</th>
						</tr>
						
						
							<td><%=record.getProperty("hiveID")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("weight_max_six")%></td>

							<td class='td_maxMin_six'><%=record
							.getProperty("weight_min_six")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("weight_max_twelve")%></td>

							<td class='td_maxMin_twelve'><%=record
							.getProperty("weight_min_twelve")%></td>
						
							
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

		<div id='container_exteriorTemperature'></div>

		<div id='container_weight'></div>

	</div>


</body>

</html>