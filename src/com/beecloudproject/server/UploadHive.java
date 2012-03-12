package com.beecloudproject.server;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.jdo.JDOHelper;
import javax.jdo.PersistenceManager;
import javax.jdo.PersistenceManagerFactory;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.TransactionOptions;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import com.google.appengine.api.datastore.Transaction;

import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;

import com.techventus.server.voice.Voice;
import com.techventus.server.voice.datatypes.records.SMSThread;

public class UploadHive extends HttpServlet {
	// array of field names in hive table
	private static final String[] fieldNamesInHiveTable = { "timeStamp", "weight", "intTemp",
			"extTemp", "battery","timeStamp" };
	HashMap currentValues = new HashMap();;
	// hashMap of hive table record
	HashMap hiveTableRecord = new HashMap();
	// hive id
	String hiveID;
	//existing record key
	Key existingRecordKey;

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException 
	{
		SMStoText SMSCollection = new SMStoText();
		ArrayList<String> records = new ArrayList<String>();
		try
		{
			Voice voice = new Voice("gvsuBeeCloud@gmail.com", "cis4672012");
			SMSCollection.setVoice(voice);
			SMSCollection.createHiveRecord(SMSCollection.getVoice(), SMSCollection.getUnreadRecords());
			records = SMSCollection.getRecords();
		}
  		catch (NullPointerException npe) 
  		{
			resp.getWriter().print("Caught something..."+npe.getMessage());
		}
				
		/*
		// build hashmap
		HashMap paramHash = buildHashMapFromParams(req,resp);
		// build entity
		Entity entity_toStore = buildEntityFromHashMap("hiveRecord", paramHash);

		// store the entity
		storeEntity(entity_toStore);
		
	}

	/**
	 * Build a hashmap from the parameters sent in the http request
	 * @param req -- the sent httprequest
	 * @return  -- the constructed hashmap
	 * @throws IOException 
	 */
	public HashMap buildHashMapFromParams(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		// declare hive fields
		HashMap paramMap = new HashMap();
		boolean TimeStart=false;
		boolean TimeEnd=false;
		boolean TimeGood=true;
		String timeStamp="";

		Enumeration parameterNames = req.getParameterNames();
		// for each parameter name
		while (parameterNames.hasMoreElements()) {
			boolean id=false;
			// get the name
			String parameterName = (String) parameterNames.nextElement();
			// if hiveID parameter, set it
			if (parameterName.equals("hiveID")) {
				id=true;
				hiveID = req.getParameter(parameterName);
			}
			if (parameterName.equals("year") || parameterName.equals("month") || parameterName.equals("day") 
					|| parameterName.equals("timeH")) {
				TimeStart=true;
			}
			if (parameterName.equals("timeM")) {
				TimeEnd=true;
			}
			// look for its value
			String parameterValue = req.getParameter(parameterName);
//			resp.getWriter().println(parameterName + ":" + parameterValue+ "||");
			// add to hashmap

			if(id)
				paramMap.put(parameterName, parameterValue);
			
			else {
				if(!isValidWithCDM(parameterName,parameterValue,resp)) {
					if(TimeStart)
						TimeGood=false;
					resp.getWriter().println("!!!" + parameterName+":"+parameterValue+" is not valid!!!");
				}
				if(TimeStart)
				{
					timeStamp += parameterValue;
					if(TimeEnd)
						TimeStart=false;
				}
				if(TimeEnd && TimeGood)
				{
					paramMap.put("timeStamp", timeStamp);
					TimeEnd=false;
				}
				else {
					paramMap.put(parameterName, parameterValue);
				}
			}
			
		}

		return paramMap;

	}

	/**
	 * Given a hashmap, make a new entity with the corresponding properties
	 * @param entityName  -- the type of the newly created entity
	 * @param sourceHashMap  -- the hashmap used for building properties
	 * @return  -- the newly created entity
	 */
	public Entity buildEntityFromHashMap(String entityName,
			HashMap sourceHashMap) {

		com.google.appengine.api.datastore.Key hiveKey = KeyFactory.createKey(
				entityName, hiveID);

		// make entity
		Entity entity_hiveRecord = new Entity(entityName, hiveKey);

		// get keys from the map
		Object[] keys = sourceHashMap.keySet().toArray();

		// for each key, find its value and add to entity
		for (Object key : keys) {

			// get value from hashmap
			String tmpParam = (String) sourceHashMap.get(key);

			// set property
			entity_hiveRecord.setProperty((String) key, tmpParam);


		}

		return entity_hiveRecord;
	}

	/**
	 * Store a given entity in the datastore
	 * @param entity_toStore
	 */
	public void storeEntity(Entity entity_toStore) {
		// create datastore service
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
	    TransactionOptions options = TransactionOptions.Builder.withXG(true);
		Transaction txn = datastore.beginTransaction(options);		
		
		try {
			
			if(existingRecordKey!=null){
			// determine if it already exists
			Entity entity_existing = datastore.get(existingRecordKey);
			
			// update the existing entity for the appropriate fields
			Map<String, Object> properties = entity_toStore.getProperties();
			// for every field, update it
		for (Map.Entry<String, Object> entry : properties.entrySet()) {
				// update that field
				entity_existing.setProperty(entry.getKey(), entry.getValue());
			}
			

			}else{
				datastore.put(entity_toStore);
			}

		} catch (EntityNotFoundException e) {

			// put in datastore
		datastore.put(entity_toStore);
		} 

		txn.commit();
	

	}

	/**
	 * query for existing records
	 * 
	 * @param hiveID
	 */
	public boolean queryDataStoreForExistingRecord(String hiveID) 
	{
		boolean aRecordReturned;
		// query
		// try querying
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();
		Key hiveKey = KeyFactory.createKey("Hive", hiveID);
		// Run an ancestor query to ensure we see the most up-to-date
		Query query = new Query("Hive", hiveKey).addSort("hiveID",
				Query.SortDirection.DESCENDING);
		query.addFilter("hiveID", Query.FilterOperator.EQUAL, hiveID);

		Entity record = datastore.prepare(query).asSingleEntity();
		//if null, then no record was returned :(
		if(record == null){
			//so, we have to do ...nothing?
			aRecordReturned=false;
			existingRecordKey=null;
			//set the minimum fields necessary
			
			//set hiveID
			//set blah...
			
		}
		else{//get the keys that are in the table!
			aRecordReturned=true;
			existingRecordKey=record.getKey();
			// break down record
			Map<String, Object> tmpHiveKeysAndValues = record.getProperties();
			for (Map.Entry<String, Object> entry : tmpHiveKeysAndValues.entrySet()) {
				// add to hashmap
				hiveTableRecord.put(entry.getKey(), entry.getValue());

			}
		}

		return aRecordReturned;

	}

	/**
	 
	 * Determine if the field is in the hive table based on an associative array
	 * 
	 * @param fieldName
	 * @return
	 */
	public boolean isInHiveTable(String fieldName) {

		boolean bool_isInHiveTable = false;
		// lets check if it is in the hive table!
		for (String baseHiveTableName : fieldNamesInHiveTable) {
			if (baseHiveTableName.equals(fieldName)) {
				// then there is a match
				bool_isInHiveTable = true;
				break;
			}

		}

		return bool_isInHiveTable;

	}


	/**
	 * Add a given value to the current values hash map.
	 * @param fieldname  -- the field to set
	 * @param entryValue -- the value to set the field to
	 */
	public void addToCurrentValues(String fieldname, String entryValue) {

		// add to map
		currentValues.put(fieldname, entryValue);

	}

	/**
	 * test to see if parameter is valid with cdm
	 * @param paramName  -- name of parameter to test against cdm
	 * @param paramValue --  value to test against cdm
	 * @throws IOException 
	 */
	public static boolean isValidWithCDM(String paramName, String paramValue,  HttpServletResponse resp) throws IOException {
//		resp.getWriter().printf("starting '%s':%s\n", paramName,paramValue);
		boolean valid = false;
		try
		{
			FileInputStream fstream = new FileInputStream("includes/CDM.txt");
			DataInputStream in = new DataInputStream(fstream);
	        BufferedReader br = new BufferedReader(new InputStreamReader(in));

	        String readIn;
	        while ((readIn = br.readLine()) != null) 
	        {
	        	String[] subs;
	        	subs=readIn.split("\t");
	        	if(subs[0].compareTo(paramName)==0)
	        	{
//	        		resp.getWriter().printf("Comparing '%s' with value %s\n",paramName,paramValue);
	        		valid = true;
	        		
		        	if(subs[1].compareTo("String")==0) {
		        		String tempS=paramValue;
		        		if(tempS.compareTo("xxxxx")==0) {
		        			valid=false;
		        			break;
		        		}
		        		break;		        			
			        }
		        	else if(subs[1].compareTo("Double")==0) {
		        		Double tempD=new Double(paramValue);
		        		DecimalFormat df = new DecimalFormat("#.###");
		                String tempDformat = df.format(tempD);
		                tempD = new Double(tempDformat);
		                //getting high and low value
	                	int Low = Integer.valueOf(subs[2]);
	                	int High = Integer.valueOf(subs[3]);
	                	if(tempD<Low || tempD>High) {
//	                		resp.getWriter().printf("out of bounds: %f\n", tempD);
	                		valid=false;
	                	}
	                	break;
		        	}
		        	else if(subs[1].compareTo("int")==0) {
		        		int tempI=Integer.valueOf(paramValue);
		        		//getting high and low value
		        		int Low = Integer.valueOf(subs[2]);
	                	int High = Integer.valueOf(subs[3]);
	                	if(tempI<Low || tempI>High) {
//	                		resp.getWriter().printf("out of bounds: %d\n", tempI);
	                		valid=false;
	                	}
	                	break;
		        	}
		        	else {
		        		valid=false;
		        		break;
		        	}
	        	
	        	}
	        	
	        }
	        br.close();
	        in.close();
	        fstream.close();
		}
		catch (Exception e)
        {			
			resp.getWriter().printf("****Exception Thrown...****");
			valid=false;
        }
		return valid;
	}


}
