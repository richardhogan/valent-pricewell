
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceProfile" %>
<%@ page import="com.valent.pricewell.*" %>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="layout" content="main" />
		<g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
		<g:javascript library="prototype" />
    </head>
    
    <body>    
   
        <div class="nav">
            <g:if test="${source != null}">
            	 <span class="menuButton">
            	 	<g:link class="list" action="show" controller="service" params="['serviceProfileId': reviewRequestInstance?.serviceProfile?.id]">
            	 		<g:if test="${source == 'serviceProfile'}">
            	 			< Back To Service
        	 			</g:if>
        	 			<g:elseif test="${source == 'home'}">
        	 				Go To Service
        	 			</g:elseif>
    	 			</g:link>
	 			</span>
            </g:if>
            <g:else>
	            <span class="menuButton"><g:remoteLink class="create" controller="reviewRequest" action="create" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']"><g:message code="default.new.label" args="[entityName]" /></g:remoteLink></span>
	         </g:else>
	         
        </div>
        <div class="body">
            <h1>Request of ${reviewRequestInstance?.serviceProfile} </h1>
            <g:if test="${flash.message}">
            	<!--div class="message">${flash.message}</div-->
            </g:if>
            <div class="dialog">
               <g:render template="show-info" model="['reviewRequestInstance': reviewRequestInstance]"/>
            </div>
            <div class="buttons">
            <g:if test="${submitterLoggedIn}">
                <g:form>
                	<g:hiddenField name="id" value="${reviewRequestInstance?.id}" />
                	<table>
                		<tr>
                			<td><span class="button"><g:submitToRemote
									controller="reviewRequest" action="edit"
									params="[id: reviewRequestInstance?.id]"
									update="mainReviewBoardTab" value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span></td>
                			<td><span class="button"><g:submitToRemote
									controller="reviewRequest" action="delete"
									params="[id: reviewRequestInstance?.id]"
									update="mainReviewBoardTab" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span></td>
                		</tr>
                	</table>
               </g:form>
                   <br>
             </g:if>
             </div>
			 
			<div id="mainComment">				
				<table> 
					<g:hiddenField name="reviewRequestId" value="${reviewRequestInstance?.id}"/>
					
				    <tr>
				    <td>
				    						
					  <g:render template="/reviewComment/listComments" model='["reviewRequestInstance" : reviewRequestInstance, "commentAllowed": commentAllowed, "statusChangeAllowed": statusChangeAllowed, "source": source]'></g:render>	
									
						</td>		
					</tr>
					
				</table>				
    		</div>
			
      	</div> 
  	</body>
</html>
    