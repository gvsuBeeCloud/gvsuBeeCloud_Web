$(document).ready(function() {


	 
	//alert("hello");
	
	
	 //hide
	 $("#div_login").hide();
	 
		$("#nav_login").click(function() {
			//  $("#div_hiveControls").show('slide', {
					// direction: "up"
				//  },1000);

				 if($("#div_login").is(':visible')){
					 $("#div_login").fadeOut();
				 }else{
					 $("#div_login").fadeIn();


					
				 }
				 
				 
			 });

 });