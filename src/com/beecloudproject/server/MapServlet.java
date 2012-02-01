package com.beecloudproject.server;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class MapServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {
		
		storeIt();
		resp.sendRedirect("/test.jsp");
	
	}
	
	public void storeIt() throws IOException {
	    UserService userService = UserServiceFactory.getUserService();
	    com.google.appengine.api.users.User user = userService.getCurrentUser();

	    // We have one entity group per Guestbook with all Greetings residing
	    // in the same entity group as the Guestbook to which they belong.
	    // This lets us run an ancestor query to retrieve all Greetings for a
	    // given Guestbook. However, the write rate to each Guestbook should be
	    // limited to ~1/second.
	    String givenHiveName ="givenHiveName";
	    com.google.appengine.api.datastore.Key hiveKey = KeyFactory.createKey("HiveParent", givenHiveName);
	    String content = "content";
	    double weight = 95.4;
	    double temperture = 100.12;
	    Entity greeting = new Entity("Hive", hiveKey);
	    greeting.setProperty("user", user);
	    greeting.setProperty("weight", weight);
	    greeting.setProperty("temperture", temperture);

	    DatastoreService datastore =
	            DatastoreServiceFactory.getDatastoreService();
	    datastore.put(greeting);


	}

}
