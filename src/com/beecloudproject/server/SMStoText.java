package com.beecloudproject.server;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;

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
	  
	  public void createHiveRecord(Voice myVoice, String unreadRecords1) throws IOException
	  {
			ArrayList<String> records = parseForRecords(unreadRecords1);
			
			for(int i = 0; i< records.size(); i++)
			{
				String transmissionID = parseForID(records.get(i));
				ArrayList<String> dataRecords = parseForMessage(records.get(i));
				dataRecords = listOfRecordsFormatted(dataRecords, records);
				
				for(int j = 0; j< dataRecords.size(); j++)
				{
				//	hiveID = "hiveID=" + hiveID + dataRecords.get(j);
					fullRecord.add(dataRecords.get(j));
				}
				
				myVoice.deleteMessage(transmissionID);
			}
	  }
	  
	  public ArrayList<String> parseForRecords(String unreadRecords1)
	  {
		  ArrayList<String> arrayOfRecords = new ArrayList<String>();
		  String lookForMessage = "SMSThread";
		  int someLeft = 0;
		  while((someLeft = unreadRecords1.lastIndexOf(lookForMessage)) != -1)
		  {
			  String rightHalfOfMessage = unreadRecords1.substring(someLeft, unreadRecords1.length());
			  arrayOfRecords.add(rightHalfOfMessage);
			  unreadRecords1 = unreadRecords1.substring(0, someLeft);		  
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
	    int otherSomeLeftAgain = -1;
	    while((someLeft = record.lastIndexOf(lookForMessage)) != -1)
	    {
	    	String rightHalfOfMessage = record.substring(someLeft, record.length());
	    	record = record.substring(0, someLeft);
	    	someLeftAgain = rightHalfOfMessage.indexOf("]");
	    	otherSomeLeftAgain = rightHalfOfMessage.lastIndexOf(" - ");
	    	if(otherSomeLeftAgain < someLeftAgain && otherSomeLeftAgain != -1)
	    	{
	    		someLeftAgain = otherSomeLeftAgain;
	    	}
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
	  
	  public ArrayList<String> listOfRecordsFormatted(ArrayList<String> recordsToBeFormatted, ArrayList<String> toGetHiveID)
	  {
		  String tempRecord = "";
		  ArrayList<String> CDMValues = getValuesFromCDM();
		  
		  String nothing = "";
		  
		  ArrayList<String> records = new ArrayList<String>();
		  
		  for(int i=0; i<recordsToBeFormatted.size(); i++)
		  {
			  tempRecord = recordsToBeFormatted.get(i);
			  tempRecord = " " + tempRecord;
			  tempRecord = tempRecord.replaceAll("<", nothing);
			  tempRecord = tempRecord.replaceAll(">", "#");
			  String[] tempArrayOfRecords = tempRecord.split("#");
			  
			  String hiveID = "hiveID=" + parseForHiveID(toGetHiveID.get(i));
			  String reset = hiveID;
			  
			  for(int k=0; k<tempArrayOfRecords.length; k++)
			  {
				  hiveID = reset;
				  tempRecord = tempArrayOfRecords[k];
				  tempRecord = tempRecord.replaceAll(":", " ");
				  
				  for(int j=0; j<CDMValues.size(); j++)
				  {
					  tempRecord = tempRecord.replaceFirst(" ", "&" + CDMValues.get(j) + "=");
				  }
				  
					hiveID = hiveID + tempRecord;

				  
				//  recordsToBeFormatted.set(i, tempRecord);  
				  records.add(hiveID);
			  }
		  }		  
		return records;
	  }
	  
	  /**
	   * Break down a message (string) to key value pairs
	   * @param message -- the original message in string format
	   * @param paramDelimiter -- the delimiter between parameters
	   * @param valueDelimiter -- the delimiter between keys and values
	   * @return -- the constructed hashMap
	   */
	  public HashMap getParametersAsHashMap(String message,String paramDelimiter, String valueDelimiter){
		  HashMap paramMap = new HashMap();
		  
		  //split on parameters
		  String[] paramTokens = message.split(paramDelimiter);
		  //for each parameter, store it
		  for(String param: paramTokens){
			  //split for key value
			  String[] keyValueTokens = param.split(valueDelimiter);
			  paramMap.put(keyValueTokens[0], keyValueTokens[1]);
		  }
		  
		  
		  return paramMap;
	  }
	  
	    public ArrayList<String> getValuesFromCDM()
	    {
	    	ArrayList<String> CDMValues = new ArrayList<String>();
	    	
	    	FileInputStream fstream;
			try 
			{
				fstream = new FileInputStream("includes/CDM.txt");
				DataInputStream in = new DataInputStream(fstream);
				BufferedReader br = new BufferedReader(new InputStreamReader(in));

	    	String readIn;
	    	int i = 0;
	    	while ((readIn = br.readLine()) != null)
	    	{
	    		String[] valuesOfLine;
	    		valuesOfLine = readIn.split("\t");
	    		CDMValues.add(valuesOfLine[0]);
	    		i++;
	    	}
			
			} 
			catch (FileNotFoundException e) 
			{

			} 
			catch (IOException e) {

			}
	    	
			return CDMValues;

	    }
}
