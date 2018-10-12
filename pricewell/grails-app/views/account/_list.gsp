<div class="list">
    <table cellpadding="0" cellspacing="0" border="0" class="display" id="${tblName}">
        <thead>
            <tr>
            	
            	<th><g:message property="accountName" code="account.accountName.label" default="Account Name" /></th>
            	
            	<th><g:message property="website" code="account.website.label" default="Website" /></th>
            	
            	<th><g:message property="phone" code="account.phone.label" default="Phone" /></th>
            	
            	<th><g:message property="assignTo" code="account.assignTo.label" default="Assign To" /></th>
            	
            	<th>No of Contacts</th>
                
                <th>No of Opportunities</th>
            
            </tr>
        </thead>
        <tbody>
        <g:each in="${accountInstanceList}" status="i" var="accountInstance">
            <tr>
            
                <td><g:link action="show" title="Show Details" class="hyperlink" id="${accountInstance.id}">${fieldValue(bean: accountInstance, field: "accountName")}</g:link></td>
                                    
                <td>${fieldValue(bean: accountInstance, field: "website")}</td>
            
                <td>${fieldValue(bean: accountInstance, field: "phone")}</td>
            
                <td>${fieldValue(bean: accountInstance, field: "assignTo")}</td>
            
                <td>${accountInstance.contacts.size()}</td>
                
                <td>${accountInstance.opportunities.size()}</td>
            
            </tr>
        </g:each>
        </tbody>
    </table>
</div>