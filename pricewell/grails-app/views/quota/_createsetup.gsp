<%@ page import="com.valent.pricewell.Quota" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.SalesController" %>
<%@ page import="com.valent.pricewell.CompanyInformationController" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
<head>
	
		<script>
			 
				  jQuery(document).ready(function()
				  {				 
					    jQuery("#quotaCreate").validate();
					    jQuery("#quotaCreate input:text")[0].focus();
					    
					    jQuery('#name').keyup(function(){
						    this.value = this.value.toUpperCase();
						 });  
						
						jQuery("#saveQuota").click(function()
						{
							//loadValues();
							if(jQuery("#quotaCreate").validate().form())
							{
								showLoadingBox();
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/quota/save",
									data:jQuery("#quotaCreate").serialize(),
									success: function(data)
									{
										hideLoadingBox();
										if(data['result'] == "success"){
											refreshGeoGroupList();
										} 
										else if(data['result'] == "quotaAvailable" || data['result'] == "notInRange") {
											jAlert(data['message'], 'Create Quota Alert');
										}
										else{
											jQuery('#quotaErrors').html(data);
											jQuery('#quotaErrors').show();
										}
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){
										alert("Error while saving");
									}
								});
							}
							return false;
						}); 

						jQuery("#cancelQuota").click(function()
						{
							showLoadingBox();
							jQuery.post( '${baseurl}/quota/listsetup' , 
							  	{source: "firstsetup"},
						      	function( data ) 
						      	{
								  	hideLoadingBox();
						          	jQuery('#contents').html('').html(data);
						      	});
							return false;
						});	

						jQuery("#person\\.id").change(function() 
				    	{
				    	 
						  	/*jQuery.ajax({type:'POST',data: {id: this.value },
								 url:'${baseurl}/sales/getUserTerritoriesForQuota',
								 success:function(data,textStatus){jQuery('#userTerritoryList').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});*/
							return false;
						  
						});

						
				  });
				  
  		</script>
	</head>
    <body>
			
        <div class="body">
			<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<div id="quotaErrors" class="errors" style="display: none;">
            </div>
                      
            <div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Add New Quota</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
			
		            <g:form action="save" name="quotaCreate" >
						<g:hiddenField name="source" value="${source}"/>
						<div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="person"><g:message code="quota.person.label" default="Assign Sales Person" /><em>*</em></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'person', 'errors')}">
		                                    <g:select name="person.id" class="personId" from="${new SalesController().generateAssignedToListForQuota()}"  value="" noSelection="['': 'Select Any One']" class="required"/>
		                                </td>
		                            </tr>

									<!-- <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="territory"><g:message code="quota.territory.label" default="Territory" /><em>*</em></label>
		                                </td>
		                                <td valign="top">
		                                	<div id="userTerritoryList">
		                                		<g:select name="territoryId" from=""  value="" noSelection="['': 'Select Any One']" class="required"/>
		                                	</div>
		                                </td>
		                                
		                                <td>&nbsp;&nbsp;</td>
		                                
		                                <td valign="top" class="name">
		                                    <label for="currency"><g:message code="quota.currency.label" default="Currency" /><em>*</em></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'currency', 'errors')}">
		                                    <g:textField name="currency" value="${quotaInstance?.currency}" class="required" readOnly="true"/>
		                                </td>
		                            </tr>-->
		                            		                            
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="timespan"><g:message code="quota.timespan.label" default="Time Duration" /><em>*</em></label>
		                                </td>
		                                <td>
		                                    <g:select name="timespan" from="['First to this quarter', 'Previous to this quarter',
		                                    								 'First quarter', 'Previous quarter', 'This quarter',
		                                    								 'Next quarter', 'Last quarter', 'This to next quarter',
		                                    								 'This to last quarter', 'Previous year', 'This year', 'Next year']"  value='This quarter' noSelection="['': 'Select Any One...']" class="required"/>
		                                </td>
		                            </tr>
		                             
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quota.amount.label" default="Amount" /><em>*</em></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'amount', 'errors')}">
		                                    <g:textField name="amount" value="${fieldValue(bean: quotaInstance, field: 'amount')}" class="required" />
		                                    <g:textField name="currency" value="${new CompanyInformationController().getBaseCurrency()}" class="required" readOnly="true"/>
		                                </td>
		                            </tr>
		                        
		                                               
		                        </tbody>
		                    </table>	
		                    	                  
		                </div>
		                <div class="buttons">
		                	<span class="button"><button id="saveQuota" title="Save Quota"> Save </button></span>
		                	<span class="button"><button id="cancelQuota" title="Cancel"> Cancel </button></span>
	                    </div>
		            </g:form>
	            
	            </div>
            </div>
				
        </div>
    </body>
</html>
