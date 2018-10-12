
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'deliveryRole.label', default: 'Delivery Role')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    
    	<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<script>
		 
			jQuery(document).ready(function()
		  	{				 
				jQuery("#deliveryRoleCreate").validate();
				jQuery("#deliveryRoleCreate input:text")[0].focus();

				jQuery("#saveDeliveryRole").click(function()
			    {
					if(jQuery("#deliveryRoleCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/deliveryRole/save",
							data:jQuery("#deliveryRoleCreate").serialize(),
							success: function(data)
							{
								if(data == "DeliveryRole_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This DelivryRole is already available.');
					       		}
								else if(data == "success"){
									
									window.location = "${baseurl}/deliveryRole/list";
								} else{
									alert("Error while saving.")
								}		
								hideLoadingBox();	
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
								hideLoadingBox();
							}
						});
					}
					return false;
				}); 
		  	});
			  
			  
		
  		</script>
    </head>
    <body>
        <div class="nav">
            <span><g:link class="buttons.button button" title="List Of Delivery Roles" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.create.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
		            <g:hasErrors bean="${deliveryRoleInstance}">
		            <div class="errors">
		                <g:renderErrors bean="${deliveryRoleInstance}" as="list" />
		            </div>
		            </g:hasErrors>
		            <g:form action="save" name="deliveryRoleCreate">
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="deliveryRole.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: deliveryRoleInstance, field: 'name', 'errors')}">
		                                    <g:textField name="name" value="${deliveryRoleInstance?.name}" class="required"/>
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="description"><g:message code="deliveryRole.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: deliveryRoleInstance, field: 'description', 'errors')}">
		                                    <g:textArea name="description" value="${deliveryRoleInstance?.description}" rows="5" cols="40" />
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <!-- <span class="button"><g:submitButton title="Save Delivery Role" name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span> -->
		                    <span class="button"><button title="Save Delivery Role" id="saveDeliveryRole"> Save </button></span>
		                </div>
		            </g:form>
				
				</div>
				
			</div>
        
            
        </div>
    </body>
</html>
