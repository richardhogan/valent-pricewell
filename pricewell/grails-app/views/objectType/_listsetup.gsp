
<%@ page import="com.valent.pricewell.ObjectType" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<g:setProvider library="prototype"/>
	<script type="text/javascript">
			jQuery.noConflict();
		</script>
    <style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
			button{
				cursor:pointer;
			}
		</style>
		
    <body>
    	<div id="mainServicePropertiesTypesTab">
    	     <g:render template="../objectType/list" model="['objectTypes': objectTypes, 'title': title, 'type': type, 'changeOrder': changeOrder]"/>
   	    </div> 
    </body>
</html>
