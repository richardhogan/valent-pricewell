<%@ page import="org.codehaus.groovy.grails.web.json.JSONObject" %>
<%
	def baseurl = request.siteUrl
%>

<html>
	<head>
	
		<style>
			hr { 
			    display: block;
			    margin-top: 0.5em;
			    margin-bottom: 0.5em;
			    margin-left: 0.5em;
			    margin-right: 0.5em;
			    border-style: inset;
			    border-width: 1px;
			} 
		</style>

		<script>
			var sowJsonString = '${sowJsonString}';
			var sowJsonContent = JSON.parse(sowJsonString);

			//var rolesByPhaseJsonString = '${rolesByPhaseJsonString}';
			//var rolesByPhaseJsonContent = JSON.parse(rolesByPhaseJsonString);
			
			jQuery(document).ready(function()
			{
				jQuery("#reviewSOWJsonDataFrm").validate();

				jQuery("#reviewSOWJsonDataFrm").submit(function(event) 
				{
					jQuery("#sowJsonObject").val(JSON.stringify(sowJsonContent));
					//jQuery("#rolesByPhaseJsonObject").val(JSON.stringify(rolesByPhaseJsonContent));
					
					if(jQuery('#reviewSOWJsonDataFrm').validate().form())
	   				{
						 var outputFilePath = '';
						 
						 showThrobberBox();
						 jQuery.ajax(
						 {
							 type:'POST',
							 url:"${baseurl}/quotation/storeSOWJsonAndGenerateSOW",
							 data: jQuery("#reviewSOWJsonDataFrm").serialize(),
							 success:function(data,textStatus)
							 {
								 //jQuery( "#viewJsonOfSowDialog" ).dialog( "close" );
								 outputFilePath = data; //data coming from ajax is generated document full path
								 downloadSOW(${quotationInstance?.id}, outputFilePath)
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown)
							 {
								 //hideLoadingBox();
								 //hideThrobberBox();
								 jQuery( "#generateSOWFailureDialog" ).dialog("open");
							 }
						 });
	   				}
	   				return false;
				});
				
				jQuery( ".deliverablePhases" ).keyup(function() {

					var id = this.id;
					var newPhaseName = jQuery("#"+id).val();
					var sequenceId = id.substring(6);
					
					jQuery.each(sowJsonContent.phases, function( index, value ) {
					  	if(sowJsonContent.phases[index].sequenceOrder == sequenceId)
						{
							var old = sowJsonContent.phases[index].phase;
					  		sowJsonContent.phases[index].phase = newPhaseName;//jQuery("#"+id).val();
					  		//alert("old : " + old + ", new : " + sowJsonContent.phases[index].phase);
					  		//alert("New : " + sowJsonContent[index].phase);
					  		return false;
					  	}
					});
					
					//alert(JSON.stringify(sowJsonContent));
				});

				jQuery( ".phaseDescription" ).keyup(function() {

					var id = this.id;
					var newPhaseDescription = jQuery("#"+id).val();
					var sequenceId = id.substring(17);
					
					jQuery.each(sowJsonContent.phases, function( index, value ) {
					  	if(sowJsonContent.phases[index].sequenceOrder == sequenceId)
						{
							var old = sowJsonContent.phases[index].phaseDescription;
					  		sowJsonContent.phases[index].phaseDescription = newPhaseDescription;//jQuery("#"+id).val();
					  		//alert("old : " + old + ", new : " + sowJsonContent.phases[index].phase);
					  		//alert("New : " + sowJsonContent[index].phase);
					  		return false;
					  	}
					});
					
				});

				jQuery( ".phaseCategory" ).keyup(function() 
				{
					var id = this.id;
					var newPhaseCategory = jQuery("#"+id).val();
					var ids = id.split("_");
					var phaseSequenceOrder = ids[1];
					var categorySequenceOrder = ids[2];
					
					jQuery.each(sowJsonContent.phases, function( index, value ) {
					  	if(sowJsonContent.phases[index].sequenceOrder == phaseSequenceOrder)
						{
							jQuery.each(sowJsonContent.phases[index].categories, function(catIndex, catValue){
								if(sowJsonContent.phases[index].categories[catIndex].sequenceOrder == categorySequenceOrder)
								{
									var old = sowJsonContent.phases[index].categories[catIndex].category;
									sowJsonContent.phases[index].categories[catIndex].category = newPhaseCategory;
							  		
							  		return false;
								}
							});
					  	}
					});
					
				});

				jQuery( ".phaseCategoryActivity" ).keyup(function() 
				{
					var id = this.id;
					var newPhaseActivity = jQuery("#"+id).val();
					var ids = id.split("_");
					var phaseSequenceOrder = ids[1];
					var categorySequenceOrder = ids[2];
					var activitySequenceOrder = ids[3];
					
					jQuery.each(sowJsonContent.phases, function( index, value ) {
					  	if(sowJsonContent.phases[index].sequenceOrder == phaseSequenceOrder)
						{
							jQuery.each(sowJsonContent.phases[index].categories, function(catIndex, catValue){
								if(sowJsonContent.phases[index].categories[catIndex].sequenceOrder == categorySequenceOrder)
								{
									jQuery.each(sowJsonContent.phases[index].categories[catIndex].activities, function(actIndex, actValue){
										if(sowJsonContent.phases[index].categories[catIndex].activities[actIndex].sequenceOrder == activitySequenceOrder)
										{
											var old = sowJsonContent.phases[index].categories[catIndex].activities[actIndex].name;
											sowJsonContent.phases[index].categories[catIndex].activities[actIndex].name = newPhaseActivity;
									  		
									  		return false;
										}
									});
								}
							});
					  	}
					});
					
				});

				jQuery( ".phaseDeliverable" ).keyup(function() 
				{
					var id = this.id;
					var newPhaseDeliverable = jQuery("#"+id).val();
					var ids = id.split("_");
					var phaseSequenceOrder = ids[1];
					var deliverableSequenceOrder = ids[2];
					
					jQuery.each(sowJsonContent.phases, function( index, value )
					{
					  	if(sowJsonContent.phases[index].sequenceOrder == phaseSequenceOrder)
						{
							jQuery.each(sowJsonContent.phases[index].deliverables, function(delIndex, delValue)
							{
								if(sowJsonContent.phases[index].deliverables[delIndex].sequenceOrder == deliverableSequenceOrder)
								{
									var old = sowJsonContent.phases[index].deliverables[delIndex].name;
									sowJsonContent.phases[index].deliverables[delIndex].name = newPhaseDeliverable;
							  		
							  		return false;
								}
							});
					  	}
					});
					
				});

				
			});

			
		</script>
		
		<style>
		  	.custom-combobox {
		    	position: relative;
		    	display: inline-block;
		  	}
		  	.custom-combobox-toggle {
		    	position: absolute;
		    	top: 0;
		    	bottom: 0;
		    	margin-left: -1px;
		    	padding: 0;
		  	}
		  	.custom-combobox-input {
		    	margin: 0;
		    	padding: 5px 10px;
		  	}
	  	</style>	
	</head>
		
	
	<div class="body">
		<div class="list">
		
			<g:form name="reviewSOWJsonDataFrm" method='POST' action="storeSOWJsonAndGenerateSOW" controller="quotation">
	    		<g:hiddenField name="id" value="${quotationInstance?.id}"/>
	    		<g:hiddenField name="sowJsonObject" value=""/>
	    		<%-- <g:hiddenField name="rolesByPhaseJsonObject" value=""/> --%>
	    		
	    		<g:each in="${sowJsonObject.get('phases')}" status="i" var="phases">
	    			<g:if test="${phases.get('deliverables').size() > 0}">
	    			
	    				<div class="collapsibleContainer">
							<div class="collapsibleContainerTitle ui-widget-header">
								<div>Phase <g:textField name="phase_${phases.get('sequenceOrder')}" value="${phases.get('phase')}" size="80" class="required deliverablePhases" /></div>
							</div>
						
							<div class="collapsibleContainerContent ui-widget-content">
								<table style="width: 60%;">
									<tbody>
										<tr>
									   		<td>Phase Description:</td><td><g:textArea name="phaseDescription_${phases.get('sequenceOrder')}" value="${phases.get('phaseDescription') }" rows="4" cols="80" class="phaseDescription"/></td>
								   		</tr>
									</tbody>
							   	</table>
							   	
							   	<h3 style="text-indent:50px;">Phase Activities List</h3><hr/>
							   	<g:each in="${phases.get('categories')}" status="ct" var="categoryInstance">
							   		<table>
								   		<tbody>
								   			<tr style="text-indent:50px;">
								   				<td><g:textField name="phaseCategory_${phases.get('sequenceOrder')}_${categoryInstance.get('sequenceOrder')}" value="${categoryInstance.get('category')}" size="80" class="required phaseCategory" /></td>
							   				</tr>
							   				
			   								<g:each in="${categoryInstance.get('activities')}" status="act" var="activityInstance">
				   								<tr style="text-indent:100px;">
				   									<td><g:textField name="phaseActivity_${phases.get('sequenceOrder')}_${categoryInstance.get('sequenceOrder')}_${activityInstance.get('sequenceOrder')}" value="${activityInstance.get('name')}" size="80" class="required phaseCategoryActivity" /></td>
				   								</tr>
			   								</g:each>
						   							
								   		</tbody>
								   	</table>
							   	</g:each>
							   	
							   	<h3 style="text-indent:50px;">Phase Deliverables</h3><hr/>
							   	
						   		<table style="width: 60%;">
							   		<tbody>
							   			<g:each in="${phases.get('deliverables')}" status="del" var="deliverableInstance">
								   			<tr style="text-indent:50px;">
								   				<td><g:textField name="phaseDeliverable_${phases.get('sequenceOrder')}_${deliverableInstance.get('sequenceOrder')}" value="${deliverableInstance.get('name')}" size="80" class="required phaseDeliverable" /></td>
							   				</tr>
						   				</g:each>
							   		</tbody>
							   	</table>								
							</div>
							
						</div><br/>
						
	    			</g:if>
	    			
				</g:each>
				
	    	</g:form>
    	
			
		</div>
	</div>				
</html>
	
