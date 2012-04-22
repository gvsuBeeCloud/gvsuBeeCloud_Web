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
			SMSCollection = new SMStoText();
			Voice voice = new Voice("gvsuBeeCloud@gmail.com", "cis4672012");
			SMSCollection.setVoice(voice);
			SMSCollection.createHiveRecord(SMSCollection.getVoice(), SMSCollection.getUnreadRecords());
			records = SMSCollection.getRecords();
			
			for(int i=0; i<records.size();i++)
			{
				resp.getWriter().println(i + ":  " + records.get(i));
			}
		
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
			String Seconds="";
			int TimeCount=0;

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
				
					hiveRecord = new Entity("hiveRecord", hiveRecordKey);
					
					//set all parameters
					for(Object paramKey: reqParams.keySet())
					{
						boolean id=false;
						boolean paramTime=false;
						String parameter = (String)paramKey;
						if (parameter.equals("hiveID"))
						{
							id=true;
						}

						if( (parameter.equals("year")) || (parameter.equals("month")) || (parameter.equals("day")) ||
							(parameter.equals("timeH")) || (parameter.equals("timeM")) || (parameter.equals("timeS")) ) 
						{
							paramTime=true;
							if(isValidWithCDM((String)paramKey,(String)reqParams.get(paramKey),resp) && TimeGood) 
							{
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
								if(parameter.equals("timeS"))
									Seconds=(String)reqParams.get(paramKey);
							}
							else 
							{
								TimeGood=false;
								resp.getWriter().println("time not good: "+(String)paramKey+ " "+(String)reqParams.get(paramKey));
							}
							if(TimeCount==6 && TimeGood) 
							{
								timeStamp+=Month;
								timeStamp+=Day;
								timeStamp+=Year;
								timeStamp+=Hours;
								timeStamp+=Minutes;
								timeStamp+=Seconds;
								TimeBuilt=true;
							}
						}
						if(id)
							hiveRecord.setProperty((String)paramKey, (String)reqParams.get(paramKey));
						if(!paramTime && !id) 
						{
							if(!isValidWithCDM((String)paramKey, (String)reqParams.get(paramKey), resp)) 
							{
								resp.getWriter().println("!!!" + (String)paramKey+":"+(String)reqParams.get(paramKey)+" is not valid!!!");
							}
							else 
							{
							hiveRecord.setProperty((String)paramKey, (String)reqParams.get(paramKey));
							}
						}
						if(TimeBuilt && TimeGood)
						{
							hiveRecord.setProperty("timeStamp", timeStamp);
							resp.getWriter().println("||"+timeStamp);
						}
					}
				//store record
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
