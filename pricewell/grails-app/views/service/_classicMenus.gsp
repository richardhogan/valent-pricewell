<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>
<%@ page import="com.valent.pricewell.Staging"%>
<%@ page import="com.valent.pricewell.ServiceController"%>
<%@ page import="org.apache.shiro.SecurityUtils"%>
	<script>
		
	</script>
<%
	def baseurl = request.siteUrl
%>	
<g:form>
				<script>
		 			function refreshPage()
		 			{
		 	 			location.reload(true);
		 	 		}

		 			function checkConfirmation()
		 	 		{
		 	 			jConfirm('Are you sure you want to cancel this service?', 'Please Confirm', function(r)
						{
							if(r == true)
							{
								return true;
							}
							else
								return false;
						});
			 	 	}
		 	 		
		 	 		jQuery(document).ready(function()
					{
							jQuery('#btnStagingLog').click(function() 
							{
								jQuery( "#dvStageService" ).dialog( "option", "title", "Staging log for <%=serviceProfileInstance?.service?.serviceName%> ");
								jQuery( "#dvStageService" ).dialog( "open" );
					
								jQuery.ajax({type:'POST',data:{serviceProfileId: <%=serviceProfileInstance?.id%>},
											 url:'${baseurl}/stagingLog/listServiceStagingLog',
											 success:function(data,textStatus){jQuery('#dvStageService').html(data);},
											 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
							}); 
							
							jQuery('#btnChangeStage').click(function() 
							{
								/*jQuery( "#dvStageService" ).dialog( "option", "title", "Service Stage Assignment");
								jQuery( "#dvStageService" ).dialog( "open" );
					
								jQuery.ajax({type:'POST',data:{serviceProfileId: <%=serviceProfileInstance?.id%>, stageId: <%=serviceProfileInstance.stagingStatus.id%>},
											 url:'${baseurl}/staging/changeStaging',
											 success:function(data,textStatus){jQuery('#dvStageService').html(data);},
											 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;*/
											 
								jQuery( "#msgBox" ).dialog( "option", "title", "Message Box");
								jQuery( "#msgBox" ).dialog( "open" );
								jQuery( "#msgBox" ).html("Feature not available in this beta.");
								return false;
							}); 
							
								
							jQuery( "#dvStageService" ).dialog(
		    				{
		    					height: 600,
		    					width: 900,
		    					modal: true,
		    					autoOpen: false,
		    					zIndex: 1999,
		    					position: [200, 50],
		    					
		    				});
		    				
							jQuery( "#msgBox" ).dialog(
		    				{
		    					modal: true,
		    					autoOpen: false,
		    					zIndex: 2999,
		    					resizable: false,
		    					position: [500, 200],
		    					buttons: {
		    						OK: function() {
		    							jQuery( "#msgBox" ).dialog( "close" );
		    							return false;
		    						}
		    					}
		    					
		    				});

							jQuery( "#btnCopy" ).click(function() 
									{
										var serviceName = jPrompt('New Service Name','', 'Copy Service', function(r)
										{
											if(r)
											{
												window.location.href = '${baseurl}/service/createCopyServiceProfile?id=${serviceProfileInstance?.id}&serviceName='+r;
											}
											else{
												return false;
											}
										});
										
										//return true;											
									});
							
		    				jQuery( "#dvMove" ).dialog(
						 	{
								autoOpen: false,
								height: 300,
								minWidth: 500,
								close: function( event, ui ) {
										jQuery(this).html('');
									}
							});
							jQuery( "#btnMove" ).click(function() 
							{
					   			jQuery('#dvMove').html("Loading, Please wait.........");
								jQuery("#dvMove").dialog("open");
								
								jQuery.ajax({type:'POST',data:{serviceProfileId: <%=serviceProfileInstance?.id%>},
											 url:'${baseurl}/service/getOtherPortfolios',
											 success:function(data1,textStatus){jQuery('#dvMove').html(data1);},
											 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
					   			
							});

							jQuery( "#btnExport" ).click(function() 
							{
								showLoadingBox();
					   			jQuery.ajax({type:'POST',data:{serviceProfileId: ${serviceProfileInstance?.id}},
											 url:'${baseurl}/service/serviceExport',
											 success:function(data1,textStatus)
											 {
													if(data1['result'] == "success")
													{
														hideLoadingBox();
														var filePath = data1['filePath'];
														window.location = "${baseurl}/downloadFile/downloadXmlFile?filePath="+filePath;
													}
											 },
											 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
					   			
							});

							jQuery( "#btnCancelService" ).click(function() 
							{
								jConfirm('Are you sure you want to cancel this service?', 'Please Confirm', function(r)
								{
									if(r == true)
									{
										window.location.href = '${baseurl}/service/makeInactive/${serviceProfileInstance?.id}';
										return true;
									}
									else
										return false;
								});
					   			
							});

							jQuery( "#btnShowOldVersion" ).click(function() 
							{
								window.location.href = '${baseurl}/service/show?serviceProfileId=${serviceProfileInstance?.oldProfile?.id}';
								return true;
									
							});

							jQuery( "#btnQuickFix" ).click(function() 
							{
								window.location.href = '${baseurl}/service/serviceQuickFix?serviceProfileId=${serviceProfileInstance?.id}';
								return true;
									
							});

							jQuery( "#btnCreateNew" ).click(function() 
							{
								window.location.href = '${baseurl}/service/createNewVersion/${serviceProfileInstance?.id}';
								return true;
									
							});

							jQuery( "#btnGoToNew" ).click(function() 
							{
								window.location.href = '${baseurl}/service/show?serviceProfileId=${serviceProfileInstance?.newProfile?.id}';
								return true;
									
							});

							jQuery( "#btnEditService" ).click(function() 
							{
								jQuery.ajax({type:'POST',data:{id: ${serviceProfileInstance?.id}},
									 url:'${baseurl}/service/edit',
									 success:function(data1,textStatus){jQuery('#seviceDetails').html(data1);},
									 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
									
							});
							
							jQuery( "#btnEvaluate" ).click(function() 
							{
								window.location.href = '${baseurl}/reviewRequest/show/ServiceProfile.findCurrentReviewRequest(serviceProfileInstance)?.id?source="serviceProfile"';
								return true;
									
							});

							jQuery( "#btnRemove" ).click(function() 
							{
								jConfirm('Service will be removed from system. Are you sure?', 'Remove Service Confirm', function(r)
								{
									if(r == true)
									{
										showLoadingBox();
							   			jQuery.ajax({type:'POST',data:{serviceProfileId: ${serviceProfileInstance?.id}},
											 url:'${baseurl}/service/checkIsDeletable',
											 success:function(data,textStatus)
											 {
												 hideLoadingBox();
													if(data['result'] == "success")
													{
														showLoadingBox();
											   			jQuery.ajax({type:'POST',data:{serviceProfileId: ${serviceProfileInstance?.id}},
															 url:'${baseurl}/service/removeService',
															 success:function(data1,textStatus)
															 {
																 hideLoadingBox();
																 if(data1 == 'success')
														         {		                   		                   		
											                   		jQuery( "#successDialog" ).dialog("open");
															     }
															     else
															     {
												                	jQuery( "#failureDialog" ).dialog("open");
															     }
														 	 },
															 error:function(XMLHttpRequest,textStatus,errorThrown){}});
													}
													else if(data['result'] == "other_profile")
													{
														jAlert('Can not remove this service because the newer version is still in the system. First remove that version and than try to remove this version.', 'Remove Service Alert');
													}
													else if(data['result'] == "in_quotation")
													{
														jAlert('Can not remove this service because it was used in some quotation.', 'Remove Service Alert');
													}
											 },
											 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
									}
									else
										return false;
								});
							});

							jQuery( "#successDialog" ).dialog(
						 	{
								modal: true,
								autoOpen: false,
								resizable: false,
								buttons: {
									OK: function() {
										jQuery( "#successDialog" ).dialog( "close" );
										window.location = "${baseurl}/service/allInEndOfLife";
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
					
					 });
				</script>
				<div id="successDialog" title="Success">
					<p>Service removed successfully from the system.</p>
				</div>
				
				<div id="failureDialog" title="Failure">
					<p>Failed to remove service from the system. Please try again. If you continue to get the same message than contact your service provider.</p>
				</div>

				<div id="dvStageService"></div>
				
				<div id="msgBox"></div>
				
				<div id="dvEvaluateServiceRequest" title="Evaluate ${serviceProfileInstance.stagingStatus.name == 'requestforpublished'? 'Publish' :serviceProfileInstance.stagingStatus?.displayName}"></div>
				
				<div id="dvMove" title="Move to Other Portfolio"></div>
				
				<g:hiddenField name="id" value="${serviceProfileInstance?.id}" />
				<div class="nav">
					<g:if test="${serviceProfileInstance?.newProfile != null && serviceProfileInstance?.oldProfile != null && serviceProfileInstance?.newProfile?.id == serviceProfileInstance?.oldProfile?.id}">
						<span>
							<input id="btnQuickFix" type="button" title="Need Urgent Fix In Service" value="Click Here First" class="buttons.button quickButton" />
						</span>
					</g:if>
					<g:if test="${reviewStage}">
						<span>
							<input id="btnEvaluate" type="button" title="Evaluate Service" value="Evaluate ${serviceProfileInstance.stagingStatus.name == 'requestforpublished'? 'Publish' :serviceProfileInstance.stagingStatus?.displayName}" class="buttons.button button" />
						</span>
					</g:if>
					<g:if test="${updatePermitted}">
						<span>
							<input id="btnEditService" type="button" title="Edit Service" value="Edit" class="buttons.button button" />
						</span>
					</g:if>
					<g:if test="${!reviewStage && stageChangedAllowed && nextStage && nextStageReview}">
						
							<span> <modalbox:createLink
									class="buttons.button button" controller="staging" action="changeStaging"
									title="Service Stage Assignment"
									params="['stageId': serviceProfileInstance.stagingStatus.id, 'serviceProfileId': serviceProfileInstance?.id, 'nextStageDisabled': true]"
									width="700" height="500">
									Request ${nextStage.name == 'requestforpublished'? 'Publish' :nextStage?.displayName}
								</modalbox:createLink> </span>
						
					</g:if> 
					
					<g:if test="${createPermitted && (serviceProfileInstance.type == ServiceProfile.ServiceProfileType.PUBLISHED || serviceProfileInstance.type == ServiceProfile.ServiceProfileType.INACTIVE)}">

						<g:if test="${serviceProfileInstance.newProfile == null && serviceProfileInstance.type == ServiceProfile.ServiceProfileType.PUBLISHED}">
							<span>
								<input id="btnCreateNew" type="button" title="Create New Version" value="New Version" class="buttons.button button" />
							</span>
						</g:if>
						<g:elseif test="${serviceProfileInstance.newProfile != null}">
							<span>
								<input id="btnGoToNew" type="button" title="Go To New Version" value="Go To New Version" class="buttons.button button" />
							</span>
						</g:elseif>

					</g:if>
					<g:if test="${createPermitted}">
						<!--  
						<g:if test="${serviceProfileInstance.stagingStatus.name != 'published'}">
							<span>
								<input id="btnChangeStage" type="button" title="Change Stage Manually" value="Change Stage Manually" class="buttons.button button" class="menuButtonStyle "/>
							</span>
						</g:if>
						-->						
						<span>
							<input id="btnStagingLog" type="button" title="Service Staging Log" value="Staging Log" class="buttons.button button" />
						</span>
							
					</g:if>
					
					<g:if test="${createPermitted && serviceProfileInstance.type != ServiceProfile.ServiceProfileType.INACTIVE}">
						<span>
							<input id="btnCancelService" type="button" title="Cancel Service" value="Cancel Service" class="buttons.button button" />
						</span>
					</g:if>

					<g:if test="${createPermitted && serviceProfileInstance.oldProfile != null}">

						<span>
							<input id="btnShowOldVersion" type="button" title="Show Old Version" value="Show Old Version" class="buttons.button button" />
						</span>

					</g:if>
					
					<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') && serviceProfileInstance.type == ServiceProfile.ServiceProfileType.PUBLISHED}">
				 		<span>
							<input id="btnMove" type="button" title="Move To Other Portfolio" value="Move"  class="buttons.button button" class="menuButtonStyle "/>
						</span>
					</g:if>
					
					<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') && serviceProfileInstance.type == ServiceProfile.ServiceProfileType.PUBLISHED}">
				 		<span>
							<input id="btnExport" type="button" title="Export Service" value="Export"  class="buttons.button button" class="menuButtonStyle "/>
						</span>
					</g:if>
					<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') && serviceProfileInstance.type == ServiceProfile.ServiceProfileType.PUBLISHED}">
				 		<span>
							<input id="btnCopy" type="button" title="Copy Service" value="Copy"  class="buttons.button button" class="menuButtonStyle "/>
						</span>
					</g:if>
					<g:if test="${createPermitted && serviceProfileInstance.type == ServiceProfile.ServiceProfileType.INACTIVE}">
						<span>
							<input id="btnRemove" type="button" title="Remove Service" value="Remove" class="buttons.button button" />
						</span>
					</g:if>	
					
				</div>
			</g:form>