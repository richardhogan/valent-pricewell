<div>
    <table cellpadding="0" cellspacing="0" border="0" class="display" id="${tblName}">
        <thead>
            <tr>
            
            	<th><g:message property="lastname" code="lead.lastname.label" default="Last Name" /></th>
            	
            	<th><g:message property="firstname" code="lead.firstname.label" default="First Name" /></th>
            	
            	<th><g:message property="title" code="lead.title.label" default="Title" /></th>
            	
            	<th><g:message property="company" code="lead.companycompany.label" default="Company" /></th>
            	
            	<th><g:message property="email" code="lead.email.label" default="Email" /></th>
            	
            	<th><g:message property="phone" code="lead.phone.label" default="Phone" /></th>
            	
            	<th><g:message property="assignTo" code="lead.assignTo.label" default="Assign To" /></th>
            	<th>Date Created</th>
       			<th>Lead Status</th>
            	
            	
            </tr>
        </thead>
        <tbody>
	        <g:each in="${leadInstanceList?.sort {it.lastname}}" status="i" var="leadInstance">
	            <tr>
	            
	                <td><g:link action="show" title="Show Details" class="hyperlink" id="${leadInstance.id}"> ${fieldValue(bean: leadInstance, field: "lastname")}</g:link></td>
	                
	                <td><g:link action="show" title="Show Details" class="hyperlink" id="${leadInstance.id}">${fieldValue(bean: leadInstance, field: "firstname")} </g:link></td>
	            
	                <td>${fieldValue(bean: leadInstance, field: "title")}</td>
	            
	                <td>${fieldValue(bean: leadInstance, field: "company")}</td>
	            
	                <td>${fieldValue(bean: leadInstance, field: "email")}</td>
	                
	                <td>${fieldValue(bean: leadInstance, field: "phone")}</td>
	                
	                <td>${fieldValue(bean: leadInstance, field: "assignTo")}</td>
	                <td><g:formatDate format="MMMMM d, yyyy" date="${leadInstance?.dateCreated}" /></td>
	               
	                <td>${fieldValue(bean: leadInstance, field: "stagingStatus.displayName")}
	            
	            		<g:if test="${leadInstance?.stagingStatus?.name=='dead'}">
	            		
	            			<g:hiddenField name="id" value="${leadInstance?.id}" />
	            			<g:remoteLink action="delete" title="Delete Lead" class="hyperlink" update="success" id="${leadInstance?.id}" onLoading="changeUrl();" >Delete</g:remoteLink>
						
						</g:if>
					</td>
	            </tr>
	        </g:each>
        </tbody>
    </table>
</div>