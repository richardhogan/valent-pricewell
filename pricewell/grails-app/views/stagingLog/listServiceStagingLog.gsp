
<%@ page import="com.valent.pricewell.StagingLog" %>
<html>
    <body> 
        <div class="body">
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <th> ${message(code: 'stagingLog.dateModified.label', default: 'Date Modified')} </th>
                        
                            <th> ${message(code: 'stagingLog.fromStage.label', default: 'From Stage')} </th>
                            
                            <th> ${message(code: 'stagingLog.toStage.label', default: 'To Stage')} </th>
                            
                             <th> ${message(code: 'stagingLog.modifiedBy.label', default: 'Modified By')} </th>
                            
                             <th> ${message(code: 'stagingLog.comment.label', default: 'Comment')} </th>
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${serviceProfileInstance?.stagingLogs()}" status="i" var="stagingLogInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:formatDate format="MMMMM d, yyyy HH:mm" date="${stagingLogInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: stagingLogInstance, field: "fromStage")}</td>
                            
                            <td>${fieldValue(bean: stagingLogInstance, field: "toStage")}</td>
                        
                            <td>${fieldValue(bean: stagingLogInstance, field: "modifiedBy")}</td>
                            
                            <td>${fieldValue(bean: stagingLogInstance, field: "comment")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
