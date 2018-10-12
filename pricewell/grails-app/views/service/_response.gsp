

<%@ page import="com.valent.pricewell.Setting" %>
<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

		<script>
		
			jQuery(document).ready(function()
		 	{
				var serviceProfileID = "${serviceProfileID}";
				/*if(serviceProfileID != ""){
					window.location = "${baseurl}/service/show?serviceProfileId="+serviceProfileID;
					return;
				}*/
				
				jQuery('.downloadBtn').click(function()
				{
					var filePath = '${filePath}';
					window.location = "${baseurl}/downloadFile/downloadTextFile?filePath="+filePath;
					return false;
					 
				});

				jQuery('.listBtn').click(function(){

					window.location = "${baseurl}/service/inStaging";
					return false;
				    
				});

				jQuery('#goToService').click(function(){
					var serviceProfileID = "${serviceProfileID}";
					window.location = "${baseurl}/service/show?serviceProfileId="+serviceProfileID;
					return false;
				});

			});
			
		</script>		
        
		<div class="body" >
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Import Service</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
					<div>
						<h1>File imported successfully. </h1>(
						<g:each in="${resultArray}" status="i" var="arrayString">
							${arrayString}
						</g:each>
						)
						<h2>Note : See all imported files in development mode.</h2>
					</div>
					
					<div class="buttons">
      					<!--  
      					<span class="button"><button title="Download Response" id="downloadBtn" class="downloadBtn buttons.button button"> Download Response </button></span>
      					-->
      					<g:if test="${serviceProfileID != ''}">
      						<span class="button"><button title="Go to Service" id="goToService" class=" buttons.button button">Go to Service</button></span>
      					</g:if>
      					<g:else>
      					<span class="button"><button title="Developement Service List" id="listBtn" class="listBtn buttons.button button"> Service List </button></span>
      					</g:else>
				    </div>
				</div>
				
			</div>	
			
		</div>
        