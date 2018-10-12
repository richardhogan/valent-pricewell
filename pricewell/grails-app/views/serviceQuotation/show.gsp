
<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceQuotation.label', default: 'ServiceQuotation')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <link rel='stylesheet' type='text/css' href='${baseurl}/js/yui-cms/2.1/accordion/assets/accordion.css'/>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body yui-skin-sam">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationInstance, field: "id")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.service.label" default="Service" /></td>
                            
                            <td valign="top" class="value"><g:link controller="service" action="show" id="${serviceQuotationInstance?.service?.id}">${serviceQuotationInstance?.service?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.baseUnits.label" default="Base Units" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationInstance, field: "baseUnits")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.additionalUnits.label" default="Additional Units" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationInstance, field: "additionalUnits")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.geo.label" default="Geo" /></td>
                            
                            <td valign="top" class="value"><g:link controller="geo" action="show" id="${serviceQuotationInstance?.geo?.id}">${serviceQuotationInstance?.geo?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.price.label" default="Price" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationInstance, field: "price")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.quotation.label" default="Quotation" /></td>
                            
                            <td valign="top" class="value"><g:link controller="quotation" action="show" id="${serviceQuotationInstance?.quotation?.id}">${serviceQuotationInstance?.quotation?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="serviceQuotation.profile.label" default="Profile" /></td>
                            
                            <td valign="top" class="value"><g:link controller="serviceProfile" action="show" id="${serviceQuotationInstance?.profile?.id}">${serviceQuotationInstance?.profile?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${serviceQuotationInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
