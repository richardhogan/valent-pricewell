<script>
</script>
<div>
	<g:form action="exportPDF" controller="quotation">
		<g:hiddenField name="qpId" value="${qpId}"></g:hiddenField>
		<g:submitButton name="btnExportQuotation" title="Download PDF" value="Download PDF"></g:submitButton>
	</g:form>
</div>
<div>
	${content}
</div>