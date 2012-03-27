package com.beecloudproject.server;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Transaction;
import com.techventus.server.voice.Voice;

public class Listener extends HttpServlet
{
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
		
		}
		
		String recordAsString = "http://www.beecloudproject.appspot.com/uploadHive?";	
		recordAsString = recordAsString + records.get(0);
		/*
		//	recordAsString = "http://www.beecloudprojectcam.appspot.com/uploadHive?hiveID=6166488274&year=2012&month=02&day=19&timeH=12&timeM=23&weight=200&intTemp=89.3&extTemp=97.2&battery=88";
			
		
		
		try {
		    URL myURL = new URL(recordAsString);
		    URLConnection myURLConnection = myURL.openConnection();
		    myURLConnection.connect();
		} 
		catch (MalformedURLException e) { 

		} 
		catch (IOException e) {   

		   
		}
		*/
		
		/* *****************************************************
		 *  Store to the data store
		 *******************************************************/
		for(String record: records){
		//get all parameters
				HashMap reqParams = SMSCollection.getParametersAsHashMap(record, "&", "=");
				
				
				
				//String userEmail=req.getParameter("email");

				DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
						Transaction txn = datastore.beginTransaction();
						try {
							//create the key to search and build with
						   Key hiveRecordKey = KeyFactory.createKey("hiveRecord", (String) reqParams.get("hiveID"));
						    Entity hiveRecord;
							
						    //try {
								//attempt to lock the hive record
								//hiveRecord = datastore.get(hiveRecordKey);
							//} catch (EntityNotFoundException e) {
								
								//if the entity is not found, create it
								hiveRecord = new Entity(hiveRecordKey);
						//	}
							
							//set all parameters
							for(Object paramKey: reqParams.keySet()){
						   
								hiveRecord.setProperty((String)paramKey, (String) reqParams.get(paramKey));

							}
						    datastore.put(hiveRecord);

						    txn.commit();
						}  finally {
						    if (txn.isActive()) {
						        txn.rollback();
						    }
						}
		
			/* **************************************************
			 * End storage
			 *****************************************************/
		
		
		
		
		
		
		}
		resp.getWriter().print("This: "+recordAsString);
	}
	
}