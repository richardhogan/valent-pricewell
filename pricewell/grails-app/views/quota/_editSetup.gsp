<%@ page import="com.valent.pricewell.Quota" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.User" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
%>
<head>
  
  <script>
	  jQuery(document).ready(function()
	  {		    
	  		jQuery("#quotaUpdate").validate();

	  		jQuery("#quotaUpdate input:text")[0].focus();
	  		
	  		jQuery("#saveQuota").click(function(){
				if(jQuery("#quotaUpdate").validate().form())
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/quota/update",
						data:jQuery("#quotaUpdate").serialize(),
						success: function(data)
						{
							hideLoadingBox();
							if(data['result'] == "success")
							{
								jQuery("#editDialog").dialog( "close" );    		                   		
		                   		jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
								jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
								jQuery(".resultDialog").html('Quota edited successfully.'); 
								
								refreshGeoGroupList("firstsetup");
							} 
							else if(data['result'] == "noChanges")
							{
								jQuery("#editDialog").dialog( "close" );    		                   		
		                   		refreshGeoGroupList("firstsetup");
							}
							else if(data['result'] == "notInRange")
							{
								jAlert(data['message'], 'Edit Quota Alert');
							}else{
								jQuery("#editDialog").dialog( "close" );
								jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
								jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
								jQuery(".resultDialog").html("Failed to edit Quota."); 
								
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

	  		jQuery("#territoryId").change(function() 
	    	{
	    	 
			  	jQuery.ajax({type:'POST',data: {id: this.value },
					 url:'${baseurl}/geo/getCurrency',
					 success:function(data,textStatus){jQuery('#currency').val(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			  
			});
	  });
		    
  </script>
</head>

<body>

	
	<div class="collapsibleContainer">
		<div class="collapsibleContainerTitle ui-widget-header">
			<div>Edit Quota</div>
		</div>
	
		<div class="collapsibleContainerContent ui-widget-content">
	
		  	<g:form name="quotaUpdate">
			    <g:hiddenField name="id" value="${quotaInstance?.id}" />
			    <g:hiddenField name="version" value="${quotaInstance?.version}" />
			    <g:hiddenField name="source" value="${source}" />
				<div class="dialog">
			    	<table>
				      	<tbody>
							<tr class="prop">
		                        <td valign="top" class="name">
		                          <label for="person"><g:message code="quota.person.label" default="Assigned To" /></label>
		                        </td>
		                        <td>&nbsp;&nbsp;</td>
		                        <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'person', 'errors')}">
		                            ${quotaInstance?.person}
		                        </td>
		                    </tr>
		                    <!--<g:if test="${loginUser?.username == 'superadmin' }">
		                    	<tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="territory"><g:message code="quota.territory.label" default="Territory" /><em>*</em></label>
	                                </td>
	                                <td>&nbsp;&nbsp;</td>
	                                <td valign="top">
	                                	<div id="userTerritoryList">
	                                		<g:select name="territoryId" from="${territoryList?.sort {it.name}}"  value="${quotaInstance?.territory?.id}" optionKey="id" optionValue="name" noSelection="['': 'Select Any One']" class="required"/>
	                                	</div>
	                                </td>
	                                
	                                <td>&nbsp;&nbsp;</td>
	                                
	                                <td valign="top" class="name">
	                                    <label for="currency"><g:message code="quota.currency.label" default="Currency" /><em>*</em></label>
	                                </td>
	                                <td>&nbsp;&nbsp;</td>
	                                <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'currency', 'errors')}">
	                                    <g:textField name="currency" value="${quotaInstance?.currency}" class="required" readOnly="true"/>
	                                </td>
	                            </tr>
		                    </g:if>-->
		                            
		                    <tr class="prop">
		                        <td valign="top" class="name">
		                          <label for="timespan"><g:message code="quota.timespan.label" default="Time Duration" /></label>
		                        </td>
		                        <td>&nbsp;&nbsp;</td>
		                        <td>
		                           <g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.fromDate}" /> To <g:formatDate format="MMMMM d, yyyy" date="${quotaInstance?.toDate}" />
		                        </td>
		                    </tr>
		                    
					      	<tr class="prop">
		                        <td valign="top" class="name">
		                          <label for="amount"><g:message code="quota.amount.label" default="Amount" /><em>*</em></label>
		                        </td>
		                        <td>&nbsp;&nbsp;</td>
		                        <td valign="top" class="value ${hasErrors(bean: quotaInstance, field: 'amount', 'errors')}">
		                            <g:textField name="amount" value="${fieldValue(bean: quotaInstance, field: 'amount')}" class="required"/> &nbsp;&nbsp; ${quotaInstance?.currency}
		                        </td>
		                    </tr>
				      	</tbody>
			    	</table>
			    </div>
				<div class="buttons">
			       <span class="button"><button title="Update Quota" id="saveQuota"> Save </button></span>
			       <span class="button"><button id="cancelQuota" title="Cancel"> Cancel </button></span>
			    </div>
		  	</g:form>
	
		</div>
    </div>
	
</body>
