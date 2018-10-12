
<%@ page import="com.valent.pricewell.Opportunity"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="layout" content="main" />
		<g:set var="entityName"
			value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
		<title><g:message code="default.show.label" args="[entityName]" />
		</title>
		<link rel="shortcut icon"
			href="${resource(dir:'images',file:'star-on.png')}" type="image/x-icon" />
		<link rel="shortcut icon"
			href="${resource(dir:'images',file:'star-off.png')}"
			type="image/x-icon" />
		<link rel="shortcut icon"
			href="${resource(dir:'images',file:'star-delete.png')}"
			type="image/x-icon" />
		<ckeditor:resources />
	</head>
<body>
	<div class="nav">
		<span class="menuButton"><A HREF="javascript:history.go(-1)">Back</A>
			<span class="menuButton"><g:link class="list" action="list">
					<g:message code="default.list.label" args="[entityName]" />
				</g:link>
		</span> <span class="menuButton"><g:link class="create"
					action="create">
					<g:message code="default.new.label" args="[entityName]" />
				</g:link>
		</span>
	</div>
	<div class="body">
		<h2>
			<g:message code="default.show.label" args="[entityName]" />
		</h2>
		<hr>
		<!--<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>-->
		<div class="dialog">
			<table>
				<tbody>

					<!-- <tr class="prop">
                            <td valign="top" class="name"><g:message code="opportunity.id.label" default="Id" /></td>
                            
                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "id")}</td>
                            
                        </tr>-->

					<tr class="prop">
						<td valign="top" class="name"><b><g:message
									code="opportunity.name.label" default="Opportunity Name : " />
						</b>
						</td>
						<td valign="top" class="value">
							${fieldValue(bean: opportunityInstance, field: "name")}
						</td>

						<td>&nbsp;&nbsp;</td>

						<td valign="top" class="name"><b><g:message
									code="opportunity.assignTo.label" default="Assign To : " />
						</b>
						</td>
						<td valign="top" class="value">
							${fieldValue(bean: opportunityInstance, field: "assignTo")}
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><b><g:message
									code="opportunity.account.label" default="Account : " />
						</b>
						</td>
						<td valign="top" class="value">
							${fieldValue(bean: opportunityInstance, field: "account.accountName")}
						</td>

						<td valign="top" class="name"><label for="geo"><g:message
									code="default.geo.label" default="Geo" />
						</label></td>
						<td valign="top" class="value">
							${opportunityInstance?.geo}
						</td>
					</tr>

					<tr class="prop">
						<td valign="top" class="name"><b><g:message
									code="opportunity.createdBy.label" default="Created By : " />
						</b>
						</td>
						<td valign="top" class="value"><g:link controller="user"
								action="show" id="${opportunityInstance?.createdBy?.id}">
								${opportunityInstance?.createdBy?.encodeAsHTML()}
							</g:link>
						</td>

						<td>&nbsp;&nbsp;</td>

						<td valign="top" class="name"><b><g:message
									code="opportunity.dateCreated.label" default="Date Created : " />
						</b>
						</td>
						<td valign="top" class="value"><g:formatDate
								format="MMMMM d, yyyy"
								date="${opportunityInstance?.dateCreated}" />
						</td>
					</tr>
				</tbody>
			</table>
			<!--<hr>
                 <table>
                 	<tbody>
                        
                        <tr class="prop">
                        	<td valign="top" class="name"><b><g:message code="opportunity.closeDate.label" default="Close Date : " /></b></td>
                            <td valign="top" class="value"><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance?.closeDate}" /></td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="opportunity.probability.label" default="Probability(%) : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "probability")}</td>
                        </tr>
                    
                        <tr class="prop">
                        	<td valign="top" class="name"><b><g:message code="opportunity.amount.label" default="Amount : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "amount")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="opportunity.discount.label" default="Discount(%) : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: opportunityInstance, field: "discount")}</td>
                            
                        </tr>
                                       
                        
                                        
                    </tbody>
                </table>-->
		</div>
		<div class="buttons">
			<g:form>
				<g:hiddenField name="id" value="${opportunityInstance?.id}" />
				<span class="button"><g:actionSubmit class="edit"
						action="edit"
						value="${message(code: 'default.button.edit.label', default: 'Edit')}" />
				</span>
				<span class="button"><g:actionSubmit class="delete"
						action="delete"
						value="${message(code: 'default.button.delete.label', default: 'Delete')}"
						onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</span>
			</g:form>
		</div>
	</div>
</body>
</html>
