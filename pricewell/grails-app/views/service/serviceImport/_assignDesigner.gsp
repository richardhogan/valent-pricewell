<%
	def baseurl = request.siteUrl
%>
<head>
	<script>

		 jQuery(document).ready(function(){
			 	jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {

			 		jQuery("#assignDesigner").validate();
			 	
			 })
			 
			 jQuery( "#successDialog" ).dialog(
				 	{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: {
							OK: function() {
								jQuery( "#successDialog" ).dialog( "close" );
								window.location.href = '${baseurl}/home';
								return false;
							}
						}
					});
					
					jQuery( "#failureDialog" ).dialog(
					{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: {
							OK: function() {
								jQuery( "#failureDialog" ).dialog( "close" );
								return false;
							}
						}
					});
				
			 		jQuery("#assignDesigner").submit(function() 
			 		{
			 			 showLoadingBox();
						 jQuery.post( '${baseurl}/service/saveServiceDesigner', jQuery("#assignDesigner").serialize(),
							      function( data ) 
							      {
							 		  hideLoadingBox();
							          if(data == 'success')
							          {		                   		                   		
					                   		if(${serviceProfileInstance.isImported == 'false'})
											{
					                   			jQuery( "#successDialog" ).dialog("open");
											}
								      }
								      else
								      {
					                  		jQuery( "#failureDialog" ).dialog("open");
								      }
							          
							      });
						 
						
						 return false;
					});

			});
		
		 
 	</script>
 </head>
 <body>
	<h4>Assign Service Designer</h4>
	<div id="successDialog" title="Success">
		<p><g:message code="assignServiceDesigner.message.success.dialog" default=""/></p>
	</div>
	
	<div id="failureDialog" title="Failure">
		<p><g:message code="assignServiceDesigner.message.failure.dialog" default=""/></p>
	</div>
	<g:form controller="service" action="saveStage" name="assignDesigner">
		<g:hiddenField name="id" value="${serviceProfileInstance.id}"></g:hiddenField>
		
		<tr class="prop">
			<td valign="top" class="name"><label for="serviceDesignerLead"><g:message
						code="serviceProfile.serviceDesignerLead.label"
						default="Service Designer Lead" />
			</label></td>
			<td valign="top"
				class="value ${hasErrors(bean: serviceProfileInstance, field: 'serviceDesignerLead', 'errors')}">
				<g:select name="serviceDesignerLead.id" from="${designerList?.sort {it.profile.fullName}}"
					optionKey="id" noSelection="['': 'Select any one']"
					value="${serviceProfileInstance.serviceDesignerLead?.id}" class="required" /></td>
		</tr>
		<br/>
		<br/>
		<!--
		<div class="buttons">
	          <span class="button">
	          	
	          <g:submitButton controller="service" action="saveStage" name="Assign Designer"/></span>
	          
	     </div>
	     -->
	</g:form>

</body>