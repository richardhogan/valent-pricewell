<%@ page import="com.valent.pricewell.ReviewComment" %>
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<%
	def baseurl = request.siteUrl
%>		
	<script>
		
		jQuery(document).ready(function()
		{
			jQuery( "#rewiewCommentCreate" ).dialog(
			{
				autoOpen: false,
				height: 300,
				width: 900,
				modal: true,
				buttons: 
				{
					"Update": function() 
					{
						var reviewRequestId = jQuery( "#reviewRequestId" ).val(),	comment = jQuery( "#comment" ).val();
						var status = jQuery("#status").val();
						if(comment.length == 0)
						{
							alert("Comment should not be blank.");
						}
						else
						{
							showLoadingBox();
							jQuery.post( '${baseurl}/reviewComment/save?comment='+comment, 
		        				  jQuery("#approveForm").serialize(),
							      function( data ) 
							      {
									  hideLoadingBox();
							          if(data == 'success')
							          {		               
							          		jQuery( "#rewiewCommentCreate" ).dialog( "close" ); 

							          		if("conceptreview" == '${reviewRequestInstance?.serviceProfile?.stagingStatus?.name}' && status == "APPROVED")
								          	{
							          			jQuery( "#confirmationDialog" ).dialog("open");
									        }
							          		else
								          	{
									          	window.location.href = '${baseurl}/service/showAfterStageChange?serviceProfileId=${reviewRequestInstance?.serviceProfile?.id}' + 
																		 '&nextStageId=${reviewRequestInstance?.toStage?.id}';
								          	}
								      }
								      else
								      {
								      		jQuery( "#rewiewCommentCreate" ).dialog("close");
								      }
							      });
										      
							//jQuery( "#rewiewCommentCreate" ).dialog( "close" );
						}
						return false;
					}
				}
			});

			jQuery( "#confirmationDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery( "#confirmationDialog" ).dialog( "close" );
						
						window.location.href = '${baseurl}/service/showAfterStageChange?serviceProfileId=${reviewRequestInstance?.serviceProfile?.id}' + 
						 							'&nextStageId=${reviewRequestInstance?.toStage?.id}';
						return false;
					}
				}
			});
		});
	</script>

        <div>
	        <div id="confirmationDialog" title="Success">
				<p><g:message code="serviceConceptApproved.message.success.dialog" args="${[reviewRequestInstance?.serviceProfile?.service?.serviceName]}" default=""/></p>
			</div>
			
	           	<g:form controller="reviewComment" action="save" name="approveForm"> 
	           		<g:hiddenField name="source" value="${source}"/>
		           	<g:hiddenField name="reviewRequestId" value="${reviewRequestInstance?.id}"/>
		           	<g:hiddenField name="status" value="${ReviewRequest.Status.APPROVED}"/>
	           		
	           		<div id="rewiewCommentCreate" name="rewiewCommentCreate" title="Add Comment">
		            	<g:hiddenField name="reviewRequestId" value="${reviewRequestInstance.id}"/>
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="comment"><g:message code="reviewComment.comment.label" default="Comment" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top">
		                                    <g:textArea class="placeholder" style="resize: none; height: 88px;width:725px; overflow-x: hidden; overflow-y: hidden; " name="comment" value="" class="required"/>
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                    <div>This comment will be forwarded to <b>${reviewRequestInstance?.submitter}</b>.</div>
		                </div>
		             </div>
				</g:form>	           
        </div>
        
        <br/>
        <div class="body">
            
            <div>
                <table>
                    <thead>
                                               
                    </thead>
                    <tbody>
                    <g:each in="${reviewRequestInstance?.listReviewComments()}" status="i" var="reviewCommentInstance" >
                         
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" style="border-bottom-style:dotted;">
                        
                            <td class="bottom">
                            	<p style="width:725px; font-size: 100%;">${fieldValue(bean:reviewCommentInstance, field: "comment")}</p>
                            	<g:if test="${reviewCommentInstance?.statusChanged?.size()>0}">
                            		<p> <b> ${reviewCommentInstance?.statusChanged} </b> </p>
                            	</g:if>
                            </td>                     
                             
                            <td class="bottom">Submitted By:<br>
                            <br>
                           
                            ${fieldValue(bean: reviewCommentInstance, field:"submitter")}
                            <br>
                            <g:formatDate format="MMMMM d, yyyy" date="${reviewCommentInstance.dateCreated}" />
                            </td>                                                                                                  
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>             
        </div>
   
