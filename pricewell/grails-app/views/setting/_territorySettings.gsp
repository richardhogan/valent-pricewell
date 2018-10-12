<%
	def baseurl = request.siteUrl
%>
<script> 

   	
			jQuery(document).ready(function()
	  		{
				var name = 'sowTemplate'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '700px',
				    	toolbar: 'Basic'});

				var name = 'terms'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '700px',
				    	toolbar: 'Basic'});
				    	
				 var name = 'billing_terms'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '700px',
				    	toolbar: 'Basic'});
				
				var name = 'signature_block'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '700px',
				    	toolbar: 'Basic'});   
			    	
				jQuery( "#successDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() 
						{
							var territoryId = jQuery( "#territoryId" ).val();
							jQuery.ajax({type:'POST',data: {territoryId: territoryId},
			   					url:'${baseurl}/setting/getTerritorySetting',
			   					success:function(data,textStatus){jQuery('#mainterritorySettingTab').html('');jQuery('#mainterritorySettingTab').html(data);},
			   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
			   		 			
			   		 			
							jQuery( "#successDialog" ).dialog( "close" );
							return false;
						}
					}
				});
						
				jQuery( "#failureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#failureDialog" ).dialog( "close" );
							return false;
						}
					}
				});

					    
				jQuery( "#saveTerritorySettings" )
				.button()
				.click(function() 
				{
					if(jQuery('#territorySettings').validate().form())
					{
						showLoadingBox();
						loadValues();
						jQuery.post( '${baseurl}/geo/saveTerritorySettings', 
              				  jQuery("#territorySettings").serialize(),
							      function( data ) 
							      {
								  		  //jQuery('#mainterritorySettingTab').html(data);
										  hideLoadingBox();
								  		  if(data['res'] == 'success')
								          {		  
								  				jQuery( "#successDialog" ).dialog("open");
									      }
									      
									      else
									      {
									      		jQuery( "#failureDialog" ).dialog("open"); 
									      }
							          
							      });
            		}
					return false;
				});
  			});

			function loadValues(){
    			jQuery('#sowTemplate').val(CKEDITOR.instances["sowTemplate"].getData());
    			jQuery('#terms').val(CKEDITOR.instances["terms"].getData());
    			jQuery('#billing_terms').val(CKEDITOR.instances["billing_terms"].getData());
    			jQuery('#signature_block').val(CKEDITOR.instances["signature_block"].getData());
    		}
        	
	</script>


<div id="successDialog" title="Successfully Saved Settings">
	<p>Territory settings are successfully saved.</p>
</div>

<div id="failureDialog" title="Save Setting Failed">
	<p>Territory save settings are failed.</p>
</div>

<g:form method="post" name="territorySettings">
	<g:hiddenField name="id" value="${geoInstance?.id}" />
	<g:hiddenField name="version" value="${geoInstance?.version}" />

	<g:if test="${source == 'globle' }">
		<b>Note : </b> These are default globle SOW settings, Change settings as per territory requirement.
			</g:if>

	<table>
		<tr>
			<td><label>SOW Label</label><em>*</em></td>
			<td><g:textField name="sowLabel" value="${sowLabel}"
					class="required" size='75'/></td>
		</tr>
		<tr>
			<td><label> SOW Template </label></td>

			<td><g:textArea name="sowTemplate" value="${sowTemplate}"
					rows="5" cols="80" style="width: 90%" /></td>
		</tr>
	<!--</table>-->
		<tr>
			<td> <label>SOW Template Tags</label></td>
			<td></td>
		</tr>
	<!--<table>-->

		<tr>
			<td><label>[@@terms@@]</label></td>
			<td><g:textArea name="terms" value="${terms}" rows="10"
					cols="80" style="width: 90%" /></td>
		</tr>
		<tr>
			<td><label>[@@billing_terms@@]</label></td>
			<td><g:textArea name="billing_terms" value="${billing_terms}"
					rows="10" cols="80" style="width: 90%" /></td>
		</tr>
		<tr>
			<td><label>[@@signature_block@@]</label></td>
			<td><g:textArea name="signature_block"
					value="${signature_block}" rows="5" cols="80" style="width: 90%" />
			</td>
		</tr>

	</table>
	<div>
		<b>Note : </b>Expense Amount and Description will be added directly
		from SOW Properties.
	</div>
	<div class="buttons">
		<span class="button"> <b><button title="Save Territory Settings" id="saveTerritorySettings">Save
					Settings</button>
		</b> </span>
	</div>
</g:form>