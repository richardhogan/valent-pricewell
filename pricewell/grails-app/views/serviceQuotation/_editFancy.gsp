<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    
    </head>
    <body>
       
        <div class="body">
            <h1>Add Service to quotation</h1>  
            <g:hasErrors bean="${serviceQuotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceQuotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            
            <g:form action="update" >
                                  
                <g:hiddenField name="id" value="${serviceQuotationInstance?.id}"/>
                            
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="service"><g:message code="serviceQuotation.service.label" default="Service" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'service', 'errors')}">
                                	<g:hiddenField name="service.id" value="${serviceQuotationInstance?.service?.id}"/>
                                	<g:hiddenField name="profile.id" value="${serviceQuotationInstance?.service?.serviceProfile?.id}"/>
                                	${serviceQuotationInstance?.service?.serviceName}
                                </td>
                            
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="serviceQuotation.geo.label" default="Geo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'geo', 'errors')}">
                                    <g:select name="geo.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${serviceQuotationInstance?.geo?.id}" onchange="alert(document.getElementById('btnCalculate')); document.getElementById('btnCalculate').click();"/>
                                </td>
                                
                                <td valign="top" class="name">
                                    <label for="totalUnits"><g:message code="serviceQuotation.totalUnits.label" default="Total Units" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'totalUnits', 'errors')}">
                                    <g:textField name="totalUnits" value="${fieldValue(bean: serviceQuotationInstance, field: 'totalUnits')}" onchange="document.getElementById('btnCalculate').click();"/>
                                </td>
                                
                                <td valign="top" class="name">
                                    <label>Currency</label>
                                </td>
                                <td valign="top">
                                    <g:textField name="currency" value="${serviceQuotationInstance?.geo?.currency}" readOnly="true"/>
                                </td>
                                <td valign="top" class="name">
                                    <label for="price"><g:message code="serviceQuotation.price.label" default="Price" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'price', 'errors')}">
                                    <g:textField name="price" value="${fieldValue(bean: serviceQuotationInstance, field: 'price')}" readOnly="true"/>
                                </td>
                                
                                <td>
                                	<input id="btnCalculate" onclick="new Ajax.Updater('dvQutationServices','${baseurl}/serviceQuotation/displayCalculatedPriceInEdit',{asynchronous:true,evalScripts:true,parameters:Form.serialize(this.form)});return false" type="button" value="Refresh" class="button"></input>
                                </td>
                            </tr>
                     		
                       </tbody>
                    </table>
                           
                        
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="Update" />
                    					<g:link controller="quotation" action="show" class="show" value="Cancel" id="${serviceQuotationInstance?.quotation?.id}" params="[tab:'show']"> Cancel </g:link>
                    </span>
                </div>
            </g:form>
        </div>
    </body>
</html>
