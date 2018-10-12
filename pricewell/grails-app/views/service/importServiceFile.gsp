<%@ page import="com.valent.pricewell.Service" %>
<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'service.label', default: 'Service')}" />
       
		<script>
        	
				jQuery(document).ready(function()
			 	{
					jQuery("#importServiceFrm").validate();

					jQuery( "#selectDeliveryRoleDiv" ).hide();
					jQuery( "#finalImportResponseDiv" ).hide();
					
					jQuery(".btnCancel").click( function()
					{
						window.location = "${baseurl}/service"
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

					jQuery( "#serviceAvailableDialog" ).dialog(
				 	{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: {
							OK: function() {
								jQuery( "#serviceAvailableDialog" ).dialog( "close" );
								return false;
							}
						}
					});
					
					jQuery(".btnSubmit").click( function() 
					{
						//jQuery( "#importServiceFileDiv" ).hide();
						//jQuery( "#selectDeliveryRoleDiv" ).show();
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
						           			jQuery( "#importServiceFileDiv" ).hide();
						           			jQuery( "#finalImportResponseDiv" ).html(data['content']).show();
						           			//jQuery( "#responseDialog" ).data('filePath', data['filePath']).html(data['content']).dialog("open");
								        }
						           		else if(data['result'] == "serviceAvailable")
							           	{
						           			jQuery( "#serviceAvailableDialog" ).html(data['responseMessage']).dialog("open");
							           	}
						           		else if(data['result'] == "unmatchedDeliveryRoles")
							           	{
						           			jQuery( "#importServiceFileDiv" ).hide();
						           			jQuery( "#selectDeliveryRoleDiv" ).html(data['content']).show();
								        }
						           		else
							           	{
						           			jQuery( "#importServiceFailureDialog" ).dialog("open");
								           	
							           	}
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
					});

					jQuery( "#importServiceFailureDialog" ).dialog(
					{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: {
							OK: function() {
								jQuery(this).dialog( "close" );
								location.reload();
								return false;
							}
						}
					});

					jQuery( "#responseDialog" ).dialog(
				 	{
						modal: true,
						autoOpen: false,
						resizable: false,
						height:500,
						width: 800,
						closeOnEscape: false,
						open: function() {                         // open event handler
					        jQuery(this)                           // the element being dialogged
					            .parent()                          // get the dialog widget element
					            .find(".ui-dialog-titlebar-close") // find the close button for this dialog
					            .hide();                           // hide it
					    },
						buttons: {
							"Download Response": function() 
							{
								 
								jQuery(this).dialog( "close" );
								var filePath = jQuery(this).data("filePath");
								window.location = "${baseurl}/downloadFile/downloadTextFile?filePath="+filePath;
								return false;
							},
							"Developement Services": function()
							{
								jQuery(this).dialog( "close" );
								window.location = "${baseurl}/service/inStaging";
								return false;
							}
						}
					});
						  
				});
				function getFileExtension(filename)
				{
				  var ext = /^.+\.([^.]+)$/.exec(filename);
				  return ext == null ? "" : ext[1];
				}        
        </script>
    </head>
    <body>
    
    	<div id="responseDialog" title="Success">
			
		</div>

		<div id="serviceAvailableDialog" title="Error">
		</div>
		
		<div id="importServiceFailureDialog" title="Failure">
			<p>Failed to import file.</p>
		</div>
        
    	<div id="createPortfolioDialog" title="Create New Portfolio">
			
		</div>
		
		<div id="createPortfolioSuccessDialog" title="Success">
			<p>Portfolio created successfully and added into list.</p>
		</div>
		
		<div class="body" >
		
		
			<div id="importServiceFileDiv">
				<div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header">
						<div>Import Service</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content">
					
						<g:form enctype="multipart/form-data" method="post" controller="service" action="serviceImport" name="importServiceFrm">
					
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
						  	<button id="btnSubmit" class="btnSubmit buttons.button button" title="Submit">Submit</button>
						  	<button id="btnCancel" class="btnCancel buttons.button button" title="Cancel">Cancel</button>
						  	
						</g:form>
						
					</div>
					
				</div>
			</div>
			
			<div id="selectDeliveryRoleDiv">
				
			</div>
			
			<div id="finalImportResponseDiv">
				
			</div>
		</div>
    </body>
</html>
