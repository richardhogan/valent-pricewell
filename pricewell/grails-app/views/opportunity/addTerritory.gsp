
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Opportunity" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
	def primaryTerritory = null
	if(loginUser?.primaryTerritory!=null && loginUser?.primaryTerritory!='null' && loginUser?.primaryTerritory!='NULL')
	{
		primaryTerritory = Geo.get(loginUser?.primaryTerritory?.id)
	}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<script>
			  jQuery(document).ready(function()
			  {		
			  		jQuery("#addTerritoryFrm").validate();
			    		
			  });
			  
  		</script>
        
        
    </head>
    <body>
        <div class="nav">
            
        </div>
        <div class="body">
            <h2>Add territory in opportunity</h2><hr>
            
            <b>Note : Territory not defined in opportunity : ${opportunityInstance?.name} so add it first.</b>
            
            <g:form action="saveTerritory" name="addTerritoryFrm">
            	<g:hiddenField name="id" value="${opportunityInstance?.id}"/>
                <div class="dialog">
                    <table>
                        <tbody>
                         
                            <tr class="prop">
                                
                                <td valign="top" class="name">
                                    <label for="geo"><g:message code="default.geo.label" default="Geo" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: opportunityInstance, field: 'geo', 'errors')}">
                                    <g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="${primaryTerritory?.id}" class="required" noSelection="['': 'Select Any One']" />
                                </td>
                                
                            </tr>
                        
                        </tbody>
	                 </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="saveBtn" title="Save Territory" class="save" value="Save" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
