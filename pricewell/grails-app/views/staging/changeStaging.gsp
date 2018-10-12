<%@ page import="com.valent.pricewell.StagingLog" %>
<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
<html>
<script>
		 jQuery(document).ready(function()
		 {
			 	jQuery.getScript("${baseurl}/js/jquery.validate.js", function()
			    {

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
							window.location.href = '${baseurl}/service/show?serviceProfileId=' + <%=serviceProfileId%>;
							//window.location.href = '${baseurl}/home';
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
					
		 		jQuery('#btnSaveChange').click(function() 
				{
			 		if(jQuery('#changeStage').validate().form()){
		    	    	   jQuery("#changeStage").submit();
		    	       }
				});
						 	
		 });
		
		 
  </script>
    <body>
         <div class="body">
            <g:form method="post" name="changeStage">
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
                                	<g:textField name="fromStageText" value="${currentStage.displayName}" readOnly="true" class="required"/>
                                	<g:hiddenField name="fromStage" value="${currentStage.id}"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                
                                  <label for="toStage"><g:message code="stagingLog.toStage.label" default="To Stage" /></label>
                     			<em>*</em>
                                </td>
                                <td valign="top">
                                    <g:select name="nextStageId" from="${stagingInstanceList}" optionKey="id" value="${nextStage.id}" class="required"/>
                                </td>
                            </tr>
                         	<g:if test="${nextReviewStage}">   
	                             <tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="assignees"><g:message code="reviewRequest.assignees.label" default="Assignees" /></label>
	                                  <em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: reviewRequestInstance, field: 'assignees', 'errors')}">
	                                    <g:select name="assignees" from="${assigneesList}" multiple="yes" optionKey="id" size="5" class="required"/>
	                                </td>
	                            </tr>
                            </g:if>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="comment"><g:message code="stagingLog.comment.label" default="Comment" /></label>
                                </td>
                                <td valign="top">
                                    <g:textArea name="comment" value="${stagingLogInstance?.comment}" rows="5" cols="40"/>
                                </td>
                            </tr>                        
                          
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                	<span>
						<input id="btnSaveChange" type="button" title="Save Changes" value="Save Changes" class="buttons.button button"/>
					</span>
                    <!-- <span class="button"><g:actionSubmit class="save" action="reviewRequestFromStaging" value="Save changes" /></span>-->
                </div>
            </g:form>
        </div>
    </body>
</html>