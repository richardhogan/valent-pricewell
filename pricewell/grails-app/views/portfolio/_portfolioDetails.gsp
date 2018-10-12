<div class="dialog">
                <table>
                    <tbody>
                    
                       <!--  <tr class="prop">
                            <td valign="top" class="name"><label for="id"><g:message code="portfolio.id.label" default="Id" /></label></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: portfolioInstance, field: "id")}</td>
                            
                        </tr>-->
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label for="portfolioName"><g:message code="portfolio.portfolioName.label" default="Portfolio Name : " /></label></td>
                            <td>&nbsp;</td>
                            <td valign="top" class="value">${fieldValue(bean: portfolioInstance, field: "portfolioName")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label for="description"><g:message code="portfolio.description.label" default="Description : " /></label></td>
                            <td>&nbsp;</td>
                            <td valign="top" class="value">${fieldValue(bean: portfolioInstance, field: "description")}</td>
                            
                        </tr>
                    </tbody>
                </table>     	
                
                <table>
                	<tbody>    
                        <tr class="prop">
                            <td valign="top" class="name"><label for="dateModified"><g:message code="portfolio.dateModified.label" default="Date Modified : " /></label></td>
                            <td>&nbsp;&nbsp;</td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${portfolioInstance?.dateModified}" /></td>
                            
                            <td>&nbsp;</td>
                            
                            <td valign="top" class="name"><label for="stagingStatus"><g:message code="portfolio.stagingStatus.label" default="Staging Status : " /></label></td>
                            <td>&nbsp;&nbsp;</td>
                            <td valign="top" class="value">${fieldValue(bean: portfolioInstance, field: "stagingStatus")}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label for="designers"><g:message code="portfolio.designers.label" default="Designers : " /></label></td>
                            <td>&nbsp;</td>
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${portfolioInstance.designers}" var="d">
                                    <li><g:link controller="user" action="show" id="${d.id}">${d?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><label for="portfolioManager"><g:message code="portfolio.portfolioManager.label" default="Portfolio Manager : " /></label></td>
                            <td>&nbsp;</td>
                            <td valign="top" class="value"><g:link controller="user" action="show" id="${portfolioInstance?.portfolioManager?.id}">${portfolioInstance?.portfolioManager?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                     <!--   <tr class="prop">
                            <td valign="top" class="name"><g:message code="portfolio.otherPortfolioManagers.label" default="Other Portfolio Managers" /></td>
                            
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${portfolioInstance.otherPortfolioManagers}" var="o">
                                    <li><g:link controller="user" action="show" id="${o.id}">${o?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr> -->
                    
                        <tr class="prop">
                            <td valign="top" class="name"><label for="services"><g:message code="portfolio.services.label" default="Services : " /></label></td>
                            <td>&nbsp;</td>
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="${portfolioInstance.services}" var="s">
                                    <li><g:link controller="service" action="show" params="[serviceProfileId: s?.serviceProfile?.id]" >${s?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${portfolioInstance?.id}" />
                    <g:if test="${updatePermit}">
                    	<span class="button"><g:actionSubmit class="edit" title="Edit Portfolio" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    </g:if>
                    <g:if test="${createPermit && portfolioInstance.services.size()==0}">
                    	
                    	<span class="button"><g:actionSubmit class="delete" title="Delete Portfolio" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                    </g:if>
                </g:form>
            </div>
