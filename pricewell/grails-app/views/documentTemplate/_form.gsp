<%@ page import="com.valent.pricewell.DocumentTemplate" %>



<div class="fieldcontain ${hasErrors(bean: documentTemplateInstance, field: 'templateName', 'error')} ">
	<label for="templateName">
		<g:message code="documentTemplate.templateName.label" default="Template Name" />
		
	</label>
	<g:textField name="templateName" value="${documentTemplateInstance?.templateName}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: documentTemplateInstance, field: 'documentFile', 'error')} ">
	<label for="documentFile">
		<g:message code="documentTemplate.documentFile.label" default="Document File" />
		
	</label>
	<g:select id="documentFile" name="documentFile.id" from="${com.valent.pricewell.UploadFile.list()}" optionKey="id" value="${documentTemplateInstance?.documentFile?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: documentTemplateInstance, field: 'isDefault', 'error')} ">
	<label for="isDefault">
		<g:message code="documentTemplate.isDefault.label" default="Is Default" />
		
	</label>
	<g:checkBox name="isDefault" value="${documentTemplateInstance?.isDefault}" />
</div>

<div class="fieldcontain ${hasErrors(bean: documentTemplateInstance, field: 'territory', 'error')} ">
	<label for="territory">
		<g:message code="documentTemplate.territory.label" default="Territory" />
		
	</label>
	<g:select id="territory" name="territory.id" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${documentTemplateInstance?.territory?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

