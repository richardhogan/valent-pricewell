
<%@ page import="com.valent.pricewell.Lead" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        
        <g:set var="entityName" value="${message(code: 'lead.label', default: 'Lead')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <script>

			 jQuery(document).ready(function(){
	
					
			 });
			 function changeUrl()
			 {
				window.location.href = '${baseurl}/lead';
				return false;
			 }
		</script>
		
		<style>	
			.RightDiv{
				  width: 10%;
				  padding: 0 0px;
				  float: right;
				  
				 } 
		</style>
    </head>
    <body>
        <div class="body">
        	<div id="dvlead">
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
	                        	<!--
		                        	<g:if test="${leadInstance.stagingStatus.name=='uncontacted' || leadInstance.stagingStatus.name=='contactinprogress'}">
		                        		<td><b>Change Stage To : </b></td>
		                        	</g:if>
		                        	<td>
		                        		<g:if test="${leadInstance.stagingStatus.name=='uncontacted'}">
		                        			<g:link class="hyperlink" action="changeStage" params="[id: leadInstance.id, toStage: 'contacted']">Contacted</g:link>  
		                        		</g:if>
		                        		
		                        		<g:if test="${leadInstance.stagingStatus.name=='contactinprogress'}">
		                        			<g:link class="hyperlink" action="changeStage" params="[id: leadInstance.id, toStage: 'converttoopportunity']">Convert To Opportunity</g:link> <b>OR</b> <g:link class="hyperlink" action="changeStage" params="[id: leadInstance.id, toStage: 'dead']">Mark It Dead Lead</g:link>
		                        		</g:if>
		         					</td>
	                    		-->
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
	            <g:if test="${updatePermission && leadInstance.stagingStatus.name != 'converttoopportunity' && leadInstance?.stagingStatus?.name != 'converted' && leadInstance?.stagingStatus?.name != 'dead'}">
		            <div class="actionBar">
		                <g:form>
		                    <g:hiddenField name="id" value="${leadInstance?.id}" />
		                    	<!--<span>	<g:remoteLink controller="lead" action="edit" class="edit"
						 				update="[success:'dvlead',failure:'dvlead']" params="[id: leadInstance?.id]" tooltip="Edit">
										<img src="${resource(dir: 'images', file: 'edit-24.png',absolute: true )}"  />
									</g:remoteLink>
								</span>
								
			                    <span class="menuButton"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
			                	-->
		                		<span><a class="nextButton" href="${baseurl}/lead/changeStage?id=${leadInstance.id}&source=nextStage" title="Go To Next Stage">Continue</a></span>
		        			
		                
		                </g:form>
		            </div>
	            </g:if>
            </div>
        </div>
    </body>
</html>
