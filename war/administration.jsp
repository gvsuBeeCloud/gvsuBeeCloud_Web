<%
response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevent caching at the proxy server

//session.invalidate();
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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


<link rel="stylesheet" href="css/admin_style.css" type="text/css"></link>
<link rel="stylesheet" href="css/menu_style.css" type="text/css"></link>


			<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" type="text/javascript"></script>
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
    <link rel="stylesheet"
	href="/css/ui-darkness/jquery-ui-1.8.18.custom.css" type="text/css"></link>
    <script type="text/javascript" src="js/admin_functions.js"></script>
</head>    
<body>
<div class="menu5">
<ul>
<li><a href="map2.jsp?view=map">Map</a></li>
<li><a href="map2.jsp?view=data">Data</a></li>
<li><a href="map2.jsp?view=charts">Charts</a></li>
<li class="active"><a href="adminstration.jsp">Admin</a></li>
<div class="clearFloat"></div>
</ul>
</div>


<%!
//define globals
	int editMode=0;
	String hiveID="";
	boolean addHive=false;
	String[] fieldsToSearch={};
	String[] hivesToSearch={};

%>
<%

//cash all parameters for future use
if(request.getParameter("editMode")!=null){
	//switch on edit mode
	editMode=Integer.parseInt(request.getParameter("editMode"));
	switch(editMode){
		case 0://edit nothing
			break;
		case 1://edit hives
			//user would like to edit an existing hive
			
				if(request.getParameter("hiveID")!=null){
				//get hive id to edit
				hiveID=request.getParameter("hiveID");
				}
						
			break;
		case 2://edit profile
		
			break;
		case 3://run query
		
			//get the hives
			//make sure the values aren't null
			if(request.getParameterValues("hives")!=null && request.getParameterValues("fields")!=null){
				
		
			hivesToSearch=request.getParameterValues("hives");
			fieldsToSearch=request.getParameterValues("fields");
			}
		
			
		
			break;
			
		case 4://add hive
			break;
			
		
	
	}
}
	
%>

<div id="div_banner">
	<div id="div_banner_header">
		Administration
	<%
		//handle user login
		UserService userService = UserServiceFactory.getUserService();
    	User user = userService.getCurrentUser();
    	if (user != null){
	%>
		<div id='div_banner_user'>Welcome, <%=user.getNickname() %>[<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">logout</a>]</div>
	<%
    	}else{
    		
    		%>
    		
    		<div id='div_banner_user'><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></div>
    		<%
    	}
	%>
	
	
	</div>
	

	
</div>


<!--  div id="div_navigation" --> 
		<!--  ul id="ul_navigation" -->
			<!--  li--> 
			
			<!--  /li -->
			
			<!-- li--><!--  /li -->
			<!--  li --> <!--  /li -->
		
		<!--  /ul-->

	<!--  /div-->

<br />
<br />
<div id="wrapper_main">
	
<div id='div_hive' class='div_module'>

<label class='sectionHeader'>Hive Management</label> 
<div id='div_createHive'>
			
</div>
	<div id='div_existingHives'> 
		
		<%
			//determine if add hive panel should be visible
			if(editMode==4){
				//show form
				%>
					<form method="get" action="/UpdateHive">
						<label>Hive ID</label><input type='text' name="hiveID" />
						<label>Name</label><input type='text' name="name" />
						<input type="hidden" value="<%= user.getEmail() %>" name="userID"/>
						<input type='submit' class='button'  value='Add' />
					</form>
				<%
			
				
			}else{
		%>
		<form method="get" action="/administration.jsp">
		<input type="hidden" name="editMode" value="4" />
		<input class='button' type="submit" value="Add Hive" />
		</form>
		
		<%
			}
		%>
		<table id="table_existingHives">
		
		
		<th>Hive ID</th><th class='th_hiveID'> Name</th><th>Alert Number</th><th>Latitude</th><th>Longitude</th><th>Manage</th>
		
		<%
			//get existing hives for the user
			//try querying
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    		Query query = new Query("Hive").addFilter("userID", Query.FilterOperator.EQUAL, user.getEmail()).addSort("hiveID", Query.SortDirection.DESCENDING);
				
    		List<Entity> records = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(999999999));
		
					
    	    if(records.isEmpty()){
    	    	%>
    	    	<!--p> Records are empty </p-->
    	    	<%
    	    }else{
    	    	for(Entity record: records){
    	    		
    	    		
    	    		//determine if the hive is one that should be edited
    	    		if(editMode==1 && hiveID.equals(record.getProperty("hiveID"))){
    	    			//show edit row
    	    			
    	    				%>
    	    				<form method="get" action="/UpdateHive">
    	    				<tr>
    	    				<input type='hidden' name='userID' value="<%=record.getProperty("userID") %>" />
    	    					<td class='hiveRecord_hiveID'><input type='text' name='hiveID' value="<%=record.getProperty("hiveID") %>" /></td>
    	    				
	    						<td class='hiveRecord_alias'><input type='text' name='alias' value="<%=record.getProperty("alias") %>" /></td>
	    						

	    						<td><input type='text' name='alertPhone' value=<%=record.getProperty("alertPhone") %> /></td>
								<td>
    	    						<input type='text' name='location_lat' value="<%=record.getProperty("location_lat") %>" />
    	    					</td>
    	    					<td>
									<input type='text' name='location_long' value="<%=record.getProperty("location_long") %>" />
								
    	    					</td>
								
								<td>
								
								<input type='submit' class='button' value='Save' /></form><form method="get" action="/DeleteHive">
								
								<input type="hidden" name="hiveID" value="<%=record.getProperty("hiveID") %>" />
								<input type='submit' class='button' value='Delete' /> 
								</form>
								</td>

							</tr>
							
							<%
    	    			
    	    		}else{
    	    			//show normal row
    	    			
    	    			
    	    			%>
    	    			<tr>
    	    		    	  	<td>
    	    						<%=record.getProperty("hiveID") %>
    	    					</td>				
    	    				<td class='hiveRecord_alias'><%=record.getProperty("alias") %></td>

	    					<td class='hiveRecord_alertPhone'><%=record.getProperty("alertPhone") %></td>
    	    		    	  	<td>
    	    						<%=record.getProperty("location_lat") %>
    	    					</td>
    	    		    	  	<td>
    	    						<%=record.getProperty("location_long") %>
    	    					</td>
    	    					
							<td><a  class='button' n' href="administration.jsp?editMode=1&hiveID=<%=record.getProperty("hiveID") %>" > Edit</a> </td>
							
						</tr>
    	    			
    	    			<% 
    	    			
    	    		}
    	
    	    	}
    	    }
			%>
		</table>
	</div> 

