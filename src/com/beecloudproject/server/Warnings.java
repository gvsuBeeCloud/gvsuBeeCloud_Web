package com.beecloudproject.server;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
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
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Transaction;
import com.techventus.server.voice.Voice;

public class Warnings extends HttpServlet
{
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	{
		try {
			//semi-globals
			ArrayList<String> paramName = new ArrayList<String>();
			ArrayList<Double> thresHi = new ArrayList<Double>();
			ArrayList<Double> thresLow = new ArrayList<Double>();
			int i=0;
			boolean pass=true;

			//read CDM
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
		        	if(Integer.valueOf(subs[4])==1)
		        	{
		        		//set paramName
			        	paramName.add(new String(subs[0]));
			        	//set thresholds
			        	thresLow.add(new Double(subs[5]));
			        	thresHi.add(new Double(subs[6]));
			        	i++;
		        	}
		        }
		        br.close();
		        in.close();
		        fstream.close();
			}
			catch (Exception a)
	        {			
				//debug
//				resp.getWriter().printf("****Warnings.java: CDM Parsing failed...****");
	        }
			//debug
//			resp.getWriter().println("read CDM");
//	    	resp.getWriter().write("<br/>");
//			for(int j=0;j<i;j++) {
//				resp.getWriter().println("||"+paramName.get(j)+":"+thresLow.get(j)+":"+thresHi.get(j));
//				resp.getWriter().write("<br/>");
//			}
			
			//debug
//			String hiveID = "";
//			String weight = "";
//			String intTemp = "";
//			String extTemp = "";
//			String battery = "";
//			String timeStamp = "";
			
			String alertNum = "";
			String txtMessage = "";

			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
//	    	Key hiveKey = KeyFactory.createKey("HiveParent", "hiveParentKey");
	    	
	    	// Run an ancestor query to ensure we see the most up-to-date
	    	// view of the Greetings belonging to the selected Guestbook.
//	    	Query query = new Query("Hive",hiveKey).addSort("hiveID", Query.SortDirection.DESCENDING);
	    	Query query = new Query("Hive").addSort("hiveID", Query.SortDirection.DESCENDING);

	    	List<Entity> records = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(999999999));

		    if(records.isEmpty()){
		    	//do nothing
		    	//debug
//		    	resp.getWriter().println("records.isEmpty()");
//		    	resp.getWriter().write("<br/>");
		    }
		    else{
		    	for(Entity record: records){
		    		alertNum = record.getProperty("alertPhone").toString();
		    		//debug
//		    		resp.getWriter().println(record.getProperty("hiveID").toString());
//		    		resp.getWriter().write("<br/>");
//		    		resp.getWriter().println("------------------------------");
//		    		resp.getWriter().write("<br/>");
		    		//add hidden values
		    		datastore = DatastoreServiceFactory.getDatastoreService();

					Query hivePopUp = new Query("hiveRecord");
					hivePopUp.addFilter("hiveID", Query.FilterOperator.EQUAL, (record.getProperty("hiveID")).toString());
					//Need to find a way to reduce number of records by implementing something that 
					//can call a date
					hivePopUp.addSort("timeStamp", Query.SortDirection.DESCENDING);
					List<Entity> rec = datastore.prepare(hivePopUp).asList(FetchOptions.Builder.withLimit(1));

					if(rec.isEmpty()){
						//debug
//						resp.getWriter().println("rec.isEmpty()");
//				    	resp.getWriter().write("<br/>");
					}
					else{
					    //Get the most recent record from the list
						Entity lastRecord = rec.get(0);
						//check through threshold levels
						for(String param : paramName)
						{
							int index = paramName.indexOf(param);
							Double value = new Double(lastRecord.getProperty(param).toString());
							Double hi = thresHi.get(index);
							Double low = thresLow.get(index);
							
							if(value>hi || value<low) {
								pass=false;
								txtMessage=txtMessage.concat(param+":"+value+" ");
							}
							//debug
//							resp.getWriter().println(param +" = "+value+" ::"+hi+":"+low+":"+pass);
//					    	resp.getWriter().write("<br/>");
						}

				    	//debug
//						//Convert the timeStamp to a more readable date and time
//						String tmpDate = (String)lastRecord.getProperty("timeStamp");
//						tmpDate = (tmpDate.substring(0,2) + "/" + tmpDate.substring(2,4) + "/" + tmpDate.substring(4,8) + " " + 
//								tmpDate.substring(8,10)+":"+tmpDate.substring(10,12) );
//						//Return the requested statistics
//						timeStamp = tmpDate;
						
						//debug
//						hiveID = (lastRecord.getProperty("hiveID")).toString(); 
//						weight = (lastRecord.getProperty("weight")).toString(); 
//						intTemp = (lastRecord.getProperty("intTemp")).toString();
//						extTemp = (lastRecord.getProperty("extTemp")).toString();
//						battery = (lastRecord.getProperty("battery")).toString();
//						resp.getWriter().println(hiveID+" : "+timeStamp+" : "+weight+" : "+intTemp+" : "+extTemp+" : "+battery);
//						resp.getWriter().write("<br/>");
					}
					//debug
//					resp.getWriter().println(txtMessage);
//					resp.getWriter().write("<br/>");
		    	}
		    }

		    if(!pass && (alertNum != ""))
		    {
			    Voice voice = new Voice("gvsuBeeCloud@gmail.com", "cis4672012");
			    voice.sendSMS(alertNum, "BeeCloud Warning!: "+txtMessage);
		    }

		}
		catch(Exception e) {
			//do nothing
		}
		
	}
}