
<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
<html>
<g:setProvider library="prototype"/>
    <style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
			button{
				cursor:pointer;
			}
		</style>
		<script>
		
			var ajaxList = new AjaxPricewellList("Staging", "Staging", "${baseurl}", "setup", 600, 500, true, true, true, true);
			
			jQuery(document).ready(function()
			{
				ajaxList.init();
			});
		</script>
    <body>
    	<div id="mainWorkflowSettingTab">
    	     <g:render template="../staging/list2" model="['stagingInstanceList': stagingInstanceList, 'title': title]"/>
   	    </div> 
    </body>
</html>
