<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<html>
<body>
//THIS IS A TEST

<a href="map.jsp">This is a link to map.jsp</a>

//lets query the datastore

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key hiveKey = KeyFactory.createKey("HiveParent", "givenHiveName");
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Hive",hiveKey).addSort("user", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
    if (greetings.isEmpty()) {
        %>
        <p>Guestbook "BLAH" has no messages.</p>
        <%
    } else {
        %>
        <p>Messages in Guestbook blah.</p>
        <%
        for (Entity greeting : greetings) {
            if (greeting.getProperty("user") == null) {
                %>
                <p>An anonymous person reported weight:</p>
                <%
            } else {
                %>
                <p><b><%= ((User) greeting.getProperty("user")).getNickname() %></b> reported:</p>
                <%
            }
            %>
            <blockquote><%= greeting.getProperty("weight") %></blockquote>
            <blockquote>Temperature: <%= greeting.getProperty("temperture") %></blockquote>
            
            <%
			
        }
    }
%>

</html>

