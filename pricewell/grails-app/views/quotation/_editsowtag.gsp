<%
	def baseurl = request.siteUrl
%>
<html>

<script>
	
	jQuery(document).ready(function()
	{
	
	
	jQuery('#saveSOW').button();
	jQuery('#saveSOW').click(function (){
		loadTags();
		jQuery.ajax({type:'POST',data: jQuery("#saveSOWPreviewForm").serialize(),
			 url:'${baseurl}/quotation/savesowtag',
			 success:function(data,textStatus){jQuery('#sowpreviewMain').html(data);},
			 error:function(XMLHttpRequest,textStatus,errorThrown){}}); 
			 
			 return false
			 
		});	
	

	jQuery('#cancelSOW').button();
	jQuery('#cancelSOW').click(function (){
		jQuery.ajax({type:'GET',data: {id: ${sowTag.quotation.id}},
			 url:'${baseurl}/quotation/cancelsavesowtag',
			 success:function(data,textStatus){jQuery('#sowpreviewMain').html(data);},
			 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
			 
		});	
	});

	function loadTags(){
		var name = 'tagValue'
		jQuery('#tagValue').val(CKEDITOR.instances[name].getData());
	}
	
	</script>
<h1>
	${tagTitle}
</h1>
<g:form name="saveSOWPreviewForm">
	<g:hiddenField name="createFlg" value="${createFlg}" />
	<g:hiddenField name="quotation.id" value="${sowTag.quotation.id}" />
	<g:hiddenField name="tagName" value="${sowTag.tagName}" />

	<g:if test="${createFlg != 'true'}">
		<g:hiddenField name="id" value="${sowTag.id}" />
	</g:if>


	<textarea id="tagValue" name="tagValue">
		${sowTag.tagValue}
	</textarea>

	<script type="text/javascript">
		var name = 'tagValue'
		var editor = CKEDITOR.instances[name];
	    if (editor) { editor.destroy(true); }
	    CKEDITOR.replace(name, {
	    	height: '400px',
	    	width: '80%'});
	    
</script>


	<button id="saveSOW" title="Save SOW">Save</button>
	<button id="cancelSOW" title="Cancel">Cancel</button>
</g:form>

</html>