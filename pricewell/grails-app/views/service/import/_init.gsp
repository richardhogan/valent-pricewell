<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
    	
		<script>

		 jQuery(document).ready(function()
		 {
			 	
			 	jQuery(".cancelBtn").click( function() 
				{
					window.location.href = '${baseurl}/service/catalog'	       
					return false;
				});
			 
			 	jQuery("#serviceCreate").validate();

			 	jQuery( "#serviceAvailableDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#serviceAvailableDialog" ).dialog( "close" );
							return false;
						}
					}
				});
			 	
			 	jQuery( "#successDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#successDialog" ).dialog( "close" );
							window.location.href = '${baseurl}/service/catalog';
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
				
			 	jQuery("#serviceCreate").submit(function() 
		 		{
				  	 var jsonData = jQuery(this).serialize();
				   	 var success1 = true;
					 if(jQuery("#serviceCreate").validate().form())
					 {
						 showLoadingBox();
						 jQuery.post('${baseurl}/service/isServiceAvailable', {serviceName: jQuery("#serviceName").val()},
								function(data)
								{
							 		hideLoadingBox();
							 		if(data['result'] == 'serviceAvailable')
								 	{
							 			jQuery( "#serviceAvailableDialog" ).html(data['placeWhereAvailable']).dialog("open");
								 	}
							 		else if(data['result'] == 'dataNotFound')
								 	{
							 			jQuery( "#serviceAvailableDialog" ).html("Server cannot get data on submition.").dialog("open");	
									}
								 	else
									{
										 showLoadingBox();
										 jQuery.post( '${baseurl}/service/saveStage', jQuery("#serviceCreate").serialize(),
										      function( data ) 
										      {
										 		  hideLoadingBox();
										          if(data['res'] == 'success')
										          {		                   		                   		
								                   		//jQuery( "#successDialog" ).dialog("open");
								                   		
								                   		window.location.href = '${baseurl}/service/show?serviceProfileId='+data['serviceProfileId'];
											      }
											      else
											      {
								                  		jQuery( "#failureDialog" ).dialog("open");
											      }
											      //alert(data['res']);
										          
										      });
									}
								});
				      }
					 
					
					 return false;
				});
			 	
			 });
		
		 
  		</script>
  		
  		
  	<body>		
  			
        <div id="successDialog" title="Success">
			<p><g:message code="service.import.message.success.dialog" default=""/></p>
		</div>

		<div id="failureDialog" title="Failure">
			<p><g:message code="service.import.message.failure.dialog" default=""/></p>
		</div>
		
		<div id="serviceAvailableDialog" title="Error">
		</div>
        
            <g:form name="serviceCreate" action="saveStage" controller="service">
            	<g:hiddenField name="source" value="init"></g:hiddenField>
            	<g:hiddenField name="createdFrom" value="customized"></g:hiddenField>
                <div class="dialog">
                    <table>
                        <tbody>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="portfolio"><g:message code="service.portfolio.label" default="Portfolio" /></label>
                                     <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'portfolio', 'errors')}">
                                    <g:select name="portfolio.id" from="${portfolioList?.sort {it.portfolioName}}" optionKey="id" value="" STYLE="width: 383px" class="required" noSelection="['': 'Select any one']"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceName"><g:message code="service.serviceName.label" default="Service Name" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'serviceName', 'errors')}">
                                    <g:textField name="serviceName" value="${serviceInstance?.serviceName}" class="required" minlength="4" size="50"/>
                                    
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="skuName"><g:message code="service.skuName.label" default="Sku Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'skuName', 'errors')}">
                                    <g:textField name="skuName" value="${serviceInstance?.skuName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="service.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceInstance, field: 'description', 'errors')}">
                                    <g:textArea name="description" value="${serviceInstance?.serviceDescription?.value}" rows="8" cols="150"/>
                                </td>
                            </tr>
                        	                            
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" title="Import Service" class="save" value="Create" /></span>
                    <span class="button"> <input type="button" id = "cancelBtn" class="cancelBtn" name="cancel" title="Cancel" value="Cancel"/>  </span>
                </div>
            </g:form>
    
</body>