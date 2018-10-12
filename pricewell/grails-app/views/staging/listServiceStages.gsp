
<%@ page import="com.valent.pricewell.Staging" %>
<html>
    <body> 
        <div class="body">
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <h3> Current Stage: ${currentStage?.name} </h3>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                            <g:sortableColumn property="sequenceOrder" title="${message(code: 'staging.sequenceOrder.label', default: 'Sequence')}" />
                        
                        	<g:sortableColumn property="name" title="${message(code: 'staging.name.label', default: 'Name')}" />
                        	
                        	<g:sortableColumn property="displayName" title="${message(code: 'staging.displayName.label', default: 'Display Name')}" />
                        	
                            <g:sortableColumn property="description" title="${message(code: 'staging.description.label', default: 'Description')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${stagingInstanceList}" status="i" var="stagingInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td>${fieldValue(bean: stagingInstance, field: "sequenceOrder")}</td>
							
							<td>${fieldValue(bean: stagingInstance, field: "name")}</td>
							
							<td>${fieldValue(bean: stagingInstance, field: "displayName")}</td>
							                           
                            <td>${fieldValue(bean: stagingInstance, field: "description")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
        </div>
    </body>
</html>
