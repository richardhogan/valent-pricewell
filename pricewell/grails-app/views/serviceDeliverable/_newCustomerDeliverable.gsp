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
			
			jQuery(function() 
			{
				jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {
					jQuery("#deliverableCreate").validate();
					jQuery("#comment").val(jQuery("#deliverableCreate").html());
			    });

				var availableDeliverableTypes = ${deliverableTypes as JSON};
				jQuery("#deliverableCreate input:text")[0].focus();

				jQuery("#type").autocomplete({
			    	source: availableDeliverableTypes
			    });

				jQuery('#type').keyup(function(){
				    this.value = this.value.toUpperCase();
				});
			    
				jQuery("#btnCancel").click(function()
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/serviceDeliverable/listServiceDeliverables",
						data: {serviceProfileId: ${serviceProfileId}},
						success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				});

				jQuery( "#deliverableCreate" ).submit(function( event )
				{
					if(jQuery('#deliverableCreate').validate().form())
					{
						showLoadingBox();
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceDeliverable/saveFromService",
							data: jQuery("#deliverableCreate").serialize(),
							success: function(data)
							{
								hideUnhideNextBtn();
								hideLoadingBox();
								jQuery('#mainCustomerDeliverablesTab').html(data);
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					return false
				});
				
				jQuery(".btnCreateServiceDeliverable").click(function()
				{
						//jQuery("#type").val(jQuery("#defaultType").val());
						jQuery("#phase").val(jQuery("#defaultPhase").val());
						
						jQuery( "#deliverableCreate" ).submit();

					return false;
				});  
				
			});	  

			function customerDeliverableList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceDeliverable/listServiceDeliverables",
					data: {'serviceProfileId': ${serviceProfileId}},
					success: function(data){jQuery("#mainCustomerDeliverablesTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
		</script>
	</head>    
	
	<div class="nav">
	    <span>
	    	<!--
		    	<g:remoteLink class="buttons.button button" controller="serviceDeliverable" 
		    		params="[serviceProfileId: serviceProfileId]" title="List Of Customer Deliverables"
		    		action="listServiceDeliverables" update="[success:'mainCustomerDeliverablesTab',failure:'mainCustomerDeliverablesTab']">
		    			List of Customer Deliverables
		    	</g:remoteLink>
	    	-->
	    	
	    	<a id="idCustomerDeliverableList" onclick="customerDeliverableList();" class="buttons.button button" title="List Of Customer Deliverables">List of Customer Deliverables</a>
	    </span>
	</div>
	<div class="body">
	    <h1>Create Customer Deliverable ${serviceProfileInstance} </h1>
	    
	    <g:if test="${flash.message}">
	    	<!--div class="message">${flash.message}</div-->
	    </g:if>
	    <g:hasErrors bean="${serviceDeliverableInstance}">
	    <div class="errors">
	        <g:renderErrors bean="${serviceDeliverableInstance}" as="list" />
	    </div>
	    </g:hasErrors>
	    <g:form action="save" name="deliverableCreate">
	    	<g:hiddenField name="serviceProfileId" value="${serviceProfileId}"/>
	    	<%--<g:hiddenField name="type" value="${serviceDeliverableInstance?.type}"/>--%>
	    	<g:hiddenField name="phase" value="${serviceDeliverableInstance?.phase}"/>
	    	
	        <div class="dialog">
	            <table>
	                <tbody>                
	                	
	                    <tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="name"><g:message code="serviceDeliverable.name.label" default="Name" /></label>
	                            <em>*</em>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'name', 'errors')}">
	                            <g:textField name="name" value="${serviceDeliverableInstance?.name}" size="100" class="required" maxlength="100" />
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
	                        		<g:select name="defaultType" from="${deliverableTypes}" value="${serviceDeliverableInstance?.type}" noSelection="['':'-Select Default One-']" class="required"/>
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
	                        		<g:select name="defaultPhase" from="${deliverablePhases}" value="${serviceDeliverableInstance?.phase}" noSelection="['':'-Select Default One-']" class="required"/>
	                        	</g:if>
	                        </td>
	                    </tr>
	                
	                    <tr class="prop">
	                        <td valign="top" class="name">
	                            <label for="description"><g:message code="serviceDeliverable.description.label" default="Description" /></label>
	                        </td>
	                        <td valign="top" class="value ${hasErrors(bean: serviceDeliverableInstance, field: 'description', 'errors')}">
	                            <g:textArea name="description" value="${serviceDeliverableInstance?.description}" rows="6" cols="130" style="width: 100%;"/>
	                        </td>
	                    </tr>
	                
	                </tbody>
	            </table>
	            <!--textarea id="comment"></textarea--> 
	        </div>
	        <div class="buttons">
	            
	            <span class="button">
                  	<button id="btnCreateServiceDeliverable" class="btnCreateServiceDeliverable" title="Save Deliverable">Create</button>
                </span>
                   	
	            <g:if test="${deliverablesList && deliverablesList.size() > 0}">
	            	<span class="button"><button title="Cancel" id="btnCancel"> Cancel </button></span>
	            </g:if>
	        </div>
	    </g:form>
	</div>
	    
