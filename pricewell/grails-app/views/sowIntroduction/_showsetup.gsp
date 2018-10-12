<%@ page import="com.valent.pricewell.SowIntroduction" %>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<script>
		   	jQuery(function() 
		   	{
				jQuery( "#tabsDiv" ).tabs();

				jQuery("#listSowIntroduction").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/sowIntroduction/listsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	
				
			});
	   	</script>	
   	
    </head>
    <body>
        
        <div class="body">
        	<g:if test="${source=='firstsetup'}">
	        	<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Show SowIntroduction<span class="button"><button id="listSowIntroduction" title="SowIntroduction List"> Go To List </button></span></div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
				
		            <div class="dialog">
		                <table>
		                    <tbody>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="SowIntroduction.name.label" default="Name" /></b></td>
		                            <td>&nbsp;&nbsp;</td>
		                            <td valign="top" class="value">${fieldValue(bean: sowIntroductionInstance, field: "name")}</td>
		                            
		                        </tr>
		                    
		                        <tr class="prop">
		                            <td valign="top" class="name"><b><g:message code="SowIntroduction.sow_text.label" default="Sow Text" /></b></td>
		                            <td>&nbsp;&nbsp;</td>
		                            <td valign="top" class="value">${fieldValue(bean: sowIntroductionInstance, field: "sow_text")}</td>
		                            
		                        </tr>
		                    
		                    </tbody>
		                </table>
		            </div>
		            
		            <div id="tabsDiv">
		            	<ul>
		            		<g:if test="${sowIntroductionInstance?.relationSowIntroduction.size()}">
				 				
				 			</g:if>
							<g:if test="${updatePermission}">
								
							</g:if>	
						</ul>				
						
		            </div>
				<g:if test="${source=='firstsetup'}">
						</div>
		            </div>
	            </g:if>
        </div>
    </body>
</html>
