<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

		
        <script>
		
			jQuery(document).ready(function()
		 	{
				jQuery("#importServiceFrm").validate();

				jQuery(".btnCancel").click( function()
				{
					jQuery( "#importServiceDialog" ).dialog( "close" );
					return false;
	           		
				});

				jQuery(".btnNew").click( function()
				{
					jQuery.ajax({type:'POST',data: {source: "importService" },
						 url:'${baseurl}/portfolio/create',
						 success:function(data,textStatus)
						 {
							 jQuery("#createPortfolioDialog").dialog( "open" );
							 jQuery('#createPortfolioDialog').html(data);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					return false;
	           		
				});
						

				jQuery( "#createPortfolioSuccessDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery(this).dialog( "close" );
							return false;
						}
					}
				});
				
				jQuery( "#createPortfolioDialog" ).dialog(
				{
					modal: true,
					height: 350,
					width: 500,
					autoOpen: false,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});
				
				jQuery(".btnSubmit").click( function() 
				{
					if(jQuery("#importServiceFrm").validate().form())
					{
						var fd = new FormData();	
						var file = jQuery("#file")[0].files[0];  
					    var filename = file.name;
						fd.append( "file", file);
						fd.append("portfolioId", jQuery("#portfolioId").val());

						var ext = getFileExtension(filename);
						if(ext == "xml")
						{
							showLoadingBox();
							jQuery.ajax(
							{
				                url: '${baseurl}/service/serviceImport',
				                type: 'POST',
				                cache: false,
				                data: fd,
				                processData: false,
				                contentType: false,
				           		success: function (data) 
				           		{
				           			hideLoadingBox();
					           		if(data['result'] == "success")
						           	{
					           			//jQuery( "#importServiceSuccessDialog" ).data('filePath', data['filePath']).dialog("open");
					           			jQuery( "#responseDialog" ).data('filePath', data['filePath']).html(data['content']).dialog("open");
							        }
					           		else
						           	{
					           			jQuery( "#importServiceFailureDialog" ).dialog("open");
							           	
						           	}
					           		jQuery( "#importServiceDialog" ).dialog( "close" );
				                }, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									//alert("Error while saving");
									hideLoadingBox();
									jQuery( "#importServiceFailureDialog" ).dialog("open");
								}
				            });
						}
						else {
							jAlert('Please import xml file.', 'Alert');
						}
					}
				       
				    return false;
				})
					  
			});
			
			function getFileExtension(filename)
			{
			  var ext = /^.+\.([^.]+)$/.exec(filename);
			  return ext == null ? "" : ext[1];
			}
		</script>
		
		<div id="createPortfolioDialog" title="Create New Portfolio">
			
		</div>
		
		<div id="createPortfolioSuccessDialog" title="Success">
			<p>Portfolio created successfully and added into list.</p>
		</div>
		
		<div class="body" >
			<g:form enctype="multipart/form-data" name="importServiceFrm">
				
				<table>
					<tbody>
						<tr>
							<td><b>Browse for a file to upload : </b></td>
							<td><input type="file" id=file name="file" class="required"/></td>
						</tr>
						<tr>
							<td><b>Portfolio : </b></td>
							<td>
								<g:select name="portfolioId" from="${portfolioList?.sort {it.portfolioName}}" optionKey="id" value=""  class="required" noSelection="['': 'Select any one']"/>
								<button id="btnNew" class="btnNew" title="Create New Portfolio">Create</button>
							</td>
						</tr>
					</tbody>
				</table>
				
			  	<br />
			  	<b>Note : </b>File will be import in selected portfolio.<br/>
			  	<button id="btnSubmit" class="btnSubmit" title="Submit">Submit</button>
			  	<button id="btnCancel" class="btnCancel" title="Cancel">Cancel</button>
			  	
			  	
			  
			</g:form>
		</div>
        