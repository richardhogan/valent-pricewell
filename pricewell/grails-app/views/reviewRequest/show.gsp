
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceProfile" %>
<%@ page import="com.valent.pricewell.*" %>

<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>

<script>

	jQuery(document).ready(function()
	{
		jQuery( "#submitToEdit" ).click(function() 
		{
			showLoadingBox();
			jQuery.post( '${baseurl}/reviewRequest/edit', 
	    		jQuery("#reviewRequestEdit").serialize(),
		      	function( data ) 
		      	{
					hideLoadingBox();
	  				jQuery("#mainReviewBoardTab").html(data);
		          	return false;
		          
		      	});
           		
       		return false;
		});
	});
	
	function createReviewRequest()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/reviewRequest/create",
			data: {'category': '${category}', 'type': '${type}'},
			success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
	
	function reviewRequestList(type)
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/reviewRequest/list",
			data: {'category': '${category}', 'type': '${type}'},
			success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>
<g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />       
   
        <div class="nav">
            <g:if test="${source != null}">
            	 <span class="menuButton"><g:link class="menuButton" action="show" controller="service" params="[serviceProfileId: reviewRequestInstance?.serviceProfile?.id]"> 
            	 	<g:if test="${source == 'serviceProfile'}">
            	 		< Back To Service
        	 		</g:if>
        	 		<g:elseif test="${source == 'inbox'}">
        	 			Go To Service >
        	 		</g:elseif>
        	 	</g:link></span>
            </g:if>
            <g:else>
	            <span>
	            	<!--<g:remoteLink class="buttons.button button" controller="reviewRequest" action="create" params="['category': category, 'type': type]" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']"><g:message code="default.new.label" args="[entityName]" /></g:remoteLink>-->
	            	
	            	<a id="idCreateReviewRequest" onclick="createReviewRequest();" class="buttons.button button" title="Create Review Request"><g:message code="default.new.label" args="[entityName]" /></a>
	            </span>
	        </g:else>
	        <g:if test="${listBtn =='yes'}">
	         	<span>
	         		<!--<g:remoteLink class="buttons.button button" controller="reviewRequest" action="list" params="['category': category, 'type': type]" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']"><g:message code="default.list.label" args="[entityName]" /></g:remoteLink>-->
	         		
	         		<a id="idReviewRequestList" onclick="reviewRequestList();" class="buttons.button button" title="List Of Review Request"><g:message code="default.list.label" args="[entityName]" /></a>
	         	</span>
	        </g:if> 
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
                <g:form name="reviewRequestEdit">
                	<g:hiddenField name="id" value="${reviewRequestInstance?.id}" />
                	<g:hiddenField name="category" value="${category}" />
                	<g:hiddenField name="type" value="${type}" />
                	<table>
                		<tr>
                			<td>
                				<span class="button">
                				
                					<button id="submitToEdit">Edit</button>
                					
								</span>
							</td>
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
				    						
					  <g:render template="/reviewComment/listComments" model="['reviewRequestInstance' : reviewRequestInstance, 'commentAllowed': commentAllowed, 'statusChangeAllowed': statusChangeAllowed, 'source': source]"></g:render>	
									
						</td>		
					</tr>
					
				</table>				
    	</div>
			
      </div> 
    