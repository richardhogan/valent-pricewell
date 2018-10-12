<%@ page import="com.valent.pricewell.Staging"%>
<html>
	<head>
		<meta name="layout" content="mainSetup" />
			
		<g:set var="entityName"
			value="${message(code: 'companyInformation.logo.label', default: 'Add Company Logo')}" />
		<title><g:message code="default.show.label" args="[entityName]" />
		</title>
		
		<script>
		
			jQuery(document).ready(function()
		 	{
				jQuery("#uploadLogoFrm").validate();
				
				jQuery("#btnUpload").live("click", function() 
				{
					if(jQuery("#uploadLogoFrm").validate().form())
					{
						showLoadingBox();
						var fd = new FormData();	
	
						fd.append( "image", jQuery("#image")[0].files[0]);
						fd.append( "source", jQuery("#source").val());
						fd.append( "id", jQuery("#id").val());
						
						jQuery.ajax({
			                url: '${baseurl}/logoImage/saveLogo',
			                type: 'POST',
			                cache: false,
			                data: fd,
			                processData: false,
			                contentType: false,
			           		success: function (data) 
			           		{
			           			hideLoadingBox();
			                }
			            });
					}
				       
				    return false;
				});
			});
		
			
		</script>
	</head>
	
	<body>
		<div class="body">
			<h1><b>Add Company Logo</b></h1><hr />
			<p>New changes related to Company Logo, Please add Company Logo first</p>
			
			<g:form enctype="multipart/form-data" method="post" name="uploadLogoFrm">
				<g:hiddenField name="source" value="home" />
				<g:hiddenField name="id" value="${companyInformationInstance?.id }" /> 
				
			  	<b>Browse for a file to upload : </b> <input type="file" id="image" name="image" value="" class="required"/>
			  	
			  	<br /><br />
			  	<button id="btnUpload" title="Upload Logo">Upload Now</button>
			  
			</g:form>
		</div>	
	</body>
</html>
