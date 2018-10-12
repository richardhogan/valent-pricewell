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
		
		jQuery(".btnDeleteMetaphors").click(function()
		{
			var id = this.id.substring(18);
			jConfirm('Do you want to delete this Pre-requisite?', 'Please Confirm', function(r)
  				{
			    if(r == true)
   				{
			    	showLoadingBox();
			    	jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/serviceProfileMetaphors/deleteFromService",
						data: {id: id, metaphorType: '${metaphorType}', entityName: '${entityName}'},
						success: function(data)
						{
							hideLoadingBox();
							jQuery('#mainServiceProfileMetaphorsTab-${metaphorType }').html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
   				}
			});
				
			
			return false;
		}); 

		jQuery(".btnEditMetaphors").click(function()
		{
			var id = this.id.substring(16);
			showLoadingBox();
	    	jQuery.ajax(
			{
				type: "POST",
				url: "${baseurl}/serviceProfileMetaphors/editFromService",
				data: {id: id, metaphorType: '${metaphorType}', entityName: '${entityName}'},
				success: function(data)
				{
					hideLoadingBox();
					jQuery('#mainServiceProfileMetaphorsTab-${metaphorType }').html(data);
					
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){
					alert("Error while saving");
				}
			});
   				
			return false;
		}); 
	});

	function serviceMetaphorList()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileMetaphors/listMetaphors",
			data: {'serviceProfileId': ${serviceProfileInstance?.id}, 'metaphorType': '${metaphorType}', 'entityName': '${entityName}'},
			success: function(data){jQuery("#mainServiceProfileMetaphorsTab-${metaphorType}").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function createNewServiceMetaphor()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileMetaphors/createFromService",
			data: {'serviceProfileId': ${serviceProfileInstance?.id}, 'metaphorType': '${metaphorType}', 'entityName': '${entityName}'},
			success: function(data){jQuery("#mainServiceProfileMetaphorsTab-${metaphorType}").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>

<%--
<g:if test="${session['designPermit']}">
	<div class="nav">
		<g:if test="${session['serviceUpdatePermit']}">
			<g:if test="${session['checkResponsiblity']}">
				<span>
					<!--<g:remoteLink class="buttons.button button"
						controller="serviceProfileMetaphors" action="createFromService"
						params="['serviceProfileId': serviceProfileInstance?.id, 'metaphorType': metaphorType, 'entityName': entityName]" title="New ${entityName}"
						update="mainServiceProfileMetaphorsTab-${metaphorType }">
						 			New ${entityName}
						 </g:remoteLink>-->
					
					<a id="idCreateNewServiceMetaphor" onclick="createNewServiceMetaphor();" class="buttons.button button" title="New ${entityName}">New ${entityName}</a>
				</span>
			</g:if>
			 
			<g:if test="${serviceProfileInstance?.metaphors?.size() > 1 }">
				<!-- <span> <g:remoteLink class="buttons.button button" controller="serviceProfileMetaphors"
						action="changeOrders"
						params="[serviceProfileId: serviceProfileInstance?.id]" title="Change Orders Of Pre-requisite"
						update="[success:'mainServiceProfileMetaphorsTab',failure:'mainServiceProfileMetaphorsTab']">
						 			Change Orders
						 </g:remoteLink> </span> -->
			</g:if>
			<span>
				<!--<g:remoteLink controller="serviceProfileMetaphors" class="buttons.button button"
					params="['serviceProfileId': serviceProfileInstance?.id, 'metaphorType': metaphorType, 'entityName': entityName]"
					action="listMetaphors" title="Refresh List"
					update="mainServiceProfileMetaphorsTab-${metaphorType }" >
			    			Refresh
		    		</g:remoteLink>-->
		    		
		    	<a id="idServiceMetaphorList" onclick="serviceMetaphorList();" class="buttons.button button" title="Refresh List">Refresh</a>
		    </span>
    		
		</g:if>

	</div>
</g:if>

--%>
<div class="body">
	<h1>${entityName }</h1>
	<div class="list">
		<table>
			<tbody>

				
				<g:each in="${metaphorsList}" status="i" var="metaphorInstance">
					<tr><%-- class="${(i % 2) == 0 ? 'odd' : 'even'}"> --%>

						<td>
							<g:textArea name="description_${metaphorType}_${metaphorInstance.id}" value="${metaphorInstance?.definitionString?.value}" class="${metaphorType}_ckeditor required"/>
						</td>

						<td>
		                  	<button id="btnEditMetaphors${metaphorInstance?.id}" class="btnEditMetaphors" title="Edit">Edit</button>
		                </td>
		                
	                	<td>
		                  	<button id="btnDeleteMetaphors${metaphorInstance?.id}" class="btnDeleteMetaphors" title="Delete">Delete</button>
		                </td>
		                
					</tr>
					<tr></tr>

				</g:each>
			</tbody>
		</table>
	</div>
</div>

