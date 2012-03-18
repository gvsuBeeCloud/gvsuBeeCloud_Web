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

</head>
<link rel="stylesheet" href="css/admin_style.css" type="text/css"></link>

    <script type="text/javascript" src="js/jquery-1.7.1.js"></script>
    <script type="text/javascript" src="js/jquery-ui-1.8.17.custom.min.js"></script>
    <link rel="stylesheet"
	href="/css/smoothness/jquery-ui-1.8.17.custom.css" type="text/css"></link>
    <script type="text/javascript" src="js/admin_functions.js"></script>
    
<body>

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
			//determine if adding hide
			if(request.getParameter("addHive")!=null){
				
				//user would like to add a hive
				addHive=true;
				
				
			}else{
				//user would like to edit an existing hive
			
				if(request.getParameter("hiveID")!=null){
				//get hive id to edit
				hiveID=request.getParameter("hiveID");
				}
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
		
	
	}
}
	
%>

<div id="div_banner">
	<div id="div_banner_header">
		Administration
	
		<div id='div_banner_user'>
		Welcome, Admin [<a href="#">logout</a>]
		
	</div>
	
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
	<input type='button' value="Add New Hive" />
</div>
	<div id='div_existingHives'> 
	
		<%
			//determine if add hive panel should be visible
			if(addHive){
				//show form
				%>
					<form>
						<input type='text' />
						<input type='text' />
						<input type='submit' value='Add' />
					</form>
				<%
			
				
			}
		%>
		
		<table id="table_existingHives">
		<th> Name</th><th>Description</th><th>Manage</th>
		
		<%
			//get existing hives for the user
			//try querying
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    		Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
    		// Run an ancestor query to ensure we see the most up-to-date
    		// view of the Greetings belonging to the selected Guestbook.
    		Query query = new Query("Hive",hiveKey).addSort("hiveID", Query.SortDirection.DESCENDING);
				
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
    	    				<tr>
	    						<td class='hiveRecord_hiveID'><%=record.getProperty("hiveID") %></td>

	    						<td class='hiveRecord_weight'><input type='text' value=<%=record.getProperty("description") %> /></td>
								<td><input type='button' value='Save' /> | <input type='button' value='Delete' /> </td>
							</tr>
							<%
    	    			
    	    		}else{
    	    			//show normal row
    	    			
    	    			
    	    			%>
    	    			<tr>
	    					<td class='hiveRecord_hiveID'><%=record.getProperty("hiveID") %></td>

	    					<td class='hiveRecord_weight'><%=record.getProperty("description") %></td>
							<td><input type='button' value='Edit' /> | <input type='button' value='Delete' /> </td>
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
			//determine if user wants to edit profile
			if(editMode==2){
				//show in edit mode
				
				
				%>
				<tr>
					<td class='table_label'> First Name </td> <td class='table_label'> Email </td>
					</tr>
					<tr>
						<td> Bob </td> <td>bob.loblaw@mail.com</td>
					</tr>
					<tr>
						<td class='table_label'> Last Name </td><td class='table_label'> Organization </td>
					</tr>
					<tr>
						 <td> Loblaw </td> <td> Independent </td>
					</tr>
					<tr>
						<td class='table_label'> Username </td><td class='table_label'> Manage </td>
		
					<tr>
						<td> bobloblaw</td>  <td> <input type='button' value='Save'/> </td>
					</tr>
				<%
			}else{
				//show in normal mode
				
				%>
				<tr>
					<td class='table_label'> First Name </td> <td class='table_label'> Email </td>
				</tr>
				<tr>
					<td> Bob </td> <td>bob.loblaw@mail.com</td>
				</tr>
				<tr>
					<td class='table_label'> Last Name </td><td class='table_label'> Organization </td>
				</tr>
				<tr>
			 		<td> Loblaw </td> <td> Independent </td>
				</tr>
				<tr>
					<td class='table_label'> Username </td><td class='table_label'> Manage </td>
		
				<tr>
						<td> bobloblaw</td>  <td> <input type='button' value='Edit'/> </td>
				</tr>
				<%
			}
		%>
		

		
		

	</table>
</div>

<br />
<div id='div_data' class='div_module'>
<label class='sectionHeader'>Data</label>
	<div id='div_dataQuery'>
	<br />
	
		<label class='lbl_section'>Select Hive</label>
		<select> 
					<option> All</option>
					
				<%
			//query available hives
			//try querying

    		//query = new Query("Hive",hiveKey).addSort("hiveID", Query.SortDirection.DESCENDING);
				
    		//records = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(999999999));
		
					
    	    if(records.isEmpty()){
    	    	%>
    	    	<!-- option> Records are empty </option-->
    	    	<%
    	    }else{
    	    	for(Entity record: records){
		%>
		
		

			<option> <%=record.getProperty("hiveID") %> </option>
			
			<%
				}
			}
		%>

		</select>
		<label class='lbl_section'>Start Date</label>
		<input id='queryStartDate' type='text' />
		<label class='lbl_section'>End Date </label>
		<input id='queryEndDate' type='text' />
		<label class='lbl_section'>Fields</label>
		<select size=5 multiple>
		<%
			//query available hives
			//try querying
    		//query = new Query("Hive",hiveKey).addSort("hiveID", Query.SortDirection.DESCENDING);
				
    		//records = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(999999999));
		
					
    	    if(records.isEmpty()){
    	    	%>
    	    	<option> No fields to display </option>
    	    	<%
    	    }else{
    	    	
    	    	Entity sampleRecord = records.get(0);
    	    	Map<String,Object> props =sampleRecord.getProperties();
    	    	for(String prop: props.keySet()){
		%>
		
		

			<option> <%=prop%> </option>
			
			<%
				}
			}
		%>
		</select>
		
		<input type='button'  value='query'/>
		
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
		Query resultsQuery = new Query("HiveRecord",hiveKey).addSort("hiveID", Query.SortDirection.DESCENDING);
			
		List<Entity> hiveRecords = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(999999999));
	
				
	    if(hiveRecords.isEmpty()){
	    	%>
	    	<p> Records are empty </p>
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