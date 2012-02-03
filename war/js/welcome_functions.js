 $(document).ready(function() {
   // put all your jQuery goodness in here.
	 $(".div_contents").hide();
	 
	 $(".div_menu").hover(function(){
		
		 
		// $("#div_circle").css("background-color","red");
		 $(this).children(".div_contents").show('blind',{},300);
		// $("#div_circle").addClass("div_circle_active");
		// $("#div_circle").removeClass("div_circle_inactive");
	//	$("#div_bottomCircle").effect('bounce',{times:3},300);
		 
	 },function(){
			$("#div_circle").css("background-color","#dddddd");
			 $("#div_circle").removeClass("div_circle_active");

			 $(this).children(".div_contents").hide();

			
			 
	 });
	 
	 $("#div_topLeft").hover(function(){
		//set circle background to map image
		 $("#div_circle").css("background-image","url(images/smallMap.png)");
		 
	 },function(){
		 $("#div_circle").css("background-image","url()");
		 $("#div_circle").css("background-color","#dddddd");
	 });
	 
	 $("#div_topRight").hover(function(){
			//set circle background to 
			// $("#div_circle").css("background-image","url(images/smallMap.png)");
		 	$("#div_circle").css("background-color","blue");
			 
		 },function(){
			 $("#div_circle").css("background-image","url()");
			 $("#div_circle").css("background-color","#dddddd");
		 });
	 
	 $("#div_bottomLeft").hover(function(){
			//set circle background to
			 $("#div_circle").css("background-color","green");
			 
		 },function(){
			 $("#div_circle").css("background-image","url()");
			 $("#div_circle").css("background-color","#dddddd");
		 });
	 $("#div_bottomRight").hover(function(){
			//set circle background to 
			 $("#div_circle").css("background-color","orange");
			 
		 },function(){
			 $("#div_circle").css("background-image","url()");
			 $("#div_circle").css("background-color","#dddddd");
		 });


	 
	 
	 
	});





 
 
 
 