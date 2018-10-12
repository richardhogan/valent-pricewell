<%
	def baseurl = request.siteUrl
%>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="forChangePassword" />  
        <title><g:message code="nimble.view.user.changepassword.title" /></title>
        <style>
       		.box_1 {
			   width: 40%;
			   height: auto;
			   border-top: 1px solid #0000FF;
			   border-bottom: 1px solid #0000FF;
			   border-right: 1px solid #0000FF;
			   border-left: 1px solid #0000FF;
			}
			.msg {
				color: red;
			}
        </style>
        
  		<script>
			 jQuery(function() 
			 {				
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
				 
				  jQuery("#changePasswordFrm").validate();
				  
				  jQuery('#pass_old').keyup(function(){
			  			jQuery("#oldpasswordMsg").html('');
					});
					
				  jQuery('#passConfirm').keyup(function(){
			  			jQuery("#confnewpasswordMsg").html('');
					});
					
				  jQuery('#pass').keyup(function(){
			  			jQuery("#newpasswordMsg").html('');
					});
			
				  jQuery("#changebtn").click(function()
				  {
						if(jQuery("#changePasswordFrm").validate().form())
						{
							if(jQuery("#pass").val() != jQuery("#passConfirm").val())
							{
								jQuery("#confnewpasswordMsg").html('Confirm password is not match with New password.');
							}
							else
							{
								jQuery.ajax(
								{
									type: "POST",
									url: "${baseurl}/userSetup/savepassword",
									data:jQuery("#changePasswordFrm").serialize(),
									success: function(data)
									{
										if(data == "not_match")
										{
											jQuery("#oldpasswordMsg").html('Old password is incorrect.');
										}
										else if(data == "sort_password"){
											jQuery("#newpasswordMsg").html('Password to short. Minimum size is 8 required.');
										}
										else if(data == "not_contain_lowercase_letters" || data == "not_contain_uppercase_letters" || data == "not_contain_numbers" || data == "not_contain_symbols"){
											jQuery("#newpasswordMsg").html("Password must contain uppercase A-Z, lowercase a-z, a number and a symbol (ie. '!','$')");
										}
										else if(data == "success")
										{
											jQuery( "#successDialog" ).dialog( "open" );
										}
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){
										alert("Error while saving");
									}
								});
							}
						}
						return false;
					}); 
				  
			 });
  		</script>
</head>

		
<body>
	<div class="box_1">
	<center><h2><g:message code="nimble.view.user.changepassword.heading" args="[user.username]" /></h2></center>

		<div id="successDialog" title="Success">
			<p><g:message code="userPasswordChanged.message.success.dialog" default=""/></p>
		</div>
			
	<p>
	  <g:message code="nimble.view.user.changepassword.descriptive" />
	</p>

	<n:errors bean="${user}"/>

	
		<g:form action="savepassword" class="passwordchange" name="changePasswordFrm">
		  <g:hiddenField name="id" value="${user.id.encodeAsHTML()}"/>
		  <table>
		    <tbody>
		    <tr>
		      <th>Old Password</th>
		      <td>
		        <input type="password" id="pass_old" name="pass_old" class="required easyinput"/>
			    <span class="icon icon_bullet_green" alt="required">&nbsp;</span>
			    <br/><div id="oldpasswordMsg" class="msg"></div>
		      </td>
		  	</tr>
		    <tr>
		      <th>New Password</th>
		      <td>
		        <input type="password" id="pass" name="pass" class="password required easyinput"/>
			    <span class="icon icon_bullet_green" alt="required">&nbsp;</span>
			    <br/><div id="newpasswordMsg" class="msg"></div>
		      </td>
		    </tr>
	
		    <tr>
		      <th>Confirm New Password</th>
		      <td>
		        <input type="password" id="passConfirm" name="passConfirm" class="required easyinput"/>
			  
				<span class="icon icon_bullet_green">&nbsp;</span>
				<br/><div id="confnewpasswordMsg" class="msg"></div>
		      </td>
		    </tr>
	
		    <tr>
		      <td/>
		      <td colspan="2">
		        <div class="buttons">
		        	<span><button class="button icon icon_key_go" title="Save Changes" id="changebtn"> <g:message code="nimble.link.changepassword" /> </button></span>
		          <!--<g:link action="show" title="Show User" id="${user.id}" class="button icon icon_cross"><g:message code="nimble.link.cancel" /></g:link>-->
		        </div>
		      </td>
		    </tr>
		    </tbody>
		  </table>
		</g:form>

</div>
<script type="text/javascript">
nimble.createTip('passwordpolicybtn','<g:message code="nimble.template.passwordpolicy.title" />','<g:message code="nimble.template.passwordpolicy" encodeAs="JavaScript"/>');
</script>

</body>