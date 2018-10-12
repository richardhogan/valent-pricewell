package com.valent.pricewell;

class PopupSelectionTagLib {
	def popupSelect = {attrs, body ->
		/** Attributes: 
		 * id: HTML ids will be generated based on provided id prefix.
		 * title: Title of the dialog box.
		 * fields: list map of field name and display name
		 * list: list of objects to display and select from.
		 * width: width of dialog 
		 * height: height of dialog.
		 * returnObject: HTML id where you would like to show value. For example, portfolioManager.id
		 * 
		 * Libraries Required, put these two scripts and css files in page where you use:
		 *  <script src="/pricewell/js/tinytable.js"></script>
		 *	<link rel="stylesheet" href="${resource(dir:'css',file:'tinytable.css')}" />
		 * jQuery library should be included as well.
		 *
		 * Example Usage:
		 * 
		 *  <g:select name="portfolioManager.id" from="${portfolioManagerList}" optionKey="id" value="${portfolioInstance?.portfolioManager?.id}"  />
         *  <% def fields =  ["profile.fullName":"Name", "profile.email": "Email"]; %>
         *  <g:popupSelect id="pm" title="title" list="${portfolioManagerList}" fields="${fields}" returnObject="portfolioManager.id"></g:popupSelect>
		 * 
		 */
		
		out << render(template: "/common/popupSelection", model: [map: attrs]);
		
	}
	
	
}
