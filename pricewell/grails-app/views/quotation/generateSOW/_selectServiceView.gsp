
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%
	def baseurl = request.siteUrl
%>
<html>
        <script>
		   	jQuery(function() 
		   	{
				jQuery("#sowQuotationServiceViewFrm").validate();
				
				jQuery("#sowQuotationServiceViewFrm").submit(function() 
				{
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/quotation/saveGenerateSOWStages",
						data:jQuery("#sowQuotationServiceViewFrm").serialize(),
						success: function(data)
						{
							if(data == "success"){
								generateSOW(${quotationInstance.id});
							} else{
								alert("Some error, please try again...");
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							return false;
						}
					});
					
					return false;
				});	

				jQuery( "#generateSOWSuccessDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#generateSOWSuccessDialog" ).dialog( "close" );
							window.location = "${baseurl}/opportunity/show/${quotationInstance?.opportunity?.id}";
							return false;
						}
					}
				}); 
				
				jQuery( "#generateSOWFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#generateSOWFailureDialog" ).dialog( "close" );
							location.reload();
							return false;
						}
					}
				}); 
								
			});

		   	function generateSOW(id)
			{
				 var outputFilePath = '';
				 showLoadingBox();
				 jQuery.ajax(
				 {
					 type:'POST',
					 url:"${baseurl}/quotation/generateDucumentOfSOW",
					 data: {id: id} ,
					 success:function(data,textStatus)
					 {
						 hideLoadingBox();
						 if(data == "noFile")
						 {
							 jAlert('Failed to generate SOW for this quotation because there is no sample SOW file imported for territory ${quotationInstance?.geo?.name}.', 'Alert');
							 return false;
						 }
						 else {
							 outputFilePath = data; //data coming from ajax is generated document full path
							 downloadSOW(id, outputFilePath);
						 }
						 
				 	 },
					 error:function(XMLHttpRequest,textStatus,errorThrown)
					 {
						 hideLoadingBox();
						 jQuery( "#generateSOWFailureDialog" ).dialog("open");
					 }
				 });

				 return false;
			 }

			 function downloadSOW(id, filePath)
			 {
				 window.location = "${baseurl}/downloadFile/downloadDocumentFile?filePath="+filePath;
				 jQuery( "#generateSOWSuccessDialog" ).dialog("open");
			 }
			
	   	</script>
        
    <body>
    
    	<div id="generateSOWSuccessDialog" title="Success">
			<p>SOW generated successfully.</p>
		</div>
		
		<div id="generateSOWFailureDialog" title="Failure">
			<p>Failed to generate SOW.</p>
		</div>
		
    	<div class="body">
				
		            <g:form action="saveGenerateSOWStages" name="sowQuotationServiceViewFrm" class="sowQuotationServiceViewFrm" >
		            	<g:hiddenField name="id" value="${quotationInstance?.id}" />
		            	<div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <h1>Select view of services related to this contract.</h1>
		                                </td>
		                            </tr>
	                            </tbody>
	                        </table>
	                        
	                        <table>
		                        <tbody>
		                        
		                            <tr class="prop">	
		                                <td valign="top" class="name">
		                                	<input type="radio" name="serviceView" title="Services in simple format" value="simpleFormat" checked>Simple View
		                                </td>
		                                <td valign="top" class="name">
											<input type="radio" name="serviceView" title="Services in table format" value="tableFormat">Tabular View
		                                </td>
		                            </tr>
	                            </tbody>
	                        </table>
	                        
		                </div>
		                <!-- <div class="buttons">
		                		<span class="button"><button id="continueBtn" title="Continue To Generate SOW"> Continue </button></span>
		                </div>-->
		            </g:form>
			
        </div>
    </body>
</html>
