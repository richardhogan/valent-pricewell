<head>
  
  <title><g:message code="nimble.view.user.edit.title" /></title>
  <script>
	  jQuery(document).ready(function()
	  {		    
	  		jQuery("#userUpdate").validate();

	  		jQuery( "#successDialogEdit" ).dialog(
		 	{
				modal: true,
				autoOpen: false,
				buttons: 
				{
					OK: function() 
					{
						jQuery( "#successDialogEdit" ).dialog( "close" );
						
						jQuery.ajax({
							type: "POST",
							url: "/pricewell/user/showsetup",
							data: {id: <%=user?.id%>},
							success: function(data){
								
								refreshGeoGroupList();
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
						return false;
					}
				}
			});
			
			jQuery( "#failureDialogEdit" ).dialog(
			{
				modal: true,
				autoOpen: false,
				buttons: {
					OK: function() {
						jQuery( "#failureDialogEdit" ).dialog( "close" );
						return false;
					}
				}
			});

	  		jQuery("#saveUser").click(function(){
				if(jQuery("#userUpdate").valid()){
					jQuery.ajax({
						type: "POST",
						url: "/pricewell/user/update",
						data:jQuery("#userUpdate").serialize(),
						success: function(data){
							if(data == "success"){
								    		                   		
		                   		jQuery( "#successDialogEdit" ).dialog("open");
		                   		jQuery( "#userDialog" ).dialog( "close" );
							} else{
								    		                   		
		                   		jQuery( "#failureDialogEdit" ).dialog("open");
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
				}
				return false;
			}); 
	  });
		    
  </script>
</head>

<body>
	
    <div id="successDialogEdit" title="Successfully Updated">
		<p>User updated successfully.</p>
	</div>
	
	<div id="failureDialogEdit" title="Updation Failed">
		<p>User update failed.</p>
	</div>
  <h2><g:message code="nimble.view.user.edit.heading" args="[user.username]" /></h2>

  <p>
    <g:message code="nimble.view.user.edit.descriptive" />
  </p>

  <n:errors bean="${user}"/>

  <g:form class="editaccount" name="userUpdate">
    <input type="hidden" name="id" value="${user.id}"/>
    <input type="hidden" name="version" value="${user.version}"/>
	<g:hiddenField name="source" value="setup"/>
	
    <table>
      <tbody>

      <tr>
        <th><label for="username"><g:message code="nimble.label.username" /></label></th>
        <td class="value">
          <input type="text" id="username" name="username" value="${user.username?.encodeAsHTML()}" class="required"/><span class="icon icon_bullet_green">&nbsp;</span>
        </td>
      </tr>
      
	  <tr>
        <td class="name"><label for="fullName"><g:message code="nimble.label.fullname" /></label></td>
        <td class="value">
          <input type="text"  id="fullName" name="fullName" value="${user.profile?.fullName?.encodeAsHTML()}" />
        </td>
      </tr>
      
      <tr>
        <td class="name"><label for="email"><g:message code="nimble.label.email" /></label></td>
        <td class="value">
          <input type="text"  id="email" name="email" value="${user.profile?.email?.encodeAsHTML()}" class="required"/><span class="icon icon_bullet_green">&nbsp;</span>
        </td>
      </tr>

      <!--  <th><g:message code="nimble.label.externalaccount" /></th>
        <td>
          <g:if test="${user.external}">
            <input type="radio" name="external" value="true" checked="true"/><g:message code="nimble.label.true" />
            <input type="radio" name="external" value="false"/><g:message code="nimble.label.false" />
          </g:if>
          <g:else>
            <input type="radio" name="external" value="true"/><g:message code="nimble.label.true" />
            <input type="radio" name="external" value="false" checked="true"/><g:message code="nimble.label.false" />
          </g:else>
        </td>
      </tr>

      <tr>
        <th><g:message code="nimble.label.federatedaccount" /></th>
        <td>
          <g:if test="${user.federated}">
            <input type="radio" name="federated" value="true" checked="true"/><g:message code="nimble.label.true" />
            <input type="radio" name="federated" value="false"/><g:message code="nimble.label.false" />
          </g:if>
          <g:else>
            <input type="radio" name="federated" value="true"/><g:message code="nimble.label.true" />
            <input type="radio" name="federated" value="false" checked="true"/><g:message code="nimble.label.false" />
          </g:else>
        </td>
      </tr>		-->

				  
		
		<!-- <tr>
          <td valign="top" class="name"><label for="geo">Select Primary Territory</label></td>
          <td valign="top" class="value ${hasErrors(bean: user, field: 'primaryGeo', 'errors')}">
          	<g:select name="primaryGeo.id" value="${user?.primaryGeo?.encodeAsHTML()}" from="${grails.plugins.nimble.core.GeoBase.list()}" optionKey="id" noSelection="['': 'Select any one']"  class="required"/>
          </td>
        </tr>
        
        <tr>
          <td valign="top" class="name"><label for="geo">Select Other Territories</label></td>
          <td valign="top">
          	<g:select name="geos.id" from="${grails.plugins.nimble.core.GeoBase.list()}" optionKey="id" value="" noSelection="['': '']" multiple="true"/>
          </td>
        </tr>
        -->
      

      </tbody>
    </table>
    
	 <div class="buttons">
       
       <span class="button"><button id="saveUser"> Save </button></span>
     </div>
  </g:form>

</body>
