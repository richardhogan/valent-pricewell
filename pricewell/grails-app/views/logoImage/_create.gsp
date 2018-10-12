<%@ page import="com.valent.pricewell.LogoImage" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

		<g:set var="entityName" value="${message(code: 'logoImage.label', default: 'Image')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <script>
		
			jQuery(document).ready(function()
		 	{
				jQuery("#uploadLogoFrm").validate();

				jQuery(".btnCancel").live("click", function()
				{
					jQuery( ".dvUploadLogo" ).dialog( "close" );
					return false;
	           		
				});
				
				jQuery(".btnUpload").click(function() 
				{
					if(jQuery("#uploadLogoFrm").validate().form())
					{
						showLoadingBox();
						var fd = new FormData();	
	
						fd.append( "image", jQuery("#image")[0].files[0]);
						fd.append( "source", jQuery("#source").val());
						
						jQuery.ajax({
			                url: '${baseurl}/logoImage/save',
			                type: 'POST',
			                cache: false,
			                data: fd,
			                processData: false,
			                contentType: false,
			           		success: function (data) 
			           		{
			           			hideLoadingBox();
				           		if(data["res"] == "success")
					           	{
				           			jQuery("#logoId").val(data["id"]);
				           			jQuery("#filePath").val(data["filePath"]);
				           			jQuery.ajax({type:'POST',
				   					 url:'${baseurl}/logoImage/showImage',
				   					 data: {id: data["id"]},
				   					 success:function(data,textStatus)
				   					 {
					   					 if('${logoFor}' == 'account')
						   				 {
					   						jQuery('#dvAccountLogo').html(data);
							   			 }
					   					 else
						   				 {
					   						jQuery('#dvCompanyLogo').html(data);
							   			 }
					   					 
					   				 },
				   					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				   					 
				           			jQuery( ".dvUploadLogo" ).dialog( "close" );
						        }
				           		else if(data['res'] == "invalidImage")
					           	{
						           	alert("Logo image is invalid. Please change file format and try again.")
						        }
				           		else
					           	{
						           	alert("Failed to upload logo. Please try again.");
					           	}
						      	
			                }
			            });
					}
				       
				    return false;
				})
					  
			});
		</script>
		
		<div class="body" >
			<g:form enctype="multipart/form-data" method="post" name="uploadLogoFrm">
				<g:hiddenField name="source" value="${source}" /> 
				
			  	<p><b>Browse for a file to upload : </b></p>
			  	<input type="file" id="image" name="image" value="" class="required"/>
			  	<br /><br />
			  	<button id="btnUpload" class="btnUpload" title="Upload Logo">Upload Now</button>
			  	<button id="btnCancel" class="btnCancel" title="Cancel">Cancel</button>
			  
			</g:form>
		</div>
        