<%@ page import="com.valent.pricewell.SowIntroduction" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'sowIntroduction.label', default: 'Sow Introduction')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    	
    	<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<script>
		 	jQuery(function() 
		 	{				 
			    jQuery("#sowIntroductionEdit").validate();	
			    jQuery("#sowIntroductionEdit input:text")[0].focus();		  

			    jQuery("#saveSowIntroduction").click(function()
				{
					if(jQuery("#sowIntroductionEdit").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/sowIntroduction/update",
							data:jQuery("#sowIntroductionEdit").serialize(),
							success: function(data)
							{
								if(data == "SowIntroduction_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This SowIntroduction is already available.');
					       		}
								else if(data == "success")
								{								    		         
									window.location = "${baseurl}/SowIntroduction/show/${SowIntroductionInstance?.id}";
								}
								else{
									alert("Error while saving");
								}
								hideLoadingBox();
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								hideLoadingBox();
								alert("Error while saving");
								//hideLoadingBox();
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
            <span><g:link class="buttons.button button" title="List Of SowIntroductions" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span><g:link class="buttons.button button" title="Create SowIntroduction" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.edit.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
		            <g:hasErrors bean="${SowIntroductionInstance}">
		            <div class="errors">
		                <g:renderErrors bean="${SowIntroductionInstance}" as="list" />
		            </div>
		            </g:hasErrors>
		            <g:form method="post" name="SowIntroductionEdit">
		                <g:hiddenField name="id" value="${SowIntroductionInstance?.id}" />
		                <g:hiddenField name="version" value="${SowIntroductionInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="name"><g:message code="SowIntroduction.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: SowIntroductionInstance, field: 'name', 'errors')}">
		                                    <g:textField name="name" value="${SowIntroductionInstance?.name}" class="required"/>
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="description"><g:message code="SowIntroduction.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: SowIntroductionInstance, field: 'description', 'errors')}">
		                                    <g:textArea name="description" value="${SowIntroductionInstance?.description}" rows="5" cols="40" />
		                                </td>
		                            </tr>
		                        
		                            
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <!-- <span class="button"><g:actionSubmit title="Update SowIntroduction" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span> -->
		                    <span class="button"><button title="Update SowIntroduction" id="saveSowIntroduction"> Update </button></span>
		                    <span class="button"><g:actionSubmit class="delete" title="Delete SowIntroduction" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
		                </div>
		            </g:form>
				
				</div>
				
			</div>
        
            
        </div>
    </body>
</html>
