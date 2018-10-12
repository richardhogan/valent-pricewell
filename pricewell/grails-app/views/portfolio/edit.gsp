

<%@ page import="com.valent.pricewell.Portfolio" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
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
				jQuery("#portfolioEdit").validate();
				jQuery("#portfolioEdit input:text")[0].focus();
				
				jQuery("#updatePortfolio").click(function(){
					if(jQuery("#portfolioEdit").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/portfolio/update",
							data:jQuery("#portfolioEdit").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "Portfolio_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This portfolio is already available.');
					       		}
								else if(data == "success")
								{
									window.location = "${baseurl}/portfolio/show/${portfolioInstance?.id}";
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
  		</script>
    </head>
    <body>
        <div class="nav">
            <span><g:link class="list" action="list" title="List Of Portfolios" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <g:if test="${createPermit}">
            	<span><g:link class="create" action="create" title="Create Portfolio" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${portfolioInstance}">
            <div class="errors">
                <g:renderErrors bean="${portfolioInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="portfolioEdit">
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
                                  <label for="designers"><g:message code="portfolio.designers.label" default="Designers" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'designers', 'errors')}">
                                    <g:select name="designers" from="${designerList}" multiple="yes" optionKey="id" size="5" value="${portfolioInstance?.designers*.id}" />
                                </td>
                            </tr>
                        
                           <!-- <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="otherPortfolioManagers"><g:message code="portfolio.otherPortfolioManagers.label" default="Other Portfolio Managers" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'otherPortfolioManagers', 'errors')}">
                                    <g:select name="otherPortfolioManagers" from="${portfolioManagerList}" multiple="yes" optionKey="id" size="5" value="${portfolioInstance?.otherPortfolioManagers*.id}" />
                                </td>
                            </tr> -->
                        
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
                        
                            <!-- <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="services"><g:message code="portfolio.services.label" default="Services" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: portfolioInstance, field: 'services', 'errors')}">
                                    
									<ul>
										<g:each in="${portfolioInstance?.services?}" var="s">
										    <li><g:link controller="service" action="show" params="[serviceProfileId: s.id]">${s?.encodeAsHTML()}</g:link></li>
										</g:each>
									</ul>
									<g:link controller="service" action="create" params="['portfolio.id': portfolioInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'service.label', default: 'Service')])}</g:link>

                                </td>
                            </tr>-->
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                	<span class="button"><button id="updatePortfolio" title="Update Portfolio"> Update </button></span>
                    <!-- <span class="button"><g:actionSubmit class="save" title="Update Portfolio" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span> -->
                    <g:if test="${createPermit}">
                    	<span class="button"><g:actionSubmit class="delete" title="Delete Portfolio" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                    </g:if>
                </div>
            </g:form>
        </div>
    </body>
</html>
