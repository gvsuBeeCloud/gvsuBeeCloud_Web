<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.Long"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.ParseException"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.PreparedQuery"%>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

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
		
		 

	});
</script>

<script type="text/javascript">
	//max and min table functionality

	//$(document).ready(function() {
		function getCalendar(field)
		{
			$(document).ready(function(){$("#" + field).datepicker();});
		}
		
	//});
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
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			        
			Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
			Key hiveRecordKey = KeyFactory.createKey("hiveRecord", hiveID);

			Query query = new Query("hiveRecord", hiveRecordKey).addSort("hiveID",
			        Query.SortDirection.DESCENDING);
			List<Entity> records = datastore.prepare(query).asList(
			        FetchOptions.Builder.withLimit(5));

			//TODO: run query
			for (Entity record : records) {
			    
				String tmpDate = (String)record.getProperty("timeStamp");
				tmpDate = (tmpDate.substring(4,6) + "/" + tmpDate.substring(6,8) + "/" + tmpDate.substring(0,4));
				String tmpTemp_interior = (String) record
						.getProperty("intTemp");
				String tmpTemp_exterior = (String) record
						.getProperty("extTemp");
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
	
		//String getUserInput() {
			//define any variables we need
			//String aliasID =request.getParameter("alias");
			//String sDate = request.getParameter("dp_start");
			//String eDate = request.getParameter("dp_end");
		//}


	
		//for debug, echo param
		//out.println("ALIAS: "+aliasID);
	%>

	<script type="text/javascript">
	//Function used in the historical data table to carry out queries
	//for the min and max data.
	function doQuery()
	{
		var sDate = document.getElementById("datePicker_start").value;
		var eDate = document.getElementById("datePicker_end").value;
		
	}
	</script>

	<div id='div_historicalData_maxAndMins'>
		<div id='div_historicalData_maxAndMins_record_wrapper'>
			<div id='div_historicalData_maxAndMins_record'>
				<div id='div_historicalData_maxAndMins_record_title'>Record
					Highs and Lows</div>





				<div id='div_historicalData_maxAndMins_record_contents'>
					<div id='nav_historicalData_maxAndMins_record_contents'>
							Start Date: <input type='text' id="datePicker_start" name ="dp_start" onclick="getCalendar(this.id)"/>
							End Date:   <input type='text' id="datePicker_end" name="dp_end" onclick="getCalendar(this.id)"/>
							<input id='badAssButton' type='button' value="Submit"/>
							Max Int Temp <input type='checkbox' name='query_options' value='maxIntTemp'/>
							Min Int Temp <input type='checkbox' name='query_options' value='minIntTemp'/>
							Max Ext Temp <input type='checkbox' name='query_options' value='maxExtTemp'/>
							Min Ext Temp <input type='checkbox' name='query_options' value='minExtTemp'/>
							Max Weight <input type='checkbox' name='query_options' value='maxWeight'/>
							Min Weight <input type='checkbox' name='query_options' value='minWeight'/>

					</div>


						
						
						
						<% 
							String alias=request.getParameter("alias");
							String dp_start=request.getParameter("dp_start");
							String dp_end=request.getParameter("dp_end");
							String[] fields = request.getParameterValues("query_options");
							
							
							long endDate = new Long("999999999999");
							long startDate = new Long ("000000000000");
							
							//Record High Interior Temperature set to a Default Value
							int highITemp = -999;
							//Record High Exterior Temperature set to a Default Value
							int highETemp = -999;
							//Record High Weight set to a Default Value
							int highWeight = -999;
							//Record Low Interior Temperature set to a Default Value
							int lowITemp = 999;
							//Record Low Exterior Temperature set to a Default Value
							int lowETemp = 999;
							//Record Low Weight set to a Default Value
							int lowWeight = 999;
							
							//Strings that will contain the user inputed date, if the date
							//is valid
							String sDate = new String();
							String eDate = new String();
							
							//Strings that will hold the timestamp for the highest/lowest
							//temperature found by the min_max_query
							String hIT_tStamp = "-1"; //High Interior Temperature
							String hET_tStamp = "-1"; //High Exterior Temperature
							String hW_tStamp = "-1"; //High Weight
							String lIT_tStamp = "-1"; //Low Interior Temperature
							String lET_tStamp = "-1"; //Low Exterior Temperature
							String lW_tStamp = "-1"; //Low Weight

						if(!dp_start.equals("undefined") && !dp_end.equals("undefined"))
						{
												
							//take the start date from a standard format and turn it into timeStamp format
							String[] sDate_pieces = dp_start.split(",");
							
							//take the end date from a standard format and turn it into timeStamp format
							String[] eDate_pieces = dp_end.split(",");
							
							//Since incoming date format is mm/dd/yyyy, we need to do a swap on
							//elements 0 and 1 in the array so it appears the incoming format was
							//really dd/mm/yyyy
							if(sDate_pieces.length > 1)
							{
							    
							    String temp = sDate_pieces[0];
							    sDate_pieces[0] = sDate_pieces[1];
							    sDate_pieces[1] = temp;
							    
							    for(int i = 0; i < sDate_pieces.length; i++)
								{
									sDate = sDate_pieces[i] + sDate;
								}
								sDate = sDate + "0000";
								startDate = Long.parseLong(sDate);
							}
							
							//same swap function mentioned above now for the end date
							if(eDate_pieces.length > 1)
							{
							    
							    String temp = eDate_pieces[0];
							    eDate_pieces[0] = eDate_pieces[1];
							    eDate_pieces[1] = temp;
							    
							    for(int i = 0; i < eDate_pieces.length; i++)
								{
									eDate = eDate_pieces[i] + eDate;
								}							
								eDate = eDate + "9999";
								endDate = Long.parseLong(eDate);
							}
							
						}	
						datastore = DatastoreServiceFactory.getDatastoreService();
						//Query for Highest and Lowest Records in the given date range
						Query min_max_Query = new Query("hiveRecord", hiveRecordKey);
						
						//Make sure that the hiveID is the same as one specified by the user
						min_max_Query.addFilter("hiveID", Query.FilterOperator.EQUAL, hiveID);
											
						//Make sure that the timeStamp of the record is between the start and end date specified
						//by the user.
						min_max_Query.addFilter("timeStamp", Query.FilterOperator.LESS_THAN_OR_EQUAL, eDate);
						min_max_Query.addFilter("timeStamp", Query.FilterOperator.GREATER_THAN_OR_EQUAL, sDate);
						min_max_Query.addSort("timeStamp", Query.SortDirection.ASCENDING);
						
						//prepare query, run it, and return a list of records
						records = datastore.prepare(min_max_Query).asList(FetchOptions.Builder.withLimit(999999999));

						if (records.isEmpty()) {
						%>
						
							<p>No Matching Records</p>
							<p>End Date long Form: <%=endDate%> </p>
							<p>Start Date long Form: <%=startDate%> </p>
							<p>End Date String Form <%=eDate%> </p>
						<%
						
						} else {
						    %>
						    <table id='table_historicalData_maxAndMins'>
							<tr>
								<th>Hive ID</th>
								<th class='td_maxMin_six'>Timestamp</th>
								<th class='td_maxMin_six'>Exterior Temperature</th>
								<th class='td_maxMin_six'>Interior Temperature</th>
								<th class='td_maxMin_twelve'>Battery</th>
								<th class='td_maxMin_twelve'>Weight</th>
							</tr>
							<%
						    //Records that have a timestamp within the user specified parameters 
						    //and selected hiveId, are returned. Now we can retrieve the statistics
						    //that were requested by the user.
							for (Entity record : records) {
						%>
						
						<tr>
								<td><%=record.getProperty("hiveID")%></td>

								<td class='td_maxMin_six'><%=record
								.getProperty("timeStamp")%></td>

								<td class='td_maxMin_six'><%=record
								.getProperty("extTemp")%></td>
							
								<td class='td_maxMin_six'><%=record
								.getProperty("intTemp")%></td>

								<td class='td_maxMin_twelve'><%=record
								.getProperty("battery")%></td>

								<td class='td_maxMin_twelve'><%=record
								.getProperty("weight")%></td>
							</tr>
							
							<% 
							//The weight and interior/exterior temperature for the current record
							int record_intTemp = Integer.parseInt(((String)record.getProperty("intTemp")).toString());
							int record_extTemp = Integer.parseInt(((String)record.getProperty("extTemp")).toString());
							int record_weight = Integer.parseInt(((String)record.getProperty("weight")).toString());
							
							//If the current record's value in the aforementioned catagories is higher/lower
							//than the current min/max, the current min/max is updated with the value of the
							//record.
							//Interior Temperature
							if(record_intTemp > highITemp) 
						    {
							    highITemp = Integer.parseInt(((String)record.getProperty("intTemp")).toString());
							    hIT_tStamp = ((String)record.getProperty("timeStamp")).toString();
						    }
							if(record_intTemp < lowITemp)
							{
							    lowITemp = Integer.parseInt(((String)record.getProperty("intTemp")).toString());
							    lIT_tStamp = ((String)record.getProperty("timeStamp")).toString();
							}
							
							//Exterior Temperature
							if(record_extTemp > highETemp) 
						    {
							    highETemp = Integer.parseInt(((String)record.getProperty("extTemp")).toString());
							    hET_tStamp = ((String)record.getProperty("timeStamp")).toString();
						    }
							if(record_extTemp < lowETemp) 
						    {
							    lowETemp = Integer.parseInt(((String)record.getProperty("extTemp")).toString());
							    lET_tStamp = ((String)record.getProperty("timeStamp")).toString();
						    }
							
							//Weight
							if(record_weight > highWeight)
							{
							    highWeight = Integer.parseInt(((String)record.getProperty("weight")).toString());
							    hW_tStamp = ((String)record.getProperty("timeStamp")).toString();
							}
							if(record_weight < lowWeight)
							{
							    lowWeight = Integer.parseInt(((String)record.getProperty("weight")).toString());
							    lW_tStamp = ((String)record.getProperty("timeStamp")).toString();
							}
						%>
						

					<%
						}
							%>
							<tr>
								<td> Highest Interior Temp: <%=highITemp%> </td>
								<td> Timestamp of occurence: <%=hIT_tStamp%> </td>
								<td> Highest Exterior Temp: <%=highETemp%> </td>
								<td> Timestamp of occurence: <%=hET_tStamp%> </td>
								<td> Highest Weight: <%=highWeight%> </td>
								<td> Timestamp of occurence: <%=hW_tStamp%> </td>
							</tr>
							<tr>
								<td> Lowest Interior Temp: <%=lowITemp%> </td>
								<td> Timestamp of occurence: <%=lIT_tStamp%> </td>
								<td> Lowest Exterior Temp: <%=lowETemp%> </td>
								<td> Timestamp of occurence: <%=lET_tStamp%> </td>
								<td> Lowest Weight: <%=lowWeight%> </td>
								<td> Timestamp of occurence: <%=lW_tStamp%> </td>
							</tr>
				

					</table>
					<%
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