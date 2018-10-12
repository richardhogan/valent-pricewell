
<%@ page import="com.valent.pricewell.ServiceQuotationTicket" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.UserSetupController" %>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'serviceQuotationTicket.label', default: 'Service Ticket')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <script>
		   	jQuery(function() 
		   	{
		   		jQuery( "#correctIdBtn" ).click(function() 
				{
					jQuery.ajax({type:'POST',
						 url:'${baseurl}/serviceQuotationTicket/correctTicketId',
						 data: {id: ${serviceQuotationTicketInstance?.id}},
						 success:function(data,textStatus)
						 {
							 jQuery('#dvCorrectTicketId').html(data);
							 
						},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					return false;
				});
			   	
		   	});
	   	</script>
    </head>
    <body>
        <div class="nav">
            <!-- <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span> -->
            <span><g:link class="buttons.button button" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <!-- <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span> -->
        </div>
        <div class="body">
            <h1><b>Service Ticket : ${serviceQuotationTicketInstance?.summary}</b></h1><hr/>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                     
                        <tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.summary.label" default="Summary" /></label></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationTicketInstance, field: "summary")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.ticketId.label" default="Ticket Id (In Connectwise)" /></label></td>
                            
                            <td valign="top" class="value">
                            	<div id="dvCorrectTicketId">
                            		${serviceQuotationTicketInstance?.ticketId?.encodeAsHTML()}
                            		<g:if test="${new UserSetupController().isSuperAdmin()}">
                            			<button id="correctIdBtn" title="Correct Ticket Id" class="buttons.button button">Correct</button>
                           			</g:if>
                            	</div>
                           	</td>
                            
                        </tr>
                    </tbody>
                </table>
                
                <table>
                	<tbody>
                    
                    	<tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.opportunity.label" default="Opportunity" /></label></td>
                            
                            <td valign="top" class="value"><g:link controller="opportunity" class="hyperlink" action="show" id="${serviceQuotationTicketInstance?.serviceQuotation.quotation.opportunity?.id}">${serviceQuotationTicketInstance?.serviceQuotation.quotation.opportunity.name?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.service.label" default="Service" /></label></td>
                            
                            <td valign="top" class="value">${serviceQuotationTicketInstance?.serviceActivity.serviceDeliverable.serviceProfile.service.serviceName?.encodeAsHTML()}</td>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.role.label" default="Role" /></label></td>
                            
                            <td valign="top" class="value">${serviceQuotationTicketInstance?.role?.encodeAsHTML()}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.serviceActivity.label" default="Service Activity" /></label></td>
                            
                            <td valign="top" class="value">${serviceQuotationTicketInstance?.serviceActivity?.encodeAsHTML()}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.budgetHours.label" default="Budget Hours" /></label></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationTicketInstance, field: "budgetHours")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.actualHours.label" default="Actual Hours" /></label></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: serviceQuotationTicketInstance, field: "actualHours")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.createdBy.label" default="Created By" /></label></td>
                            
                            <td valign="top" class="value">${serviceQuotationTicketInstance?.createdBy?.encodeAsHTML()}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.modifiedBy.label" default="Modified By" /></label></td>
                            
                            <td valign="top" class="value">${serviceQuotationTicketInstance?.modifiedBy?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.createdDate.label" default="Created Date" /></label></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${serviceQuotationTicketInstance?.createdDate}" /></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.modifiedDate.label" default="Modified Date" /></label></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${serviceQuotationTicketInstance?.modifiedDate}" /></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label><g:message code="serviceQuotationTicket.status.label" default="Status" /></label></td>
                            
                            <td valign="top" class="value">${serviceQuotationTicketInstance?.status?.encodeAsHTML()}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <!-- <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${serviceQuotationTicketInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>-->
        </div>
    </body>
</html>
