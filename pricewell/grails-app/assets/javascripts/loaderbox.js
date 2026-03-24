jQuery(document).ready(function()
{
	jQuery('#loader-overlay, #loader-box').hide();
	jQuery('#throbber-overlay, #throbber-box').hide();
});

//hide loader.............
function hideLoadingBox(){
	jQuery('#loader-overlay, #loader-box').hide();		
}

//show loader.............
function showLoadingBox() {
		
	// get the screen height and width  
	var maskHeight = jQuery(document).height();  
	var maskWidth = jQuery(window).width();
	
	// calculate the values for center alignment
	var loaderTop =  (maskHeight/2) - (jQuery('#loader-box').height()-50);  
	var loaderLeft = (maskWidth/2) - (jQuery('#loader-box').width()/2); 
	
	// assign values to the overlay and dialog box
	jQuery('#loader-overlay').show();//.css({height:maskHeight, width:maskWidth})
	jQuery('#loader-box').css({top:loaderTop, left:loaderLeft}).show();
	
}

//hide loader.............
function hideThrobberBox(){
	jQuery('#throbber-overlay, #throbber-box').hide();		
}

//show loader.............
function showThrobberBox() {
	// get the screen height and width  
	var maskHeight = jQuery(document).height();  
	var maskWidth = jQuery(window).width();
	
	// calculate the values for center alignment
	var loaderTop =  (maskHeight/2) - (jQuery('#throbber-box').height()-50);  
	var loaderLeft = (maskWidth/2) - (jQuery('#throbber-box').width()/2); 
	
	// assign values to the overlay and dialog box
	// assign values to the overlay and dialog box
	jQuery('#throbber-overlay').show();//.css({height:maskHeight, width:maskWidth})
	jQuery('#throbber-box').css({top:loaderTop, left:loaderLeft}).show();
	
}