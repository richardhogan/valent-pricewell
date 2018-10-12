
<%@ page import="com.valent.pricewell.ServiceProfileMetaphors.MetaphorsType" %>

<%
	def baseurl = request.siteUrl
%>
<script>
	
</script>
<div id="mainServiceProfileMetaphorsTab-${metaphorType}">

	<g:if test="${metaphorsList && metaphorsList.size() > 0}">
		<g:render template="/serviceProfileMetaphors/listMetaphors" model="['serviceProfileInstance': serviceProfileInstance, 'metaphorsList': metaphorsList, 'metaphorType': metaphorType, 'entityName': entityName]"/>
	</g:if>
	<g:else>
		<g:render template="/serviceProfileMetaphors/createMetaphors" model="['serviceProfileId': serviceProfileInstance.id, 'metaphorsList': metaphorsList,'metaphorType': metaphorType, 'entityName': entityName]"/>
	</g:else>
	

</div>