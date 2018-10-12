<div class="list">
    <table cellpadding="0" cellspacing="0" border="0" class="display" id="${tblName}">
        <thead>
            <tr>
            	<th><g:message property="firstname" code="contact.firstname.label" default="Contact Name" /></th>
            	
            	<th><g:message property="department" code="contact.department.label" default="Department" /></th>
            	
            	<th><g:message property="email" code="contact.email.label" default="Email" /></th>
            	
            	<th><g:message property="phone" code="contact.phone.label" default="Phone" /></th>
            	
            	<th><g:message property="account" code="contact.account.label" default="Account" /></th>
            	
            	<th><g:message property="assignTo" code="contact.assignTo.label" default="Assign To" /></th>
            
            </tr>
        </thead>
        <tbody>
        <g:each in="${contactInstanceList}" status="i" var="contactInstance">
            <tr>
            
                <td><g:link action="show" title="Show Details" class="hyperlink" id="${contactInstance.id}">${fieldValue(bean: contactInstance, field: "firstname")} ${fieldValue(bean: contactInstance, field: "lastname")}</g:link></td>
            
                <td>${fieldValue(bean: contactInstance, field: "department")}</td>
            
                <td>${fieldValue(bean: contactInstance, field: "email")}</td>
            
                <td>${fieldValue(bean: contactInstance, field: "phone")}</td>
                
                <td>${fieldValue(bean: contactInstance, field: "account.accountName")}</td>
                
                <td>${fieldValue(bean: contactInstance, field: "assignTo")}</td>
            
            </tr>
        </g:each>
        </tbody>
    </table>
</div>