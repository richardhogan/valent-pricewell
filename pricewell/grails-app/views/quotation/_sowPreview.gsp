<%@ page {
    size: 8.5in 11in;  /* width height */
    margin: 0.25in;
} %>
<%
	def baseurl = request.siteUrl
%>
<g:if test="${sowFinalPreview}">

</g:if>
<g:else>
	<style>
		.editSowInputTag{
			display:table-cell;
    		empty-cells:hide;
    		padding: 10px;
    		border: 1px solid orange;
		}
		.addSowInputTag {
			display:table-cell;
    		empty-cells:hide;
    		padding: 10px;
    		border: 1px solid red;	
		}
		
		a.hyperlink {
	 		color: #1874CD;
	 		text-decoration:underline;
	 		hover-color: #fff;			 
		} 
		
	</style>
	<script>
	jQuery(document).ready(function()
	{
		jQuery('.addSowInputTag').each(function(index, value) { 
			var title = jQuery(this).attr('title');
			var id = jQuery(this).attr('id');
			var btn = "<a href='#' class='addSowInputTagBtn hyperlink'>" + title + " </a><br/>"
		    jQuery(this).prepend(btn) 
		});

		jQuery('.editSowInputTag').each(function(index, value) { 
			var title = jQuery(this).attr('title');
			var id = jQuery(this).attr('id');
			var btn = "<a href='#' class='editSowInputTagBtn hyperlink'>" + title + " </a><br/>"
		    jQuery(this).prepend(btn) 
		});

		//jQuery('.addSowInputTagBtn').button();
		jQuery('.addSowInputTagBtn').click(function() {
			var id = jQuery(this).parent().attr('id')
			var title = jQuery(this).parent().attr('title')
			jQuery.ajax({type:'GET',data: {qid: ${quotation.id}, tag: id, title: title, createFlg: 'true'},
					 url:'${baseurl}/quotation/editsowtag',	
					 success:function(data,textStatus){jQuery('#sowpreviewMain').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		 	return false
					 
			});

		//jQuery('.editSowInputTagBtn').button();
		jQuery('.editSowInputTagBtn').click(function() {
			var id = jQuery(this).parent().attr('id')
			var title = jQuery(this).parent().attr('title')
			jQuery.ajax({type:'GET',data: {qid: ${quotation.id}, tag: id, title: title, createFlg: 'false'},
					 url:'${baseurl}/quotation/editsowtag',	
					 success:function(data,textStatus){jQuery('#sowpreviewMain').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		 	return false
					 
			});

		jQuery('#finalPreview').button();
		jQuery('#finalPreview').click(function(){
			jQuery.ajax({type:'POST',data: {id: ${quotation.id}},
				 url:'${baseurl}/quotation/finalPreviewSOW',
				 success:function(data,textStatus)
				 {
					 jQuery( "#dvPreview" ).dialog( "option", "zIndex", 10000 );
					 jQuery('#dvPreview').html(data);
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			});
					
			
		});

</script>
</g:else>

<div id="sowpreviewMain">
<div>
	
	<g:if test="${sowFinalPreview}"> 
		<g:form action="exportSOWInPDF" controller="quotation">
			<g:hiddenField name="sowId" value="${quotation.id}"></g:hiddenField>
			<g:submitButton name="btnExportSOW" title="Download PDF" value="Download PDF"></g:submitButton>
		</g:form>
	</g:if>
	<g:else>
		<button id="finalPreview" title="Show Preview"> Preview </button>
		<h1> Edit Highlighted sections before previewing SOW..</h1> 
	</g:else>
</div>
<div>
	<g:render template="/quotation/sow" model="['content': sowContent, 'sowLabel': sowLabel]"/>
</div>
</div>