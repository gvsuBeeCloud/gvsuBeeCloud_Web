package com.beecloudproject.server;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

import com.techventus.server.voice.Voice;
import com.techventus.server.voice.datatypes.records.SMSThread;

public class SMStoText{
	
	  Voice voice = new Voice("gvsuBeeCloud@gmail.com", "cis4672012");
	  String unreadRecords;
	  String debugLog = "";
	  ArrayList<String> fullRecord = new ArrayList<String>();
	  
	  public SMStoText() throws IOException
	  {			
		  	voice.login();
		  		try
		  		{
		  			Collection<SMSThread> myUnreadRecords = voice.getSMSThreads();
		  		  	unreadRecords = myUnreadRecords.toString();
		  		}
		  		catch (NullPointerException npe) 
		  		{

		  		}
	  }
	  
	  public String debugLog()
	  {
		  return debugLog;
	  }
	  
	  public void setVoice(Voice myVoice)
	  {
		  voice = myVoice;
	  }
	  
	  public Voice getVoice()
	  {
		  return voice;
	  }
	  
	  public String getUnreadRecords()
	  {
		  return unreadRecords;
	  }
	  
	  public ArrayList<String> getRecords()
	  {
		  return fullRecord;
	  }
	  
	  public void createHiveRecord(Voice myVoice, String unreadRecords) throws IOException
	  {
			ArrayList<String> records = parseForRecords(unreadRecords);
			
			for(int i = 0; i< records.size(); i++)
			{
				String transmissionID = parseForID(records.get(i));
				String hiveID = parseForHiveID(records.get(i));
				ArrayList<String> dataRecords = parseForMessage(records.get(i));
				dataRecords = listOfRecordsFormatted(dataRecords);
				
				for(int j = 0; j< dataRecords.size(); j++)
				{
					hiveID = "hiveID=" + hiveID  + "&year=" + dataRecords.get(j);
					fullRecord.add(hiveID);
				}
								myVoice.deleteMessage(transmissionID);
			}
	  }
	  
	  public ArrayList<String> parseForRecords(String unreadRecords)
	  {
		  ArrayList<String> arrayOfRecords = new ArrayList<String>();
		  String lookForMessage = "SMSThread";
		  int someLeft = 0;
		  while((someLeft = unreadRecords.lastIndexOf(lookForMessage)) != -1)
		  {
			  String rightHalfOfMessage = unreadRecords.substring(someLeft, unreadRecords.length());
			  arrayOfRecords.add(rightHalfOfMessage);
			  unreadRecords = unreadRecords.substring(0, someLeft);		  
		  }
		  return arrayOfRecords;
	  }
	  
	  public String parseForID(String record)
	  {
		String lookForMessage = "[id=";
		int someLeft = 0;
	    someLeft = record.lastIndexOf(lookForMessage);    
    	String rightHalfOfMessage = record.substring(someLeft, record.length());
    	record = record.substring(0, someLeft);
    	int tempInt2 = rightHalfOfMessage.indexOf(", ");
    	String id = rightHalfOfMessage.substring(lookForMessage.length(), tempInt2);
	    
	    return id;
	   }
	  
	  public ArrayList<String> parseForMessage(String record)
	  {
	    ArrayList<String> arrayOfMessages = new ArrayList<String>();
	    String lookForMessage = "text=";
	    int someLeft = 0;
	    int someLeftAgain = -1;
	    while((someLeft = record.lastIndexOf(lookForMessage)) != -1)
	    {
	    	String rightHalfOfMessage = record.substring(someLeft, record.length());
	    	record = record.substring(0, someLeft);
	    	someLeftAgain = rightHalfOfMessage.lastIndexOf(" - ");
	    	if(someLeftAgain != -1)
	    	{
	    	String message = rightHalfOfMessage.substring(lookForMessage.length(), someLeftAgain);
	    	arrayOfMessages.add(message);
	    	someLeftAgain = -1;
	    	}
	    }
	    
	    return arrayOfMessages;
	  }
	  
	  public String parseForHiveID(String record)
	  {
		  String messageString = "number=+";
		  int someLeft = 0;
		  someLeft = record.lastIndexOf(messageString);
		  String rightHalfOfMessage = record.substring(someLeft, record.length());
		  record = record.substring(0, someLeft);
		  int someLeftAgain = rightHalfOfMessage.indexOf(";");
		  String hiveID = rightHalfOfMessage.substring(messageString.length(), someLeftAgain);
	    
	    return hiveID;
	  }
	
	  public ArrayList<String> listOfRecordsFormatted(ArrayList<String> recordsToBeFormatted)
	  {
		  String tempRecord = "";
		  for(int i=0; i<recordsToBeFormatted.size();i++)
		  {
			  tempRecord = recordsToBeFormatted.get(i);
			  tempRecord = tempRecord.replaceAll(":", " ");
			  tempRecord = tempRecord.replaceFirst(" ", "&month=");
			  tempRecord = tempRecord.replaceFirst(" ", "&day=");
			  tempRecord = tempRecord.replaceFirst(" ", "&timeH=");
			  tempRecord = tempRecord.replaceFirst(" ", "&timeM=");		  
			  tempRecord = tempRecord.replaceFirst(" ", "&weight=");
			  tempRecord = tempRecord.replaceFirst(" ", "&intTemp=");
			  tempRecord = tempRecord.replaceFirst(" ", "&extTemp=");
			  tempRecord = tempRecord.replaceFirst(" ", "&battery=");

			  recordsToBeFormatted.set(i, tempRecord);
		  }
		return recordsToBeFormatted;
	  }
}