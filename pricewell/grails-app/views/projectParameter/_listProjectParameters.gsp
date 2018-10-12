<%@ page import="com.valent.pricewell.ProjectParameter"%>
<%@ page import="com.valent.pricewell.Quotation"%>

<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>

	jQuery(document).ready(function()
	{
		jQuery(".ckeditor").each(function( index ) {
			var name = this.id;

			var editor = CKEDITOR.instances[name];
		    if (editor) { editor.destroy(true); }
		    CKEDITOR.replace(name, {
		    	height: '10%',
		    	width: '90%',
		    	indentOffset: 30,
		    	toolbar: [], readOnly: true, resize_enabled : false, resize_maxHeight : '20%'});
		});

		jQuery("#sowSupportParameterSelection").change(function(){
			if( jQuery("#sowSupportParameterSelection").val() != '' ){
				jQuery("#value").val(jQuery("#sowSupportParameterSelection").val());
				CKEDITOR.instances[name].setData(jQuery("#sowSupportParameterSelection").val());
			}
		});
		
		jQuery(".btnDeleteProjectParameter").click(function()
		{
			var id = this.id.substring(26);
			jConfirm('Do you want to delete this Project Parameter?', 'Please Confirm', function(r)
  				{
			    if(r == true)
   				{
			    	showLoadingBox();
			    	jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/projectParameter/deleteFromQuotationSow",
						data: {id: id, quotationId: ${quotationInstance?.id}},
						success: function(data)
						{
							hideLoadingBox();
							jQuery('#mainSOWProjectParametersTab').html(data);
							hideUnhideNextBtn();
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
   				}
			});
				
			
			return false;
		}); 

		jQuery(".btnEditProjectParameter").click(function()
		{
			var id = this.id.substring(24);
			showLoadingBox();
	    	jQuery.ajax(
			{
				type: "POST",
				url: "${baseurl}/projectParameter/editFromQuotationSow",
				data: {id: id, quotationId: ${quotationInstance?.id}},
				success: function(data)
				{
					hideLoadingBox();
					jQuery('#mainSOWProjectParametersTab').html(data);
					
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){
					alert("Error while saving");
				}
			});
   				
			return false;
		}); 
	});

	function loadValues(){
		var name = 'value'
		jQuery('#value').val(CKEDITOR.instances[name].getData());
	}

	function createFromQuotationSow()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/projectParameter/createFromQuotationSow",
			data: {'quotationId': ${quotationInstance?.id} },
			success: function(data){jQuery("#mainSOWProjectParametersTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function listProjectParameters()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/projectParameter/listProjectParameters",
			data: {quotationId: ${quotationInstance?.id} },
			success: function(data){jQuery("#mainSOWProjectParametersTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>


	<g:if test="${isReadOnly == false }">
		<%-- <div class="nav">
			<!-- <span> <g:remoteLink class="buttons.button button"
					controller="projectParameter" action="createFromQuotationSow"
					params="['quotationId': quotationInstance?.id]" title="New Project Parameter"
					update="mainSOWProjectParametersTab">
					 		New Project Parameter
					</g:remoteLink> </span>
			
			 
			<span> <g:remoteLink controller="projectParameter" class="buttons.button button"
					params="[quotationId: quotationInstance?.id]"
					action="listProjectParameters" title="Refresh List"
					update="mainSOWProjectParametersTab" >
			    			Refresh
		    		</g:remoteLink> </span>
    		-->
			<span>
				<a id="idcreateFromQuotationSow" onclick="createFromQuotationSow();" class="buttons.button button" title="New Project Parameter">New Project Parameter</a>
			</span>
			
			<span>
				<a id="idlistProjectParameters" onclick="listProjectParameters();" class="buttons.button button" title="Refresh">Refresh</a>
			</span>
		</div> --%>
	</g:if>
	

<div class="body">
	<h1>${entityName }</h1>
	<div class="list">
		<table>
			<tbody>

				
				<g:each in="${quotationInstance?.projectParameters}" status="i" var="projectParameterInstance">
					<tr>

						<td>
							${i+1})
						</td>
						
						<td style="width: 85%">
							<g:textArea name="value-${projectParameterInstance?.id}" value="${projectParameterInstance?.value}" rows="10" cols="80" readOnly="true" class="ckeditor required"/>
							
						</td>

						<g:if test="${isReadOnly == false }">
							<td>
			                  	<button id="btnEditProjectParameter-${projectParameterInstance?.id}" class="btnEditProjectParameter" title="Edit">Edit</button>
			                </td>
	                
			                <td>
			                  	<button id="btnDeleteProjectParameter-${projectParameterInstance?.id}" class="btnDeleteProjectParameter" title="Delete">Delete</button>
			                </td>
						</g:if>
						
					</tr>

				</g:each>
			</tbody>
		</table>
	</div>
</div>

