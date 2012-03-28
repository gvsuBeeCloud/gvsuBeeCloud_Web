package com.beecloudproject.server;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DecimalFormat;
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
		try
		{
			Voice voice = new Voice("gvsuBeeCloud@gmail.com", "cis4672012");
			SMSCollection.setVoice(voice);
			SMSCollection.createHiveRecord(SMSCollection.getVoice(), SMSCollection.getUnreadRecords());
			records = SMSCollection.getRecords();
		}
		catch (NullPointerException npe) 
		{
//			resp.getWriter().println("ERROR: could not log in");
		}
		
//		String recordAsString = "http://www.beecloudproject.appspot.com/uploadHive?";	
//		recordAsString = recordAsString + records.get(0);
		
//		recordAsString = "http://www.beecloudprojectcam.appspot.com/uploadHive?hiveID=6166488274&year=2012&month=02&day=19&timeH=12&timeM=23&weight=200&intTemp=89.3&extTemp=97.2&battery=88";
			
		
		
//		try {
//		    URL myURL = new URL(recordAsString);
//		    URLConnection myURLConnection = myURL.openConnection();
//		    myURLConnection.connect();
//		} 
//		catch (MalformedURLException e) { 
//
//		} 
//		catch (IOException e) {   
//
//		   
//		}
		
		//needed to build timeStamp
		boolean BuildTimeStamp=false;
		boolean TimeBuilt=false;
		boolean TimeGood=true;
		String timeStamp="";
		String Year="";
		String Month="";
		String Day="";
		String Hours="";
		String Minutes="";
		int TimeCount=0;
		/******************************************************
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
				
//				try {
//					//attempt to lock the hive record
//					hiveRecord = datastore.get(hiveRecordKey);
//				} catch (EntityNotFoundException e) {			
//					//if the entity is not found, create it
					hiveRecord = new Entity(hiveRecordKey);
//				}
					
				//set all parameters
				for(Object paramKey: reqParams.keySet()){
					boolean id=false;
					boolean paramTime=false;
					String parameter = (String)paramKey;
					if (parameter.equals("hiveID")) 
						id=true;
					//print data
//					resp.getWriter().println((String)paramKey+" "+(String)reqParams.get(paramKey));
					//if checks against CDM, set prop
						//if "time" unit, save and wait until they are all there,
						//	then build timeStamp
					if( (parameter.equals("year")) || (parameter.equals("month")) || (parameter.equals("day")) ||
							(parameter.equals("timeH")) || (parameter.equals("timeM")) ) 
					{
						paramTime=true;
						if(isValidWithCDM((String)paramKey,(String)reqParams.get(paramKey),resp) && TimeGood) {
							TimeCount++;
							if(parameter.equals("year"))
								Year=(String)reqParams.get(paramKey);
							if(parameter.equals("month"))
								Month=(String)reqParams.get(paramKey);
							if(parameter.equals("day"))
								Day=(String)reqParams.get(paramKey);
							if(parameter.equals("timeH"))
								Hours=(String)reqParams.get(paramKey);
							if(parameter.equals("timeM"))
								Minutes=(String)reqParams.get(paramKey);
						}
						else {
							TimeGood=false;
							resp.getWriter().println("time not good: "+(String)paramKey+ " "+(String)reqParams.get(paramKey));
						}
						if(TimeCount==5 && TimeGood) {
							timeStamp+=Month;
							timeStamp+=Day;
							timeStamp+=Year;
							timeStamp+=Hours;
							timeStamp+=Minutes;
							TimeBuilt=true;
						}
					}
					if(id)
						hiveRecord.setProperty((String)paramKey, (String)reqParams.get(paramKey));
					if(!paramTime && !id) {
						if(!isValidWithCDM((String)paramKey, (String)reqParams.get(paramKey), resp)) {
							resp.getWriter().println("!!!" + (String)paramKey+":"+(String)reqParams.get(paramKey)+" is not valid!!!");
						}
						else {
							hiveRecord.setProperty((String)paramKey, (String)reqParams.get(paramKey));
						}
					}
					if(TimeBuilt && TimeGood){
						hiveRecord.setProperty("timeStamp", timeStamp);
					}
				}
				//store record
				datastore.put(hiveRecord);
				txn.commit();
				
			}  finally {
			    if (txn.isActive()) {
			    	txn.rollback();
			    }
			}
		
			/***************************************************
			 * End storage
			 *****************************************************/
		}
//		resp.getWriter().print(recordAsString);
	}
	
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
		        		DecimalFormat df = new DecimalFormat("#.#");
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
