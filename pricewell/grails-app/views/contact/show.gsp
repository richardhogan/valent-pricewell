
<%@ page import="com.valent.pricewell.Contact" %>

<html>
<%
	def baseurl = request.siteUrl
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <style>	
			.RightDiv{
				  width: 10%;
				  padding: 0 0px;
				  float: right;
				  
				 } 
		</style>
		
        <script>

			 jQuery(document).ready(function()
			 {
			
				 jQuery('.edit').attr("title", "Edit");
			 });
			 
			 function changeUrl()
			 {
				window.location.href = '${baseurl}/contact';
				return false;
			 }
	    </script>
    </head>
    <body>
        <div class="nav">
        	
        	<g:form action="edit" method="post">
            	<g:hiddenField name="id" value="${contactInstance?.id}" />
            
	            <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
	            <span><A HREF="javascript:history.go(-1)" title="Go Back" class="buttons.button button">Back</A></span>
	            <span><g:link class="buttons.button button" title="List Of Contacts" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	            <span><g:link class="buttons.button button" title="Create Contact" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
	            <g:if test="${updatePermission}">
	            	<span><button type="submit" class="buttons.button button" title="Edit Contact" > <r:img dir="images" file="edit-24.png"/>  </button></span>
	            </g:if>
            </g:form>
        </div>
        <div class="body">
            <h2><g:message code="default.show.label" args="[entityName]" /></h2><hr>
            <!--<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>-->
            <div class="dialog">
            	
            	
	            	
                <table>
                    <tbody>
                    
                       <!-- <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="contact.id.label" default="Id" /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "id")}</td>
                        </tr>-->
                    
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
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.fax.label" default="Fax : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: contactInstance, field: "fax")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="contact.createdBy.label" default="Created By : " /></b></td>
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${contactInstance?.createdBy?.id}">${contactInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.dateCreated.label" default="Date Created : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${contactInstance?.dateCreated}" /></td>
                        	
                        </tr>
                       
                        <!-- 
                    	
                        <tr class="prop">
                        	<td valign="top" class="name"><b><g:message code="contact.dateCreated.label" default="Date Created : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${contactInstance?.dateCreated}" /></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="contact.dateModified.label" default="Date Modified : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${contactInstance?.dateModified}" /></td>
                        </tr>-->
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
