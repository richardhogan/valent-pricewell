<%@ page import="com.valent.pricewell.Portfolio" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'portfolio.label', default: 'Portfolio')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		 <script src="${baseurl}/js/tinytable.js"></script>
		<!-- <link rel="stylesheet" href="${resource(dir:'css',file:'tinytable.css')}" />-->
		 
		<script>

			jQuery(document).ready(function()
			{			 
				jQuery("#portfolioCreate").validate();
				jQuery("#portfolioCreate input:text")[0].focus();
				
				jQuery("#savePortfolio").click(function(){
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
								else if(data == "success")
								{
									window.location = "${baseurl}/portfolio/list";
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
			});

			 function onCancel()
			 {
				 window.location.href = '${baseurl}/portfolio';
				 return false;
		     }
			 
  		</script>
    </head>
    <body>
        <div class="nav">
            <span><g:link class="list" action="list" title="List Of Portfolios" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            
            <g:form action="save" name="portfolioCreate" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="portfolioName"><g:message code="portfolio.portfolioName.label" default="Name" /></label>
                                	<em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'portfolioName', 'errors')}">
                                    <g:textField name="portfolioName" value="${portfolioInstance?.portfolioName}" size="58" class="required"/>
                                    <br/><div id="nameMsg" class="msg"></div>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="description"><g:message code="portfolio.description.label" default="Description" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'description', 'errors')}">
                                    <g:textArea name="description" value="${portfolioInstance?.description}" rows="15" cols="60" />
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
                    <span class="button"><button id="savePortfolio" title="Save Portfolio"> Save </button></span>
                    <!--<g:submitButton name="create" title="Save Portfolio" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>-->
                    <span class="button"><input type="button" value="Cancel" title="Cancel" onclick="onCancel()"></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
