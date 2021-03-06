<%@ page import="com.valent.pricewell.Portfolio" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        
        <g:set var="entityName" value="${message(code: 'portfolio.label', default: 'Portfolio')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
        <script>
       			jQuery(document).ready(function()
   				{				 
				    jQuery("#portfolioUpdate").validate();
				    jQuery("#portfolioUpdate input:text")[0].focus();
				    
					jQuery("#updatePortfolioSetup").click(function(){
						if(jQuery("#portfolioUpdate").validate().form())
						{
							showLoadingBox();
							jQuery.ajax({
								type: "POST",
								url: "${baseurl}/portfolio/update",
								data:jQuery("#portfolioUpdate").serialize(),
								success: function(data)
								{
									hideLoadingBox();
									if(data == "Portfolio_Available")
						      		{
						        		jQuery("#nameMsg").html('Error: This portfolio is already available.');
						       		}
									else if(data == "success")
									{								    		         
										jQuery(".resultDialog").html('Loading, please wait.....'); 
										jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
										jQuery(".resultDialog").html('Portfolio edited successfully.'); jQuery( xdialogDiv ).dialog( "close" );
									}
									else{
										jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
										jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
										jQuery(".resultDialog").html("Failed to edit portfolio."); jQuery( xdialogDiv ).dialog( "close" );
									}
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									hideLoadingBox();
									alert("Error while saving");
								}
							});
						}
						return false;
					}); 

					jQuery("#savePortfolio").click(function()
					{
						if(jQuery("#portfolioUpdate").validate().form())
						{
							showLoadingBox();
							jQuery.ajax({
								type: "POST",
								url: "${baseurl}/portfolio/update",
								data:jQuery("#portfolioUpdate").serialize(),
								success: function(data)
								{
									
									if(data == "Portfolio_Available")
						      		{
						        		jQuery("#nameMsg").html('Error: This portfolio is already available.');
						       		}
									else if(data == "success"){
										refreshGeoGroupList();
									} else{
										jQuery('#portfolioErrors').html(data);
										jQuery('#portfolioErrors').show();
									}
									hideLoadingBox();
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									hideLoadingBox();
									alert("Error while saving");
								}
							});
						}
						return false;
					}); 

					jQuery("#cancelPortfolio").click(function()
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/portfolio/listsetup' , 
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
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<div id="portfolioErrors" class="errors" style="display: none;">
            </div>
            
            <g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Edit Portfolio</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
            
		            <g:form method="post" name="portfolioUpdate">
		                <g:hiddenField name="source" value="${source}"/>
						<g:hiddenField name="id" value="${portfolioInstance?.id}" />
		                <g:hiddenField name="version" value="${portfolioInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="portfolioName"><g:message code="portfolio.portfolioName.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'portfolioName', 'errors')}">
		                                    <g:textField name="portfolioName" value="${portfolioInstance?.portfolioName}" size="38" class="required"/>
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="description"><g:message code="portfolio.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'description', 'errors')}">
		                                    <g:textArea name="description" value="${portfolioInstance?.description}" rows="5" cols="40" />
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="designers"><g:message code="portfolio.designers.label" default="Designers" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'designers', 'errors')}">
		                                    <g:select name="designers" from="${designerList}" multiple="yes" optionKey="id" size="5" value="${portfolioInstance?.designers*.id}" />
		                                </td>
		                            </tr>
		                        
		                           
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="portfolioManager"><g:message code="portfolio.portfolioManager.label" default="Portfolio Manager" /></label>
		                                </td>
		                                
		                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'portfolioManager', 'errors')}">
		                                   <g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}">
		                        	            <g:select name="portfolioManager.id" from="${portfolioManagerList}" optionKey="id" value="${portfolioInstance?.portfolioManager?.id}"  />
								    		</g:if>    
								    		<g:else>
								    			<g:link controller="user" action="show" id="${portfolioInstance?.portfolioManager?.id}">${portfolioInstance?.portfolioManager?.encodeAsHTML()}</g:link>
								    		</g:else>                        
		                                </td>
		                                
		                            </tr>
		                        
		                            
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <span class="button">
		                    	<g:if test="${source == 'firstsetup'}">
		                    		<button id="savePortfolio" title="Update Portfolio"> Update </button>
		                    		<span class="button"><button id="cancelPortfolio" title="Cancel"> Cancel </button></span>
		                    	</g:if>
		                    	<g:else>
		                    		<button id="updatePortfolioSetup" title="Update Portfolio"> Update </button>
		                   		</g:else>
		                    </span>
		                </div>
		            </g:form>
	            <g:if test="${source=='firstsetup'}">
			            </div>
		            </div>
	            </g:if>
        </div>
    </body>
</html>
