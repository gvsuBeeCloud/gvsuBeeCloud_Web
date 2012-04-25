<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.lang.String"%>
<%@ page import="java.lang.Integer"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.Long"%>
<%@ page import="java.util.Map"%>
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
<title>Project Bee Cloud</title>
<link rel="stylesheet" href="css/style.css" type="text/css"></link>

<script type="text/javascript"
	src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCQnswJmYxTHOZdj3MbKtUE-bR_Fg6mx5c&sensor=true">
	
</script>
<script type="text/javascript"
	src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
    <link rel="stylesheet"
	href="/css/ui-darkness/jquery-ui-1.8.18.custom.css" type="text/css"></link>
<script type="text/javascript" src="js/highcharts.js"></script>
<script src="js/modules/exporting.js" type="text/javascript"></script>
<script type="text/javascript" src="js/map_functions.js"></script>

</head>
<body onload="loadMarkersFromHiddenDivs()">

	<div class='shouldBeHidden' id='div_param_hiveID'></div>
	<%!String weight = "";
	String int_temp = "";
	String ext_temp = "";
	String message = "";
	String battery = "";
	String timeStamp = "";
	
	public String formatStamp(String theStamp)
	{
	    String temp = theStamp;
		temp = (temp.substring(4, 6) + "/"
					+ temp.substring(6, 8) + "/"
					+ temp.substring(0, 4));
		return temp;
	}
	%>
	<%
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		//Key hiveKey = KeyFactory.createKey("HiveParent");

		// Run an ancestor query to ensure we see the most up-to-date
		Query query = new Query("Hive").addSort("hiveID",
				Query.SortDirection.DESCENDING);

		List<Entity> records = datastore.prepare(query).asList(
				FetchOptions.Builder.withLimit(999999999));

		if (records.isEmpty()) {
	%>
	<p>Records are empty</p>
	<%
		} else {
			for (Entity record : records) {

				//add hidden values
	%>


		<%
			//Key hiveRecordKey = KeyFactory.createKey("hiveRecord", "hiveID");
					Query hivePopUp = new Query("hiveRecord");
					hivePopUp.addFilter("hiveID", Query.FilterOperator.EQUAL,
							(record.getProperty("hiveID")).toString());
					//Need to find a way to reduce number of records by implementing something that 
					//can call a date
					hivePopUp.addSort("timeStamp",
							Query.SortDirection.DESCENDING);
					List<Entity> rec = datastore.prepare(hivePopUp).asList(
							FetchOptions.Builder.withLimit(1));

					if (rec.isEmpty()) {
						message = "No Records";
					} else {

						//Get the most recent record from the list
						Entity lastRecord = rec.get(0);

						//Convert the timeStamp to a more readable date and time
						
 						String tmpDate = (String) lastRecord.getProperty("timeStamp");
// 						tmpDate = (tmpDate.substring(4, 6) + "/"
// 								+ tmpDate.substring(6, 8) + "/"
// 								+ tmpDate.substring(0, 4) + " " + tmpDate
// 								.substring(8, 12));

						//Return the requested statistics
						timeStamp = (formatStamp(tmpDate) + " " + tmpDate.substring(8,12) );
						weight = "" + lastRecord.getProperty("weight");
						int_temp = "" + lastRecord.getProperty("intTemp");
						ext_temp = "" + lastRecord.getProperty("extTemp");
						battery = "" + lastRecord.getProperty("battery");

					}
		%>
	<div id="hive<%=record.getProperty("hiveID") %>" class='shouldBeHidden hiveRecord'>

		<span class="hiveRecord_label">ID</span>
		<span class='hiveRecord_field hiveRecord_hiveID'><%=record.getProperty("hiveID")%></span>
		<span class="hiveRecord_label">Weight</span>
		<span class='hiveRecord_field hiveRecord_weight'><%=weight%></span><br />
		
		
		<span class="hiveRecord_label">Name</span>
		<span class='hiveRecord_field hiveRecord_aliasID'><%=record.getProperty("aliasID")%></span>
		<span class="hiveRecord_label">Interior Temperature</span>
		<span class='hiveRecord_field hiveRecord_iTemperature'><%=int_temp%></span><br />
		
		<span class="hiveRecord_label">Latitude</span>
		<span class='hiveRecord_field hiveRecord_loc_lat'><%=record.getProperty("location_lat")%></span>
				<span class="hiveRecord_label">Exterior Temperature</span>
		<span class='hiveRecord_field hiveRecord_eTemperature'><%=ext_temp%></span><br />
		
		<span class="hiveRecord_label">Longitude</span>
		<span class='hiveRecord_field hiveRecord_loc_long'><%=record.getProperty("location_long")%></span>
		<span class="hiveRecord_label">Battery</span>
		<span class='hiveRecord_field hiveRecord_battery'><%=battery%></span>
		
		</span>
		
		

		<span class="timestamp_wrapper">
		<span class="hiveRecord_label hiveRecord_timeStamp_label" >Recent Collection</span>
		<span class='hiveRecord_field hiveRecord_timeStamp'><%=timeStamp%></span>

	</div>

	<%
		}

		}
	%>




	<div id="div_map_container" class="class_box_shadow"></div>

	<div id='div_hiveControls_wrapper' class=''> <span id="banner_title">BeeCloud</span>
		<div id='div_hiveControls_grabber'>
		<div id="logo">
	<img src="images/bee.gif" />
