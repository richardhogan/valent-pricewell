<%
	def baseurl = request.siteUrl
%><head>
  <meta name="layout" content="${grailsApplication.config.nimble.layout.administration}"/>
  <title><g:message code="nimble.view.user.create.title" /></title>
  
  <style>
		.msg {
			color: red;
		}
		em { font-weight: bold; padding-right: 1em; vertical-align: top; }
  </style>
  <script>
  		jQuery(document).ready(function()
		{
  			jQuery.validator.addMethod("password",function(value,element){
                return this.optional(element) || /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#\$%\^&\*()_\+\-={}\[\]\\:;]).{8,20}$/i.test(value);
            },"Password must be 8-16 characters logn with uppercase letters, lowercase letters, special character and at least one number.");

  			jQuery.validator.addMethod("confirm_password]",function(value,element){
  				return this.optional(element) || /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#\$%\^&\*()_\+\-={}\[\]\\:;]).{8,20}$/i.test(value);
            },"Password must be 8-16 characters logn with uppercase letters, lowercase letters, special character and at least one number.");

  			jQuery.validator.addMethod("phone", function(value, element) 
			{ 
				return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
			}, "Please enter a valid number.");
				
				/*jQuery.validator.addMethod("fax", function(value, element) 
				{ 
				return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
				}, "Please enter a valid number.");*/

				jQuery('#username').keyup(function(){
		  			jQuery("#usernameMsg").html('');
				});

		  		jQuery('#email').keyup(function(){
		  			jQuery("#emailMsg").html('');
				});

		  		jQuery('#phone').keyup(function(){
		  			jQuery("#phoneMsg").html('');
				});
				
		  		jQuery('#passConfirm').keyup(function(){
		  			jQuery("#passConfirmMsg").html('');
				});
			  				  			  		
			    jQuery("#userCreate").validate();
			    
			    jQuery( "#saveUser" ).click(function() 
				{
					if(jQuery('#userCreate').validate().form())
					{
						if(jQuery("#pass").val() == jQuery("#passConfirm").val())
						{
						//alert(jQuery("#userCreate").serialize());
    	   					jQuery.post( '${baseurl}/userSetup/save', 
            				  jQuery("#userCreate").serialize(),
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
							       		jQuery.post( '${baseurl}/administration/users/save', 
					            			jQuery("#userCreate").serialize(),
											function( data1 ) 
											{
												//alert(data1);
												if(data1 == "success")
												{
													//window.location.href = '${baseurl}/administration/users/list';
													//show/data1["id"]';
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
						else
						{
							jQuery("#passConfirmMsg").html('Error: Confirm password and password dose not match.');
						}
                		
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
							window.location.href = '${baseurl}/administration/users/list';
							return false;
						}
					}
				});		
			    	
			 });
  </script>
  
</head>

<body>
	<div id="failureDialog" title="Failure">
		<p>Failed to create new user.</p>
	</div>
	
	<div id="successDialog" title="Success">
		<p>User created successfully.</p>
	</div>
  <h2>Create User</h2>

  <p>
    <g:message code="nimble.view.user.create.descriptive" />
  </p>

  <n:errors bean="${user}"/>

  <g:form action="save" name="userCreate">
  	<input type="hidden" name="sourceOfCreate" value="advanceAdministrator"/>
    <table>
      <tbody>

      <tr>
        <td class="name"><label for="username"><g:message code="nimble.label.username" /></label></td>
        <td class="value">
		  <input type="text" size="30" id="username" name="username" value="${fieldValue(bean: user, field: 'username')}"  class="required easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>
		  <a href="#" id="usernamepolicybtn" rel="usernamepolicy" class="empty icon icon_help"></a>
        	<br/><div id="usernameMsg" class="msg"></div>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="pass"><g:message code="nimble.label.password" /></label></td>
        <td class="value">
          <input type="password" size="30" id="pass" name="pass" value="${user.pass?.encodeAsHTML()}"  class="required password easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>  
          <a href="#" id="passwordpolicybtn" rel="passwordpolicy" class="empty icon icon_help">&nbsp;</a>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="passConfirm"><g:message code="nimble.label.password.confirmation" /></label></td>
        <td class="value">
          <input type="password" size="30" id="passConfirm" name="passConfirm" value="${user.passConfirm?.encodeAsHTML()}" class="required confirm_password easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>
        	<br/><div id="passConfirmMsg" class="msg"></div>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="fullName"><g:message code="nimble.label.fullname" /></label></td>
        <td class="value">
          <input type="text" size="30" id="fullName" name="fullName" value="${user.profile?.fullName?.encodeAsHTML()}" class="required easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="email"><g:message code="nimble.label.email" /></label></td>
        <td class="value">
          <input type="text" size="30" id="email" name="email" value="${user.profile?.email?.encodeAsHTML()}" class="required email easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>
        	<br/><div id="emailMsg" class="msg"></div>
        </td>
      </tr>
	  
      <tr>
        <td class="name"><label for="phone"><g:message code="nimble.label.phone" default="Phone"/></label></td>
        <td class="value">
          <input type="text" size="30" id="phone" name="phone" value="${user.profile?.phone?.encodeAsHTML()}" class="required phone easyinput"/><span class="icon icon_bullet_green">&nbsp;</span>
        
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
		
      </tbody>
    </table>

    <div>
      <button class="button icon icon_user_add" type="button" id="saveUser" name="saveUser">Create User</button>
      <g:link action="list" class="button icon icon_cancel"><g:message code="nimble.link.cancel" /></g:link>
    </div>

  </g:form>

<script type="text/javascript">
nimble.createTip('usernamepolicybtn','<g:message code="nimble.template.usernamepolicy.title" />','<g:message code="nimble.template.usernamepolicy" encodeAs="JavaScript"/>');
nimble.createTip('passwordpolicybtn','<g:message code="nimble.template.passwordpolicy.title" />','<g:message code="nimble.template.passwordpolicy" encodeAs="JavaScript"/>');
</script>

</body>