</div>
<div id='div_profile' class='div_module'>
<label class='sectionHeader'>Profile</label>

	<table id='table_profile'>
		<tr>
		
			
		</tr>
		
		<%
			//get all profile data
			    		Key profileKey = KeyFactory.createKey("Users", user.getEmail());

			Query profileQuery = new Query("Users",profileKey);
    		List<Entity> profileRecords = datastore.prepare(profileQuery).asList(FetchOptions.Builder.withLimit(1));
		
    		if(profileRecords.isEmpty()){
    			//create a sample record
    			profileRecords.add(new Entity(profileKey));
    		}
			for(Entity profile:profileRecords){
			
		
			//determine if user wants to edit profile
			if(editMode==2){
				//show in edit mode

				
				
				
				%><form method="get" action="/UpdateProfile">
				<tr>
				
					<td class='table_label'>First Name  </td> <td class='table_label'> Email </td>
					</tr>
					<tr>
						<td><input name="firstName" value="<%=profile.getProperty("firstName") %>" type='text' /> </td> <td><input name="email" value="<%=profile.getProperty("email") %>" type="text"/></td>
					</tr>
					<tr>
						<td class='table_label'> Last Name </td><td class='table_label'> Organization </td>
					</tr>
					<tr>
						 <td><input name="lastName" value="<%=profile.getProperty("lastName") %>" type="text"/> </td> <td> <input name="organization" value="<%=profile.getProperty("organization") %>" type="text"/> </td>
					</tr>
					<tr>
						<td class='table_label'> Username </td><td class='table_label'> Manage </td>
					</tr>
					<tr>
						
						<td> <input name="username" value="<%=profile.getProperty("username") %>" type="text"/></td>  <td> <input type='submit' class='button' value='Save'/> </td>
						
					</tr>
					</form>
				<%
			}else{
				//show in normal mode
				
				%>
				<tr>
					<td class='table_label'> First Name </td> <td class='table_label'> Email </td>
				</tr>
				<tr>
					<td> <%=profile.getProperty("firstName") %> </td> <td><%=profile.getProperty("email") %></td>
				</tr>
				<tr>
					<td class='table_label'> Last Name </td><td class='table_label'> Organization </td>
				</tr>
				<tr>
			 		<td> <%=profile.getProperty("lastName") %> </td> <td> <%=profile.getProperty("organization") %> </td>
				</tr>
				<tr>
					<td class='table_label'> Username </td><td class='table_label'> Manage </td>
		
				<tr>
						<td> <%=profile.getProperty("username") %></td>  <td> <a class='button' href="administration.jsp?editMode=2">Edit</a></td>
				</tr>
				<%
			}
			}
		%>
		

		
		

	</table>
