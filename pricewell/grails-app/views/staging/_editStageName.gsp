<%@ page import="java.lang.String" %>
<%
	def baseurl = request.siteUrl
%>
<head>
  <style>
		.msg {
			color: red;
		}
		em { font-weight: bold; padding-right: 1em; vertical-align: top; }
	</style>

  <script>
	  jQuery(document).ready(function()
	  {		    
			jQuery("#updateSubStage").click(function()
			{
				if(jQuery("#stageUpdateFrm").validate().form())
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/staging/updateStageName",
						data:jQuery("#stageUpdateFrm").serialize(),
						success: function(data)
						{
							hideLoadingBox();
												       	
							if(data == "success")
							{
								jQuery("#dvResponseDialog").dialog( "option", "title", "Success" );
								jQuery("#dvResponseDialog").html("Service Substage updated successfully.").dialog("open");
								
							} else{
								jQuery("#dvResponseDialog").dialog( "option", "title", "Failure" );
								jQuery("#dvResponseDialog").html("Service Substage failed to update.").dialog("open");
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
							hideLoadingBox();
						}
					});
				}
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
						  	{type: 'serviceSubstages', source: 'setup'},
					      	function( data ) 
					      	{
							  	hideLoadingBox();
					          	jQuery('#mainWorkflowSettingTab').html(data);
					      	});
						return false;
		          	}
		        }
				
			});
			
			jQuery("#cancelStage").click(function()
			{
				showLoadingBox();
				jQuery.post( '${baseurl}/staging/updateList' , 
				  	{type: 'serviceSubstages', source: 'setup'},
			      	function( data ) 
			      	{
					  	hideLoadingBox();
			          	jQuery('#mainWorkflowSettingTab').html(data);
			      	});
				return false;
			});	
	  });
		    
  </script>
</head>

<body>
	
	<div id="dvResponseDialog"></div>
	
	<div class="collapsibleContainer">
		<div class="collapsibleContainerTitle ui-widget-header" >
			<div>Edit Stage :  ${subStage.displayName?.encodeAsHTML()}</div>
		</div>
	
		<div class="collapsibleContainerContent ui-widget-content" >
	
   			<g:form class="editSubstage" name="stageUpdateFrm">
    			
    			<input type="hidden" name="id" value="${subStage.id}"/>
    			<table>
      				<tbody>

      					<tr>
      						<td><label for="name">Substage Name</label></td>
        					<td class="value">
          						<input type="text" id="name" name="name" value="${subStage.name?.encodeAsHTML()}" readOnly="true" class="required easyinput"/>
        					</td>
        					
        					<td>&nbsp;&nbsp;</td>
        					
        					<td><label for="name">Parent Stage</label></td>
        					<td class="value">
          						<input type="text" id="parentName" name="parentName" value="${subStage.staging.displayName?.encodeAsHTML()}" readOnly="true" class="required easyinput"/>
        					</td>
        				</tr>
        				
        				<tr>	
        					<td><label for="displayName">Display Name</label><em>*</em></td>
        					<td class="value">
          						<input type="text" id="displayName" name="displayName" value="${subStage.displayName?.encodeAsHTML()}" class="required easyinput"/>
        						<br/><div id="stagenameMsg" class="msg"></div>
        					</td>
      					</tr>
    				</tbody>
    			</table>
    
				<div class="buttons">
       
       				<span class="button"><button title="Update Stage" id="updateSubStage"> Update </button></span>
       
       				<span class="button"><button id="cancelStage" title="Cancel"> Cancel </button></span>
   		
				</div>
  			</g:form>
  		</div>
	</div>
	
</body>

