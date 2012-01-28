package com.beecloudproject.server;

import java.io.IOException;
import java.util.Date;
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

public class UploadHive extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		
		resp.getWriter().println("Weight: "+req.getParameter("weight"));
		
		
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
	//	String type;
		String hiveID;
		String temperature;
		String weight;
		String location_lat;
		String location_long;
		
		//breakdown hive data
	//	type="hiveRecord";
		hiveID=req.getParameter("hiveID");
		temperature=req.getParameter("temperature");
		weight=req.getParameter("weight");
		location_lat=req.getParameter("location_lat");
		location_long=req.getParameter("location_long");
		
		System.out.println("ID: "+hiveID);
		
		HashMap paramMap = new HashMap();
		
	//	paramMap.put("type",type);
		paramMap.put("hiveID", hiveID);
		paramMap.put("temperature", temperature);
		paramMap.put("weight", weight);
		paramMap.put("location_lat", location_lat);
		paramMap.put("location_long", location_long);
		
		return paramMap;
		
		
		
	}
	
	public Entity buildEntityFromHashMap(HashMap sourceHashMap){
		
		String keyName="hiveParentKey";
		com.google.appengine.api.datastore.Key hiveKey = KeyFactory.createKey("HiveParent", keyName);
	    
		//make entity
		Entity entity_hiveRecord = new Entity("hiveRecord",hiveKey);
		
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
