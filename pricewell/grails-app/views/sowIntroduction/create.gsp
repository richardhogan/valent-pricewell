
<%@ page import="com.valent.pricewell.SowIntroduction" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'sowIntroduction.label', default: 'Sow Introduction')}" />
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
				jQuery("#sowIntroductionCreate").validate();
				jQuery("#sowIntroductionCreate input:text")[0].focus();

				jQuery("#saveSowIntroduction").click(function()
			    {
					if(jQuery("#sowIntroductionCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/sowIntroduction/save",
							data:jQuery("#sowIntroductionCreate").serialize(),
							success: function(data)
							{
								if(data == "SowIntroduction_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This SowIntroduction is already available.');
					       		}
								else if(data == "success"){
									
									window.location = "${baseurl}/sowIntroduction/list";
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
            <span><g:link class="buttons.button button" title="List Of Sow Introduction" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
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
		            <g:hasErrors bean="${sowIntroductionInstance}">
		            <div class="errors">
		                <g:renderErrors bean="${sowIntroductionInstance}" as="list" />
		            </div>
		            </g:hasErrors>
		            <g:form action="save" name="sowIntroductionCreate">
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="sowIntroduction.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: sowIntroductionInstance, field: 'name', 'errors')}">
		                                    <g:textField name="name" value="${sowIntroductionInstance?.name}" class="required"/>
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="sow_text"><g:message code="sowIntroduction.sow_text.label" default="Sow Text" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: sowIntroductionInstance, field: 'sow_text', 'errors')}">
		                                    <g:textArea name="sow_text" value="${sowIntroductionInstance?.sow_text}" rows="5" cols="40" />
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <!-- <span class="button"><g:submitButton title="Save Delivery Role" name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span> -->
		                    <span class="button"><button title="Save Sow Introduction" id="saveSowIntroduction"> Save </button></span>
		                </div>
		            </g:form>				
				</div>				
			</div>            
        </div>
    </body>
</html>
