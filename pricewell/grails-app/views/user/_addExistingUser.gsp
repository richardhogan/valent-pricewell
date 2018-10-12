<html>
	<script>
		jQuery(document).ready(function()
	    {		   
			
			jQuery( "#successToAddDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				buttons: {
					OK: function() 
					{
						jQuery( "#successToAddDialog" ).dialog( "close" );
						refreshGeoGroupList();
						return false;
					}
				}
			});

			jQuery( "#failureToAddDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				buttons: {
					OK: function() {
						jQuery( "#failureToAddDialog" ).dialog( "close" );
						return false;
					}
				}
			});
					 
	  		jQuery("#addUser").click(function()
	  		{

	  			var roleId = jQuery( "#roleId" ).val();
	  			
				var userId = jQuery( "#userId" ).val();

				jQuery.ajax({
					type: "POST",
					url: "/pricewell/user/addExistingUser?roleId="+roleId+"&userId="+userId,
					
					success: function(data){
						if(data == "success"){
							jQuery( "#userDialog" ).dialog( "close" );    		                   		
	                   		jQuery( "#successToAddDialog" ).dialog("open");
						} else{
							jQuery( "#userDialog" ).dialog( "close" );
					    	jQuery( "#failureToAddDialog" ).dialog("open");
						}
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){
						alert("Error while saving");
					}
				});
				

					//alert("roleId : "+roleId+" userId : "+userId);
					
				
				return false;
			}); 
	    });
		    
  </script>


	<body>
	
		
		<div id="successToAddDialog" title="Successfully Changed">
			<p>User added successfully into ${roleInstance?.name }.</p>
		</div>
	
		<div id="failureToAddDialog" title="Changes Failed">
			<p>Failed to add user in role.</p>
		</div>
		
		<g:form>
			<g:hiddenField name="roleId"  value="${roleInstance?.id}" />
			<table>
				<td><label>Add User In ${roleInstance?.name }</label></td>
				
				<td>&nbsp;&nbsp;</td>
				
				<td> <g:select name="userId" from="${existingUsers}" value="" optionKey="id" noSelection="['': 'Select any one']"/></td>
				
			</table>
			
			<div>
		      <span class="buttons"><button id="addUser"> Save </button></span>
		    </div>
		</g:form>
		
		
	</body>

</html>