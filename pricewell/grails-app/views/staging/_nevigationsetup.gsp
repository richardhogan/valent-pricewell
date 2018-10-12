<%
	def baseurl = request.siteUrl
%>
	
<script type="text/javascript">
  		
	function showWorkflowSettingsList(type)
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/staging/updateList",
			data: {type: type, source: 'setup'},
			success: function(data){jQuery("#mainWorkflowSettingTab").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
		
		return false;
	}

</script>


<ul class="navigation" id="plain">
	<li class="navigation_first">
		<a id="serviceWorkflow" onclick="showWorkflowSettingsList('service');" class="hyperlink" title="Service Workflow">Service Workflow</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'service', source: 'setup']" title="Service Workflow" update="mainWorkflowSettingTab">Service Workflow</g:remoteLink>-->
	</li>
	
	<li>
		<a id="serviceWorkflowMode" onclick="showWorkflowSettingsList('serviceWorkflowMode');" class="hyperlink" title="Service Workflow Mode">Service Workflow Mode</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'serviceWorkflowMode', source: 'setup']" title="Service Workflow Mode" update="mainWorkflowSettingTab">Service Workflow Mode</g:remoteLink>-->
	</li>
	
	<li>
		<a id="customizeSubstages" onclick="showWorkflowSettingsList('serviceSubstages');" class="hyperlink" title="Customize Substages">Customize Substages</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'serviceSubstages', source: 'setup']" title="Customize Substages" update="mainWorkflowSettingTab">Customize Substages</g:remoteLink>-->
	</li>
	
	<li>
		<a id="leadWorkflow" onclick="showWorkflowSettingsList('lead');" class="hyperlink" title="Lead Workflow">Lead Workflow</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'lead', source: 'setup']" title="Lead Workflow" update="mainWorkflowSettingTab">Lead Workflow</g:remoteLink>-->
	</li>
		
	<li>
		<a id="opportunityWorkflow" onclick="showWorkflowSettingsList('opportunity');" class="hyperlink" title="Opportunity Workflow">Opportunity Workflow</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'opportunity', source: 'setup']" title="Opportunity Workflow" update="mainWorkflowSettingTab">Opportunity Workflow</g:remoteLink>-->
	</li>
	
	<li>
		<a id="quotationWorkflow" onclick="showWorkflowSettingsList('quotation');" class="hyperlink" title="Quotation Workflow">Quotation Workflow</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'quotation', source: 'setup']" title="Quotation Workflow" update="mainWorkflowSettingTab">Quotation Workflow</g:remoteLink>-->
	</li>
		
	<li class="navigation_last">
		<a id="quotationWorkflowMode" onclick="showWorkflowSettingsList('quotationWorkflowMode');" class="hyperlink" title="Quotation Workflow Mode">Quotation Workflow Mode</a>
		
		<!--<g:remoteLink class="hyperlink" controller="staging" action="updateList" params="[type: 'quotationWorkflowMode', source: 'setup']" title="Quotation Workflow Mode" update="mainWorkflowSettingTab">Quotation Workflow Mode</g:remoteLink>-->
	</li>
	
	
	
</ul>