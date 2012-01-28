package com.beecloudproject.server;

import java.io.IOException;
import java.util.Date;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gwt.i18n.client.LocalizableResource.Key;
import com.google.storage.onestore.v3.OnestoreEntity.User;
//import com.google.appengine.api.datastore.Key;

public class Guesbook {
	
	public Guesbook(){
		//default constructor
	}
	
	public void storeIt() throws IOException {
    UserService userService = UserServiceFactory.getUserService();
    com.google.appengine.api.users.User user = userService.getCurrentUser();

    // We have one entity group per Guestbook with all Greetings residing
    // in the same entity group as the Guestbook to which they belong.
    // This lets us run an ancestor query to retrieve all Greetings for a
    // given Guestbook. However, the write rate to each Guestbook should be
    // limited to ~1/second.
    String guestbookName ="guestbookName";
    com.google.appengine.api.datastore.Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    String content = "content";
    Date date = new Date();
    Entity greeting = new Entity("Greeting", guestbookKey);
    greeting.setProperty("user", user);
    greeting.setProperty("date", date);
    greeting.setProperty("content", content);

    DatastoreService datastore =
            DatastoreServiceFactory.getDatastoreService();
    datastore.put(greeting);


}

}
