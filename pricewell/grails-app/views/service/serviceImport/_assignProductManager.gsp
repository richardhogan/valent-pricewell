<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="grails.converters.JSON"%>

<%
	def baseurl = request.siteUrl
%>    	
		<script>

		 jQuery(document).ready(function()
		 {
			 	

			 	jQuery("#assignProductManager").validate();
			 	
			 	
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
				
			 	jQuery("#assignProductManager").submit(function() 
		 		{
				  	 var jsonData = jQuery(this).serialize();
				   	 var success1 = true;
					 if(jQuery("#assignProductManager").validate().form())
					 {
						 showLoadingBox();
						 jQuery.post( '${baseurl}/service/saveProductManager', jQuery("#assignProductManager").serialize(),
							      function( data ) 
							      {
							 		  hideLoadingBox();
							          if(data == 'success')
							          {		                   		                   		
					                   		//jQuery( "#successDialog" ).dialog("open");
											window.location.href = '${baseurl}/service/changeImportServiceStage?id='+${serviceProfileInstance?.id};
								      }
								      else
								      {
					                  		jQuery( "#failureDialog" ).dialog("open");
								      }
							          
							      });
				      }
					 
					
					 return false;
				});

			 	var productManager = '${serviceProfileInstance?.service?.productManager?.username}';
	 			 	
				if( productManager == 'product' ){
					 jQuery(".buttonFinish").trigger("click");
				}
			 	
			 });
		
		 
  		</script>
  		
  		
  	<body>		
  			<g:hasErrors bean="${serviceInstance}">
	            <div class="errors">
	                <g:renderErrors bean="${serviceInstance}" as="list" />
	            </div>
            </g:hasErrors>
            
        <div id="successDialog" title="Success">
			<p><g:message code="service.create.message.success.dialog" default=""/></p>
		</div>

		<div id="failureDialog" title="Failure">
			<p><g:message code="service.create.message.failure.dialog" default=""/></p>
		</div>
            <g:form name="assignProductManager" action="saveProductManager" controller="service">
            	<g:hiddenField name="serviceProfileId" value="${serviceProfileInstance?.id}"></g:hiddenField>
                <div class="dialog">
                    <table>
                        <tbody>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="portfolio"><g:message code="service.portfolio.label" default="Portfolio" /></label>
                                     <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.portfolio', 'errors')}">
                                    <!--<g:textField name="portfolio" value="${serviceProfileInstance?.service?.portfolio?.portfolioName}" class="required" minlength="4" readonly="true"/>-->
                                	${serviceProfileInstance?.service?.portfolio?.portfolioName}
                                </td>
                            </tr>
                        
                        	<g:if test="${!assignPortfolioManager}">
	                        	<tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="portfolioManager"><g:message code="service.portfolio.portfolioManager.label" default="Portfolio Manager" /></label>
	                                     <em>*</em>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.portfolio?.portfolioManager', 'errors')}">
	                                    <g:select name="portfolioManagerId" noSelection="${['':'Select any one']}" from="${portfolioManagerList?.sort {it.profile.fullName}}" optionKey="id" value=""  class="required"/>
	                                </td>
	                            </tr>
	                        </g:if>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceName"><g:message code="service.serviceName.label" default="Service Name" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.serviceName', 'errors')}">
                                    <!--<g:textField name="serviceName" value="${serviceProfileInstance?.service?.serviceName}" class="required" readonly="true"/>-->
                                    ${serviceProfileInstance?.service?.serviceName}
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="skuName"><g:message code="service.skuName.label" default="Sku Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.skuName', 'errors')}">
                                    <g:textField name="skuName" value="${serviceProfileInstance?.service?.skuName}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="service.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.description', 'errors')}">
                                    <g:textArea name="description" value="${serviceProfileInstance?.service?.serviceDescription?.value}" rows="5" cols="40"/>
                                </td>
                            </tr>
                             <g:if test="${serviceProfileInstance?.service?.productManager?.username != 'product' }">
                                                   
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="productManager"><g:message code="service.productManager.label" default="Product Manager" /></label>
                                     <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceProfileInstance, field: 'service?.productManager', 'errors')}">
                                    <g:select value="${serviceProfileInstance?.service?.productManager?.id}" name="productManagerId" noSelection="${['':'Select any one']}" from="${productManagerList?.sort {it.profile.fullName}}" optionKey="id" class="required"/>
                                </td>
                            </tr>
                        	  </g:if>               
                        </tbody>
                    </table>
                </div>
                <!-- <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" title="New Service" value="Save" /></span>
                    <span class="button"> <input type="button" name="cancel" title="Cancel" value="Cancel"/>  </span>
                </div> -->
            </g:form>
    
</body>