
<%@ page import="com.valent.pricewell.Contact" %>

<html>

        
        
    <body>
        
        <div class="body">
        	<g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
            <h2>Lead Converted To Contact</h2><hr>
            <div class="dialog">
            	<table>
                    <tbody>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="contact.firstname.label" default="Firstname : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "firstname")}</td>
                           
							<td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.lastname.label" default="Lastname : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "lastname")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="contact.email.label" default="Email : " /></b></td>
		                    <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "email")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.phone.label" default="Phone : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "phone")}</td>
   							   
                        </tr>
                        
                        
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="contact.account.label" default="Account : " /></b></td>
		                    <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "account.accountName")}</td>
                        
                        	<td>&nbsp;&nbsp;</td>
                        	
                        	<td valign="top" class="name"><b><g:message code="contact.assignTo.label" default="Assign to : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "assignTo")}</td>
                        </tr>
                        
                        
                    </tbody>
                </table>
                <hr>
                <h1>Extra Information</h1>
                <table>
                	<tbody>
                        <tr class="prop">
                        	<td valign="top" class="name"><b><g:message code="contact.title.label" default="Title : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "title")}</td>
                        	
                        	<td>&nbsp;&nbsp;</td>
                        	
                            <td valign="top" class="name"><b><g:message code="contact.department.label" default="Department : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "department")}</td>
                            
                        </tr>
                                       
                        <tr class="prop">
                        	<td valign="top" class="name"><b><g:message code="contact.altEmail.label" default="Alternative Email : " /></b></td>
		                    <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "altEmail")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.mobile.label" default="Mobile : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "mobile")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="contact.createdBy.label" default="Created By : " /></b></td>
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${contactInstance?.createdBy?.id}">${contactInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.dateCreated.label" default="Date Created : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${contactInstance?.dateCreated}" /></td>
                        	
                        </tr>
                       
                        
                    </tbody>
                </table>
                <hr>
                <h1>Contact Address</h1>
                <table>
                	<tbody>
                		<tr class="prop">
                			<td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 1 : " /></b></td>
                            <td valign="top" class="value">${contactInstance?.billingAddress?.billAddressLine1}</td>
                			
                		</tr>
                		
                		<tr class="prop">
                			<td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 2 : " /></b></td>
                            <td valign="top" class="value">${contactInstance?.billingAddress?.billAddressLine2}</td>
                			
                		</tr>
                		<tr class="prop">
                    		<td valign="top" class="name"><b><g:message code="contact.city.label" default="City : " /></b></td>
                            <td valign="top" class="value">${contactInstance?.billingAddress?.billCity}</td>
                            <td>&nbsp;&nbsp;</td>
    						<td valign="top" class="name"><b><g:message code="contact.state.label" default="State : " /></b></td>
                            <td valign="top" class="value">${contactInstance?.billingAddress?.billState}</td>
                		
                        </tr>
                		 <tr class="prop">
                			<td valign="top" class="name"><b><g:message code="contact.postalcode.label" default="Postal Code : " /></b></td>
                            <td valign="top" class="value">${contactInstance?.billingAddress?.billPostalcode}</td>
                    		<td>&nbsp;&nbsp;</td>
                    		<td valign="top" class="name"><b><g:message code="contact.country.label" default="Country : " /></b></td>
                            <td valign="top" class="value">
                            	<g:if test="${contactInstance?.billingAddress?.billCountry?.size() > 3}">
                            		${contactInstance?.billingAddress?.billCountry}
                        		</g:if>
                        		<g:elseif test="${contactInstance?.billingAddress?.billCountry?.size() == 3}">
                        			<g:country code="${contactInstance?.billingAddress?.billCountry}"/>
                    			</g:elseif>
                            </td>
                    	</tr>
                		                        
                	</tbody>
                </table>
            </div>
        </div>
    </body>
</html>
