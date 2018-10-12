<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="com.valent.pricewell.ObjectType" %>
<%
	def baseurl = request.siteUrl
%>
<html>
        <script>
        	jQuery(document).ready(function()
		   	{
		   		jQuery(".ckeditor").each(function( index ) {
					var name = this.id;

					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '10%',
				    	width: '90%',
				    	toolbar: [], readOnly: true, resize_enabled : false, resize_maxHeight : '20%'});
				});

		   		jQuery( "#viewJsonOfSowDialog" ).dialog(
   				{
   					height: 700,
   					width: 1300,
   					modal: true,
   					autoOpen: false,
   					buttons: {
   						OK: function() {
   							//jQuery( "#viewJsonOfSowDialog" ).dialog( "close" );
   							jQuery( "#reviewSOWJsonDataFrm" ).submit();
   							return false;
   						}
   					}
   				});
		    			
			});

			function buildJSONDataForQuotationProperties(id)
			{
				 showThrobberBox();
				 jQuery.ajax(
				 {
					 type:'POST',
					 url:"${baseurl}/quotation/buildJsonObjectForQuotationProperties",
					 data: {id: id} ,
					 success:function(data,textStatus)
					 {
						 if(data["isJson"]){
							 hideThrobberBox();
							 jQuery("#viewJsonOfSowDialog").dialog("open").html(data["content"]);
						 }
						 else
						 {
							 outputFilePath = data["filePath"]; //data coming from ajax is generated document full path
							 downloadSOW(id, outputFilePath);
						 }
						 
				 	 },
					 error:function(XMLHttpRequest,textStatus,errorThrown)
					 {
						 //hideLoadingBox();
						 hideThrobberBox();
						 jQuery( "#generateSOWFailureDialog" ).dialog("open");
					 }
				 });

				 return false;
			}

		   	function buildSOWForQuotation(id)
			{
				 var outputFilePath = '';
				 //showLoadingBox();
				 showThrobberBox();
				 jQuery.ajax(
				 {
					 type:'POST',
					 url:"${baseurl}/quotation/generateDucumentOfSOW",
					 data: {id: id} ,
					 success:function(data,textStatus)
					 {
						 outputFilePath = data; //data coming from ajax is generated document full path
						 downloadSOW(id, outputFilePath)
						
				 	 },
					 error:function(XMLHttpRequest,textStatus,errorThrown)
					 {
						 //hideLoadingBox();
						 hideThrobberBox();
						 jQuery( "#generateSOWFailureDialog" ).dialog("open");
					 }
				 });

				 return false;
			}
			
			function goToOpportunity(id)
			{
				//window.location = "${baseurl}/quotation/goToOpportunity/"+id;
				jQuery( "#goToOpportunityFrm" ).submit();
			}
    		
	   	</script>
        
    <body>
    
    	<div id="viewJsonOfSowDialog" title="Review SOW Contents"></div>
    	
    	<g:form name="goToOpportunityFrm" method='POST' action="goToOpportunity" controller="quotation">
    		<g:hiddenField name="id" value="${quotationInstance?.id}"/>
    		<g:hiddenField name="filePath" value=""/>
    	</g:form>
    
    	<div class="body">
    	
           	<div class="dialog">
           		<h1>SOW Introduction</h1><hr/>
           		<div class="list">
					<table>
	    				<tbody>
	    
	        				<tr class="prop">
	        					<td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'sowIntroduction', 'errors')}"  style="width: 100%">		
									<g:textArea name="sowIntroductionReadOnly" value="${quotationInstance?.sowIntroductionSetting?.value}" class="ckeditor" rows="5" cols="80" readOnly="true"/>
	                      		</td>
	                  		</tr>
	          			</tbody>
	   				</table>
   				</div>
   				
   				<h1>Project Parameters</h1><hr/>
				<div class="list">
					<table>
						<tbody>
							<g:each in="${quotationInstance?.projectParameters}" status="i" var="projectParameterInstance">
								<tr class="prop">
			
									<td style="width: 100%">
										<g:textArea name="value${projectParameterInstance?.id}" value="${projectParameterInstance?.value}" rows="5" cols="80" readOnly="true" class="ckeditor"/>
									</td>
			
								</tr>
							</g:each>
						</tbody>
					</table>
				</div>
				
				<h1>Payment Milestone</h1><hr/>
   				<g:render template="generateSOW/showQuotationMilestoneReadOnly" model="['quotationInstance': quotationInstance]" />
   				
			</div>
		                
        </div>
    </body>
</html>