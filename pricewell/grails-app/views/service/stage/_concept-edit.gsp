<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.ObjectType" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
   <head>
   		<style type="text/css">
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
   
		<script>

		 jQuery(document).ready(function()
			{


		 		jQuery.getScript("${baseurl}/js/jquery.validate.js", function()
		 		{
		 			jQuery("#serviceEdit").validate(
					    {
		  					rules: 
		  					{
		    					premiumPercent: 
		    					{
		      						number: true	
		    					},
		    					baseUnits:
		    					{
		    						number: true
		    					}
		  					}
						});
			 	});

		 		var availableUnitOfSaleList = ${serviceUnitOfSaleList as JSON};

		 		jQuery("#unitOfSale").autocomplete({
			    	source: availableUnitOfSaleList
			    });
		 		
		 		jQuery("#unitOfSale").keyup(function(){
				    this.value = this.value.toUpperCase();
				});
				
				jQuery("#serviceEdit").submit(function() 
		 		{
			 		//alert(1); return false;
			 					 		
					jQuery.post('${baseurl}/service/saveStage', 
						jQuery("#serviceEdit").serialize(),
				      	function( data )
				      	{
				         	return false;
				      	});
						
					return false;
				});
			 	
				jQuery( "#createExtraUnitbtn" ).click(function() 
				{
					var serviceId=jQuery('#serviceId').val();
					//alert("CreateExtraButton");
					jQuery("#createExtraUnitDialog").html("Loading Data, Please Wait.....");
					jQuery("#createExtraUnitDialog").dialog("open");
					jQuery.ajax(
							{
								type: "POST",
								url: "${baseurl}/extraUnit/loadExtraUnit",
								data: {serviceId: serviceId},
								success: function(data)
								{
									//alert("In success")
									jQuery('#createExtraUnitDialog').html(data);					
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									alert("Error while saving");
								}
							});
							return false;
					
				});
				
				jQuery( "#createExtraUnitDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					height: 500,
					width: 1000,
					
				});

		});
		
		 
  </script>
    </head>
    <body>
        
        <div class="body">
            <div id="createExtraUnitDialog" title="Add Extra Unit"><%--
				<g:render template="../service/stage/createExtraUnit" model="['extraUnitInstanceList': extraUnitInstanceList]"/>
			--%></div>

            <g:form action="saveStage" controller="service" name="serviceEdit">
            	<g:hiddenField id="serviceId" name="id" value="${serviceProfileInstance?.id}" />
                <g:hiddenField name="version" value="${serviceProfileInstance?.version}" />
                 
                <div class="dialog">
                    <table>
                        <tbody>
                        	
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceName"><g:message code="service.serviceName.label" default="Service Name" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.serviceName', 'errors')}">
                                    <g:textField name="serviceName" value="${serviceProfileInstance?.service?.serviceName}" class="required" minlength="4" size="100" maxlength="255" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="skuName"><g:message code="service.skuName.label" default="Sku Name" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.skuName', 'errors')}">
                                    <g:textField name="skuName" value="${serviceProfileInstance?.service?.skuName}" class="required" size="100" maxlength="255"/>
                                </td>
                            </tr>
                            <tr>
                            
		                    </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="service.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service.description', 'errors')}">
                                    <g:textArea name="description" value="${serviceProfileInstance?.service?.serviceDescription?.value}" rows="8" cols="102"/>
                                </td>
                            </tr>
                        	
                        	 <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitOfSale"><g:message code="serviceProfile.unitOfSale.label" default="Unit Of Sale" /></label>
                               		<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'unitOfSale', 'errors')}">
                                	
                                	<g:set var="defaultUnitOfSales" value="${ObjectType.getUnitOfSaleTypes()}" />
                                	
                                	<g:if test="${defaultUnitOfSales?.size() > 0 }">
                                		<g:hiddenField name="isNewUnitOfSale" value="${false}" />
                                		
                                		<div id="defaultUnitOfSaleDiv">
                                			<g:textField name="unitOfSale" id="unitOfSale" value="${serviceProfileInstance?.unitOfSale}" class="required" />
                                			<%--<g:select name="unitOfSale" from="${defaultUnitOfSales}" value="${serviceProfileInstance?.unitOfSale}" noSelection="['':'-Select Default One-']" class=""/>--%>
                                			
                                			<%--<button id="newUnitOfSaleBtn" class="roundNewButton"  title="New Additional Unit Requirement">+</button>--%>
                                			<span class="button"><button id="createExtraUnitbtn" class="createExtraUnitbtn" title="Add Extra Units"> Add Extra Units </button></span>
                                		</div>
                                		<div id="newUnitOfSaleDiv">
                                			<%--<g:textField name="newUnitOfSale" value="" class="" />--%>
                                			
                                			<%--<button id="defaultUnitOfSaleBtn" class="roundNewButton"  title="List Default Unit of Sale">-</button>--%>
                                			
                                			<br/>
                                			<p style="color: blue;">Write Unit of Sale you want in above text field.</p>
                                		</div>
		                        		
		                        		<script>
		                        			jQuery(document).ready(function()
		        						    {
		                        				jQuery("#newUnitOfSaleDiv").hide();
		                        				jQuery("#defaultUnitOfSale").addClass('required');

		                        				jQuery('#newUnitOfSale').keyup(function(){
		                    					    this.value = this.value.toUpperCase();
		                    					});
		                    					
		                        				jQuery( "#newUnitOfSaleBtn" ).click(function() 
		                        				{
			                        				jQuery("#isNewUnitOfSale").val(${true});
		                        					jQuery("#defaultUnitOfSaleDiv").hide();
		                        					jQuery("#newUnitOfSaleDiv").show();

		                        					jQuery("#defaultUnitOfSale").removeClass('required'); jQuery("#defaultUnitOfSale").val("");
		                        					jQuery("#newUnitOfSale").addClass('required');
		                        					return false;
		                        				});

		                        				jQuery( "#defaultUnitOfSaleBtn" ).click(function() 
		                        				{
		                        					jQuery("#isNewUnitOfSale").val(${false});
		                        					jQuery("#newUnitOfSaleDiv").hide();
		                        					jQuery("#defaultUnitOfSaleDiv").show();

		                        					jQuery("#newUnitOfSale").removeClass('required'); jQuery("#newUnitOfSale").val("");
		                        					jQuery("#defaultUnitOfSale").addClass('required');
		                        					return false;
		                        				});
		        						    });
		                        				
		                        		</script>
		                        		
		                        	</g:if>
		                        	<g:else>
		                        		<g:hiddenField name="isNewUnitOfSale" value="${true}" />
		                        		<g:textField name="newUnitOfSale" value="${serviceProfileInstance?.unitOfSale}" class="required" />
		                        		
		                        		<script>
		                        			jQuery(document).ready(function()
			        						{	
				        						jQuery('#newUnitOfSale').keyup(function(){
                    					    		this.value = this.value.toUpperCase();
                    							});
			        						});
		                        		</script>
		                        	</g:else>
	                        		
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="baseUnits"><g:message code="serviceProfile.baseUnits.label" default="Base Units" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'baseUnits', 'errors')}">
                                    <g:textField name="baseUnits" id="baseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'baseUnits')}" class="required number"/>
                                </td>
                            </tr>
                            
                            <g:if test="${!isLightWorkflow }">
                            	<tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="totalEstimateInHoursFlat"><g:message code="serviceProfile.totalEstimateInHoursFlat.label" default="totalEstimateInHoursFlat" /></label>
	                                    <em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat', 'errors')}">
	                                    <g:textField name="totalEstimateInHoursFlat" id="totalEstimateInHoursFlat" value="${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursFlat')}" />
	                                </td>
	                            </tr>
	                            
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="totalEstimateInHoursPerBaseUnits"><g:message code="serviceProfile.totalEstimateInHoursPerBaseUnits.label" default="totalEstimateInHoursPerBaseUnits" /></label>
	                                    <em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits', 'errors')}">
	                                    <g:textField name="totalEstimateInHoursPerBaseUnits" id="totalEstimateInHoursPerBaseUnits" value="${fieldValue(bean: serviceProfileInstance, field: 'totalEstimateInHoursPerBaseUnits')}" class="required number"/>
	                                </td>
	                            </tr>
                            </g:if>
                                                   
	                        <tr class="prop">
	                        	<td valign="top" class="name">
                                    <label for="premiumPercent"><g:message code="serviceProfile.premiumPercent.label" default="Premium Percentage" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'totalEstimateInHours', 'errors')}">
                                    <g:textField name="premiumPercent" id="premiumPercent" value="${fieldValue(bean: serviceProfileInstance, field: 'premiumPercent')}" class="number"/>
                                </td>
	                        </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="tags">Search tags</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.tags', 'errors')}">
                                    <g:textField name="tags" value="${serviceProfileInstance?.service?.tags}" size="100" maxlength="255" />
                                </td>
                            </tr>
                            
                            
                        </tbody>
                    </table>
                </div>
                     

            </g:form>
        </div>
    </body>