</div>
			<ul>
				<li id="nav_map" class='nav_first nav_main'><!--  img src="images/globe.jpg" /-->Map</li>
				<li id="nav_data" class='nav_main'>Data</li>
				<li id="nav_charts" class='nav_main'>Charts</li>
				<li id="nav_admin" class='nav_last last nav_main' id='nav_login'><a href="/administration.jsp">Admin</a></li>


			</ul>





		</div>
		<div id="div_hiveControls_trim">
		</div>
	</div>


<div id="data" class='content_wrapper class_box_shadow'>
				<div id='div_historicalData_maxAndMins'>
				
				
				
				
					<%!public ArrayList<String> getValuesFromCDM() {
		ArrayList<String> CDMValues = new ArrayList<String>();

		FileInputStream fstream;
		try {
			fstream = new FileInputStream("includes/CDM.txt");
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));

			String readIn;
			int i = 0;
			while ((readIn = br.readLine()) != null) {
				String[] valuesOfLine;
				valuesOfLine = readIn.split("\t");
				CDMValues.add(valuesOfLine[0]);
				i++;
				
			}

		}

		catch (FileNotFoundException e) {
		

		} catch (IOException e) {

		}

		return CDMValues;
	}

	//Obtain field values from CDM
	List<String> availableOptions = getValuesFromCDM();%>
	



	<div id='div_historicalData_maxAndMins_record_wrapper'>
		<div id='div_historicalData_maxAndMins_record'>
			<div id='div_historicalData_maxAndMins_record_title'>Record
				Highs and Lows</div>




			<div id='div_historicalData_maxAndMins_record_contents'>
				<div id='nav_historicalData_maxAndMins_record_contents'>
				<form methpd="get" action="/map2.jsp?view=data">
				
				
				Hive: <select name="hiveID">
				
				
				<% for(Entity hive : records){
					%>
						<option value='<%= hive.getProperty("hiveID")%>'><%=hive.getProperty("alias") %></option>
					
					<%
					
				}
					%>
				
				</select>
					Start Date: <input type='text' class="datePick" id="datePicker_start" name="dp_start" /> 
					End Date: <input type='text' class="datePick" id="datePicker_end" name="dp_end" />
					<input id='badAssButton' type='submit' value="Submit" /> <br />
					<%
					
						//get all the previous records
						String hiveID = request.getParameter("hiveID");
						//try querying
						 datastore = DatastoreServiceFactory.getDatastoreService();
						//Run a query to get the field values from the datastore
						Query fieldsInTable = new Query("hiveRecord").addSort("timeStamp",
								Query.SortDirection.DESCENDING);
						//fieldsInTable.addFilter("hiveID", Query.FilterOperator.EQUAL,"16166488272");
						List<Entity> recFields = datastore.prepare(fieldsInTable).asList(
								FetchOptions.Builder.withLimit(1));

						if (recFields.isEmpty()) {
							//We do nothing
							%>
							<p> _ </p>
							<%
						} else {
							//Grab entity from list
							Entity fields = recFields.get(0);
							if (fields != null) {
								Map<String, Object> tmpHiveKeysAndValues = fields.getProperties();
								List<String> similar = new ArrayList<String>();
								for (Map.Entry<String, Object> entry : tmpHiveKeysAndValues.entrySet()) {
									if (availableOptions.contains(entry.getKey())) {
										similar.add(entry.getKey());
									}
								}
								availableOptions = similar;
							}else{
								%>
								<p> Fields null </p>
								
								<%
							}
							
							%>
							
							
							
							<%
							for (int count = 0; count < availableOptions.size(); count++) {
					%>
					Max
					<%=availableOptions.get(count)%>
					<input class="ch_query_options" name="max<%=availableOptions.get(count)%>" type='checkbox'/>
					Avg
					<%=availableOptions.get(count)%>
					<input class="ch_query_options" name="avg<%=availableOptions.get(count)%>" type='checkbox'/> 
					Min
					<%=availableOptions.get(count)%>
					<input class="ch_query_options" name="min<%=availableOptions.get(count)%>" type='checkbox'/>
					<%
						}
						}
					%>
					<input type="hidden" name="view" value="data" />
					</form>
				</div>


				<%
					boolean readyToGo = true;
					String[] expectedParams = { "dp_start", "dp_end" };
					for (int i = 0; i < expectedParams.length; i++) {
						if (request.getParameter(expectedParams[i]) == null) {
							readyToGo = false;
							break;
						}
					}
					if (readyToGo == true) {
						boolean dateCorrect = false;
						String alias = request.getParameter("alias");
						String dp_start = request.getParameter("dp_start");
						String dp_end = request.getParameter("dp_end");

						long endDate = new Long("9999999999999999");
						long startDate = new Long("0000000000000000");

						//Strings that will contain the user inputed date, if the date
						//is valid
						String sDate = new String();
						String eDate = new String();

						if (!dp_start.equals("undefined")
								&& !dp_end.equals("undefined") && !dp_start.isEmpty()
								&& !dp_end.isEmpty()) {

							//take the start date from a standard format and turn it into timeStamp format
							String[] sDate_pieces = dp_start.split("/");

							//take the end date from a standard format and turn it into timeStamp format
							String[] eDate_pieces = dp_end.split("/");

							//Since incoming date format is mm/dd/yyyy, we need to do a swap on
							//elements 0 and 1 in the array so it appears the incoming format was
							//really yyyy/mm/dd
							if (sDate_pieces.length > 1) {

								String temp = sDate_pieces[2];
								sDate_pieces[2] = sDate_pieces[1];
								sDate_pieces[1] = sDate_pieces[0];
								sDate_pieces[0] = temp;

								//sDate=sDate_pieces.toString();
								for (int i = 0; i < sDate_pieces.length; i++) {
									sDate = sDate+ sDate_pieces[i];
								}
								sDate = sDate + "0000";
								startDate = Long.parseLong(sDate);
							}

							
							//same swap function mentioned above now for the end date
							if (eDate_pieces.length > 1) {

								String temp = eDate_pieces[2];
								eDate_pieces[2] = eDate_pieces[1];
								eDate_pieces[1] = eDate_pieces[0];

								eDate_pieces[0] = temp;

								//eDate=eDate_pieces.toString();
								for (int i = 0; i < eDate_pieces.length; i++) {
									eDate += eDate_pieces[i];
								}
								eDate = eDate + "999999";
								endDate = Long.parseLong(eDate);
							}
							dateCorrect = true;
						}
						if ((startDate <= endDate) && (dateCorrect == true)) {
							//prepare for next query query
							dateCorrect = false;
							        
							//call datastore
							datastore = DatastoreServiceFactory.getDatastoreService();
							        
							 
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							        
							//Until we decide what we want....This will be duplicate code. This will
							//later be merged or may take on a life of its own
							List<String> avgReqOps = new ArrayList<String>(); 
							List<String[]> averages = new ArrayList<String[]>();
							
							               
							Query average_Query = new Query("hiveRecord");

							//Make sure that the hiveID is the same as one specified by the user
							average_Query.addFilter("hiveID",Query.FilterOperator.EQUAL, hiveID);

							//Make sure that the timeStamp of the record is between the start and end date specified
							//by the user.
							average_Query.addFilter("timeStamp",Query.FilterOperator.LESS_THAN_OR_EQUAL, eDate);
							average_Query.addFilter("timeStamp",Query.FilterOperator.GREATER_THAN_OR_EQUAL, sDate);
							average_Query.addSort("timeStamp",Query.SortDirection.ASCENDING);

							
							//All the records returned by the average_Query
							List<Entity> avgRecords = new ArrayList<Entity>();
							//prepare query, run it, and return a list of records
							avgRecords = datastore.prepare(average_Query).asList(FetchOptions.Builder.withLimit(999999999));
							
							if(avgRecords.isEmpty())
							{
							    %><p> No Records Available </p> <%
							}
							
							else
							{
							    //Get the timestamp of the first record, so we have something to compare later
							    String currentStamp = (avgRecords.get(0).getProperty("timeStamp").toString()).substring(0,8);
							    //running total of whatever is being averaged and number of occurences
							    double totalValue = 0;
							    double occurence = 0;
							    double average = 0;
							    //This is used to make sure that the last date gets put on the list
							    int numRecords = 0;
							    //Check to see which options were selected
							    for (int i = 0; i < availableOptions.size(); i++) {
									if (request.getParameter("avg" + availableOptions.get(i)) != null) {
									    avgReqOps.add(availableOptions.get(i));
									}
								}
							    
							    for(String selected : avgReqOps)
							    {
							    	for(Entity aRecord : avgRecords)
							    	{
							        
							        	String dateOnly = (aRecord.getProperty("timeStamp").toString()).substring(0,8);
							        	if(dateOnly.equals(currentStamp))
							        	{
							            	totalValue = (Double.parseDouble(aRecord.getProperty(selected).toString())) + totalValue;
							            	occurence++;
							            	numRecords++;
							            
							           		//If this is the last record, we need to push it's results to the array
							            	if(numRecords == avgRecords.size())
							            	{
							                	//Calculate the average for the timestamp
								            	average = totalValue / occurence;
								            	//Package the timestamp and the average together in an array
								            	String[] temp = {currentStamp,Double.toString(average)};
								            	//Add the array to the list of averages that will later be displayed
								            	averages.add(temp);
							            	}
							        	}
							        	else
							        	{
							            	//Calculate the average for the previous timestamp
							            	average = totalValue / occurence;
							            	//Package the timestamp and the average together in an array
							            	String[] temp = {currentStamp,Double.toString(average)};
							            	//Add the array to the list of averages that will later be displayed
							            	averages.add(temp);
							            
							           		//Set the values for the now current timestamp
							            	currentStamp = dateOnly;
							            	totalValue = Double.parseDouble(aRecord.getProperty(selected).toString());
							            	average = 0;
							            	occurence = 1;
							            
							            	numRecords++;
							          		//If this is the last record, we need to push it's results to the array
							            	if(numRecords == avgRecords.size())
							            	{
							                	//Calculate the average for the timestamp
								            	average = totalValue / occurence;
								            	//Package the timestamp and the average together in an array
								            	String[] tempOther = {currentStamp,Double.toString(average)};
								            	//Add the array to the list of averages that will later be displayed
								            	averages.add(tempOther);
							            	}
							        	}
							    	}
							    	%>
							    	<table id='table_query_averages'>
							    	<tr><th>Date</th><th><%=selected %></th></tr>
							    	<%
							    	for(String[] avgData : averages)
							    	{
							    	    String formatResult = avgData[1];
							    	    formatResult = formatResult.substring(0,(formatResult.indexOf('.') + 2));
							       		%><tr><td><%=formatStamp(avgData[0])%></td><td><%=formatResult%></td></tr><% 
							    	}
							    	%></table><%
							    	averages.clear();
								}
							}
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							        
							//Query for Highest and Lowest Records in the given date range
							Query min_max_Query = new Query("hiveRecord");

							//Make sure that the hiveID is the same as one specified by the user
							min_max_Query.addFilter("hiveID",
									Query.FilterOperator.EQUAL, hiveID);

							//Make sure that the timeStamp of the record is between the start and end date specified
							//by the user.
							min_max_Query.addFilter("timeStamp",
									Query.FilterOperator.LESS_THAN_OR_EQUAL, eDate);
							min_max_Query.addFilter("timeStamp",
									Query.FilterOperator.GREATER_THAN_OR_EQUAL, sDate);
							min_max_Query.addSort("timeStamp",
									Query.SortDirection.ASCENDING);

							//prepare query, run it, and return a list of records
							records = datastore.prepare(min_max_Query).asList(
									FetchOptions.Builder.withLimit(999999999));

							if (records.isEmpty()) {
				                %><p>No Matching Records</p><%
					        }

							else {

								List<String> requestedOptions = new ArrayList<String>();

								//Loop through all the possible fields to be queryed and add the ones
								//that have been selecected to the requested list

								for (int i = 0; i < availableOptions.size(); i++) {
									if (request.getParameter("max" + availableOptions.get(i)) != null) {
										requestedOptions.add("max" + availableOptions.get(i));
									}
									
									if (request.getParameter("min" + availableOptions.get(i)) != null) {
										requestedOptions.add("min" + availableOptions.get(i));
									}
								}

								//Records that have a timestamp within the user specified parameters 
								//and selected hiveId, are returned. Now we can retrieve the statistics
								//that were requested by the user.
				%><table id='table_historicalData_maxAndMins'>
					<%
						for (String option : requestedOptions) {
										//String containing the record attribute and the timestamp
										List<String> recordAttributes = new ArrayList<String>();
										//Record attribute as an integer
										List<Double> numericAttributes = new ArrayList<Double>();

										//Either max or min
										String prefix = option.substring(0, 3);

										//One of the available options from the availableOptions list
										String root = option.substring(3, option.length());

										//Sort through all the records add to both lists
										for (Entity record : records) {
											//Make sure the record value isn't empty
											if (record.getProperty(root) != null) {
												recordAttributes.add((record
														.getProperty(root).toString())
														+ "*"
														+ (record.getProperty("timeStamp")
																.toString()));
												numericAttributes.add(Double
														.parseDouble(record.getProperty(root)
																.toString()));
											}
										}

										//Sort the integer list in ascending order
										Collections.sort(numericAttributes);
					%><tr>
						<td><b><%=prefix + " " + root + ": "%></b> <%
 	//Format the timestamp and add the selected value and the timestamp to the table.
 					if (prefix.equals("max")) {
 						for (String temp : recordAttributes) {
 							//Search through the list of strings to find the timestamp of the selected numeric value
 							if ((numericAttributes
 									.get(numericAttributes.size() - 1)
 									.toString()).equals(temp.substring(
 									0, temp.indexOf("*")))) {
 								//Convert timestamp to a more readable form
 								String rawTimestamp = temp.substring(
 										(temp.indexOf("*") + 1),
 										temp.length());
 								rawTimestamp = (rawTimestamp.substring(
 										4, 6)
 										+ "/"
 										+ rawTimestamp.substring(6, 8)
 										+ "/" + rawTimestamp.substring(
 										0, 4));

 								//Add selected values to the table
 %> <%=numericAttributes.get(numericAttributes.size() - 1)%>
						</td>
						<td><b>Timestamp of occurence:</b> <%=rawTimestamp%></td>
					</tr>
					<%
						break;

												}
											}
										}
										//Same as the if statement above, now for "min" prefixes	
										else {
											for (String temp : recordAttributes) {
												//Search through the list of strings to find the timestamp of the selected numeric value
												if ((numericAttributes.get(0).toString())
														.equals(temp.substring(0,
																temp.indexOf("*")))) {
													//Convert timestamp to a more readable form
													String rawTimestamp = temp.substring(
															(temp.indexOf("*") + 1),
															temp.length());
													rawTimestamp = (rawTimestamp.substring(
															4, 6)
															+ "/"
															+ rawTimestamp.substring(6, 8)
															+ "/" + rawTimestamp.substring(
															0, 4));

													//Add selected values to the table
					%>
					<%=numericAttributes.get(0)%>
					</td>
					<td><b>Timestamp of occurence:</b> <%=rawTimestamp%></td>
					</tr>
					<%
						break;
												}//end if
											}// end for each recordAttributes loop
										}//end else
									}//end for each requestedOptions loop
					%>
				</table>
				<%
					}//end else
						}//end if
						else if (dateCorrect == true) {
				%><p>The Start Date Must Be Before The End Date.</p>
				<%
					} else {
				%><p>Neither of The Date Fields Can Be Blank</p>
				<%
					}
						//end else
					}//end if readyToGo
				%>
			


			</div>

		</div>

	</div>
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				</div>
</div>
<div id="charts" class="content_wrapper class_box_shadow">
	
			<div id='div_historicalData_Charts'>
			<table id="tbl_charts">
				<tr>
				
					<td> 
						<label class="lbl_charts">Hive:</label> 
						<select multiple="multiple" size="2">
							<option> Hive 1</option>
						</select>

					</td>
					
					<td>
						<label class="lbl_charts">Fields:</label>
						<select size="2" multiple="multiple" >
							<option> Field 1</option>
							<option> Field 2</option>
							<option> Field 3</option>
							<option> Field 4</option>
							<option> Field 5</option>
							<option> Field 6</option>
						</select>
					</td>

					
					<td>
						<label class="lbl_charts">Start Date:</label>
						<input class="datePick" type="text"/>
						<label class="lbl_charts">End Date:</label>
						<input class="datePick" type="text"/>
					
					</td>

					<td>
											<label class="lbl_charts">Interval:</label>
						<select>
							<option>
							
								Daily
							</option>
							<option>
								Hourly
							</option>
							
						</select>
						<br />
						<label class="lbl_charts">Create:</label>
						<input type="button" value="Create" id="btn_createChart" />
				</tr>
			</table>
			
				<div id='container_interiorTemperature'></div>

			</div>

	
</div>


<div id='test'>
HERE IS SOME TEXT
</div>


</body>
</html>
