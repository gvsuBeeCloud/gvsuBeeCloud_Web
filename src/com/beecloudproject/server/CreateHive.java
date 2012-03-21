package com.beecloudproject.server;

import java.io.IOException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class CreateHive extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {

		//build hashmap
		HashMap paramHash=buildHashMapFromParams(req);
		//build entity
		Entity entity_toStore=buildEntityFromHashMap(paramHash);
		
		//store the entity
		storeEntity(entity_toStore);
		
		

	resp.sendRedirect("/map.jsp");
	
	}
	
	public HashMap buildHashMapFromParams(HttpServletRequest req){
		//declare hive fields
		HashMap paramMap = new HashMap();

		
		Enumeration parameterNames=req.getParameterNames();
		//for each parameter name
		while(parameterNames.hasMoreElements()){
			//get the name
			String parameterName=(String) parameterNames.nextElement();
			//look for its value
			String parameterValue= req.getParameter(parameterName);
			//add to hashmap
			paramMap.put(parameterName, parameterValue);				
		}

		
		
		
		
		/**
		
		String hiveID;
		String temperature_exterior;
		String temperature_exterior_max_six;
		String temperature_exterior_min_six;
		String temperature_exterior_max_twelve;
		String temperature_exterior_min_twelve;
		

		String temperature_interior;
		String temperature_interior_max_six;
		String temperature_interior_min_six;
		String temperature_interior_max_twelve;
		String temperature_interior_min_twelve;
		String weight;
		String weight_max_six;
		String weight_min_six;
		String weight_max_twelve;
		String weight_min_twelve;
		String location_lat;
		String location_long;
		
		//breakdown hive data
	//	type="hiveRecord";
		hiveID=req.getParameter("hiveID");
		temperature_interior=req.getParameter("temperature_interior");
		temperature_interior=req.getParameter("temperature_exterior_max_six");
		temperature_interior=req.getParameter("temperature_interior");
		temperature_interior=req.getParameter("temperature_interior");
		temperature_interior=req.getParameter("temperature_interior");
		
		temperature_exterior=req.getParameter("temperature_exterior");
		temperature_exterior=req.getParameter("temperature_exterior");
		temperature_exterior=req.getParameter("temperature_exterior");
		temperature_exterior=req.getParameter("temperature_exterior");
		temperature_exterior=req.getParameter("temperature_exterior");

		weight=req.getParameter("weight");
		weight=req.getParameter("weight");
		weight=req.getParameter("weight");
		weight=req.getParameter("weight");
		weight=req.getParameter("weight");

		location_lat=req.getParameter("location_lat");
		location_long=req.getParameter("location_long");
		
		System.out.println("ID: "+hiveID);
		
		
	//	paramMap.put("type",type);
		paramMap.put("hiveID", hiveID);
		paramMap.put("temperature_interior", temperature_interior);
		paramMap.put("temperature_exterior",temperature_exterior);
		paramMap.put("weight", weight);
		paramMap.put("location_lat", location_lat);
		paramMap.put("location_long", location_long);
		
		*/
		
		return paramMap;
		
		
		
	}
	
	public Entity buildEntityFromHashMap(HashMap sourceHashMap){
		
		String keyName="hiveParentKey";
		com.google.appengine.api.datastore.Key hiveKey = KeyFactory.createKey("HiveParent", keyName);
	    
		//make entity
		Entity entity_hiveRecord = new Entity("Hive",hiveKey);
		
		//get keys from the map
		Object[] keys = sourceHashMap.keySet().toArray();
		
		//for each key, find its value and add to entity
		for(Object key: keys){

	
			//get value from hashmap
			String tmpParam= (String) sourceHashMap.get(key);
			
			if(key.equals("type")){
				
				//set the entity type
				
				
			}else{

			
			//set property
			entity_hiveRecord.setProperty((String)key, tmpParam);
			}
			
		}

		
		return entity_hiveRecord;
	}
	
	public void storeEntity(Entity entity_toStore){
		//create datastore service
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		//put in datastore
		datastore.put(entity_toStore);
			
	}

	



}