</div>

<br />
<div id='div_data' class='div_module'>
<label class='sectionHeader'>Data</label>
	<div id='div_dataQuery'>
	<form method="get" action="administration.jsp">
	<input type="hidden" value="3" name="editMode" />
	<br />
	
		<label class='lbl_section'>Select Hive</label>
		<select name="hives"> 
					<option> All</option>
					
				<%
			//query available hives
			//try querying

    		Query hiveQuery = new Query("Hive").addFilter("userID", Query.FilterOperator.EQUAL, user.getEmail()).addSort("hiveID", Query.SortDirection.DESCENDING);
				
    		List<Entity> hiveNameRecords = datastore.prepare(hiveQuery).asList(FetchOptions.Builder.withLimit(999999999));
		
					
    	    if(hiveNameRecords.isEmpty()){
    	    	%>
    	    	<!-- option> Records are empty </option-->
    	    	<%
    	    }else{
    	    	for(Entity record: hiveNameRecords){
		%>
		
		

			<option value="<%=record.getProperty("hiveID")%>"> <%=record.getProperty("alias") %> </option>
			
			<%
				}
			}
		%>

		</select>
		<label class='lbl_section'>Start Date</label>
		<input class='datepick' id='queryStartDate' type='text' />
		<label class='lbl_section'>End Date </label>
		<input class='datepick' id='queryEndDate' type='text' />
		<label class='lbl_section'>Fields</label>
		<select name="fields" size=5 multiple>
		<%
			//query available hives
			//try querying
    		Query hiveRecordFieldsQuery = new Query("hiveRecord").addSort("hiveID", Query.SortDirection.DESCENDING);
				
    		List<Entity>hiveRecordFields = datastore.prepare(hiveRecordFieldsQuery).asList(FetchOptions.Builder.withLimit(2));
		
					
    	    if(hiveRecordFields.isEmpty()){
    	    	%>
    	    	<option> No fields to display </option>
    	    	<%
    	    }else{
    	    	
    	    	Entity sampleRecord = hiveRecordFields.get(0);
    	    	Map<String,Object> props =sampleRecord.getProperties();
    	    	for(String prop: props.keySet()){
		%>
		
		

			<option> <%=prop%> </option>
			
			<%
				}
			}
		%>
		</select>
			<input type='submit' class='button'  value='Query'/>		
	
</form>	
	</div>
	
	<div id='div_dataResults'>
	
		<div id='div_dataResults_controls'>
		
			<label class='lbl_section'>Results</label>
			<div id='img_print' class='controlBox'></div>
			<div id='img_send' class='controlBox'></div>
		</div>
		<br />
		<table id='table_dataResults'>
		<% 
		//determine if the user has selected to run a query
		if(editMode==3){
		//print the row headers
		for(String field:fieldsToSearch){
			%>
			
			<th><%=field %></th>
			
			<%
		}
		
		
		//run data query
		//try querying
		//DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		//Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
		// Run an ancestor query to ensure we see the most up-to-date
		// view of the Greetings belonging to the selected Guestbook.
		Query resultsQuery = new Query("hiveRecord").addFilter("hiveID",Query.FilterOperator.EQUAL,hivesToSearch[0].trim() 	).addSort("hiveID", Query.SortDirection.DESCENDING);
			
		List<Entity> hiveRecords = datastore.prepare(resultsQuery).asList(FetchOptions.Builder.withLimit(999999999));
		
				
	    if(hiveRecords.isEmpty()){
	    	%>
	    	<p> Records are empty for hive <%=hivesToSearch[0] %> </p>
	    	<%
	    }else{
	    	for(Entity hiveRecord: hiveRecords){
	    	
	    		
	    		%>
	    			<tr>
	    		<%
	    		for(String field: fieldsToSearch){
	    			
	    		
		%>
	
				<td><%=hiveRecord.getProperty(field) %>

		<%
	    		}
	    		%>
	    		</tr>
	    		<%
			}
		}
		}
		%>
		</table>
	</div>
</div>
<br />	

</div>
</body>

</html>