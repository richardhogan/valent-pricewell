<%@ page import="grails.plugins.nimble.core.*" %>
<%@ page import="grails.plugins.nimble.core.UserBase" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ServiceStageFlow" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
        <title>${title}</title>
        <style type="text/css" title="currentStyle">
			@import "${baseurl}/js/dataTables/css/demo_page.css";
			@import "${baseurl}/js/dataTables/css/demo_table.css";
		</style>
			
		<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>
        <script>
        	var title = '<%= title %>';
        	
        	function zoomIn(){
	       		alert(title);
	        }

        	jQuery(document).ready(function()
    		{
    			jQuery('#serviceList').dataTable({
    				"sPaginationType": "full_numbers",
    				"sDom": 't<"F"ip>',
			        "bFilter": true,
			        "fnDrawCallback": function() {
		                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
		                        jQuery('.dataTables_paginate').css("display", "block"); 
		                        jQuery('.dataTables_length').css("display", "block");                   
		                } else {
		                		jQuery('.dataTables_paginate').css("display", "none");
		                		jQuery('.dataTables_length').css("display", "none");
		                }
		            },
		            "aaSorting": [[ 7, "desc" ]]
    			});

    			jQuery( "#importServiceSuccessDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() 
						{
							 
							jQuery(this).dialog( "close" );
							var filePath = jQuery(this).data("filePath");
							window.location = "${baseurl}/downloadFile/downloadTextFile?filePath="+filePath;
							return false;
						}
					}
				});

    			jQuery( "#responseDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					height:500,
					width: 800,
					buttons: {
						"Download Response": function() 
						{
							 
							jQuery(this).dialog( "close" );
							var filePath = jQuery(this).data("filePath");
							window.location = "${baseurl}/downloadFile/downloadTextFile?filePath="+filePath;
							return false;
						},
						"close": function()
						{
							jQuery(this).dialog( "close" );
							return false;
						}
					}
				});

				jQuery( "#workflowSelectionDialog" ).dialog(
					 	{
							modal: true,
							autoOpen: false,
							resizable: false,
							height:300,
							width: 400
						});

    			jQuery( "#btnNewService" ).click(function() 
						{
							if(${portfolioList?.size()==0})
							{
								jAlert('${message(code:'newServicePortfolioNotAssign.message.alert')}', 'Create New Service Alert');
								
							}
							else
							{
								jQuery.ajax({type:'POST',
				   					url:'${baseurl}/service/selectionOfWorkflow',
				   					success:function(data,textStatus)
				   					{
					   					jQuery('#workflowSelectionDialog').html(data);
									 	jQuery("#workflowSelectionDialog").dialog("open");
									},
				   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
							}
							
							return false;
						});
				
				jQuery( "#importServiceFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery(this).dialog( "close" );
							location.reload();
							return false;
						}
					}
				});

						    
				jQuery( "#btnImport" ).click(function() 
				{
					jQuery.ajax({type:'POST',
	   					url:'${baseurl}/service/importFile',
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#importServiceDialog').html(data);
						 	jQuery("#importServiceDialog").dialog("open");
						},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
   					
					return false;
				});

						
				jQuery( "#importServiceDialog" ).dialog(
				{
					modal: true,
					height: 300,
					width: 450,
					autoOpen: false,
					resizable: false,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});
    		});

        	function cancelInDevService(serviceID){
        		jConfirm('Are you sure you want to cancel this service?', 'Please Confirm', function(r)
					{
						if(r == true)
						{
							window.location.href = '${baseurl}/service/makeDevServiceInactive/'+serviceID;
							return true;
						}
						else
							return false;
					});
            }
        </script>
    </head>
    <body>
    	<div id="importServiceSuccessDialog" title="Success">
			<p>File imported successfully. Now one response file will be generated. Please press OK.</p>
		</div>

		<div id="responseDialog" title="Success">
			
		</div>
		
		<div id="workflowSelectionDialog" title="Select Service Workflow">
			
		</div>
		
		<div id="importServiceFailureDialog" title="Failure">
			<p>Failed to import file.</p>
		</div>
		
		<div id="importServiceDialog" title="Import Service File">
			
		</div>
		
    	<g:if test="${createPermit}">
    		<div class="nav">
       		   	<span><g:link class="buttons.button button" title="New Service" action="create" onclick="if(${portfolioList?.size()==0}){jAlert('${message(code:'newServicePortfolioNotAssign.message.alert')}', 'Create New Service Alert');return false;}"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
	            <!-- <span><g:link class="buttons.button button" action="importService" title="Import New Service" onclick="if(${portfolioList?.size()==0}){jAlert('${message(code:'newServicePortfolioNotAssign.message.alert')}', 'Create New Service Alert');return false;}">Import Service</g:link></span> -->
	            <!-- <span>&nbsp;
					<input id="btnNewService" type="button" title="New Service" value="New Service"  class="buttons.button button" class="menuButtonStyle "/>
				</span> --> 
            	<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}">
			 		<span>&nbsp;
						<!-- <input id="btnImport" type="button" title="Import Multiple Services" value="Import Service"  class="buttons.button button" class="menuButtonStyle "/> -->
						<g:link class="buttons.button button" action="importFile" title="Import Multiple Services" >Import Service</g:link>
					</span>
				</g:if>           		
       		</div>
       	</g:if>	
	        	
       <div class="leftNav">
       		<g:render template="serviceNavigation"/>		 		
    	</div>
    		
        <div id="columnRight" class="body rightContent column">
        	
            <h1>${title}</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            
            <g:if test="${showSearch}">
            	<g:if test="${instage}">
            		<g:set var="serviceMode" value="DEV" scope="request"/>
            	</g:if>
            	<g:else>
            		<g:set var="serviceMode" value="REMOVE" scope="request"/>
            	</g:else>
            	<g:set var="instage" value="${instage}" scope="request" />
            	<g:render template="searchToolBar" model="['searchFields',searchFields]"/>
            </g:if>
             
            <div class="list">
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="serviceList">
	                    <thead>
	                        <tr>
	                        	
	                            <th><g:message code="service.serviceName.label" default="Service Name" /></th>
	                        	
	                        	<th><g:message code="service.version.label" default="Version" /></th>
	                        	
	                        	<th><g:message code="service.skuName.label" default="Sku Name" /></th>
	                        	
	                        	<th><g:message code="service.tags.label" default="Tags" /></th>
	                        	
	                        	<th><g:message code="service.description.label" default="Description" /></th>
	                            
	                            <th><g:message code="service.portfolio.label" default="Portfolio" /></th>
	                            
	                            <th><g:message code="service.stagingStatus.label" default="Stage" /></th>
	                        
	                            <th><g:message code="service.dateModified.label" default="Date Modified" /></th>
	                            
	                        	<g:if test="${instage}"><th>Current Owner</th></g:if>
	                        	<g:if test="${instage}"><th>Action</th></g:if>
	                        	
	                        </tr>
	                    </thead>
	                    <g:if test="${serviceInstanceList}">
	                    <tbody>
	                 
	                    <g:each in="${serviceInstanceList}" status="i" var="serviceProfileInstance">
	                        <tr>
	                        
	                        	<td>
	                        		<g:link action="show" class="hyperlink" params="['serviceProfileId': serviceProfileInstance.id]" >${fieldValue(bean: serviceProfileInstance, field: "service.serviceName")}</g:link>
                       			</td>
	                            
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "revision")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.skuName")}</td>
	                            
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.tags")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.description")}</td>
	                        
	                            <td>${fieldValue(bean: serviceProfileInstance, field: "service.portfolio")}</td>
	                            
	                            <td>${serviceProfileInstance.stagingStatus?.displayName}</td>
	                        
	                            <td><g:formatDate format="MMMMM d, yyyy" date="${serviceProfileInstance.dateModified}" /></td>
	                        	
	                        	<g:if test="${instage}">
	                        		
	                        		<td>
	                        			
	                        			<%
											def responsiblePerson = new ArrayList()
											def user = User.get(new Long(SecurityUtils.subject.principal))
								
											for(UserBase usr : serviceProfileInstance.responsiblePerson())
											{
												
												if(!usr?.roles*.code?.contains('SYSTEM ADMINISTRATOR'))
												{
													responsiblePerson.add(usr)
												}
											} 
											
											if(createPermit && serviceProfileInstance?.isImported == "true")
											{
												responsiblePerson.add(serviceProfileInstance?.service?.portfolio?.portfolioManager)
											}
											else
											{
												if(serviceProfileInstance?.workflowMode.toString().toUpperCase() == "CUSTOMIZED")
												{
													if(createPermit && !responsiblePerson?.contains(user))
													{
														responsiblePerson.add(serviceProfileInstance?.service?.portfolio?.portfolioManager)
													}
												}
											}
	                        			%>
	                        				
	                        				
			                        	<g:if test="${responsiblePerson?.size() >0 && responsiblePerson[0] != null }">
				                        	<g:each in="${responsiblePerson}" var="a" status="k">
				                        	
				                        		<g:if test="${k>0}">
				                        			;
				                        		</g:if>
				                            	<span> ${a?.encodeAsHTML()} </span>
				                            
				                        	</g:each>
				                        </g:if>
				                        <g:else>
				                        	<span> Administrator </span>
				                        </g:else>
	                        		</td>
	                        	</g:if>
	                        	<g:if test="${instage}">
	                        		<td>
	                        		<input id="btnCancelService" onclick="cancelInDevService('${serviceProfileInstance.id}')" type="button" title="Cancel Service" value="Cancel Service" class="buttons.button button" />
	                        		</td>
	                        	</g:if>
	                        </tr>
	                    </g:each>
	                    </tbody>
	                    </g:if>
	                </table>
	                
	                
            </div>
            
        </div>
    </body>
</html>