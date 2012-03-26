<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<html>
<head>
<title>Project Bee Cloud</title>
<link rel="stylesheet" href="css/style.css" type="text/css"></link>

<script type="text/javascript"
	src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCQnswJmYxTHOZdj3MbKtUE-bR_Fg6mx5c&sensor=true">
    </script>
    <script type="text/javascript" src="js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.8.17.custom.min.js"></script>
    <script type="text/javascript" src="js/functions.js"></script>


</head>
<body onload="loadMarkersFromHiddenDivs()">
	<div id='div_banner'><!--  img src="images/gvLogoTemp.png" /-->BeeCloud Project
	
	
	<div class='shouldBeHidden' id='div_param_hiveID'> </div>
	<%! 
		String weight = "";
		String int_temp = "";
		String ext_temp = "";
		String message = "";
	%>
	<%
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    	Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
    	
    	// Run an ancestor query to ensure we see the most up-to-date
    	// view of the Greetings belonging to the selected Guestbook.
    	Query query = new Query("Hive",hiveKey).addSort("hiveID", Query.SortDirection.DESCENDING);
				
    	List<Entity> records = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(999999999));
				
	    if(records.isEmpty()){
	    	%>
	    	<p> Records are empty </p>
	    	<%
	    }else{
	    	for(Entity record: records){
	    		
	    		//add hidden values
	    		%> <div class='shouldBeHidden hiveRecord'>
	    				<div class='hiveRecord_hiveID'><%=record.getProperty("hiveID") %></div>
	    				<div class='hiveRecord_aliasID'><%=record.getProperty("aliasID") %></div>
	    				<div class='hiveRecord_loc_lat'><%=record.getProperty("location_lat") %></div>
	    				<div class='hiveRecord_loc_long'><%=record.getProperty("location_long") %></div>
	    				<%
	    				datastore = DatastoreServiceFactory.getDatastoreService();
	    				Key hiveRecordKey = KeyFactory.createKey("hiveRecordParent", "hiveRecordParentKey");
	    				Query hivePopUp = new Query("hiveRecord",hiveRecordKey);
	    				hivePopUp.addFilter("hiveID", Query.FilterOperator.EQUAL, ((String)record.getProperty("hiveID")));
	    				//Need to find a way to reduce number of records by implementing something that 
	    				//can call a date
	    				//hivePopUp.addSort("timeStamp", Query.SortDirection.DESCENDING);
	    				List<Entity> rec = datastore.prepare(hivePopUp).asList(FetchOptions.Builder.withLimit(999999999));
			
    					if(rec.isEmpty()){
	    					message = "Must Be A New Hive With No Records";    		
    					}
    					else{
    						Entity lastRecord = rec.get(0);
    	
    						weight = (lastRecord.getProperty("weight")).toString(); 
							int_temp = (lastRecord.getProperty("intTemp")).toString();
							ext_temp = (lastRecord.getProperty("extTemp")).toString();
						}
    					%> 
	    				<div class='hiveRecord_weight'><%=weight %></div>
	    				<div class='hiveRecord_iTemperature'><%=int_temp %></div>
	    				<div class='hiveRecord_eTemperature'><%=ext_temp %></div>
	    		</div>  
	    		
	    		<%
	    		
	    		
	    	}
	    	
	    }
	    
	    
	%>
	
	</div>
	<div id="div_map_container"></div>


<div id='div_hiveControls_wrapper'><div id='div_hiveControls'></div><div id='div_hiveControls_grabber'>



</div>


</div>
<div id="container_historicalData"><div id="grabber_historicalData"></div><div id='div_historicalData'> 
<span style="color:white;">Click a hive to view data.</span>
<p> Weight: <%=weight%> </p>
<p> iTemp: <%=int_temp%> </p>
<p> eTemp: <%=ext_temp%> </p>
<p> message: <%=message%> </p>

</div></div>
</body>
</html>