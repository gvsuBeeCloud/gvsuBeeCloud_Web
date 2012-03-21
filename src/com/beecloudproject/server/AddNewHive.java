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

public class AddNewHive extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		//resp.getWriter().println("Weight: "+req.getParameter("weight"));
		
		
		//build hashmap
		HashMap paramHash=buildHiveHashMapFromParams(req);
		//build entity
		Entity entity_newHiveToStore=buildEntityFromHashMap(paramHash,"hive");

		
		//store the entity
		storeEntity(entity_newHiveToStore);
		
	}
	
		
	public HashMap buildHiveHashMapFromParams(HttpServletRequest req){
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

		
		
		
	
		return paramMap;
		
		
		
	}
	
	public Entity buildEntityFromHashMap(HashMap sourceHashMap,String type){
		
	
		com.google.appengine.api.datastore.Key hiveKey = KeyFactory.createKey("HiveParent", (String) sourceHashMap.get("hiveID"));
	    
		//make entity
		Entity entity_newRecord = new Entity(type,hiveKey);
		
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
			entity_newRecord.setProperty((String)key, tmpParam);
			}
			
		}

		
		return entity_newRecord;
	}
	

	
	public void storeEntity(Entity entity_toStore){
		//create datastore service
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		//put in datastore
		datastore.put(entity_toStore);
			
	}
}
