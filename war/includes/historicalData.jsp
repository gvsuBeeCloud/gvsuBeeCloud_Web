<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.ArrayList"%>
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






<script type="text/javascript">
	$(document).ready(function() {
		
		

		//alert("Script working");
		//setup historical data listeners
		//hide max to start
		$("#div_historicalData_maxAndMins").hide();
		$("#div_historicalData_previousRecords").hide();
		$("#div_historicalData_Charts").hide();

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

		var box=$('#datePicker_start');
		box.datepicker();
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
<%!
public ArrayList<String> getValuesFromCDM()
{
	ArrayList<String> CDMValues = new ArrayList<String>();

	FileInputStream fstream;
	try
	{
		fstream = new FileInputStream("CDM.txt");
		DataInputStream in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader(new InputStreamReader(in));

		String readIn;
		int i = 0;
		while ((readIn = br.readLine()) != null)
		{
			String[] valuesOfLine;
			valuesOfLine = readIn.split("\t");
			CDMValues.add(valuesOfLine[0]);
			i++;
		}

	}
	
	catch (FileNotFoundException e)
	{

	}
	catch (IOException e) {

	}

	return CDMValues;
}
//Obtain field values from CDM
List<String> availableOptions = getValuesFromCDM();
%>
	


	<div id='div_historicalData_previousRecords'>
		<%
			//get all the previous records
			String hiveID = request.getParameter("hiveID");
			//try querying
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			        
			//Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
			//Key hiveRecordKey = KeyFactory.createKey("hiveRecord", hiveID);

			Query query = new Query("hiveRecord");
			query.addSort("timeStamp", Query.SortDirection.ASCENDING);
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

	<div id='div_historicalData_maxAndMins'>
		<div id='div_historicalData_maxAndMins_record_wrapper'>
			<div id='div_historicalData_maxAndMins_record'>
				<div id='div_historicalData_maxAndMins_record_title'>Record
					Highs and Lows</div>




				<div id='div_historicalData_maxAndMins_record_contents'>
					<div id='nav_historicalData_maxAndMins_record_contents'>
							Start Date: <input type='text' class="datePick" id="datePicker_start" name ="dp_start" />
							End Date:   <input type='text' class="datePick" id="datePicker_end" name="dp_end"/>
							<input id='badAssButton' type='submit' onclick='datQuery()' value="Submit"/>
							<br />
							<%
							//Run a query to get the field values from the datastore
							datastore = DatastoreServiceFactory.getDatastoreService();
							Query fieldsInTable = new Query("hiveRecord").addSort("timeStamp", Query.SortDirection.DESCENDING);
							fieldsInTable.addFilter("hiveID", Query.FilterOperator.EQUAL, hiveID);
							List<Entity> recFields = datastore.prepare(fieldsInTable).asList(FetchOptions.Builder.withLimit(1));
							 
								if(recFields.isEmpty())
								{
								    //We do nothing
								}
								else
								{
									//Grab entity from list
									Entity fields = recFields.get(0);
							    	if(fields != null)
									{
							    		Map<String, Object> tmpHiveKeysAndValues = fields.getProperties();
							    		List<String> similar = new ArrayList<String>();
							    		for (Map.Entry<String, Object> entry : tmpHiveKeysAndValues.entrySet()) {
										    if(availableOptions.contains(entry.getKey()))
										    {
										        similar.add(entry.getKey());
										    }
										}
							    		availableOptions = similar;
							 		}
							    	for(int count = 0; count < availableOptions.size(); count++)
									{
										%>
										Max <%=availableOptions.get(count) %> <input class="ch_query_options" id="max<%=availableOptions.get(count) %>" type='checkbox' name='query_options'/>
										Min <%=availableOptions.get(count) %> <input class="ch_query_options" id="min<%=availableOptions.get(count) %>" type='checkbox' name='query_options'/>
										<%
									}
							    }
							%>
					</div>
					
					
						<% 						
							boolean readyToGo = true;
							String[] expectedParams={"dp_start","dp_end"};
							for(int i = 0; i < expectedParams.length; i++)
							{
							    if(request.getParameter(expectedParams[i]) == null)
							    {
							        readyToGo = false;
							        break;
							    }
							}
							if(readyToGo == true)
							{
							    boolean dateCorrect = false;
								String alias=request.getParameter("alias");
								String dp_start=request.getParameter("dp_start");
								String dp_end=request.getParameter("dp_end");
						
						
								long endDate = new Long("999999999999");
								long startDate = new Long ("000000000000");
							
								//Strings that will contain the user inputed date, if the date
								//is valid
								String sDate = new String();
								String eDate = new String();

								if(!dp_start.equals("undefined") && !dp_end.equals("undefined") && !dp_start.isEmpty() && !dp_end.isEmpty())
								{
												
									//take the start date from a standard format and turn it into timeStamp format
									String[] sDate_pieces = dp_start.split("/");
							
									//take the end date from a standard format and turn it into timeStamp format
									String[] eDate_pieces = dp_end.split("/");
							
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
									dateCorrect = true;
								}
								if((startDate <= endDate) && (dateCorrect == true))
								{
								    dateCorrect = false;
									datastore = DatastoreServiceFactory.getDatastoreService();
									//Query for Highest and Lowest Records in the given date range
									Query min_max_Query = new Query("hiveRecord");
						
									//Make sure that the hiveID is the same as one specified by the user
									min_max_Query.addFilter("hiveID", Query.FilterOperator.EQUAL, hiveID);
											
									//Make sure that the timeStamp of the record is between the start and end date specified
									//by the user.
									min_max_Query.addFilter("timeStamp", Query.FilterOperator.LESS_THAN_OR_EQUAL, eDate);
									min_max_Query.addFilter("timeStamp", Query.FilterOperator.GREATER_THAN_OR_EQUAL, sDate);
									min_max_Query.addSort("timeStamp", Query.SortDirection.ASCENDING);
						
									//prepare query, run it, and return a list of records
									records = datastore.prepare(min_max_Query).asList(FetchOptions.Builder.withLimit(999999999));

									if (records.isEmpty()) 
									{
										%><p>No Matching Records</p><%
									}
									
									else 
									{
						        
										List<String> requestedOptions = new ArrayList<String>();
 						    
										//Loop through all the possible fields to be queryed and add the ones
										//that have been selecected to the requested list
							
										for(int i = 0; i < availableOptions.size(); i++)
										{
							    			if(request.getParameter("max" + availableOptions.get(i)) != null)
							    			{
							        			requestedOptions.add("max" + availableOptions.get(i));
							    			}
							    		if(request.getParameter("min" + availableOptions.get(i)) != null)
							    		{
							        		requestedOptions.add("min" + availableOptions.get(i));
							    		}
									}
						    							
						    //Records that have a timestamp within the user specified parameters 
						    //and selected hiveId, are returned. Now we can retrieve the statistics
						    //that were requested by the user.
						    %><table id='table_historicalData_maxAndMins'><%
						    for(String option : requestedOptions)
						    {
						        //String containing the record attribute and the timestamp
						        List<String> recordAttributes = new ArrayList<String>();
						        //Record attribute as an integer
						        List<Integer> numericAttributes = new ArrayList<Integer>();
						        	
						        //Either max or min
						        String prefix = option.substring(0,3);
						        
						        //One of the available options from the availableOptions list
						        String root = option.substring(3, option.length());
						        
						        //Sort through all the records add to both lists
						        for (Entity record : records) 
						        {
						            //Make sure the record value isn't empty
						            if(record.getProperty(root) != null)
						            {
						           		recordAttributes.add((record.getProperty(root).toString()) + "*" + (record.getProperty("timeStamp").toString()));
						           		numericAttributes.add(Integer.parseInt(record.getProperty(root).toString()));
						            }
						        }
						        
						        //Sort the integer list in ascending order
						        Collections.sort(numericAttributes);
						        
						        %><tr>
						        <td><b><%=prefix + " " + root + ": "%></b> <%
						        
						        //Format the timestamp and add the selected value and the timestamp to the table.
						        if(prefix.equals("max"))
						        {   
						            for(String temp : recordAttributes)
						            {
						                //Search through the list of strings to find the timestamp of the selected numeric value
						                if((numericAttributes.get(numericAttributes.size()-1).toString()).equals(temp.substring(0,temp.indexOf("*"))))
						                {
						                    //Convert timestamp to a more readable form
						                    String rawTimestamp = temp.substring((temp.indexOf("*")+1), temp.length());
						                    rawTimestamp = (rawTimestamp.substring(4,6) + "/" + rawTimestamp.substring(6,8) + "/" + rawTimestamp.substring(0,4));
						                    
						                    //Add selected values to the table
						                    
						                    	%>
									       		<%=numericAttributes.get(numericAttributes.size()-1)%> </td>
									       		<td><b>Timestamp of occurence:</b> <%=rawTimestamp %> </td></tr><%
									       		break;
						                    
						                }
						            }	
						        }
						        //Same as the if statement above, now for "min" prefixes	
						        else
						        {
						            for(String temp : recordAttributes)
						            {
						                //Search through the list of strings to find the timestamp of the selected numeric value
						            	if((numericAttributes.get(0).toString()).equals(temp.substring(0,temp.indexOf("*"))))
					                	{
						            	    //Convert timestamp to a more readable form
					                    	String rawTimestamp = temp.substring((temp.indexOf("*")+1), temp.length());
					                    	rawTimestamp = (rawTimestamp.substring(4,6) + "/" + rawTimestamp.substring(6,8) + "/" + rawTimestamp.substring(0,4));
					                    	
					                    	//Add selected values to the table
					                    	%>
							       			<%=numericAttributes.get(0)%> </td>
							       			<td><b>Timestamp of occurence:</b> <%=rawTimestamp%> </td></tr><%
								       		break;
					                	}//end if
						            }// end for each recordAttributes loop
						        }//end else
						    }//end for each requestedOptions loop
						   
						    %></table><% 
						    }//end else
						}//end if
						else{
						    if(dateCorrect == true)
						    {
						    	%><p>The Start Date Must Be Before The End Date.</p><%						        
						    }
						    else
						    {
						    	%><p>Neither of The Date Fields Can Be Blank</p><%
						    }
						}//end else
					}//end if readyToGo
							
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