 $(document).ready(function() {
   
	 //on load effects
	 $("#div_topLeft").hide();
	 $("#div_bottomLeft").hide();
	 $("#div_bottomRight").hide();
	 $("#div_topRight").hide();


	 $("#div_topLeft").fadeIn(500, function(){
		 $("#div_bottomLeft").fadeIn(500,function(){
			 
			 $("#div_bottomRight").fadeIn(500,function(){
				 $("#div_topRight").fadeIn(500);
			 });
		 });

	 });
	 
	 //redirect handling
	 $("#div_topLeft").click(function(){
		//send to map
		 document.location.href= "http://beecloudproject.appspot.com/map.jsp";
	 });
	 
	 
	 // put all your jQuery goodness in here.
	 $(".div_contents").hide();
	 
	 $(".div_menu").hover(function(){
		
		 
		// $("#div_circle").css("background-color","red");
		 $(this).children(".div_contents").show('blind',{direction : "horizontal"},100);
		// $("#div_circle").addClass("div_circle_active");
		// $("#div_circle").removeClass("div_circle_inactive");
	//	$("#div_bottomCircle").effect('bounce',{times:3},300);
		 
	 },function(){
			$("#div_circle").css("background-color","");
			 $("#div_circle").removeClass("div_circle_active");

			 $(this).children(".div_contents").hide();

			
			 
	 });
	 
	 $("#div_topLeft").hover(function(){
		//set circle background to map image
		 $("#div_circle").css("background-image","url(images/smallMap.png)");
		 
	 },function(){
		 $("#div_circle").css("background-image","url()");
		 $("#div_circle").css("background-color","");
	 });
	 
	 $("#div_topRight").hover(function(){
			//set circle background to 
			// $("#div_circle").css("background-image","url(images/smallMap.png)");
		 	$("#div_circle").css("background-color","blue");
			 
		 },function(){
			 $("#div_circle").css("background-image","url()");
			 $("#div_circle").css("background-color","");
		 });
	 
	 $("#div_bottomLeft").hover(function(){
			//set circle background to gv logo
		 	 $("#div_circle").css("background-color","#ffffff");
			 $("#div_circle").css("background-image","url(images/gv_logo.png)");
			 
		 },function(){
			 $("#div_circle").css("background-image","url()");
			 $("#div_circle").css("background-color","");
		 });
	 $("#div_bottomRight").hover(function(){
			//set circle background to 
			 $("#div_circle").css("background-color","orange");
			 
		 },function(){
			 $("#div_circle").css("background-image","url()");
			 $("#div_circle").css("background-color","");
		 });


	 
	 
	 
	});





 
 
 
 