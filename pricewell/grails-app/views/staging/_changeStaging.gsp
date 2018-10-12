<%@ page import="com.valent.pricewell.StagingLog" %>
<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
<script>
		 jQuery(document).ready(function(){
			 	jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {

			 		jQuery("#changeStage").validate();		 		
			 	});
			 	
			 	jQuery( "#successDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#successDialog" ).dialog( "close" );
							window.location.href = '${baseurl}/service/showAfterStageChange?serviceProfileId=' + 
									<%=serviceProfileId%> + '&nextStageId=' + jQuery('#nextStageId').val();
							
							return false;
						}
					}
				});
				
				jQuery( "#failureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#failureDialog" ).dialog( "close" );
							return false;
						}
					}
				});
			
		 		jQuery("#changeStage").submit(function() 
		 		{
					 
					 jQuery.post( '${baseurl}/staging/reviewRequestFromStaging', jQuery("#changeStage").serialize(),
						      function( data ) 
						   	  {
						          if(data == 'success')
						          {		                   		                   		
				                   		jQuery( "#successDialog" ).dialog("open");
							      }
							      else
							      {
				                  		jQuery( "#failureDialog" ).dialog("open");
							      }
						          return false;
						      });
					 
					
					 return false;
				});
					
			 });
		
		 
  </script>
  <style>
		p {
			font-size: 100%;
			margin: 0 0 0em;
		}
  </style>
    <body>
         <div class="body">
            <div id="successDialog" title="Success">
				<p><g:message code="reviewRequest.create.message.success.dialog" default=""/></p>
			</div>
	
			<div id="failureDialog" title="Failure">
				<p><g:message code="reviewRequest.create.message.failure.dialog" default=""/></p>
			</div>
            <g:form method="post" name="changeStage" controller="staging" action="reviewRequestFromStaging">
                <g:hiddenField name="id" value="${stagingLogInstance?.id}" />
                <g:hiddenField name="version" value="${stagingLogInstance?.version}" />
                <g:hiddenField name="serviceProfileId" value="${serviceProfileId}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                  <label for="fromStage"><g:message code="stagingLog.fromStage.label" default="From Stage" /></label>
                                  <em>*</em>
                                </td>
                                
                                <td>
                                	<g:textField name="fromStageText" value="${currentStage.displayName}" readOnly="true" class="required" style="width:250px"/>
                                	<g:hiddenField name="fromStage" value="${currentStage.id}"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                
                                  <label for="toStage"><g:message code="stagingLog.toStage.label" default="To Stage" /></label>
                     			<em>*</em>
                                </td>
                                <td valign="top">
                                    <g:select name="nextStageId" from="${stagingInstanceList}" optionKey="id" value="${nextStage.id}" class="required" style="width:250px"/>
                                </td>
                            </tr>
                         	<g:if test="${nextReviewStage}">   
	                             <tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="assignees"><g:message code="reviewRequest.assignees.label" default="Assignees" /></label>
	                                  <em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'assignees', 'errors')}">
	                                    <g:select name="assignees" from="${assigneesList?.sort {it.profile.fullName}}" multiple="yes" optionKey="id" size="5" class="required" style="width:250px"/>
	                                </td>
	                            </tr>
                            </g:if>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comment"><g:message code="stagingLog.comment.label" default="Comment" /></label>
                                </td>
                                <td valign="top">
                                    <g:textArea name="comment" value="${stagingLogInstance?.comment}" rows="5" cols="125"/>
                                </td>
                            </tr>                        
                          
                        </tbody>
                    </table>
                </div>
                <!--
                <div class="buttons">
                    <span class="button"><g:submitButton name="sendRequest" controller="staging" class="save" action="reviewRequestFromStaging" value="Send Request" /></span>
                </div>
                -->
            </g:form>
        </div>
    </body>
