
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page {
    size: 8.5in 11in;  /* width height */
    margin: 0.25in;
} %>
<html>
    <body>        
        <div class="body yui-skin-sam">
            <h1>Quotation</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.account.label" default="Account Name" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: quotationInstance, field: "account")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.customerType.label" default="Customer Type" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: quotationInstance, field: "customerType")}</td>
                            
                        </tr>
                    
                        
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.geo.label" default="Geo" /></td>
                            
                            <td valign="top" class="value"><g:link controller="geo" action="show" id="${quotationInstance?.geo?.id}">${quotationInstance?.geo?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.totalQuotedPrice.label" default="Total Quoted Price" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: quotationInstance, field: "totalQuotedPrice")}</td>
                            
                        </tr>
                    	<tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.createdDate.label" default="Created Date" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.createdDate}" /></td>
                            
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.modifiedDate.label" default="Modified Date" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${quotationInstance?.modifiedDate}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.status.label" default="Status" /></td>
                            
                            <td valign="top" class="value">${quotationInstance?.status?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="quotation.createdBy.label" default="Created By" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${quotationInstance?.createdBy?.id}">${quotationInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
           
        <br/>
          
        </div>
    </body>
</html>