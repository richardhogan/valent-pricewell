

<%@ page import="com.valent.pricewell.Staging" %>
<%
	def baseurl = request.siteUrl
%>
        <g:set var="entityName" value="${message(code: 'staging.label', default: 'Staging')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <script>
		
			jQuery(document).ready(function()
		 	{
			 
				jQuery("#stagingCreate").validate();
				
				jQuery("#saveStaging").click(function(){
					if(jQuery("#stagingCreate").valid()){
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/staging/save",
							data:jQuery("#stagingCreate").serialize(),
							success: function(data){
								if(data == "success"){
									refreshGeoGroupList();
								} else{
									jQuery('#stagingErrors').html(data);
									jQuery('#stagingErrors').show();
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
					}
					return false;
				}); 
				
				  
			});
		
			
		
		</script>
    
    <div class="body">
        
        <div>
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            	<div class="message">${flash.message}</div>
            </g:if>
			<div id="stagingErrors" class="errors" style="display: none;">
            </div>
            
            
            <g:form name="stagingCreate">
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="entity"><g:message code="staging.entity.label" default="Entity" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'entity', 'errors')}">
                                    <g:select name="entity" from="${com.valent.pricewell.Staging$StagingObjectType?.values()}" keys="${com.valent.pricewell.Staging$StagingObjectType?.values()*.name()}" value="${stagingInstance?.entity?.name()}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="sequenceOrder"><g:message code="staging.sequenceOrder.label" default="Sequence Order" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'sequenceOrder', 'errors')}">
                                    <g:textField name="sequenceOrder" value="${fieldValue(bean: stagingInstance, field: 'sequenceOrder')}" class="required" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="staging.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'description', 'errors')}">
                                    <g:textField name="description" value="${stagingInstance?.description}" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="displayName"><g:message code="staging.displayName.label" default="Display Name" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'displayName', 'errors')}">
                                    <g:textField name="displayName" value="${stagingInstance?.displayName}" class="required"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="staging.name.label" default="Name" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: stagingInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${stagingInstance?.name}" class="required"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><button id="saveStaging" title="Save Stage"> Save </button></span>
                </div>
            </g:form>
        </div>
    </div>

