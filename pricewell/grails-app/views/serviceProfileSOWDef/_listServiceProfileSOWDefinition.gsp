<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.ServiceProfileSOWDef"%>

<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>
	jQuery(function() {

	  	jQuery(".territoryId").change(function () 
    	{
	    	if(this.value != "" && this.value != null)
		    {
	    		jQuery.ajax({type:'POST',data: {territoryId: this.value, serviceProfileId: ${serviceProfileInstance?.id}},
					 url:'${baseurl}/serviceProfileSOWDef/getTerritorySOWDefinition',
					 success:function(data,textStatus){jQuery('#territorySOWDefinitionList').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			}else{
	    		jQuery('#territorySOWDefinitionListPreview').html("");
			} 
    	});
	});

	function addNewSow()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileSOWDef/createFromService",
			data: {'serviceProfileId': ${serviceProfileInstance?.id} },
			success: function(data){jQuery("#mainSOWDefinitionTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function refreshSowDefList()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileSOWDef/listServiceProfileSOWDefinition",
			data: {'serviceProfileId': ${serviceProfileInstance?.id} },
			success: function(data){jQuery("#mainSOWDefinitionTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

	function showDefaultSowDef()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileSOWDef/getDefaultSOWDefinition",
			data: {'id': ${serviceProfileInstance?.id} },
			success: function(data)
			{
				jQuery("#territorySOWDefinitionList").html(data);
				jQuery('.territoryId').val('');
			}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>



<g:if test="${session['designPermit']}">
	<div class="nav">
		<g:if test="${session['serviceUpdatePermit']}">
			<g:if test="${session['checkResponsiblity']}">
				<span>
					<!--<g:remoteLink class="buttons.button button"
						controller="serviceProfileSOWDef" action="createFromService"
						params="['serviceProfileId': serviceProfileInstance?.id ]" title="New SOW Definition"
						update="[success:'mainSOWDefinitionTab',failure:'mainSOWDefinitionTab']">
						 			Add New
						 </g:remoteLink>-->
						 
					<a id="addNewSOWDef" onclick="addNewSow();" class="buttons.button button" title="New SOW Definition">Add New</a>
				</span>
			</g:if>
			 
			<span> 
				<!--<g:remoteLink controller="serviceProfileSOWDef" class="buttons.button button"
					params="['serviceProfileId': serviceProfileInstance?.id]"
					action="listServiceProfileSOWDefinition" title="List Of SOW Definition"
					update="[success:'mainSOWDefinitionTab',failure:'mainSOWDefinitionTab']" >
			    			Refresh
		    		</g:remoteLink>-->
		    		
		    		<a id="refreshSOWDefList" onclick="refreshSowDefList();" class="buttons.button button" title="List Of SOW Definition">Refresh</a> 
		    </span>
		    		
		    <g:if test="${hasDefaultSOWDefinition}">
				<span class="button">
					<!--<g:remoteLink action="getDefaultSOWDefinition" controller="serviceProfileSOWDef" update="[success:'territorySOWDefinitionList',failure:'territorySOWDefinitionList']"
									class="buttons.button button" title="Show Default SOW Language" onComplete="jQuery('.territoryId').val('');"
									id="${serviceProfileInstance?.id}" >
										Default Language
									</g:remoteLink>-->
									
					<a id="defaultSowLanguage" onclick="showDefaultSowDef();" class="buttons.button button" title="Show Default SOW Language">Default Language</a>
				</span>
			</g:if>
    		
		</g:if>
	
	</div>
</g:if>
<div>
	<g:if test="${territoryList?.size() > 0}">
		<b>Select Territory </b>&nbsp;&nbsp; <g:select name="territoryId" class="territoryId" from="${territoryList?.sort {it.name}}" value="" optionKey="id" optionValue="name" noSelection="['': 'Select Any One']"/>
	</g:if>
</div>

<div  id="territorySOWDefinitionList">
	<g:if test="${hasDefaultSOWDefinition}">
		<g:render template="../service/showDefinition" model="['serviceProfileInstance': serviceProfileInstance, 'defaultSOWDefinition': defaultSowDef, 'readOnly': readOnly]"/>
	</g:if>
</div>

