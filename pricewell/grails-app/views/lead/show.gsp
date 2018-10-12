
<%@ page import="com.valent.pricewell.Lead" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'lead.label', default: 'Lead')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
            <span class="mybutton"><A HREF="javascript:history.go(-1)">Back</A></span>
            <span class="mybutton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="mybutton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h2><g:message code="default.show.label" args="[entityName]" /></h2><hr>
            <!--<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>-->
            
            <g:render template="stageProgress" model="['leadInstance': leadInstance, 'stagingInstanceList': stagingInstanceList]"> </g:render>
            
            <div class="dialog">
                <table>
                    <tbody>
                    
                        <!--<tr class="prop">
                            <td valign="top" class="name"><g:message code="lead.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "id")}</td>
                            
                        </tr>-->
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="lead.firstname.label" default="Firstname : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "firstname")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="lead.lastname.label" default="Lastname : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "lastname")}</td>
                        </tr>
                    
                    	<tr class="prop">
                            <td valign="top" class="name"><b><g:message code="lead.email.label" default="Email : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "email")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="lead.phone.label" default="Phone : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "phone")}</td>
                        </tr>
                        
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="lead.status.label" default="Status : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "status")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="lead.assignTo.label" default="Assign to : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "assignTo")}</td>
                        
                        	<td>&nbsp;&nbsp;</td>
                        	
                        	<td><b>Change Stage To : </b></td>
                        	<td>
                        		<g:if test="${leadInstance.stagingStatus.name=='uncontacted'}">
                        			<g:link class="hyperlink" action="changeStage" params="[id: leadInstance.id, toStage: 'contacted']">Contacted</g:link>  
                        		</g:if>
                        		
                        		<g:if test="${leadInstance.stagingStatus.name=='contactinprogress'}">
                        			<g:link class="hyperlink" action="changeStage" params="['id': leadInstance.id, 'toStage': 'converted']">Convert To Opportunity</g:link> <b>OR</b> <g:link class="hyperlink" action="changeStage" params="[id: leadInstance.id, toStage: 'dead']">Mark It Dead Lead</g:link>
                        		</g:if>
         					</td>
                        	
                        </tr>
                    </tbody>
                </table>
                <hr>
                <h1>Contact Information</h1>
                <table>
                	<tbody>
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="lead.title.label" default="Title : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "title")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="lead.company.label" default="Company : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "company")}</td>
                        </tr>
                    	
                    	<tr class="prop">
                        	<td valign="top" class="name"><b><g:message code="lead.altEmail.label" default="Alternative Email : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "altEmail")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="lead.mobile.label" default="Mobile : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: leadInstance, field: "mobile")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="lead.createdBy.label" default="Created By : " /></b></td>
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${leadInstance?.createdBy?.id}">${leadInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="lead.dateCreated.label" default="Date Created : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${leadInstance?.dateCreated}" /></td>
                        </tr>
                    
                    	<!--<tr class="prop">
                            <td valign="top" class="name"><g:message code="lead.modifiedBy.label" default="Modified By" /></td>
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${leadInstance?.modifiedBy?.id}">${leadInstance?.modifiedBy?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="lead.dateModified.label" default="Date Modified" /></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${leadInstance?.dateModified}" /></td>
                            
                        </tr>-->
                    
                    </tbody>
                </table>
                <hr>
                <h1>Contact Address</h1>
                <table>
                	<tbody>
                		<tr class="prop">
                    		
                    		<td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 1 : " /></b></td>
                            <td valign="top" class="value">${leadInstance?.billingAddress?.billAddressLine1}</td>
                        </tr>
                    	<tr class="prop">
                    		
                    		<td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 2 : " /></b></td>
                            <td valign="top" class="value">${leadInstance?.billingAddress?.billAddressLine2}</td>
                        </tr>	
                    		<td valign="top" class="name"><b><g:message code="contact.city.label" default="City : " /></b></td>
                            <td valign="top" class="value">${leadInstance?.billingAddress?.billCity}</td>
                           <td>&nbsp;&nbsp;</td>
                    		<td valign="top" class="name"><b><g:message code="contact.state.label" default="State : " /></b></td>
                            <td valign="top" class="value">${leadInstance?.billingAddress?.billState}</td>
                    		
						</tr>
                    	
                    	<tr class="prop">
                    		<td valign="top" class="name"><b><g:message code="contact.postalcode.label" default="Postal Code : " /></b></td>
                            <td valign="top" class="value">${leadInstance?.billingAddress?.billPostalcode}</td>
                    		<td>&nbsp;&nbsp;</td>
                            <td valign="top" class="name"><b><g:message code="contact.country.label" default="Country : " /></b></td>
                            <td valign="top" class="value">
                            	<g:if test="${leadInstance?.billingAddress?.billCountry?.size() > 3}">
                            		${leadInstance?.billingAddress?.billCountry}
                        		</g:if>
                        		<g:elseif test="${leadInstance?.billingAddress?.billCountry?.size() == 3}">
                        			<g:country code="${leadInstance?.billingAddress?.billCountry}"/>
                    			</g:elseif>
                        	</td>
                            
                        </tr>
                        
                	</tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${leadInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
