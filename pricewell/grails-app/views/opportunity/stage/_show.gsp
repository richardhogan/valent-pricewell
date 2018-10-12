
<%@ page import="com.valent.pricewell.Opportunity" %>
<%
	def baseurl = request.siteUrl
%>
    
        
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <g:set var="today" value="new Date()" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        
        <script>

			 jQuery(document).ready(function(){
	
					
			 });
			 
			function changeUrl()
			{
				window.location.href = '${baseurl}/opportunity';
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
    
    <%
		def today = new Date();
	%>
        
        <div class="body ">
	        <div id="dvopportunity">
	            <!--<g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
	            </g:if>-->
            
            	
	            <div class="dialog collapse">
	            	
	                <table>
	                    <tbody>	
	                    
	                       <!-- <tr class="prop">
	                            <td valign="top" class="name"><g:message code="opportunity.id.label" default="Id" /></td>
	                            
	                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "id")}</td>
	                            
	                        </tr>-->
	                    
	                        <tr class="prop">
	                            
	                            <td valign="top" class="name"><b><g:message code="opportunity.assignTo.label" default="Assign To : " /></b></td>
	                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "assignTo")}</td>
	                            
	                            <td>&nbsp;&nbsp;</td>
	                            
	                            <td valign="top" class="name"><b><g:message code="opportunity.createdBy.label" default="Created By : " /></b></td>
	                            <td valign="top" class="value"><g:link controller="user" action="show" id="${opportunityInstance?.createdBy?.id}">${opportunityInstance?.createdBy?.encodeAsHTML()}</g:link></td>
	                            
	                            <td>&nbsp;&nbsp;</td>
	                            
	                            <td valign="top" class="name"><b><g:message code="opportunity.dateModified.label" default="Date Modified : " /></b></td>
	                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance?.dateModified}" /></td>
	                        </tr>
	                    
	                    	<tr class="prop">
	                            	                         	
	                         	<!--<g:if test="${opportunityInstance.stagingStatus.name=='negotiationReview'}">
	                         	 
		                         	<g:if test="${opportunityInstance.stagingStatus.name!='closedWon' && opportunityInstance.stagingStatus.name!='closedLost'}">
		                        		<td><b>Change Stage To : </b></td>
		                        	</g:if>
		                            <td>
		                            	<g:if test="${opportunityInstance.stagingStatus.name=='negotiationReview'}">
		                            		<g:link class="hyperlink" action="changeStage" params="[id: opportunityInstance.id, source: 'closedWon']">Closed Won</g:link> <b>OR</b> <g:link class="hyperlink" action="changeStage" params="[id: opportunityInstance.id, source: 'closedLost']">Closed Lost</g:link>
		                            	</g:if>
		                            	<g:elseif test="${opportunityInstance.stagingStatus.name=='closedWon'}">
		                            	</g:elseif>
		                            	<g:else>
		                            		<g:link class="hyperlink" action="changeStage" controller="opportunity" params="[id: opportunityInstance.id, toStage: nextStage?.name]">${nextStage?.displayName}</g:link></td>
		                            	</g:else>
		                         </g:if>   	-->
	                        </tr>
	                        
	                        <tr class="prop">
	                            
	                        </tr>
	                    </tbody>
	                 </table>
	                 <!--<hr>
	                 <table>
	                 	<tbody>
	                        
	                        <tr class="prop">
	                        	<td valign="top" class="name"><b><g:message code="opportunity.closeDate.label" default="Close Date : " /></b></td>
	                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance?.closeDate}" /></td>
	                            
	                            <td>&nbsp;&nbsp;</td>
	                            
	                            <td valign="top" class="name"><b><g:message code="opportunity.probability.label" default="Probability(%) : " /></b></td>
	                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "probability")}</td>
	                        </tr>
	                    
	                        <tr class="prop">
	                        	<td valign="top" class="name"><b><g:message code="opportunity.amount.label" default="Amount : " /></b></td>
	                            <td valign="top" class="value">${opportunityInstance?.geo?.currencySymbol}${fieldValue(bean: opportunityInstance, field: "amount")}</td>
	                            
	                            <td>&nbsp;&nbsp;</td>
	                            
	                            <td valign="top" class="name"><b><g:message code="opportunity.discount.label" default="Discount(%) : " /></b></td>
	                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "discount")}</td>
	                            
	                        </tr>
	                                       
	                        <tr class="prop">
	                            <td valign="top" class="name"><b><g:message code="opportunity.createdBy.label" default="Created By : " /></b></td>
	                            <td valign="top" class="value"><g:link controller="user" action="show" id="${opportunityInstance?.createdBy?.id}">${opportunityInstance?.createdBy?.encodeAsHTML()}</g:link></td>
	                            
	                            <td>&nbsp;&nbsp;</td>
	                            
	                            <td valign="top" class="name"><b><g:message code="opportunity.dateCreated.label" default="Date Created : " /></b></td>
	                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance?.dateCreated}" /></td>
	                        </tr>
	                                        
	                    </tbody>
	                </table>-->
	            </div>
				
				<g:if test="${opportunityInstance?.stagingStatus?.name != 'closedWon' && opportunityInstance?.stagingStatus?.name != 'closedLost' && opportunityInstance?.closeDate > today}">
		                    
		            <div class="actionBar">
		                <g:form>
		                    <g:hiddenField name="id" value="${opportunityInstance?.id}" />
		                    
		                    <g:if test="${opportunityInstance?.stagingStatus?.name != 'prospecting' && opportunityInstance?.stagingStatus?.name != 'closedWon' && opportunityInstance?.stagingStatus?.name != 'closedLost'}">
		        				<span><a class="previousButton" href="${baseurl}/opportunity/changeStage?id=${opportunityInstance.id}&source=previousStage" title="Go To Previous Stage">< Back</a></span>
		        			</g:if>
		        			
		        			<g:if test="${opportunityInstance?.stagingStatus?.name != 'closedWon' && opportunityInstance?.stagingStatus?.name != 'closedLost'}">
			                    <!--<span>	<g:remoteLink controller="opportunity" action="edit" class="edit"
						 				update="[success:'dvopportunity',failure:'dvopportunity']" params="[id: opportunityInstance?.id]" tooltip="Edit">
										<img src="${resource(dir: 'images', file: 'edit-24.png',absolute: true )}" />
									</g:remoteLink>
								</span>
								
			                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
			               		-->
			               		<span><a class="nextButton" href="${baseurl}/opportunity/changeStage?id=${opportunityInstance.id}&source=nextStage" title="Go To Next Stage">Continue</a></span>
		        			
		        			</g:if>
		        			
		                </g:form>
		            </div>
	            </g:if>
	            
           </div>
        </div>
    

