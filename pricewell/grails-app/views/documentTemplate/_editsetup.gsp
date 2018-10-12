<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

		
        <script>
		
			jQuery(document).ready(function()
		 	{
				jQuery("#editDocumentTemplateFrm").validate();

				jQuery( "#reimportFileDv" ).hide();
				
				jQuery(".btnCancleReimportDocument").click( function()
				{
					jQuery( "#reimportFileDv" ).hide();
					jQuery( ".btnReimportDocument" ).show();
					jQuery( "#isreimported" ).val(${false});
					jQuery('#file').removeClass('required');
					return false;
	           		
				});

				jQuery(".btnReimportDocument").click( function()
				{
					jQuery( "#reimportFileDv" ).show();
					jQuery( ".btnReimportDocument" ).hide();
					jQuery( "#isreimported" ).val(${true});
					jQuery('#file').addClass('required');
					return false;
	           		
				});

				jQuery(".btnCancelImport").click( function()
				{
					jQuery( "#sowDocumentTemplateDialog" ).dialog( "close" );
					return false;
	           		
				});
						
				jQuery("#btnSubmitSOW").click( function() 
				{
					if(jQuery("#editDocumentTemplateFrm").validate().form())
					{
						var fd = new FormData();	

						var isreimported = jQuery("#isreimported").val();
						if(isreimported == true || isreimported == "true")
						{
							var file = jQuery("#file")[0].files[0]; 
							fd.append( "file", file); 
							var filename = file.name;
							var ext = getFileExtension(filename);
							if(ext == "docx" || ext == "doc")
							{
								//alert(1);
							}
							else {
								//alert(2);
								jAlert('Please import document file.', 'Alert');
								return false;
							}
						}
						
						var documentName = jQuery("#documentName").val();

						fd.append("id", ${documentTemplateInstance?.id});
						fd.append("version", ${documentTemplateInstance?.version});
						fd.append("documentName", documentName);
						fd.append("isreimported", isreimported);
						
						showLoadingBox();
						jQuery.ajax(
						{
			                url: '${baseurl}/documentTemplate/update',
			                type: 'POST',
			                cache: false,
			                data: fd,
			                processData: false,
			                contentType: false,
			           		success: function (data) 
			           		{
			           			hideLoadingBox();

			           			if(isreimported == true || isreimported == "true")
				           		{
					           		if(data['reimportResult'] != "success")
						           	{
					           			jAlert('Document file not imported successfully. Please try again.', 'Alert');
					           			return false;
							        }
					           	}
			           			
				           		if(data['nameChanged'] == "true" || data['nameChanged'] == "noNameChange")
					           	{
				           			jQuery( "#sowDocumentTemplateDialog" ).dialog( "close" );
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
			<g:form enctype="multipart/form-data" method="post" controller="documentTemplate" action="update" name="editDocumentTemplateFrm">
				<g:hiddenField name="isreimported" value="${false}"/>
				<g:hiddenField name="id" value="${documentTemplateInstance?.id}"/>
				<g:hiddenField name="version" value="${documentTemplateInstance?.version}"/>
				<table>
					<tbody>
						<tr>
							<td><label>Name</label><em>*</em></td>
							<td>&nbsp;&nbsp;</td>
							<td>
								<g:textArea name="documentName" value="${documentTemplateInstance?.documentName}" cols="40" rows="3" maxlength="100" class="required"/>
							</td>
							<td>&nbsp;</td>
							<td>
								<button id="btnReimportDocument" class="btnReimportDocument" title="Reimport">Reimport</button>
							</td>
						</tr>
						
						<tr id="reimportFileDv" class="reimportFileDv">
							<td><label>Upload File</label><em>*</em></td>
							<td>&nbsp;&nbsp;</td>
							<td>
								<input type="file" id=file name="file" class=""/>
							</td>
							<td>&nbsp;</td>
							<td>
								<button id="btnCancleReimportDocument" class="btnCancleReimportDocument" title="Cancel Reimport">Cancel Reimport</button>
							</td>
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
        