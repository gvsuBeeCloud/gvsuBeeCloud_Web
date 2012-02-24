package com.beecloudproject.server;

/*
 * TODO:
 * Validate Data:  
 *  + Check for "Bad Data" - Doesn't match CDM
 *  + Missing Data is okay.  Will upload as <missing field>
 *  + buildHashMapFromParams
 * Store Data:
 *  + Needs to update Hives (not Hive Records)
 * 	+ storeEntity
 * Error Checking:
 * 	+ Failure needs to fail nicely
 *  + All Methods
 */

import java.io.IOException;
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

public class UploadHive extends HttpServlet {
	// array of field names in hive table
	private static final String[] fieldNamesInHiveTable = { "temperature_interior",
			"temperature_exterior", "weight" };
	// array of endings for hive table
	private static final String[] hiveTableSuffix_max = { "_max_six", "_max_twelve" };
	private static final String[] hiveTableSuffix_min = { "_min_six", "_min_twelve" };
	// hashmap of max and min
	HashMap maxAndMin = new HashMap();
	// hashmap of current values
	HashMap currentValues = new HashMap();;
	// hashMap of hive table record
	HashMap hiveTableRecord = new HashMap();
	// hive id
	String hiveID;
	//existing record key
	Key existingRecordKey;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		resp.getWriter().println("Weight: " + req.getParameter("weight"));

		// build hashmap
		HashMap paramHash = buildHashMapFromParams(req);
		// build entity
		Entity entity_toStore = buildEntityFromHashMap("hiveRecord", paramHash);

		// store the entity
		//storeEntity(entity_toStore);

		// query Hive
		queryDataStoreForExistingRecord(hiveID);
		// build max and min stuff
		addToHiveTable(paramHash);

		// build Hive entity
		Entity entity_Hive = buildEntityFromHashMap("Hive", hiveTableRecord);

		// store Hive entity
			storeEntity(entity_Hive);

		resp.getWriter().println("Hive Table Record");
		for (Object o : hiveTableRecord.keySet()) {
			resp.getWriter().println("key "+(String) o+ " Val: "+(String)hiveTableRecord.get(o));
		}

		resp.getWriter().println("End Hive Table Record");

		resp.getWriter().println("Current Values");
		for (Object o : currentValues.keySet()) {
		
			resp.getWriter().println("KEY: "+(String)o + " Val: "+(String) currentValues.get(o));
		}

		resp.getWriter().println("End Current Values");
		
		
		//resp.sendRedirect("/map.jsp");



	}

	/**
	 * Build a hashmap from the parameters sent in the http request
	 * @param req -- the sent httprequest
	 * @return  -- the constructed hashmap
	 */
	public HashMap buildHashMapFromParams(HttpServletRequest req) {
		// declare hive fields
		HashMap paramMap = new HashMap();

		Enumeration parameterNames = req.getParameterNames();
		// for each parameter name
		while (parameterNames.hasMoreElements()) {

			// get the name
			String parameterName = (String) parameterNames.nextElement();
			// if hiveID parameter, set it
			if (parameterName.equals("hiveID")) {
				hiveID = req.getParameter(parameterName);
			}
			// look for its value
			String parameterValue = req.getParameter(parameterName);
			// add to hashmap
			paramMap.put(parameterName, parameterValue);
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
	public boolean queryDataStoreForExistingRecord(String hiveID) {
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
			
		}else{//get the keys that are in the table!
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
	 * Determine if a given value is a max or minimum for a field based on current data.
	 * @param fieldName -- the field to investigate
	 * @param value -- the new value for comparison
	 * @param whatToTestFor -- 0 for max, 1 for min
	 * @return
	 */
	public String[] isMaxOrMin(String fieldName, String value, int whatToTestFor){
		// make string array to return
		String[] fieldsThatShouldBeUpdated = new String[hiveTableRecord.size()];
		// keep track of position in array
		int position = 0;
		// determine suffix array to use
		String [] hiveTableSuffix={};
		
		
		//determine comparison
		switch(whatToTestFor){
			case 0: //test max
				hiveTableSuffix=hiveTableSuffix_max;
				
				break;
			case 1: //test min
				hiveTableSuffix=hiveTableSuffix_min;
				break;
		}
		
		// check each hive table value
				for (String baseHiveTableFieldName : fieldNamesInHiveTable) {

					// make sure we are looking at the right field
					if (baseHiveTableFieldName.equals(fieldName)) {

						// build each field variation
						for (String hiveTableFieldNameSuffix : hiveTableSuffix) {
							String fullHiveTableFieldName = baseHiveTableFieldName
									+ hiveTableFieldNameSuffix;

							// convert to doubles
							double newValue = Double.parseDouble(value);
							// break down existing value
							double existingValue;
							try{
									
									existingValue=Double
									.parseDouble((String) hiveTableRecord
											.get(fullHiveTableFieldName));
							}catch(Exception e){
								existingValue=99999;
								e.printStackTrace();
							}
							
							switch(whatToTestFor){
							case 0: //max
								// check if the new value is lower than the old value
								if(newValue > existingValue){
									// add to string array
									fieldsThatShouldBeUpdated[position] = fullHiveTableFieldName;
									position++;

								}
								break;
							case 1: //min
								// check if the new value is lower than the old value
								if(newValue < existingValue){
									// add to string array
									fieldsThatShouldBeUpdated[position] = fullHiveTableFieldName;
									position++;

								}
								break;
							}

		

						}

					}// else do nothing because we are not looking at that field

				}
		
		return fieldsThatShouldBeUpdated;
		
		
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
	 * 
	 * @param paramHash
	 */
	public void addToHiveTable(HashMap paramHash) {

		// iterate over each property
		Map<String, Object> propertyNames = paramHash;

		// for each property, determine if it is in the hive table
		for (Map.Entry<String, Object> entry : propertyNames.entrySet()) {

			// get name of entry
			String entryName = entry.getKey();
			// if so, check if new high or low
			if (isInHiveTable(entryName)) {

				
				String entryValue = (String) entry.getValue();
				String entryValue_toUseForMax=entryValue;
				String entryValue_toUseForMin=entryValue;
				
				//check if entry value is null
				if(entryValue == null){
					//set to impossible
					entryValue_toUseForMax = "-99999";
					entryValue_toUseForMin ="99999";
				}
				// update current Hive field values
				addToCurrentValues(entryName, (String)""+ entry.getValue());

				// if the hive table record is empty, dont do a comparison
				// so only check if max or min if not empty
				if (!hiveTableRecord.isEmpty()) {

					// get field names of what it is higher than
					String[] maxFieldsToUpdate = isMaxOrMin(entryName, entryValue_toUseForMax,0);

					// get field names of what it is less than
					String[] minFieldsToUpdate = isMaxOrMin(entryName,entryValue_toUseForMin,1);

					// replace values in the original hashmap
					for (String field : maxFieldsToUpdate) {
						if(field != null){
						// update record hashmap
						hiveTableRecord.put(field, entryValue_toUseForMax);
						}

					}
					for (String field : minFieldsToUpdate) {
						if(field!=null){
						// update record hashmap
						hiveTableRecord.put(field, entryValue_toUseForMin);
						}
					}

				} else { // hive table record is empty so just update with the
							// current values
							// update all of the values to the current values
					hiveTableRecord = currentValues;

				}

			}

		}

	}

}
