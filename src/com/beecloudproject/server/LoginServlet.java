package com.beecloudproject.server;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class LoginServlet extends HttpServlet {
   
	private HttpServletResponse resp;
	public void doGet(HttpServletRequest req, HttpServletResponse respo)
            throws IOException {
        resp = respo;
		
		UserService userService = UserServiceFactory.getUserService();

        String thisURL = req.getRequestURI();

        resp.setContentType("text/html");
        println("<html><head>");
        
        writeLinks();
        println("</head>");
        
        if (req.getUserPrincipal() == null) {
        
        	//show all options available to the user
        	println("<ul>"+
        	"<li class='nav_main'>Other</li>"+
        	"<li class='nav_main' id='nav_login'>Log In</li>"+

        	"</ul>"+

        	"<div id='div_login'>"+
        	"<br />"+
        	"Username"+
        	"<input type='text' />"+
        	"Password"+
        	"<input type='password'/>"+

        	"<br />"+
        	"<br />"+
        	"<a href='register.jsp'>Register</a>"+
        	"</div>");
        	
     
        	
        	
        	/*
            resp.getWriter().println("<p>Hello, " +
                                     req.getUserPrincipal().getName() +
                                     "!  You can <a href=\"" +
                                     userService.createLogoutURL(thisURL) +
                                     "\">sign out</a>.</p>");
                                     
                                     */
        } else {
            resp.getWriter().println("<p>Please <a href=\"" +
                                     userService.createLoginURL(thisURL) +
                                     "\">sign in</a>.</p>");
        }
        
       	println("</html");
    }
    
	public void writeLinks(){
		println("<link rel='stylesheet' href='css/style.css' type='text/css'></link>");
		
		println("    <script type='text/javascript' src='js/jquery-1.7.1.js'></script>");
    println("<script type='text/javascript' src='js/jquery-ui-1.8.17.custom.min.js'></script>");
  // println("<script type='text/javascript' src='js/functions.js'></script>");
    
    
    println("<script type='text/javascript' src='js/login_functions.js'></script>");
	}
    
    public void println(String whatToPrint){
    	try {
			resp.getWriter().println(whatToPrint);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
