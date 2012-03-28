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
import com.google.appengine.api.datastore.TransactionOptions;
import com.techventus.server.voice.Voice;

public class Listener extends HttpServlet
{
	public void doGet(HttpServletRequest req, HttpServletResponse resp) 
	{		
		
		SMStoText SMSCollection;
		
		ArrayList<String> records = new ArrayList<String>();

			Voice voice;
			try 
			{
				SMSCollection = new SMStoText();
				voice = new Voice("gvsuBeeCloud@gmail.com", "cis4672012");
				SMSCollection.setVoice(voice);
				SMSCollection.createHiveRecord(SMSCollection.getVoice(), SMSCollection.getUnreadRecords());
				records = SMSCollection.getRecords();
				
				for(String record: records)
				{
					//get all parameters
					HashMap reqParams = SMSCollection.getParametersAsHashMap(record, "&", "=");
					
					DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
					Transaction txn = datastore.beginTransaction();
							
					try 
					{
						//create the key to search and build with
						Key hiveRecordKey = KeyFactory.createKey("hiveRecord", (String) reqParams.get("hiveID"));
						Entity hiveRecord;
						
						//if the entity is not found, create it
						hiveRecord = new Entity("hiveRecord", hiveRecordKey);
								
						//set all parameters
						for(Object paramKey: reqParams.keySet())
						{
							   hiveRecord.setProperty((String)paramKey, (String) reqParams.get(paramKey));
						}
							   
						datastore.put(hiveRecord);							   
						txn.commit();
						
					}
					finally 
					{
						if (txn.isActive()) 
						{ 	
							txn.rollback();
						}
					}
				}
			}
			catch (Exception e) 
			{

			}
			

		
		String recordAsString = "http://www.beecloudproject.appspot.com/uploadHive?";	
		for(int i=0; i<records.size();i++)
		{
			recordAsString = recordAsString + records.get(i) +"\t\t";
		}


		try 
		{
			resp.getWriter().print(recordAsString);
		} 
		catch (IOException e) 
		{
			
		}
	}
	
}