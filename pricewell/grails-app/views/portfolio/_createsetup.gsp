<%@ page import="com.valent.pricewell.Portfolio" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'portfolio.label', default: 'Portfolio')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		 <script src="${baseurl}/js/tinytable.js"></script>
		 
		<script>

			jQuery(document).ready(function()
			{			 
				jQuery("#portfolioCreate").validate();
				jQuery("#portfolioCreate input:text")[0].focus();
				
				jQuery("#savePortfolioSetup").click(function(){
					if(jQuery("#portfolioCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/portfolio/save",
							data:jQuery("#portfolioCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "Portfolio_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This portfolio is already available.');
					       		}
								else if(data == "success"){
									jQuery( xdialogDiv ).dialog( "close" ); jQuery(".resultDialog").html('Loading .....');
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('Portfolio is created successfully.'); jQuery( ".resultDialog" ).dialog("open");
									hideUnhideNextBtn();
									
								} else{
									jQuery( xdialogDiv ).dialog( "close" ); jQuery(".resultDialog").html('Loading .....');
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to create portfolio"); jQuery( ".resultDialog" ).dialog("open");
									
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
					if(jQuery("#portfolioCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/portfolio/save",
							data:jQuery("#portfolioCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "Portfolio_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This portfolio is already available.');
					       		}
								else if(data == "success"){
									refreshGeoGroupList();
								} 
								else if(data['result'] == "success")
								{
									var id = data['id']; var name = data['name'];
									var selected = jQuery('select[name="portfolioId"] option:selected').text();
									jQuery("#portfolioId").append('<option value='+id+' selected="selected">'+name+'</option>');
									
									jQuery("#createPortfolioDialog").dialog( "close" );
									jQuery("#createPortfolioSuccessDialog").dialog( "open" );
								}
								else{
									jQuery('#portfolioErrors').html(data);
									jQuery('#portfolioErrors').show();
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

				jQuery("#cancelPortfolio").click(function()
				{
					if("firstsetup" == '${source}')
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/portfolio/listsetup' , 
						  	{source: "firstsetup"},
					      	function( data ) 
					      	{
							  	hideLoadingBox();
					          	jQuery('#contents').html('').html(data);
					      	});
					}
					else{
						jQuery("#createPortfolioDialog").dialog( "close" );
					}
					
					return false;
				});	
			});

			 function onCancel()
			 {
				 window.location.href = '${baseurl}/portfolio';
				 return false;
		     }
			 
  		</script>
    </head>
    <body>
        <div class="body">
            
            <!--<g:if test="${flash.message}">
            	<div class="message">${flash.message}</div>
            </g:if>
			<div id="portfolioErrors" class="errors" style="display: none;">
            </div>-->
            
            <g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add New Portfolio</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
		            <g:form action="save" name="portfolioCreate" >
		                <g:hiddenField name="source" value="${source}"/>
				                
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
		                                    <label for="portfolioManager"><g:message code="portfolio.portfolioManager.label" default="Portfolio Manager" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'portfolioManager', 'errors')}">
		                                    <g:select name="portfolioManager.id"  
		                                    	 noSelection="['': 'Select any one']"
		                                    	from="${portfolioManagerList?.sort {it.profile.fullName}}" optionKey="id" value="${portfolioInstance?.portfolioManager?.id}"  class="required"/>
		                                    <% def fields =  ["profile.fullName":"Name", "profile.email": "Email"]; %>
		                                    <!--<g:popupSelect id="pm" title="title" list="${portfolioManagerList}" fields="${fields}" returnObject="portfolioManager.id"></g:popupSelect>-->
		                                </td>
		                            </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                	<g:if test="${source=='firstsetup' || source=='importService'}">
		                		<span class="button"><button id="savePortfolio" title="Save Portfolio"> Save </button></span>
		                		<span class="button"><button id="cancelPortfolio" title="Cancel"> Cancel </button></span>
		                	</g:if>
		                	<g:else>
		                		<span class="button"><button id="savePortfolioSetup" title="Save Portfolio"> Save </button></span>
		                	</g:else>
				                	
		                    
		                </div>
		            </g:form>
	            <g:if test="${source=='firstsetup'}">
			            </div>
		            </div>
	            </g:if>
        </div>
    </body>
</html>
