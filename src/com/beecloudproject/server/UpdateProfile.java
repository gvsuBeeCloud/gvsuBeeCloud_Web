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

public class UpdateProfile extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		
		//resp.getWriter().println("Resp working");
		//get all parameters
		//Map<String, String[]> reqParams = req.getParameterMap();
		String userEmail=req.getParameter("email");
		String firstName=req.getParameter("firstName");
		String lastName=req.getParameter("lastName");
		String username=req.getParameter("username");
		String organization=req.getParameter("organization");
		

		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
				Transaction txn = datastore.beginTransaction();
				try {
				    Key profileKey = KeyFactory.createKey("Users", userEmail);
				    
				    Entity userRecord;
					try {
						userRecord = datastore.get(profileKey);
					} catch (EntityNotFoundException e) {
						// TODO Auto-generated catch block
						userRecord = new Entity(profileKey);
					}
					
					//set all parameters				   
					userRecord.setProperty("email", userEmail);
					userRecord.setProperty("firstName", firstName);
					userRecord.setProperty("lastName", lastName);
					userRecord.setProperty("username", username);
					userRecord.setProperty("organization", organization);

				    datastore.put(userRecord);

				    txn.commit();
				}  finally {
				    if (txn.isActive()) {
				        txn.rollback();
				    }
				}
		
				
				resp.sendRedirect("/administration.jsp");
	}
	
		
}
