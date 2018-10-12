<%@ page import="com.valent.pricewell.Quotation" %>

<%
	int onCount = stage.sequenceOrder;
	int c = 1;
	String type = type;
	String myId = id + "-" + type + "-link"; 
%>


<g:link id="${myId}" href="javascript:void(0);" onclick="return false;">
	<g:if test="${stage.sequenceOrder < 0}">
		<img src="${resource(dir:'images',file:'star-delete.png')}" border="0" />
	</g:if>
	<g:else>
		<g:while test="${c < 6}">
	    	<g:if test="${c <= onCount}">
	    		<img src="${resource(dir:'images',file:'star-on.png')}" border="0" />
	    	</g:if>
	    	<g:else>
	    		<img src="${resource(dir:'images',file:'star-off.png')}" border="0" />
	    	</g:else>
	    	<%c++%>
		</g:while>
	</g:else>
</g:link>    
