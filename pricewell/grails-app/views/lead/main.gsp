<%@ page import="com.valent.pricewell.Lead"%>
<%@ page import="com.valent.pricewell.Staging"%>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.User" %>
<%
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="layout" content="main" />
		
	<g:set var="entityName"
		value="${message(code: 'lead.label', default: 'Lead')}" />
	<title><g:message code="default.show.label" args="[entityName]" />
	</title>
	
	<modalbox:modalIncludes />
	<g:setProvider library="prototype"/>
</head>

<body>
  
  	<div class="nav">
        <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
        <!--<span><A HREF="javascript:history.go(-1)" class="buttons.button button">Back</A></span>-->
        <span><g:link class="list" title="List Of Lead" action="list" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        <span><g:link class="create" title="Create Lead" action="create" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
    </div>
        
	<g:set var="title" value="${leadInstance?.id != null?leadInstance.toString(): 'New Lead'}"/>
	<div class="body">
		<div class="collapsibleContainer">
			<div class="collapsibleContainerTitle ui-widget-header">
				<div>
					<b>Lead:</b> ${title}
					&nbsp;&nbsp;
					<g:if test="${leadInstance.stagingStatus.name != 'converttoopportunity' && leadInstance?.stagingStatus?.name != 'converted' && leadInstance?.stagingStatus?.name != 'dead'}">
			            <g:if test="${updatePermission}">
			            	<span>	
		            			<g:remoteLink controller="lead" action="edit" class="edit" title="Edit Lead"
					 				update="[success:'dvlead',failure:'dvlead']" params="[id: leadInstance?.id]" 
					 				onLoading ="showLoadingBox();" onComplete="hideLoadingBox();" title="Edit Lead">
									<r:img dir="images" file="edit-24.png"/>
									</g:remoteLink>
							</span>
								
							&nbsp;&nbsp;
						
							<span>
								<g:hiddenField name="id" value="${leadInstance?.id}" />
								<g:remoteLink action="delete" update="success"  class="hyperlink" title="Delete Lead"
									id="${leadInstance?.id}" onLoading="changeUrl();" 
									onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
									<r:img dir="images" file="delete-24.png"/>
									</g:remoteLink>
		            		</span>
	            		</g:if>
		            </g:if>
				</div>
			</div>
		
			<div class="collapsibleContainerContent ui-widget-content">
			
				<g:render template="stageProgress" model="['leadInstance': leadInstance, 'stagingInstanceList': stagingInstanceList, 'updatePermission': updatePermission]"/>
			
				<g:if test="${updatePermission}">
					<g:if test="${leadInstance.id != null}">
						<g:if test="${leadInstance.stagingStatus.name == 'converttoopportunity'}">
							<g:render template="stage/${leadInstance?.stagingStatus?.name}" model="['leadInstance': leadInstance, 'accountId': accountId, 'updatePermission': updatePermission]"/>
						</g:if>
						<g:else>
							<g:render template="stage/show" model="['leadInstance': leadInstance, 'stagingInstanceList': stagingInstanceList, 'updatePermission': updatePermission]"/>
						</g:else>
					</g:if>
				</g:if>
				<g:else>
					<g:render template="stage/show" model="['leadInstance': leadInstance, 'stagingInstanceList': stagingInstanceList, 'updatePermission': updatePermission]"/>
				</g:else>
		
			</div>
		</div>
	</div>	
		
	<br />
	<br />
</body>
</html>
