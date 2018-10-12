
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <nav:resources/>
        <g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'ReviewRequest')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    
    	<div class="nav">
	            <span class="menuButton"><g:link class="create" action="create" params="[serviceProfileId: serviceProfileInstance?.id , userId: userInstance?.id]"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        	
    	<div class="leftNav">      		
    		<nav:render group="review" id="plain"/>
    	</div>	
        
        <div id="columnRight" class="body rightContent column">
        	
            <h1>${title}</h1>
            
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <th> </th>
                        
                            <g:sortableColumn property="subject" title="${message(code: 'reviewRequest.subject.label', default: 'Subject')}" />
                            
                            <g:sortableColumn property="status" title="${message(code: 'reviewRequest.status.label', default: 'Status')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'reviewRequest.description.label', default: 'Description')}" />
                                                
                            <g:sortableColumn property="dateModified" title="${message(code: 'reviewRequest.dateModified.label', default: 'Date Modified')}" />
                        
                            <th><g:message code="reviewRequest.submitter.label" default="Submitter" /></th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${reviewRequestInstanceList}" status="i" var="reviewRequestInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${reviewRequestInstance.id}"> Show details </g:link></td>
                        
                            <td>${fieldValue(bean: reviewRequestInstance, field: "subject")}</td>
                            
                            <td>${fieldValue(bean: reviewRequestInstance, field: "status")}</td>
                        
                            <td>${fieldValue(bean: reviewRequestInstance, field: "description")}</td>
                                                
                            <td><g:formatDate format="MMMMM d, yyyy" date="${reviewRequestInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: reviewRequestInstance, field: "submitter")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${reviewRequestInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
