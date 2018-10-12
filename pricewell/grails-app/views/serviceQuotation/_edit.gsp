
<%@ page import="grails.converters.JSON" %>
<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<style>
		
		.activityRoleAccordion {
			width: 100% auto;
		}
		
		.hrStyle {
		  	width: 95%;
		  	color: #44A9FB;
			background-color: #44A9FB;
			height: 1px;
		}
		.serviceQuotationBox {
			   width: auto;
			   height: auto;
			   border-top: 1px solid #44A9FB;
			   border-bottom: 1px solid #44A9FB;
			   border-right: 1px solid #44A9FB;
			   border-left: 1px solid #44A9FB;
			}
		
		.vertaligntop 	
		{ 	
			vertical-align:top; 
			margin-top:0; 
			height: 100% auto;
		}
	</style>

	<g:setProvider library="prototype"/>
    <script>

    	var editedAdditionalUnitOfSaleJson = JSON.parse('${additionalUnitOfSaleJSONObjectString}');
	    var totalAddtionalUnits = 1;
    
		jQuery(function() {

			jQuery("#frmUpdateQuote").validate();

			jQuery.each(editedAdditionalUnitOfSaleJson.additionalUnitOfSaleJSONArray, function( index, item )
			{
	    		totalAddtionalUnits = totalAddtionalUnits * parseInt(item.units);
	    		
			});
			jQuery("#extraUnits").val(totalAddtionalUnits);

			jQuery( ".editAdditionalUnits" ).keyup(function()
			{
				var id = this.id;
				var changedAdditionalUnits = jQuery("#"+id).val();
				var sequenceId = id.substring(20);
				totalAddtionalUnits = 1;
				
				if(changedAdditionalUnits == "" || changedAdditionalUnits == 0)
				{
					jQuery("#"+id).val(1);
					changedAdditionalUnits = 1;
				}
				
				jQuery.each(editedAdditionalUnitOfSaleJson.additionalUnitOfSaleJSONArray, function( index, item )
				{
				  	if(item.id == sequenceId)
					{
						var old = item.units;
						item.units = changedAdditionalUnits;
				  		//return false;
				  	}

				  	if(item.units > 0)
					{
				  		totalAddtionalUnits = totalAddtionalUnits * parseInt(item.units);
					}
				});

				jQuery("#extraUnits").val(totalAddtionalUnits);

				loadEditedServiceQuotationPrice();
				//alert(jQuery("#extraUnits").val());
			});	
			
			jQuery('#totalUnitsEdited').bind("keyup", function(event){

					var id = <%= serviceQuotationInstance?.id %>;
					if(id === undefined)
					{
						 jQuery('#dialog').dialog('open');
						 return false;
					}
					var totalUnits = jQuery( "#totalUnitsEdited" ).val()
					if(totalUnits.length == 0)
					{
						jQuery('#totalUnitsEdited').val(0);
					}

					//var formData = jQuery("#frmUpdateQuote").serialize() + "&totalUnits=" + this.value;
					loadEditedServiceQuotationPrice();
					
			});


			jQuery('#btnUpdate').button();

			jQuery('#btnUpdate').click( function()
			{

				var price = jQuery('#newGeneratedPrice').val();
				var totalUnits = parseInt(jQuery('#totalUnitsEdited').val());
				var baseUnits = parseInt(${serviceQuotationInstance?.profile?.baseUnits});
				jQuery("#editedAdditionalUnitOfSaleJson").val(JSON.stringify(editedAdditionalUnitOfSaleJson));
				
				if(totalUnits == 0){jAlert('Please add required total units of service first.', 'Add Service Alert'); return false;}
				if(totalUnits < baseUnits){jAlert('${message(code:'smallerTotalUnitsOfService.message.alert')}', 'Add Service Alert'); return false;}
				if(!jQuery('#frmUpdateQuote').validate().form()){return false;}
				else
				{
					jQuery('<input />').attr('type', 'hidden')
		            	.attr('name', 'totalUnits')
		            	.attr('value',totalUnits)
		            	.appendTo('#frmUpdateQuote');

				
					jQuery('<input />').attr('type', 'hidden')
		            	.attr('name', 'price')
		            	.attr('value', price)
		            	.appendTo('#frmUpdateQuote');

					jQuery.ajax({type:'POST',data: jQuery("#frmUpdateQuote").serialize(),
						 url:'${baseurl}/serviceQuotation/update',
						 success:function(data,textStatus){
							 	jQuery('#dvQuote').html(data);
							 	jQuery( "#dvQutationServices" ).dialog( "close" );
							 	refreshForecastValue();
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){alert(errorThrown)}});
				}
				
				return false;				      
		
			});

			jQuery( ".activityRoleAccordion" ).accordion();
			jQuery( ".accordionContent" ).height("auto");
			
		});
				      
		function loadEditedServiceQuotationPrice()
		{
			var totalUnits = jQuery( "#totalUnitsEdited" ).val();
			var formData = jQuery("#frmUpdateQuote").serialize() + "&totalUnits=" + totalUnits;
	
			jQuery.post( '${baseurl}/serviceQuotation/displayCalculatedPriceInEdit', 
				formData ,
		      	function( data ) {
		          	jQuery( "#newGeneratedPrice" ).val( data );
		      	});
		}
	 
	</script>
    <body>
       
        <div class="body serviceQuotationBox">
            
            <div id="serviceQuotationDetails">
            	<g:form action="update" name="frmUpdateQuote" >
                                  
	                <g:hiddenField name="sqid" value="${serviceQuotationInstance?.id}"/>
	                <g:hiddenField name="id" value="${serviceQuotationInstance?.id}"/>
	                <g:hiddenField id="editedAdditionalUnitOfSaleJson" name="editedAdditionalUnitOfSaleJson" value=""/>
	                      
	                <div class="list">
	                    <table>
	                    	<thead>
	                    		<th> <label for="service"><g:message code="serviceQuotation.service.label" default="Service" /></label> </th>
	                    		<th> <label for="totalUnits"><g:message code="serviceQuotation.totalUnits.label" default="Total Units" /><em>*</em></label> </th>
	                    		<th> <label for="price"><g:message code="serviceQuotation.price.label" default="Price" /></label> </th>
	                    		<th> </th>
	                    	</thead>
	                        <tbody>
	                        
	                            <tr class="prop">
	                                
	                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'profile?.service', 'errors')}">
	                                	<g:hiddenField name="service.id" value="${serviceQuotationInstance?.service?.id}"/>
	                                	<g:hiddenField name="profile.id" value="${serviceQuotationInstance?.profile?.id}"/>
	                                	<g:hiddenField name="geo.id" value="${serviceQuotationInstance?.geo?.id}"/>
	                                	<g:hiddenField id="extraUnits" name="extraUnits" value="${extraUnits}"/>
	                                	<label>Name</label> : ${serviceQuotationInstance?.service?.serviceName} [Version ${serviceQuotationInstance?.profile?.revision}]
	                                	
	                                	<br/>
	                                	
	                                	<label>Unit Of Sale</label> : ${serviceQuotationInstance?.profile?.unitOfSale}
	                                	
	                                	<br/>
	                                	
	                                	<label>Base Units</label> : ${serviceQuotationInstance?.profile?.baseUnits}
	                                </td>
	                                
	                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'totalUnits', 'errors')}">
	                                    <g:textField name="totalUnitsEdited" id="totalUnitsEdited" value="${fieldValue(bean: serviceQuotationInstance, field: 'totalUnits')}" style="width: 5em" class="required number"/>
	                                </td>
	                                
	                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'price', 'errors')}">
	                                    <g:textField name="newGeneratedPrice" value="${fieldValue(bean: serviceQuotationInstance, field: 'price')}" readOnly="true" style="width: 7em" class="required"/>
	                                    <label> ${serviceQuotationInstance?.geo?.currency} </label>
	                                </td>
	                                
	                                <td>
	                                	<input id="btnUpdate" type="button" title="Update Service" value="Update"/>
	                                 <!--  	<g:submitToRemote id="update" name="btnUpdate" class="save" value="Update" update="dvQuotationMain" controller="serviceQuotation" action="update"/> -->
	                                	<!--button id="calculate" name="calculate">Calculate</button-->
	                                </td>
	                            </tr>
	                     		
	                     		<tr>
	                     			<td>
	                     				<div id="dvEditAdditionalUnitOfsale" class="vertaligntop">
	                     					<g:each in="${additionalUnitOfSaleJSONObject.get('additionalUnitOfSaleJSONArray')}" status="i" var="uniOfSaleInstance">
	                     						<label>${uniOfSaleInstance.get('unitOfSale')}</label>
	                     					</g:each>
	                     				</div>
	                     			</td>
	                     			
	                     			<td>
	                     				<div id="dvEditAdditionalUnitOfsaleUnits" class="vertaligntop">
	                     					<g:each in="${additionalUnitOfSaleJSONObject.get('additionalUnitOfSaleJSONArray')}" status="i" var="uniOfSaleInstance">
	                     						<input type="text" name="editAdditionalUnits_${uniOfSaleInstance.get('id')}" 
	                     											id="editAdditionalUnits_${uniOfSaleInstance.get('id')}" value="${uniOfSaleInstance.get('units')}" 
	                     											class='required number editAdditionalUnits' min='1' style="width: 4em;"/>
	                     					</g:each>
	                     				</div>
	                     			</td>
	                     		</tr>
	                       </tbody>
	                    </table>
	                           
	                        
	                </div>
	                
	            </g:form>
            </div>
            
            <hr class="hrStyle"/>
            
            <script>

				jQuery(document).ready(function()
				{
					jQuery( "#dvRoleTimeEdit" ).dialog(
    				{
    					height: 'auto',
    					width: 'auto',
    					modal: true,
    					autoOpen: false,
    					close: function( event, ui ) {
							jQuery(this).html('');
						}
    					
    				}); 
					
					jQuery('.artcEdit').click( function()
					{
						var artcId = this.id.substring(7);
						var activityContentId = jQuery(this).parent().parent().parent().parent().parent().parent().attr('id');
						var extraUnits = jQuery("#extraUnits").val();
						
						showLoadingBox();
						jQuery.ajax({type:'POST',data: {roleTimeCorrectionId: artcId, sqId: ${serviceQuotationInstance?.id}, extraUnits: extraUnits},
							 url:'${baseurl}/correctionInActivityRoleTime/edit',
							 success:function(data,textStatus){
								 	//jQuery('#'+activityContentId).html(data);
								 jQuery("#dvRoleTimeEdit").html(data).dialog( "open" );
								 hideLoadingBox();
								 	
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){alert(errorThrown)}});
						 
						return false;
							      
					});
			
					jQuery('.artEdit').click( function()
					{
						var artId = this.id.substring(6);
						var activityContentId = jQuery(this).parent().parent().parent().parent().parent().parent().attr('id');
						var extraUnits = jQuery("#extraUnits").val();
						
						showLoadingBox();
						jQuery.ajax({type:'POST',data: {roleTimeId: artId, sqId: ${serviceQuotationInstance?.id}, extraUnits: extraUnits},
							 url:'${baseurl}/correctionInActivityRoleTime/create',
							 success:function(data,textStatus){
								 	//jQuery('#'+activityContentId).html(data);
								 jQuery("#dvRoleTimeEdit").html(data).dialog( "open" );
								 hideLoadingBox();
								 	
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){alert(errorThrown)}});
						 
						return false;
							      
					});

					if(${activityId} != "null")
					{
						jQuery('#activityRoleAccordion').accordion('option', 'active', '#accordionTab-${activityId}');
					}
					
				});
						      
						 
			 
			</script>
			
            <g:set var="serviceProfileInstance" value="${serviceQuotationInstance?.profile}" />
            
            <div id="activityRoleAccordion" class="activityRoleAccordion">
            	<g:each in="${serviceProfileInstance?.customerDeliverables?.sort {it.name}}" status="i" var="serviceDeliverableInstance">
            		<g:each in="${serviceDeliverableInstance?.serviceActivities?.sort {it.name}}" status="j" var="serviceActivityInstance">
            			<h2 id="accordionTab-${serviceActivityInstance?.id}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${serviceActivityInstance?.name }</h2>
            			
            				
            				<div  id="accordionContent-${serviceActivityInstance?.id}" class="accordionContent">
            					<g:render template="/serviceQuotation/activityRoleTimeList" model="['serviceActivityInstance': serviceActivityInstance, 'serviceQuotationInstance': serviceQuotationInstance]"/>
			  				</div>
            			
            		</g:each>
            	</g:each>
			  
			  
		  	</div>
		  
		  	<div id="dvRoleTimeEdit" title="Edit Delivery Role Time"></div>
		  
		  
        </div>
    </body>
</html>
