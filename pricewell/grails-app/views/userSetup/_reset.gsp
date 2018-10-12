
<%
	def baseurl = request.siteUrl
	
%>
<html>	
	<style>
		.msg {
			color: red;
		}
		em { font-weight: bold; padding-right: 1em; vertical-align: top; }
	</style>
	
	<g:setProvider library="prototype"/>
	
	<script type="text/javascript">
			jQuery(document).ready(function()
			{
				jQuery('#email').keyup(function(){
		  			jQuery("#emailMsg").html('');
				});

				jQuery(".resetFrm").validate();
				
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
				
				jQuery( "#failDialog" ).dialog(
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
		
				jQuery(".resetBtn").click(function()
		  		{
					if(jQuery('.resetFrm').validate().form())
					{					
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/userSetup/resetPass",
							data:jQuery(".resetFrm").serialize(),
							success: function(data)
							{
								if(data != "email_Available")
								{
									jQuery("#emailMsg").html('Error: This email is not match with an existing user account.');	
								//alert(data);
								}
								else{
								jQuery( "#successDialog" ).dialog( "open" );
								
								}
								//alert(data);
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
	<body>
		<div id="successDialog" title="Success">
			<p><g:message code="userPasswordChanged.message.success.reset.dialog" default=""/></p>
		</div>
		<div id="failDialog" title="Success">
			<p><g:message code="userPasswordChanged.message.fail.dialog" default=""/></p>
		</div>
		 <g:form name="resetFrm" class="resetFrm">
			<table>
		      <tbody>
		      	<tr>
		        	<td class="name"><label for="email"><g:message code="nimble.label.email" /></label><em>*</em></td>
		        	<td class="value">
		          		<input type="text" size="30" id="email" name="email" value="" class="required email easyinput"/><!--  <span class="icon icon_bullet_green">&nbsp;</span>-->
		        	<br/><div id="emailMsg" class="msg"></div>
		        	</td>
		        	<td>
		      			<span class="button"><button title="Submit Email id" name="resetBtn" id="resetBtn" class="resetBtn"> Submit </button></span>
		    		</td>
		      	</tr>
		  	  </tbody>
		  	</table>
		</g:form>
	</body>
</html>