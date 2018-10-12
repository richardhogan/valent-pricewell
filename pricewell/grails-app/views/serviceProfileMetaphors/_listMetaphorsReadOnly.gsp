<%@ page import="com.valent.pricewell.ServiceProfileMetaphors"%>

<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>

	jQuery(document).ready(function()
	{
		jQuery(".${metaphorType}_ckeditor").each(function( index ) {
			var name = this.id;

			var editor = CKEDITOR.instances[name];
		    if (editor) { editor.destroy(true); }
		    CKEDITOR.replace(name, {
		    	height: '10%',
		    	width: '90%',
		    	toolbar: [], readOnly: true, resize_enabled : false, resize_maxHeight : '20%'});
		});

	});
			
</script>

<div class="body">
	<h1><b>List of ${entityName}</b></h1>
	<div class="list">
		<table>
			<tbody>
				<g:each in="${metaphorsList}" status="i" var="metaphorInstance">
					<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
						<td>
							<g:textArea name="description_${metaphorType}_${metaphorInstance.id}" value="${metaphorInstance?.definitionString?.value}" class="${metaphorType}_ckeditor required"/>
						</td>
					</tr>
				</g:each>
			</tbody>
		</table>
	</div>
</div>

