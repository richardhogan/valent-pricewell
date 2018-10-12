<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

		
        <script>
		
			jQuery(document).ready(function()
		 	{
				jQuery("#importSOWFrm").validate();

				jQuery(".btnCancelImport").click( function()
				{
					jQuery( "#importSOWDialog" ).dialog( "close" );
					return false;
	           		
				});

				jQuery(".btnSubmitSOW").click( function() 
				{
					if(jQuery("#importSOWFrm").validate().form())
					{
						var fd = new FormData();	
						var file = jQuery("#file")[0].files[0];  
						var documentName = jQuery("#documentName").val();
					    var filename = file.name;
						fd.append( "file", file);	fd.append("id", ${geoInstance?.id});
						fd.append("documentName", documentName);
						
						var ext = getFileExtension(filename);
						if(ext == "docx" || ext == "doc")
						{
							showLoadingBox();
							jQuery.ajax(
							{
				                url: '${baseurl}/documentTemplate/saveSowTemplate',
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
					           			refreshSideNevAndContentList(data["id"]);
							        }
					           		else
						           	{
					           			jQuery( "#importSOWFailureDialog" ).dialog("open");
							           	
						           	}
					           		jQuery( "#importSOWDialog" ).dialog( "close" );
				                }, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									//alert("Error while saving");
									hideLoadingBox();
									jQuery( "#importSOWFailureDialog" ).dialog("open");
								}
				            });
						}
						else {
							jAlert('Please import document file.', 'Alert');
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
		
		<div class="body" >
			<g:form enctype="multipart/form-data" method="post" controller="setting" action="saveimportedSOW" name="importSOWFrm">
				
				<table>
					<tbody>
						<tr>
							<td><label>Name</label><em>*</em></td>
							<td>&nbsp;&nbsp;</td>
							<td>
								<g:textArea name="documentName" value="" cols="40" rows="3" maxlength="100" class="required"/>
							</td>
						</tr>
						
						<tr>
							<td><label>Upload File</label><em>*</em></td>
							<td>&nbsp;&nbsp;</td>
							<td><input type="file" id=file name="file" class="required"/></td>
						</tr>
						
						<tr>
							<td><label>Note : </label><em></em></td>
							<td>&nbsp;&nbsp;</td>
							<td>Name field accept maximum 100 characters only.</td>
						</tr>
					</tbody>
				</table>
				
				
				<div class="buttons">
		            <span class="button">
	                  	<button id="btnSubmitSOW" class="btnSubmitSOW" title="Submit">Submit</button>
	                </span>
	                   	
		            <span class="button">
	                  	<button id="btnCancelImport" class="btnCancelImport" title="Cancel">Cancel</button>
	                </span>
		        </div>
			  
			</g:form>
		</div>
        