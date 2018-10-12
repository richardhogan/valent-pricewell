<%@ page import="com.valent.pricewell.FieldMapping" %>



<div class="fieldcontain ${hasErrors(bean: fieldMappingInstance, field: 'value', 'error')} ">
	<label for="value">
		<g:message code="fieldMapping.value.label" default="Value" />
		
	</label>
	<g:textArea name="value" cols="40" rows="5" maxlength="2048000" value="${fieldMappingInstance?.value}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: fieldMappingInstance, field: 'type', 'error')} required">
	<label for="type">
		<g:message code="fieldMapping.type.label" default="Type" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="type" from="${com.valent.pricewell.FieldMapping$MappingType?.values()}" keys="${com.valent.pricewell.FieldMapping$MappingType.values()*.name()}" required="" value="${fieldMappingInstance?.type?.name()}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: fieldMappingInstance, field: 'key', 'error')} ">
	<label for="key">
		<g:message code="fieldMapping.key.label" default="Key" />
		
	</label>
	<g:textField name="key" value="${fieldMappingInstance?.key}"/>
</div>

