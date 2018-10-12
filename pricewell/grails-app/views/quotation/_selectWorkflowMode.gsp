<%@ page import="com.valent.pricewell.Service" %>

<%@ page import="grails.converters.JSON"%>

<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>
		
        <script>
		
			jQuery(document).ready(function()
		 	{

				jQuery('.fullFlow').click(function()
				{
			    	var selectedFlow = jQuery(this).val();
					jQuery("#workflowValue").val(selectedFlow);

				});

				jQuery('.lightFlow').click(function(){

					var selectedFlow = jQuery(this).val();
					jQuery("#workflowValue").val(selectedFlow);

				});

				
				jQuery("#saveQuotationWorkflowMode").click( function() 
				{
					var selectedFlow = jQuery("#workflowValue").val();
					showLoadingBox();
					jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/quotation/quotationWorkflowSettingSave",
						data:jQuery('#selectQuotationWorkflowFrm').serialize(),
						success: function(data)
						{
							hideLoadingBox();
												       	
							if(data == "success")
							{
								jQuery("#dvResponseDialog").dialog( "option", "title", "Success" );
								jQuery("#dvResponseDialog").html("Quotation workflow mode updated successfully.").dialog("open");
								
							} else{
								jQuery("#dvResponseDialog").dialog( "option", "title", "Failure" );
								jQuery("#dvResponseDialog").html("Failed to update workflow mode.").dialog("open");
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
							hideLoadingBox();
						}
					});
					
					return false;
					
				});

				jQuery( "#dvResponseDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					close: function( event, ui ) {
							jQuery(this).html('');
					},
			      	buttons: {
			          	OK: function() {
			            	jQuery( this ).dialog( "close" );
			            	
			            	showLoadingBox();
							jQuery.post( '${baseurl}/staging/updateList' , 
							  	{type: 'quotationWorkflowMode', source: 'setup'},
						      	function( data ) 
						      	{
								  	hideLoadingBox();
						          	jQuery('#mainWorkflowSettingTab').html(data);
						      	});
							return false;
			          	}
			        }
					
				});
			});
			
		</script>
		
		<div class="body" >	
			<div id="dvResponseDialog"></div>
			<div class="leftNavSmall">      		
	    		<g:render template="../staging/nevigationsetup"/>
	    	</div>
            
            <div id="dvSubStage" class="body rightContent column">
            	
            	<div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Quotation Workflow Mode</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
		
						<g:form name="selectQuotationWorkflowFrm">
									
							<g:hiddenField name="workflowValue" value="${workflowValue}"/>
							<g:hiddenField name="source" value="setup"/>						
										
				        	<p><g:radio name="selectionGroup" checked= "${isFullChecked}"  value="full" class="fullFlow"/> Full Workflow</p>	                           
				                     
				        	<p><g:radio name="selectionGroup" checked= "${isLightChecked}" value="light" class="lightFlow"/> Light Workflow</p>		
				        	
			        		<div class="buttons">
					        	<span class="button"><button title="Save Workflow Mode" id="saveQuotationWorkflowMode" > Save </button></span>
							</div>
										
						</g:form>
					</div>
				</div>
			</div>
		</div>
        