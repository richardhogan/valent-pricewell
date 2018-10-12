<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

		
        <script>
		
			jQuery(document).ready(function()
		 	{
			 					
				jQuery('.doMapping').click(function()
				{
				     var id = this.id.substring(8);

				     /*if(jQuery("#roleName-"+id).val() == "")
					 {
				    	 jAlert('Please select Role first.', 'Alert');
				    	 return false;
					 }
				     else
					 {*/
						var selectedRole = jQuery("#roleName-"+id).val();
						jQuery("#finalRole-"+id).val(selectedRole);
						jQuery("#roleName-"+id).addClass( "required" );
					 //}
					 
				});

				jQuery('.createNew').click(function(){

					var id = this.id.substring(8);
					jQuery("#roleName-"+id).val("");
					jQuery("#finalRole-"+id).val("");
					jQuery("#roleName-"+id).removeClass( "required" );
				    
				});

				jQuery(".roleName").change(function() 
		    	{
			    	var id = this.id.substring(9);
			    	if(jQuery(this).val() != "" && jQuery(this).val() != null)
					 {
						jQuery('input:radio[class=doMapping][id=myGroup-'+id+']').prop('checked', true);
						var selectedRole = jQuery("#roleName-"+id).val();
						jQuery("#finalRole-"+id).val(selectedRole);

						if(!jQuery("#roleName-"+id).hasClass( "required" ))
						{
							jQuery("#roleName-"+id).addClass( "required" );
						}
					 }
					else
					{
						
						jQuery('input:radio[class=doMapping][id=myGroup-'+id+']').prop('checked', false);
						jQuery('input:radio[class=createNew][id=myGroup-'+id+']').prop('checked', true);
						jQuery("#finalRole-"+id).val("");
						jQuery("#roleName-"+id).removeClass( "required" );
					}
				  	
				  
				});

				jQuery(".continueBtn").click( function() 
				{
					if(jQuery("#matchRoleFrm").validate().form())
					{
						
							showLoadingBox();
							jQuery.ajax(
							{
				                url: '${baseurl}/service/saveImport',
				                type: 'POST',
				                data: jQuery("#matchRoleFrm").serialize(),
				                success: function (data) 
				           		{
				           			hideLoadingBox();
					           		if(data['result'] == "success")
						           	{
					           			jQuery( "#selectDeliveryRoleDiv" ).hide();
					           			jQuery( "#finalImportResponseDiv" ).html(data['content']).show();
					           			//jQuery( "#responseDialog" ).data('filePath', data['filePath']).html(data['content']).dialog("open");
							        }
					           		else
						           	{
					           			jQuery( "#importServiceFailureDialog" ).dialog("open");
							           	
						           	}
				                }, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									//alert("Error while saving");
									hideLoadingBox();
									jQuery( "#importServiceFailureDialog" ).dialog("open");
								}
				            });
						
					}
				       
				    return false;
				});

				
			});
			
		</script>
		
		<div class="body" >
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Import Service</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
				
					<g:form name="matchRoleFrm">
						<g:hiddenField name="portfolioId" value="${portfolio?.id}"/>
						<g:hiddenField name="filePath" value="${filePath}"/>
						<g:hiddenField name="source" value="checkedDeliveryRole"/>
						
						<div class="list">
			                <table>
			                    <thead>
			                        <tr>
			                        	<th>Related Activities</th>
			                        	
			                            <th>Unmatched Delivery Role</th>
			                        
			                            <th>Mapped With Role</th>
			                        
			                            <th>Do Mapping</th>
			                        
			                            <th>Create New</th>
			                        
			                        </tr>
			                    </thead>
			                    <tbody>
			                    <g:each in="${unAvailableDeliveryRoles}" status="i" var="deliveryRoleName">
			                        <tr  class="${(i % 2) == 0 ? 'odd' : 'even'}">
			                        	<g:hiddenField name="finalRole-${i}" value=""/>
			                        	
			                        	<td>
			                        		<ul>
			                        			<g:each in="${roleActivityList[i]}" status="j" var="activityName">
			                        				<li>${j+1}) ${activityName}</li>
			                        			</g:each>
			                        		</ul>
			                        	</td>
			                        	
			                            <td>${i+1}) ${deliveryRoleName}</td>
			                        
			                            <td><g:select name="roleName-${i}" from="${DeliveryRole.list()?.sort {it.name}}" optionKey="name" value="" noSelection="['':'-Select Any One-']" class="roleName required" /></td>
			                        
			                            <td><g:radio name="myGroup-${i}" class="doMapping" checked="true" value=""/></td>
			                        
			                            <td><g:radio name="myGroup-${i}" value="${deliveryRoleName}" class="createNew"/></td>
			           
			                        </tr>
			                    </g:each>
			                    </tbody>
			                </table>
			            </div>
			            
			            <div class="buttons">
       						<span class="button"><button title="Continue" id="continueBtn" class="continueBtn buttons.button button"> Continue </button></span>
					    </div>
					    
					</g:form>
				</div>
				
			</div>
		</div>
        