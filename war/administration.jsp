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

<div id="div_banner">
	<div id="div_banner_header">
		Header
	</div>
	
</div>
<div id="div_navigation"> 
		<ul id="ul_navigation">
			<li> Hives
			
			</li>
			
			<li> Data </li>
			<li> Profile </li>
		
		</ul>
	</div>
<div id="wrapper_main">
	
<div id='div_hive'>
<label class='sectionHeader'>Hive Management</label> 
<div id='div_createHive'>
	<input type='button' value="Add New Hive" />
</div>
	<div id='div_existingHives'> 
	
		
		<table id="table_existingHives">
			<th>Name</th><th>Description</th><th>Manage</th>
			<tr>
				<td> hiveBlah </td> <td> Holland Hive </td> <td>Edit | Delete</td>
			
			</tr>
		</table>
	</div> 

</div>
<div id='div_data'>
<label class='sectionHeader'>Data</label>
	<div id='div_dataQuery'>
	
		Select Hive
		<select> 
			<option> All
			
			</option>
			
			<option> hiveBlah
			</option>
		</select>
		Start Date
		<input id='queryStartDate' type='text' />
		End Date 
		<input id='queryEndDate' type='text' />
		Fields
		<select size=5 multiple>
			<option> field1 </option>
			<option> field2 </option>
		</select>
		
		<input type='button'  value='query'/>
		
	</div>
	
	<div id='div_dataResults'>
	
		<table id='table_dataResults'>
			<tr>
				<th>Field 1</th><th>Field 2</th><th>Field 3</th>
				
			</tr>
			<tr>
				<td>res1 </td> <td>res2 </td> <td>res3 </td>
			</tr>
		
		</table>
	</div>
</div>

<div id='div_profile'>
<label class='sectionHeader'>Profile</label>
</div>
</div>
</body>

</html>