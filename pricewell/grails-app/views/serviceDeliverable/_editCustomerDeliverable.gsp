<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ObjectType" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>    
    <head>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			
			.ui-autocomplete {
    			max-height: 100px;
    			overflow-y: auto;
    			/* prevent horizontal scrollbar */
    			overflow-x: hidden;
  			}
			
			/* IE 6 doesn't support max-height
   			* we use height instead, but this forces the menu to always be this tall
   			*/
   
			* html .ui-autocomplete {
    			height: 100px;
  			}
		</style>
		<g:setProvider library="prototype"/>
		<script>
			jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {
					jQuery("#deliverableEdit").validate(
				    {
	  					rules: 
	  					{
	    					sequenceOrder: 
	    					{
	      						number: true	
	    					}
	  					}
					});
					jQuery("#comment").val(jQuery("#deliverableEdit").html());
			  });

			jQuery(document).ready(function()
			{
				jQuery("#deliverableEdit input:text")[0].focus();
				
				jQuery(".btnUpdateDeliverable").click(function()
				{
					if(jQuery('#deliverableEdit').validate().form())
					{
						showLoadingBox();
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceDeliverable/updateFromService",
							data: jQuery("#deliverableEdit").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								jQuery('#mainCustomerDeliverablesTab').html(data);
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					
					return false;
				}); 

				var availableDeliverableTypes = ${deliverableTypes as JSON};
				
				jQuery("#type").autocomplete({
			    	source: availableDeliverableTypes
			    });

				jQuery('#type').keyup(function(){
				    this.value = this.value.toUpperCase();
				});

			});

			function createNewCustoerDeliverable()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceDeliverable/createFromService",
					data: {'serviceProfileId': ${serviceDeliverableInstance?.serviceProfile?.id} },
					success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}

			function customerDeliverableList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceDeliverable/listServiceDeliverables",
					data: {'serviceProfileId': ${serviceDeliverableInstance?.serviceProfile?.id}},
					success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
		</script>
	</head>  
	
	<div class="nav">
	    <span>
	    	<!--<g:remoteLink class="buttons.button button" controller="serviceDeliverable" 
	    		params="['serviceProfileId': serviceDeliverableInstance?.serviceProfile?.id]" title="List Of Customer Deliverables"
	    		action="listServiceDeliverables" update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']">
	    			List of Customer Deliverables
	    	</g:remoteLink>
			<g:remoteLink class="buttons.button button" controller="serviceDeliverable" action="createFromService" 
							params="['serviceProfileId': serviceDeliverableInstance?.serviceProfile?.id]" title="New Customer Deliverables"
					 update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']">
					 	New Customer Deliverable
			</g:remoteLink>-->
			
			<a id="idCustomerDeliverableList" onclick="customerDeliverableList();" class="buttons.button button" title="List Of Customer Deliverables">List of Customer Deliverables</a>
		</span>
		
		<span>
			<a id="idNewCustomerDeliverable" onclick="createNewCustoerDeliverable();" class="buttons.button button" title="New Customer Deliverable">New Customer Deliverable</a>
		</span>
	</div>
	
	<div class="body">
	    <h1>Edit Customer Deliverable</h1>
	    
	    <g:hasErrors bean="${serviceDeliverableInstance}">
	    <div class="errors">
	        <g:renderErrors bean="${serviceDeliverableInstance}" as="list" />
	    </div>
	    </g:hasErrors>
	    <g:form action="save" name="deliverableEdit">
	    	<g:hiddenField name="id" value="${serviceDeliverableInstance?.id}"/>
	        <div class="dialog">
	            <table>
	                <tbody>
	                
	                	<%-- <tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="sequenceOrder"><g:message code="serviceDeliverable.sequenceOrder.label" default="Sequence Order" /></label>
	                       		<em>*</em>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'sequenceOrder', 'errors')}">
	                            <g:textField name="sequenceOrder" id="sequenceOrder" value="${serviceDeliverableInstance?.sequenceOrder}" class="required"/>
	                        </td>
	                    </tr> --%>
	                    
	                    <tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="name"><g:message code="serviceDeliverable.name.label" default="Name" /></label>
	                        	<em>*</em>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'name', 'errors')}">
	                            <g:textField name="name" value="${serviceDeliverableInstance?.name}" maxlength="100" size="100" class="required"/>
	                        </td>
	                    </tr>
	                
	                    <tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="type"><g:message code="serviceDeliverable.type.label" default="Type" /></label>
	                        	<em>*</em>
	                        </td>
	                        
	                        <%--<g:set var="deliverableTypes" value="${ObjectType.getDeliverableTypes()}" />--%>
	                        
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'type', 'errors')}">
	                            
	                            <input name="type" id="type" value="${serviceDeliverableInstance?.type}" class="required">
	                            
	                            <%--<g:if test="${deliverableTypes?.size() > 0 }">
	                        		<g:select name="type" from="${deliverableTypes}" value="${serviceDeliverableInstance?.type}" noSelection="['':'-Select Default One-']" class="required"/>
	                        	</g:if>--%>
	                        </td>
	                    </tr>
	                
	                	<tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="type"><g:message code="serviceDeliverable.phase.label" default="Phase" /></label>
	                            <em>*</em>
	                        </td>
	                        
	                        <g:set var="deliverablePhases" value="${ObjectType.getDeliverablePhases()}" />
	                        
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'phase', 'errors')}">
	                        	
	                        	<g:if test="${deliverablePhases?.size() > 0 }">
	                        		<g:select name="phase" from="${deliverablePhases}" value="${serviceDeliverableInstance?.phase}" noSelection="['':'-Select Default One-']" class="required"/>
	                        	</g:if>
	                        </td>
	                    </tr>
	                    
	                    <tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="description"><g:message code="serviceDeliverable.description.label" default="Description" /></label>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'newDescription?.value', 'errors')}">
	                            <g:textArea name="description" value="${serviceDeliverableInstance?.newDescription?.value}" rows="6" cols="130" />
	                        </td>
	                    </tr>
	                    
	                    <tr class="prop">
                            <td valign="top" class="name">
                              <label for="results"><g:message code="serviceActivity.results.label" default="Results" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: serviceActivityInstance, field: 'results', 'errors')}">
                                <g:textField name="results" value="${serviceActivityInstance?.results}" />
                            </td>
	                     </tr>
	                
	                </tbody>
	            </table>
	        </div>
	        <div class="buttons">
	        	<span class="button">
                   	<button id="btnUpdateDeliverable" class="btnUpdateDeliverable" title="Updare Product">Update</button>
                </span>
                   	
	        </div>
	    </g:form>
	</div>
	    
