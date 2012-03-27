$(document).ready(function (){
	$(".div_popup").hide();
	$(".show").show();
	$("td").hover(function(){
		//alert("hover");
		$(".div_popup").hide();
		$(this).children(".div_popup").show();
	});
	
	$("#div_hive").hover(function(){},function(){
		//alert("hover");
		$(".div_popup").hide();
	});
	//setup page
	$("#queryStartDate").datepicker();
	$("#queryEndDate").datepicker();
	

	
});
