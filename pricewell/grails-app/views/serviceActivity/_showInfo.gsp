<%@ page import="com.valent.pricewell.ServiceDeliverable" %>
<%@ page import="com.valent.pricewell.ServiceActivity" %>

<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>
		<script>
			jQuery(function() 
			{
				jQuery("#editActivity").validate();			   
	
				jQuery("#btnEditInfo").click(function()
				{
			    	jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/serviceActivity/editInfo",
						data: {id: ${serviceActivityInstance.id}},
						success: function(data)
						{
							jQuery('#dvInfo').html(data);
							jQuery("#dvInfo").dialog("open");
							//hideUnhideNextBtn();
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert(errorThrown);
						}
					});
	   				return false;
					
				}); 

				jQuery("#btnActivityTasks").click(function()
				{
			    	jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/serviceActivity/displayActivityTasks",
						data: {id: ${serviceActivityInstance.id}},
						success: function(data)
						{
							jQuery('#dvDisplayActivityTasks').html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert(errorThrown);
						}
					});
	   				return false;
					
				}); 

				jQuery( "#dvInfo" ).dialog(
				{
					height: 350,
					width: 1000,
					modal: true,
					autoOpen: false,
					buttons: {
						'Update Info': function() 
						{
							if(jQuery('#editActivity').validate().form())
							{
						    	jQuery.ajax(
								{
									type: "POST",
									url: "${baseurl}/serviceActivity/updateFromDeliverable",
									data: jQuery("#editActivity").serialize(),
									success: function(data)
									{
										jQuery('#delActivity').html(data);
										jQuery( "#dvInfo" ).dialog("close");	
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){
										alert(errorThrown);
									}
								});
			   				}
							return false;
						}
					},
					close: function( event, ui ) {
						jQuery(this).html('');
					}
					
				});
				
			});
  		</script>


<div class="body">
	
		
		<div id="dvInfo" title="Edit Activity Info"></div>
		<div class="list">
		    <table>
		        
		            <tr>
		                <td><label>${message(code: 'serviceActivity.sequenceOrder.label', default: 'Order')}</label>: 
		                	${fieldValue(bean: serviceActivityInstance, field: "sequenceOrder")}</td>
						
						<td><label>${message(code: 'serviceActivity.category.label', default: 'Category')}</label>: 
							${fieldValue(bean: serviceActivityInstance, field: "category")}</td>
						
		                <td><label>${message(code: 'serviceActivity.name.label', default: 'Name')}</label>: 
		                	${fieldValue(bean: serviceActivityInstance, field: "name")}</td>
						
						<td><label>Description</label>: 
							${fieldValue(bean: serviceActivityInstance, field: "description")}</td>
					
						<!-- <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							
						<td><label>Results</label></td><td>&nbsp;&nbsp;</td>
						<td>${fieldValue(bean: serviceActivityInstance, field: "results")}</td>-->
		            </tr>
		        
		        
		    </table>
		    
		    <div class="buttons">
		   		<g:if test="${edit == true}">
		           	
		           <button id="btnEditInfo" class="btnEditInfo" title="Edit Info">Edit Info</button>
		           
		           <button id="btnActivityTasks" class="btnActivityTasks" title="Activity Tasks">Tasks</button>
		           
		        </g:if>
		    </div>
		    
		    <div id="dvDisplayActivityTasks">
		    
		    </div>
		</div>
	</div>