package com.beecloudproject.server;

import java.io.IOException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.jdo.PersistenceManager;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class UpdateHive extends HttpServlet {
	
	/**
	 * 
	 */
	//private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		
		//resp.getWriter().println("Resp working");
		//get all parameters
		Map<String,String[]> reqParams = req.getParameterMap();
		
		//String userEmail=req.getParameter("email");

		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
				Transaction txn = datastore.beginTransaction();
				try {
				   Key profileKey = KeyFactory.createKey("Hive", (String) reqParams.get("hiveID")[0]);

				    
				    Entity hiveRecord;
					try {
						hiveRecord = datastore.get(profileKey);
					} catch (EntityNotFoundException e) {
						// TODO Auto-generated catch block
						hiveRecord = new Entity(profileKey);
					}
					
					//set all parameters
					for(Object paramKey: reqParams.keySet()){
				   
						hiveRecord.setProperty((String)paramKey, (String) reqParams.get(paramKey)[0]);

					}
				    datastore.put(hiveRecord);

				    txn.commit();
				}  finally {
				    if (txn.isActive()) {
				        txn.rollback();
				    }
				}
		
				
				resp.sendRedirect("/administration.jsp");
	}
	
		
}
