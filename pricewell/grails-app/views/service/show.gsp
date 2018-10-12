<%@ page import="com.valent.pricewell.Service"%>
<%@ page import="com.valent.pricewell.ServiceProfile"%>
<%@ page import="com.valent.pricewell.Staging"%>
<%
	def baseurl = request.siteUrl
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<g:set var="entityName"
	value="${message(code: 'service.label', default: 'ServiceProfile')}" />
	
<title><g:message code="default.show.label" args="[entityName]" />
</title>

<ckeditor:resources />

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
			}
	    	else{
	    		jQuery('#territorySOWDefinitionListPreview').html("");
			} 
		    	
    	});
	});
</script>
<style>


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

p.notes {
	background-color: #FFFFE0;
	font-size: 16px;
}

</style>
	<script>
		jQuery(function() {
			jQuery( "#tabsDiv" ).tabs();
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
	
	<g:if test="${flash.dialogMessage}">
	<script>
		jQuery(function() {
			jQuery( "#successDialog" ).dialog(
		 	{
				modal: true,
				autoOpen: true,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery(this).dialog('close');
					}
				}
			});
		});
	</script>
	</g:if>
	
</head>
<body>
						
	<div class="body">
	<g:if test="${flash.dialogMessage}">
	<div id="successDialog" title="Success Message">
		<p style="font-size: 14px">${flash.dialogMessage}</p>
	</div>
	</g:if>
	
	<div class="collapsibleContainer">
	
		<div class="collapsibleContainerTitle ui-widget-header"><div>Service: ${serviceProfileInstance.toString()}</div></div>
		
		
		<div class="collapsibleContainerContent">
	
	

			<g:render template="stageProgress" model="['serviceProfileInstance': serviceProfileInstance, 'stagingInstanceList': stagingInstanceList]"> </g:render>
			
			<g:if test="${createPermitted}">
				<g:render template="classicMenus" model="['serviceProfileInstance': serviceProfileInstance, 'updatePermitted': updatePermitted, 'createPermitted':createPermitted, 'reviewStage':reviewStage, 'stageChangedAllowed':stageChangedAllowed,'nextStage':nextStage]"> </g:render>
			</g:if>
			<g:else><hr/></g:else>
			
			
			<!--<g:if test="${serviceProfileInstance.type != ServiceProfile.ServiceProfileType.PUBLISHED}">
	        	<p class="notes"> Assigned person(s) for ${serviceProfileInstance.stagingStatus} Stage: ${responsiblePersons} </p>
	        </g:if>-->
			
			<div id="seviceDetails">
				<g:set var="calculatedEstimate"
					value="${serviceProfileInstance?.calculateTotalEstimatedTime()}" />
				
				<g:render template="show-info" model="['serviceProfileInstance': serviceProfileInstance, 'calculatedEstimate': calculatedEstimate]"/>
				
				<div id="tabsDiv">
					<ul>
						<li><a href="#tbDetails">Details</a></li>
						
						<g:if test="${serviceProfileInstance?.customerDeliverables?.size() > 0}">
							<li><a href="#tbCustomerDeliverables">Customer Deliverables</a></li>
						</g:if>
						<g:if test="${serviceProfileInstance?.stagingStatus?.sequenceOrder > 20}">
							<li><a href="#tbProductsRequired">Product Required</a></li>
							<li><a href="#tbRolesRequired">Roles Required</a></li>
						
							<li><a href="#tbMargin">Profit Margin</a></li>
							<li><a href="#tbDef">SOW Language</a></li>
							<li><a href="#tbPrerequisite">Pre-requisites</a></li>
							<li><a href="#tbOutOfScope">Out of Scope</a></li>
						</g:if>
										
					</ul>
				
				
					<div id="tbDetails" label="Details">
							<g:render template="show-detailedInfo" model="['serviceProfileInstance': serviceProfileInstance]"> </g:render>
					</div>
					
					
					<g:if test="${serviceProfileInstance?.customerDeliverables?.size() > 0}">
						<div id="tbCustomerDeliverables" label="Customer Delivarables"
							active="${selectedTab=='deliverables'}">
							<div id="mainCustomerDeliverablesTab" class="body">
								<g:render template="/serviceDeliverable/listCustomerDeliverables"
									model="['serviceProfileInstance': serviceProfileInstance, 'updatePermitted':updatePermitted]"></g:render>
							</div>
						</div>
					</g:if>
					
					<g:if test="${serviceProfileInstance?.stagingStatus?.sequenceOrder > 20}">
						<div id="tbProductsRequired" label="Products Required"
							active="${selectedTab=='products'}">
							<div id="mainProductsRequiredTab">
								<g:render template="/serviceProductItem/listServiceProductItems"
									model="['serviceProfileInstance': serviceProfileInstance]"></g:render>
							</div>
						</div>
						<div id="tbRolesRequired" label="Roles Required"
							active="${selectedTab=='roles'}">
							<div id="dvRolesRequired">
								<g:render template="/service/listRequiredRoles"
									model="['serviceProfileInstance': serviceProfileInstance]"></g:render>
							</div>
						</div>
					</g:if>
					<g:if test="${serviceProfileInstance?.stagingStatus?.sequenceOrder > 20}">
						<div id="tbMargin" label="Profit Margin">
							<g:render template="/service/marginCalculation"
								model="['serviceProfileInstance':serviceProfileInstance]"></g:render>
						</div>
						
						<div id="tbDef" label="SOW Language">
							<g:if test="${territoryList.size() > 0 }">
								<div>
									<b>Select Territory </b>&nbsp;&nbsp; <g:select name="territoryId" class="territoryId" from="${territoryList?.sort {it.name}}" value="" optionKey="id" optionValue="name" noSelection="['': 'Select Any One']"/>
									&nbsp; &nbsp;
									<g:if test="${hasDefaultSOWDefinition}">
										<span class="button">
											<a id="idgetDefaultSOWDefinition" onclick="getDefaultSOWDefinition();" class="buttons.button button" title="Show Default SOW Language">Default Language</a>
										</span>
									</g:if>
									
								</div>
								
								<div  id="territorySOWDefinitionListPreview">
									<g:if test="${hasDefaultSOWDefinition}">
										<g:render template="/service/showDefinition"
											model="['serviceProfileInstance':serviceProfileInstance, 'writable': true, 'defaultSOWDefinition': defaultSOWDefinition, 'readOnly': readOnly]"></g:render>
									</g:if>
								</div>
							</g:if>
							<g:else>
								<g:render template="/service/showDefinition"
									model="['serviceProfileInstance':serviceProfileInstance, 'writable': true, 'defaultSOWDefinition': defaultSOWDefinition, 'readOnly': readOnly]"></g:render>
							</g:else>
							
						</div>	
						
						<div id="tbPrerequisite" label="Pre-requisites">
							<g:render template="/serviceProfileMetaphors/listMetaphorsReadOnly"	model="['metaphorsList':prerequisitesList, 'entityName': 'Pre-requisite', 'metaphorType': 'prerequisites']"></g:render>
						</div>
						
						<div id="tbOutOfScope" label="Out of Scope">
							<g:render template="/serviceProfileMetaphors/listMetaphorsReadOnly"	model="['metaphorsList':outOfScopeList, 'entityName': 'Out of Scope', 'metaphorType': 'outofscope']"></g:render>
						</div>
						
					</g:if>			
				</div>
			</div>
		</div>
		</div>
	</div>
	
</body>
</html>
