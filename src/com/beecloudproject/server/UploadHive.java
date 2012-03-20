package com.beecloudproject.server;

/*
 * TODO:
 * Validate Data:  
 *  + Check for "Bad Data" - Doesn't match CDM
 *  + Missing Data is okay.  Will upload as <missing field>
 *  + buildHashMapFromParams
 * Store Data:
 *  + Needs to update Hives (not Hive Records)
 *  + storeEntity
 * Error Checking:
 *  + Failure needs to fail nicely
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
    private static final String[] fieldNamesInHiveTable = { "year", "month", "day", "weight", "intTemp",
            "extTemp", "battery" };
    // hashmap of current values
    HashMap currentValues = new HashMap();
    // hashMap of hive table record
    HashMap hiveTableRecord = new HashMap();
    // hive id
    String hiveID;
    //existing record key
    Key existingRecordKey;

    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // build hashmap
        HashMap paramHash = buildHashMapFromParams(req);
        // build entity
        Entity entity_toStore = buildEntityFromHashMap("hiveRecord", paramHash);

        // store the entity
        storeEntity(entity_toStore);

        
        
        resp.sendRedirect("/map.jsp");



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
    public boolean queryDataStoreForExistingRecord(String hID) 
    {
        boolean aRecordReturned;
        // query
        // try querying
        DatastoreService datastore = DatastoreServiceFactory
                .getDatastoreService();
        Key hiveKey = KeyFactory.createKey("Hive", hID);
        // Run an ancestor query to ensure we see the most up-to-date
        Query query = new Query("Hive", hiveKey).addSort("hiveID",
                Query.SortDirection.DESCENDING);
        query.addFilter("hiveID", Query.FilterOperator.EQUAL, hID);

        Entity record = datastore.prepare(query).asSingleEntity();
        //if null, then no record was returned :(
        if(record == null){
            //so, we have to do ...nothing?
            aRecordReturned=false;
            existingRecordKey=null;
            
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
}