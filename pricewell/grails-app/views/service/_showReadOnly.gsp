<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>
<%@ page import="com.valent.pricewell.Staging"%>
<html>
<head>

<%
	def baseurl = request.siteUrl
%>
<script>
	jQuery(function() {

	  	jQuery(".territoryId").change(function () 
    	{
	    	if(this.value != "" && this.value != null)
		    {
	    		jQuery.ajax({type:'POST',data: {territoryId: this.value, serviceProfileId: ${serviceProfileInstance?.id}, type: "readOnly"},
					 url:'${baseurl}/serviceProfileSOWDef/getTerritorySOWDefinition',
					 success:function(data,textStatus){jQuery('#territorySOWDefinitionListPreview').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
			}else{
	    		jQuery('#territorySOWDefinitionListPreview').html("");
			} 
    	});
	});

	function getDefaultSOWDefinition()
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/serviceProfileSOWDef/getDefaultSOWDefinition",
			data: {'id': ${serviceProfileInstance?.id}, 'type': 'readOnly'},
			success: function(data)
			{
				jQuery('.territoryId').val('');
				jQuery("#territorySOWDefinitionListPreview").html(data);
			}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}
</script>

<style>
p {
	font-size: 1%;
	margin: 0 0 0em;
}

td.name {
	font-weight: bold;
	font-size: 85%
}

td.Value {
	font-weight: bold;
	font-size: 95%
}

td.reduced {
	font-size: 90%
}

</style>
<script>
	jQuery(function() {
		jQuery( "#tabsDiv" ).tabs();
	});
	</script>
</head>
<body>
  	

	<div>
					
		<div id="seviceDetails">
			<g:set var="calculatedEstimate"
				value="${serviceProfileInstance?.calculateTotalEstimatedTime()}" />
			
			<g:render template="show-info" model="['serviceProfileInstance':serviceProfileInstance, 'calculatedEstimate': calculatedEstimate]"> </g:render>
			
			<div id="tabsDiv">
				<ul>
						<li><a href="#tbDetails">Details</a></li>
						<li><a href="#tbCustomerDeliverables">Customer Deliverables</a></li>
						<li><a href="#tbProductsRequired">Product Required</a></li>
						<li><a href="#tbRolesRequired">Roles Required</a></li>
						<li><a href="#tbMargin">Profit Margin</a></li>
						<li><a href="#tbDef">SOW Language</a></li>
						<li><a href="#tbPrerequisite">Pre-requisites</a></li>
						<li><a href="#tbOutOfScope">Out of Scope</a></li>
									
				</ul>
			
			
					<div id="tbDetails" label="Details">
						<g:render template="show-detailedInfo" model="['serviceProfileInstance':serviceProfileInstance]"> </g:render>
					</div>
					
					<div id="tbCustomerDeliverables" label="Customer Delivarables"
						active="${selectedTab=='deliverables'}">
						<div id="mainCustomerDeliverablesTab" class="body">
							<g:render template="/serviceDeliverable/listCustomerDeliverablesReadOnly"
								model="['serviceProfileInstance':serviceProfileInstance, 'updatePermitted':false]"></g:render>
						</div>
					</div>
				
					<div id="tbProductsRequired" label="Products Required"
						active="${selectedTab=='products'}">
						<div id="mainProductsRequiredTab">
							<g:render template="/serviceProductItem/listServiceProductItems"
								model="['serviceProfileInstance':serviceProfileInstance]"></g:render>
						</div>
					</div>
					
					<div id="tbRolesRequired" label="Roles Required"
						active="${selectedTab=='roles'}">
						<div id="dvRolesRequired">
							<g:render template="/service/listRequiredRoles"
								model="['serviceProfileInstance':serviceProfileInstance]"></g:render>
						</div>
					</div>
					
					<div id="tbMargin" label="Profit Margin">
						<g:render template="/service/marginCalculation"
							model="['serviceProfileInstance':serviceProfileInstance]"></g:render>
					</div>
					
					<div id="tbDef" label="SOW Language">
						<div>
							<b>Select Territory </b>&nbsp;&nbsp; <g:select name="territoryId" class="territoryId" from="${territoryList?.sort {it.name}}" value="" optionKey="id" optionValue="name" noSelection="['': 'Select Any One']"/>
							
							<g:if test="${hasDefaultSOWDefinition}">
								<span class="button">
									<a id="idgetDefaultSOWDefinition" onclick="getDefaultSOWDefinition();" class="buttons.button button" title="Show Default SOW Language">Default Language</a>
								</span>
							</g:if>
						</div>
						
						<div  id="territorySOWDefinitionListPreview">
							<g:if test="${hasDefaultSOWDefinition}">
								<g:render template="../service/showDefinition" model="['serviceProfileInstance': serviceProfileInstance, 'defaultSOWDefinition': defaultSowDef, 'readOnly': readOnly]"/>
							</g:if>
						</div>
						
						
					</div>				
					
					<div id="tbPrerequisite" label="Pre-requisites">
						<g:render template="/serviceProfileMetaphors/listMetaphorsReadOnly"	model="['metaphorsList':prerequisiteMetaphorsList, 'entityName': 'Pre-requisite', 'metaphorType': 'prerequisites']"></g:render>
					</div>
					
					<div id="tbOutOfScope" label="Out of Scope">
						<g:render template="/serviceProfileMetaphors/listMetaphorsReadOnly"	model="['metaphorsList':outOfScopeMetaphorsList, 'entityName': 'Out of Scope', 'metaphorType': 'outofscope']"></g:render>
					</div>
			</div>
		</div>
		
	</div>
	
</body>
</html>
