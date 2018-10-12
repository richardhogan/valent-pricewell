<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="com.valent.pricewell.Geo" %>
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
					var selectedTerritory = jQuery("#territoryName-"+id).val();
					jQuery("#finalTerritory-"+id).val(selectedTerritory);
					jQuery("#territoryName-"+id).addClass( "required" );
					jQuery("#isMapped-"+id).val(${true});
					 
					 
				});

				jQuery('.createNew').click(function(){

					var id = this.id.substring(8);
					jQuery("#territoryName-"+id).val("");
					var unmatchedValue = jQuery("#unMatchedTerritory-"+id).val();
					jQuery("#finalTerritory-"+id).val(unmatchedValue);
					jQuery("#territoryName-"+id).removeClass( "required" );
					jQuery("#isMapped-"+id).val(${false});
				    
				});

				jQuery(".territoryName").change(function() 
		    	{
			    	var id = this.id.substring(14);
			    	if(jQuery(this).val() != "" && jQuery(this).val() != null)
					 {
						jQuery('input:radio[class=doMapping][id=myGroup-'+id+']').prop('checked', true);
						var selectedRole = jQuery("#territoryName-"+id).val();
						jQuery("#finalTerritory-"+id).val(selectedRole);

						if(!jQuery("#territoryName-"+id).hasClass( "required" ))
						{
							jQuery("#territoryName-"+id).addClass( "required" );
						}
					 }
					else
					{
						
						jQuery('input:radio[class=doMapping][id=myGroup-'+id+']').prop('checked', false);
						jQuery('input:radio[class=createNew][id=myGroup-'+id+']').prop('checked', true);
						var unmatchedValue = jQuery("#unMatchedTerritory-"+id).val();
						jQuery("#finalTerritory-"+id).val(unmatchedValue);
						jQuery("#territoryName-"+id).removeClass( "required" );
					}
				  	
				  
				});

				jQuery(".continueBtn").click( function() 
				{
					if(jQuery("#matchTerritoryFrm").validate().form())
					{
						
							showLoadingBox();
							jQuery.ajax(
							{
				                url: '${baseurl}/cw/saveTerritoryMapping',
				                type: 'POST',
				                data: jQuery("#matchTerritoryFrm").serialize(),
				                success: function (data) 
				           		{
				           			hideLoadingBox();
					           		if(data['result'] == "success")
						           	{
					           			jQuery( "#importSuccessDialog" ).html(data['content']).dialog("open");

					           			jQuery( "#mapOpportunityTerritoryDialog" ).dialog( "close" );
					           			//jQuery( "#dvImportOpportunityContent" ).html(data['content']);//for saperate window...
							        }
					           		else
						           	{
					           			jQuery( "#importFailureDialog" ).dialog("open");
							           	
						           	}
				                }, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									//alert("Error while saving");
									hideLoadingBox();
									jQuery( "#importFailureDialog" ).dialog("open");
								}
				            });
						
					}
				       
				    return false;
				});

				jQuery( "#importSuccessDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					height:500,
					width: 800,
					buttons: {
						OK: function() 
						{
							jQuery( "#importSuccessDialog" ).dialog( "close" );
							window.location.href = '${baseurl }/opportunity/list';
							return false;
						}
					}
				});

				jQuery( "#importFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#importFailureDialog" ).dialog( "close" );
							return false;
						}
					}
				});
			});
			
		</script>
		
		<div id="importSuccessDialog" title="Success">
				
		</div>

		<div id="importFailureDialog" title="Failure">
			
		</div>
		<div class="body list" >
			<g:form name="matchTerritoryFrm">
				<g:hiddenField name="responseContent" value="${content}"/>
				
				<g:hiddenField name="opportunityIds" value="${opportunityIds}"/>
				
				<div class="list">
	                <table>
	                    <thead>
	                        <tr>
	                        	<th>Opportunity</th>
	                        	
	                            <th>Unmatched Territory</th>
	                        
	                            <th>Mapped With Territory</th>
	                        
	                            <th>Do Mapping</th>
	                        
	                            <th>Create New</th>
	                        
	                        </tr>
	                    </thead>
	                    <tbody>
	                    <g:each in="${opportunityList}" status="i" var="opportunityInstance">
	                        <tr  class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        	<g:hiddenField name="finalTerritory-${opportunityInstance?.id}" value="${territoryList[i]}"/>
	                        	<g:hiddenField name="unMatchedTerritory-${opportunityInstance?.id}" value="${territoryList[i]}"/>
	                        	<g:hiddenField name="isMapped-${opportunityInstance?.id}" value="${true}"/>
	                        	<g:hiddenField name="connectwiseTerritoryName-${opportunityInstance?.id}" value="${territoryList[i]}"/>
	                        	
	                        	<td>
	                        		${i+1}) ${opportunityInstance?.name}	
	                        	</td>
	                        	
	                            <td>${territoryList[i]}</td>
	                        
	                            <td><g:select name="territoryName-${opportunityInstance?.id}" from="${Geo.list()?.sort {it.name}}" optionKey="name" value="" noSelection="['':'-Select Any One-']" class="territoryName required" /></td>
	                        
	                            <td><g:radio name="myGroup-${opportunityInstance?.id}" class="doMapping" checked="true" value=""/></td>
	                        
	                            <td><g:radio name="myGroup-${opportunityInstance?.id}" value="${territoryList[i]}" class="createNew"/></td>
	           
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
        