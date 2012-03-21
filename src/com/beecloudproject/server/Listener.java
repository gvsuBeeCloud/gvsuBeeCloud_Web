package com.beecloudproject.server;

import java.io.IOException;
import java.util.ArrayList;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		
		String recordAsString = "http://www.beecloudprojectcam.appspot.com/uploadHive?";	
		recordAsString = recordAsString + records.get(0);
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
		resp.getWriter().print(recordAsString);
	}
	
}