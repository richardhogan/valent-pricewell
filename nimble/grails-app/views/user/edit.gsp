<%
	def baseurl = request.siteUrl
%>
<head>
  <meta name="layout" content="${grailsApplication.config.nimble.layout.administration}"/>
  <title><g:message code="nimble.view.user.edit.title" /></title>
  
  <style>
		.msg {
			color: red;
		}
		em { font-weight: bold; padding-right: 1em; vertical-align: top; }
  </style>
  <script>
	  jQuery(document).ready(function()
	  {		    
	  		jQuery("#editaccount").validate();

	  		jQuery.validator.addMethod("phone", function(value, element) 
			{ 
				return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
			}, "Please enter a valid number.");
				
	  		jQuery('#username').keyup(function(){
	  			jQuery("#usernameMsg").html('');
			});

	  		jQuery('#email').keyup(function(){
	  			jQuery("#emailMsg").html('');
			});

	  		jQuery('#phone').keyup(function(){
	  			jQuery("#phoneMsg").html('');
			});
			
	  		jQuery( "#updateUser" ).click(function() 
			{
				if(jQuery('#editaccount').validate().form())
				{
					
  	   				jQuery.post( '${baseurl}/userSetup/update', 
          				  jQuery("#editaccount").serialize(),
				      function( data ) 
				      {
				      
					      	if(data == "username_Available")
					      	{
					        	jQuery("#usernameMsg").html('Error: This username is already registered with an existing user account.');
					       	}
					       	else if(data == "email_Available")
					       	{
					        	jQuery("#emailMsg").html('Error: This email is already registered with an existing user account.');
					       	}
					       	else if(data == "invalid_phone")
					       	{
					        	jQuery("#phoneMsg").html('Error: This phone number is not valid as per the selected country.');
					       	} 
					       	else
					       	{
						       	
						       	var phone = data.substring(7);
						       	jQuery("#phone").val(phone);
					       		jQuery.post( '${baseurl}/administration/users/update', 
			            			jQuery("#editaccount").serialize(),
									function( data1 ) 
									{
										//alert(data1);
										if(data1 == "success")
										{
											jQuery("#successDialog").dialog( "open" );
										}
										else
										{
											jQuery("#failureDialog").dialog( "open" );
										}
									});
					       	}
				          
				      });
					
               		
           		}
				return false;
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

		    jQuery( "#successDialog" ).dialog(
			{
				modal: true,
				autoOpen: false,
				resizable: false,
				buttons: {
					OK: function() {
						jQuery( "#successDialog" ).dialog( "close" );
						window.location.href = '${baseurl}/administration/users/show/${user.id}';
						return false;
					}
				}
			});	
	  });
		    
  </script>
</head>

<body>
	<div id="failureDialog" title="Failure">
		<p>Failed to update user : ${user.profile?.fullName?.encodeAsHTML()}.</p>
	</div>
	
	<div id="successDialog" title="Success">
		<p>User updated successfully.</p>
	</div>
  <h2>Edit User ${user.username }</h2>
  <p>
    <g:message code="nimble.view.user.edit.descriptive" />
  </p>

  <n:errors bean="${user}"/>

  <g:form action="update" class="editaccount" name="editaccount">
    <input type="hidden" name="id" value="${user.id}"/>
    <input type="hidden" name="version" value="${user.version}"/>
    <input type="hidden" name="sourceOfUpdate" value="advanceAdministrator"/>

    <table>
      <tbody>

      <tr>
        <th><label for="username"><g:message code="nimble.label.username" /></label><em>*</em></th>
        <td class="value">
          <input type="text" size="30" id="username" name="username" value="${user.username?.encodeAsHTML()}" class="required"/><!-- <span class="icon icon_bullet_green">&nbsp;</span>-->
        	<br/><div id="usernameMsg" class="msg"></div>
        </td>
      </tr>
      
	  <tr>
        <td class="name"><label for="fullName"><g:message code="nimble.label.fullname" /></label></td>
        <td class="value">
          <input type="text" size="30" id="fullName" name="fullName" value="${user.profile?.fullName?.encodeAsHTML()}" />
        </td>
      </tr>
      
      <tr>
        <td class="name"><label for="email"><g:message code="nimble.label.email" /></label><em>*</em></td>
        <td class="value">
          <input type="text" size="30" id="email" name="email" value="${user.profile?.email?.encodeAsHTML()}" class="required"/><!-- <span class="icon icon_bullet_green">&nbsp;</span>-->
        	<br/><div id="emailMsg" class="msg"></div>
        </td>
      </tr>

	  <tr>
        <td class="name"><label for="phone"><g:message code="nimble.label.phone" default="Phone"/></label><em>*</em></td>
        <td class="value">
          <input type="text" size="30" id="phone" name="phone" value="${user.profile?.phone?.encodeAsHTML()}" class="required phone easyinput"/><!--  <span class="icon icon_bullet_green">&nbsp;</span>-->
	        
			<br/>
				
        	<g:countrySelect name="phoneCountry"
			                 from="['afg','alb','dza','asm','and','ago','aia','ata','atg','arg','arm','abw','aus','aut','aze'
									,'bhs','bhr','bgd','brb','blr','bel','blz','ben','bmu','btn','bol','bih','bwa','bra','iot'
									,'vgb','brn','bgr','bfa','bdi','khm','cmr','can','cpv','cym','caf','tcd','chl','chn'
									,'cxr','cck','col','com','cok','hrv','cub','cyp','cze','dnk','dji','dma','dom'
									,'ecu','egy','slv','gnq','eri','est','eth','flk','fro','fji','fin','fra','pyf','gab','gmb'
									,'geo','deu','gha','gib','grc','grl','grd','gum','gtm','gin','gnb','guy','hti','hnd'
									,'hkg','hun','ind','idn','irn','irq','irl','imn','isr','ita','jam','jpn','jor'
									,'kaz','ken','kir','kwt','kgz','lao','lva','lbn','lso','lbr','lby','lie','ltu','lux','mac'
									,'mdg','mwi','mys','mdv','mli','mlt','mhl','mrt','mus','myt','mex','fsm','mda','mco'
									,'mng','msr','mar','moz','mmr','nam','nru','npl','nld','ant','ncl','nzl','nic','ner','nga'
									,'niu','nfk','prk','mnp','nor','omn','pak','plw','pan','png','pry','per','phl','pcn','pol'
									,'prt','pri','qat','cog','rou','rus','rwa','shn','kna','lca','spm','vct','wsm'
									,'smr','stp','sau','sen','syc','sle','sgp','svk','svn','slb','som','zaf','kor','esp'
									,'lka','sdn','sur','sjm','swz','swe','che','syr','twn','tjk','tza','tha','tls','tgo','tkl'
									,'ton','tto','tun','tur','tkm','tca','tuv','uga','ukr','are','gbr','usa','ury','vir','uzb'
									,'vut','ven','vnm','wlf','esh','yem','zmb','zwe']" class="required"
			                 value="${user.profile?.country?.encodeAsHTML()}" style="height: 30px;" noSelection="['':'-Select Country Please-']" class="required"/>
        	<br/><div id="phoneMsg" class="msg"></div>
        </td>
      </tr>
      
        <th><g:message code="nimble.label.externalaccount" /></th>
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
      </tr>

		
		
        
      <tr>
        <td/>
        <td>
          <div class="buttons">
            <!-- <button class="button icon icon_user_go" type="submit">Update User</button> -->
            <button class="button icon icon_user_go" type="button" id="updateUser" name="updateUser">Update User</button>
            <g:link action="show" id="${user.id}" class="button icon icon_cross"><g:message code="nimble.link.cancel" /></g:link>
          </div>
        </td>
      </tr>

      </tbody>
    </table>

  </g:form>

</body>
