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
					    var filename = file.name;
						fd.append( "file", file);	fd.append("id", ${geoInstance?.id});
						
						var ext = getFileExtension(filename);
						if(ext == "docx" || ext == "doc")
						{
							showLoadingBox();
						
							jQuery.ajax(
							{
				                url: '${baseurl}/setting/saveimportedSOW',
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
				
				<p><b>Browse for a file to upload : </b></p>
			  	<input type="file" id=file name="file" class="required"/>
			  	<br /><br />
			  	<button id="btnSubmitSOW" class="btnSubmitSOW" title="Submit">Submit</button>
			  	<button id="btnCancelImport" class="btnCancelImport" title="Cancel">Cancel</button>
			  	
			  	
			  
			</g:form>
		</div>
        