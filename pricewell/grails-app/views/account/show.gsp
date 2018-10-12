
<%@ page import="com.valent.pricewell.Account" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'account.label', default: 'Account')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <g:setProvider library="prototype"/>
        
        <style>
       		.boxNew {
			   width: auto;
			   height: auto;
			   border-top: 1px solid #828282;
			   border-bottom: 1px solid #828282;
			   border-right: 1px solid #828282;
			   border-left: 1px solid #828282;
			   text-align: left;
			}
			
			.ImageBorder
			{
			    border-width: 3px;
			    border-color: #FF00FF;
			}
			.RightDiv{
				  width: 10%;
				  padding: 0 0px;
				  float: right;
				  
				 }
       </style>
       
       <script>

			 jQuery(document).ready(function()
			 {
			
				//jQuery('.edit').attr("title", "Edit");

			 });
			 
			 function changeUrl()
			 {
				window.location.href = '${baseurl}/account';
				return false;
			 }

			 function addContactFromAccount()
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/contact/addContactFromAccount",
						data: {'accountId': ${accountInstance.id} },
						success: function(data){jQuery("#contectFromAccount").html(data);}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				}

			 function addOpportunityFromAccount()
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/opportunity/addOpportunityFromAccount",
						data: {'accountId': ${accountInstance.id} },
						success: function(data){jQuery("#opportunityFromAccount").html(data);}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				}
	    </script>
    </head>
    <body>
        <div class="nav">
        	<g:form action="edit" method="post">
            	<g:hiddenField name="id" value="${accountInstance?.id}" />
            	
	           	<span><A HREF="javascript:history.go(-1)" title="Go Back" class="buttons.button button">Back</A></span>
	            <span><g:link action="list" title="List Of Accounts" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	            <span><g:link action="create" title="Create Account" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
	       		<g:if test="${updatePermission}">	
                	<span><button type="submit" class="buttons.button button" title="Edit Account" > <r:img dir="images" file="edit-24.png"/>  </button></span>      
           		</g:if>
           	</g:form>
        </div>
        <div class="body">
            <h2><g:message code="default.show.label" args="[entityName]" /></h2><hr>
            <!--<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>-->
            
            <div class="dialog" id= "look">
            	
                <table>
                    <tbody>
						<tr class="prop">
                            <td valign="top" class="name"><b><g:message code="account.accountName.label" default="Account Name : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "accountName")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
							
							<td valign="top" class="name"><b><g:message code="account.assignTo.label" default="Assign to : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "assignTo")}</td>
                        </tr>
                        
                        <tr>
                        	<td valign="top" class="name"><b><g:message code="account.logo.label" default="Logo : " /></b></td>
                            <td>
                        		<g:if test="${accountInstance?.logo?.id != null && isLogoAvailable}">
                        			<img src="<g:createLink controller='logoImage' action='renderImage' id='${accountInstance?.logo?.id}'/>" hight="80" width="100" />
                    			</g:if>
                			</td>
                        </tr>
                    </tbody>
                </table>
                <hr>
                <h1>Extra Information</h1>
                <table>
                	<tbody>
                   		<tr class="prop">
                            <td valign="top" class="name"><b><g:message code="account.website.label" default="Website : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "website")}</td>
							
							<td>&nbsp;&nbsp;</td>
							
							<td valign="top" class="name"><b><g:message code="account.email.label" default="Email : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "email")}</td>
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="account.phone.label" default="Phone : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "phone")}</td>
							
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="account.fax.label" default="Fax : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "fax")}</td>
                        </tr>
                    
                    	<tr class="prop">
                    		<td valign="top" class="name"><b><g:message code="account.createdBy.label" default="Created By : " /></b></td>
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${accountInstance?.createdBy?.id}">${accountInstance?.createdBy?.encodeAsHTML()}</g:link></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="account.dateCreated.label" default="Date Created : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${accountInstance?.dateCreated}" /></td>
                        </tr>
                        
                                                
                    </tbody>
                </table>
                <hr>
                <h1>Billing Address</h1>
                <table>
                	<tbody>
                		<tr class="prop">   
                            <td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 1 : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.billingAddress?.billAddressLine1}</td>
						</tr>
						<tr class="prop">	
							<td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 2 : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.billingAddress?.billAddressLine2}</td>
							
                        </tr>
 
 						<tr class="prop">
                    		<td valign="top" class="name"><b><g:message code="contact.city.label" default="City : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.billingAddress?.billCity}</td>
                            <td>&nbsp;&nbsp;</td>
                         	<td valign="top" class="name"><b><g:message code="contact.state.label" default="State : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.billingAddress?.billState}</td>
                         	
                         </tr>
 						
 						<tr class="prop">
                			<td valign="top" class="name"><b><g:message code="contact.postalcode.label" default="Postal Code : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.billingAddress?.billPostalcode}</td>
                    		<td>&nbsp;&nbsp;</td>
                    		<td valign="top" class="name"><b><g:message code="contact.country.label" default="Country : " /></b></td>
                            <td valign="top" class="value">
								<g:if test="${accountInstance?.billingAddress?.billCountry?.size() > 3}">
                            		${accountInstance?.billingAddress?.billCountry}
                        		</g:if>
                        		<g:elseif test="${accountInstance?.billingAddress?.billCountry?.size() == 3}">
                        			<g:country code="${accountInstance?.billingAddress?.billCountry}"/>
                    			</g:elseif>
                			</td>
                    		
                    	</tr>
 							
                	</tbody>
                </table>
				<hr>
                <h1>Shipping Address</h1>
                <table>
                	<tbody>
                		
                		 <tr class="prop">    
                            <td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 1 : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.shippingAddress?.shipAddressLine1}</td>
						</tr>
						<tr class="prop">
							<td valign="top" class="name"><b><g:message code="contact.address.label" default="Address Line 2 : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.shippingAddress?.shipAddressLine2}</td>                        
                        </tr>
                		
                		<tr class="prop">
                    		<td valign="top" class="name"><b><g:message code="contact.city.label" default="City : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.shippingAddress?.shipCity}</td>
                            <td>&nbsp;&nbsp;</td>
                        	<td valign="top" class="name"><b><g:message code="contact.state.label" default="State : " /></b></td>
                        	<td valign="top" class="value">${accountInstance?.shippingAddress?.shipState}</td>
                		
                        </tr>
                		
                		<tr class="prop">
                			<td valign="top" class="name"><b><g:message code="contact.postalcode.label" default="Postal Code : " /></b></td>
                            <td valign="top" class="value">${accountInstance?.shippingAddress?.shipPostalcode}</td>
                    		<td>&nbsp;&nbsp;</td>
                    		<td valign="top" class="name"><b><g:message code="contact.country.label" default="Country : " /></b></td>
                            <td valign="top" class="value">
                            	<g:if test="${accountInstance?.shippingAddress?.shipCountry?.size() > 3}">
                            		${accountInstance?.shippingAddress?.shipCountry}
                        		</g:if>
                        		<g:elseif test="${accountInstance?.shippingAddress?.shipCountry?.size() == 3}">
                        			<g:country code="${accountInstance?.shippingAddress?.shipCountry}"/>
                    			</g:elseif>
                            </td>
                    		
                    	</tr>
                		                       
                	</tbody>
                </table>
                
                <hr>
                <h1>Contacts</h1>
            	<div id="addContacts">
            		<ol>
            		   <table>
                       <g:each in="${accountInstance.contacts}" var="c">
                            
                            	<tr>
                        			<td>
                        				<g:link controller="contact" action="show" id="${c.id}">${c?.firstname?.encodeAsHTML()} ${c?.lastname?.encodeAsHTML()}</g:link>&nbsp;&nbsp;&nbsp;
                        			</td>
                        			<td>
                        				<b>Phone :</b> &nbsp; ${c?.phone}&nbsp;&nbsp;&nbsp;
                        			</td>
                        			<td>
                        				<b>Email :</b> &nbsp; ${c?.email}&nbsp;&nbsp;&nbsp;
                        			</td>
                    			</tr>
                    		
                       </g:each>
                       </table>  
                    </ol>
                    <span>	<!--<g:remoteLink class="buttons.button button" controller="contact" action="addContactFromAccount"
			 				update="[success:'contectFromAccount',failure:'contectFromAccount']" params="['accountId': accountInstance.id]">
							Add New Contact
						</g:remoteLink>-->
					
						<a id="idaddContactFromAccount" onclick="addContactFromAccount();" class="buttons.button button" title="Add New Contact">Add New Contact</a>
					</span>
                    <div id="contectFromAccount" class="boxNew">
        				
					</div>
                </div>
                    
                    
                
               <h1>Opportunities</h1> 
               <div>
               		<ol>
            		   <table>
	                       <g:each in="${accountInstance.opportunities}" var="c">
	                            
                            	<tr>
                        			<td>
                        				<g:link controller="opportunity" action="show" id="${c.id}">${c?.name?.encodeAsHTML()}</g:link>&nbsp;&nbsp;&nbsp;
                        			</td>
                        			<td>
                        				<b>Primary Contact :</b> &nbsp; <g:link controller="contact" action="show" id="${c?.primaryContact?.id}">${c?.primaryContact?.firstname} ${c?.primaryContact?.lastname}</g:link>&nbsp;&nbsp;&nbsp;
                        			</td>
                    			</tr>
	                    		
	                       </g:each>
                       </table>  
                    </ol>
                        
                    <span>	<!--<g:remoteLink class="buttons.button button" controller="opportunity" action="addOpportunityFromAccount"
			 				update="[success:'opportunityFromAccount',failure:'opportunityFromAccount']" params="['accountId': accountInstance.id]">
							Add New Opportunity
						</g:remoteLink>-->
						
						<a id="idaddOpportunityFromAccount" onclick="addOpportunityFromAccount();" class="buttons.button button" title="Add New Opportunity">Add New Opportunity</a>
					</span>
                    
                    <div id="opportunityFromAccount" class="boxNew"></div>
               </div>      
                 	
               <h1>Quotation</h1>
               <div>
               		<ol>
                		<g:each in="${accountInstance.quotations}" var="q">
                        	<li><g:link controller="quotation" action="show" id="${q.id}">${q?.encodeAsHTML()}</g:link></li>
                    	</g:each>
                    </ol>
               </div>
                
                
                <!--<tr class="prop">
                            <td valign="top" class="name"><g:message code="account.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: accountInstance, field: "id")}</td>
                            
                        </tr>
                    	<tr class="prop">
                            <td valign="top" class="name"><g:message code="account.dateModified.label" default="Date Modified" /></td>
                            
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${accountInstance?.dateModified}" /></td>
                            
                        </tr>
                    	<tr class="prop">
                            <td valign="top" class="name"><g:message code="account.modifiedBy.label" default="Modified By" /></td>
                            
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${accountInstance?.modifiedBy?.id}">${accountInstance?.modifiedBy?.encodeAsHTML()}</g:link></td>
                            
                        </tr>-->
                
            </div>
            <!--<div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${accountInstance?.id}" />
                    <span class="button"><g:actionSubmitImage class="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" action="edit" src="${resource(dir: 'images', file: 'edit-24.png')}" tooltip="Edit"/></span>
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" src="${resource(dir: 'images', file: 'delete-24.png')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>-->
            </div>
        </div>
    </body>
</html>
