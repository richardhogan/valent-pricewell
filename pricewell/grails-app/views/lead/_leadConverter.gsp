<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="home" />
        <g:set var="entityName" value="${message(code: 'lead.label', default: 'Lead')}" />
        <g:javascript library="jquery" plugin="jquery"/>
		
		<script>
			 
			jQuery(document).ready(function()
			{			 
			    jQuery( "#successConvertDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#successConvertDialog" ).dialog( "close" );
							window.location.href = '${baseurl}/lead';
							return false;
						}
					}
				});
						
				jQuery( "#failureConvertDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#failureConvertDialog" ).dialog( "close" );
							return false;
						}
					}
				});
					    
			    jQuery("#leadConverter").submit(function() 
		 		{
		 			/*
				  	 jQuery.post( '${baseurl}/lead/convertToContact', jQuery("#leadConverter").serialize(),
						      function( data )
						      {
						          if(data == 'success')
						          {		        		                   		
				                   		jQuery( "#successConvertDialog" ).dialog("open");
							      }
							      else
							      {
							      		jQuery( "#failureConvertDialog" ).dialog("open");
							      }
						          
						          return false;
						      });
						
						*/
						alert("hello");
						return false;
				});
						
						
				jQuery( "#successDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: 
					{
						OK: function() 
						{
							jQuery( "#successDialog" ).dialog( "close" );
							window.location.href = '${baseurl}/lead/leadConverter?id='+<%=leadInstance?.id%>;
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
								
				jQuery( "#newAccountForm" ).dialog(
				{
					autoOpen: false,
					height: 690,
					width: 900,
					modal: true,
					buttons: 
					{
						"Create an account": function() 
						{
							var accountName = jQuery( "#accountName" ).val(),	accountAssignToId = jQuery( "#accountAssignToId" ).val();
							var createFrom = jQuery( "#createFrom" ).val(), 	website  = jQuery( "#website" ).val(),
								email  = jQuery( "#email" ).val(), 				phone  = jQuery( "#phone" ).val(),
								fax  = jQuery( "#fax" ).val(), 					billAddress  = jQuery( "#billAddress" ).val(),
								billCountry  = jQuery( "#billCountry" ).val(), 	billState  = jQuery( "#billState" ).val(),
								billCity  = jQuery( "#billCity" ).val(), 		billPostalcode  = jQuery( "#billPostalcode" ).val(),
								shipAddress  = jQuery( "#shipAddress" ).val(), 	shipState  = jQuery( "#shipState" ).val(),
								shipCountry  = jQuery( "#shipCountry" ).val(), 	shipCity  = jQuery( "#shipCity" ).val(),
								shipPostalcode  = jQuery( "#shipPostalcode" ).val();
							
							if(accountName.length == 0)
							{
								alert("Account Name is required field..");
							}
							
							else
	                		{
	                			jQuery.post( '${baseurl}/account/save?accountName=' + accountName +
	                												'&accountAssignToId='+accountAssignToId +	'&createFrom='+createFrom+
	                												'&website='+website+						'&email='+email+
	                												'&phone='+phone+							'&fax='+fax+
	                												'&billAddress='+billAddress+				'&billCountry='+billCountry+
	                												'&billState='+billState+					'&billCity='+billCity+
	                												'&billPostalcode='+billPostalcode+			'&shipAddress='+shipAddress+	
	                												'&shipCountry='+shipCountry+				'&shipState='+shipState+		
	                												'&shipCity='+shipCity+						'&shipPostalcode='+shipPostalcode, 
	                				  jQuery("#createAccount").serialize(),
								      function( data ) 
								      {
								          if(data == 'success')
								          {		               
								          		jQuery( "#newAccountForm" ).dialog( "close" );    		                   		
						                   		jQuery( "#successDialog" ).dialog("open");
									      }
									      else
									      {
						                  		jQuery( "#failureDialog" ).dialog("open");
									      }
								          
								      });
	                		}
							
							return false;
						},
						Cancel: function() 
						{
							jQuery( "#newAccountForm" ).dialog( "close" );
						}
					}
				});
				
				jQuery( "#newAccount" )
					.button()
					.click(function() {
						jQuery( "#newAccountForm" ).dialog( "open" );
						return false;
					});
						   
		    });
		</script>
	</head>
	<body>
		<h2>Convert Lead To Contact</h2><hr>
		<div class="body">
		
			<div id="successConvertDialog" title="Success">
				<p>Lead is successfully converted to contact.</p>
			</div>
	
			<div id="failureConvertDialog" title="Fail">
				<p>Failed to convert lead to contact.</p>
			</div>
			
			<div id="successDialog" title="Success">
				<p>Account is successfully created.</p>
			</div>
	
			<div id="failureDialog" title="Fail">
				<p>Account creation failed.</p>
			</div>
			
			<div id="newAccountForm" title="Create New Account">
			
				<g:render template="/account/createAccount"/>
			</div>
			
			Lead ${leadInstance?.firstname} ${leadInstance?.lastname} is converting to contact and status is changed automatically to converted. To associate contact with account please select account from existing list.
			<g:form action="convertToContact" method="post" name="leadConverter">
				<g:hiddenField name="id" value="${leadInstance?.id}" />
                <g:hiddenField name="version" value="${leadInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class="prop">
                                
                                <td valign="top" class="name">
                                    <label for="account"><g:message code="lead.account.label" default="Select Account" /></label><em>*</em>
                                </td><td>&nbsp;&nbsp;</td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'account?.accountName', 'errors')}">
                                    <g:select name="accountId" from="${com.valent.pricewell.Account.list()}" value="${id}" optionKey="id" optionValue="accountName"/>
                                </td>  
                                
                                <td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
                                    <label for="assignTo"><g:message code="account.assignto.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value">
                                    <g:select name="assignToId" from="${com.valent.pricewell.User.list()}" value="${SecurityUtils.subject.principal}" optionKey="id"/>
                                    <b>Or Create <button id="newAccount">New Account</button></b>
                                </td>                              
                            </tr>
                        </tbody>
                     </table>
                     
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="convert" action="convertToContact" class="save" value="Convert" /></span>
                </div>
            </g:form>
		</div>
	</body>
</html>