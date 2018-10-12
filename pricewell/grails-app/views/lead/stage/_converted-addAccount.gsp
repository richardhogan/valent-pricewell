<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.ReviewService"%>	
<%@ page import="com.valent.pricewell.User"%>	
<%@ page import="com.valent.pricewell.SalesController" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
%>
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
							//window.location.href = '${baseurl}/lead/show?id='<%= leadinstance?.id%>;
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
					    
				jQuery( "#convertToContact" ).click(function() 
				{
					if(jQuery("#leadConverter").validate().form())
	            	{
						showLoadingBox();
		            	  jQuery.post( '${baseurl}/lead/convertToContact', jQuery('#leadConverter').serialize(),
						      function( data )
						      {
						      		//alert(data);
						      	  hideLoadingBox();
						      	  if(data == 'fail')
						          {		        		                   		
				                   		//jQuery( "#successConvertDialog" ).dialog("open");
						      			jQuery( "#failureConvertDialog" ).dialog("open");
						      		
							      }
							      else
							      {
							      		jQuery("#dvLeadToContact").html(data);
				                   		if(jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
				                   		{
				                   			jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
				                   		}
							      }
						          
						      });
						
	            	}
						
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
							window.location.href = '${baseurl}/lead/show?id='+<%=leadInstance?.id%>;
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
					maxHeight: 690,
					width: 950,
					modal: true,
					buttons: 
					{
						"Create an account": function() 
						{
							if(jQuery('#accountCreate').validate().form())
							{
								showLoadingBox();
    	    	   				jQuery.post( '${baseurl}/account/save', 
	                				  jQuery("#accountCreate").serialize(),
								      function( data ) 
								      {
    	    	   						  hideLoadingBox();
								          if(data == 'invalidPhone')
								          {		  
								          		jAlert('Invalid Phone number.', 'Alert Dialog'); 
									      }
									      else if(data == 'invalidMobile')
									      {
									      		jAlert('Invalid Mobile number.', 'Alert Dialog');
									      }
									      else if(data == 'success')
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
				
				jQuery( "#newAccount" ).click(function() 
				{
						jQuery( "#newAccountForm" ).dialog( "open" );
						jQuery('#newAccountForm').html("Loading, Please wait...");
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/account/createAccount",
							//data: {source: 'firstsetup'},
							success: function(data){
								jQuery('#newAccountForm').html(data);
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
						return false;
					});
						   
			   jQuery("#leadConverter").validate();
		    });

			function loadValues(){
    			alert(jQuery('#accountId').val());
    			//return false;
    		}
		</script>
	
	<body>
		
		
		<div class="body" id="dvLeadToContact">
		
			<h2>Convert Lead To Contact</h2><hr>
			
			<div id="successConvertDialog" title="Success">
				<p><g:message code="convertLeadToContact.message.success.dialog" default=""/></p>
			</div>
	
			<div id="failureConvertDialog" title="Failure">
				<p><g:message code="convertLeadToContact.message.failure.dialog" default=""/></p>
			</div>
			
			<div id="successDialog" title="Success">
				<p><g:message code="account.create.message.success.dialog" default=""/></p>
			</div>
	
			<div id="failureDialog" title="Failure">
				<p><g:message code="account.create.message.failure.dialog" default=""/></p>
			</div>
			
			<div id="newAccountForm" title="Create New Account">
			
				
			</div>
			<h1><b>Notes :-</b></h1>
			<b>&nbsp;&nbsp;&nbsp;&nbsp;1) </b>	Lead <b>${leadInstance?.firstname} ${leadInstance?.lastname}</b> is converting to contact and status is changed automatically to converted. </br>
			<b>&nbsp;&nbsp;&nbsp;&nbsp;2) </b>  To associate contact with account please select account from existing list.
			</br></br>
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
                                    <g:select name="accountId" from="${accountList?.sort {it.accountName}}" value="" optionKey="id" optionValue="accountName" noSelection="['':'-Select Any One-']" class="required"/>
                                	<button id="newAccount" class="roundNewButton" title="Create New Account">+</button>
                                </td>  
                             
                            </tr>   
                            <tr class="prop">
								
								<td valign="top" class="name">
                                    <label for="assignTo"><g:message code="account.assignto.label" default="Assign To" /></label><em>*</em>
                                </td><td>&nbsp;&nbsp;</td>
                                <td valign="top" class="value">
                                    <!--<g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${SecurityUtils.subject.principal}" optionKey="id" noSelection="['':'-Select Any One-']" class="required"/>-->
                                    <g:select name="assignToId" from="${new SalesController().generateAssignedToList(loginUser.id)}" value="" noSelection="['': 'Select Any One']" class="required"/>
                                </td>                              
                            </tr>
                        </tbody>
                     </table>
                     
                </div>
                <div class="buttons">
                    <!-- <span class="button"><g:submitButton name="convert" action="convertToContact" class="save" value="Convert" /></span>-->
                    <input type="button" id="convertToContact" title="Convert Lead To Contact" value="Convert To Contact"/>
                </div>
            </g:form>
		</div>
	</body>