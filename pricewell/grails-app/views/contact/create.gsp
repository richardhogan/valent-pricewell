
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Contact" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.SalesController" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
	def primaryTerritory = null
	if(loginUser?.primaryTerritory!=null && loginUser?.primaryTerritory!='null' && loginUser?.primaryTerritory!='NULL')
	{
		primaryTerritory = Geo.get(loginUser?.primaryTerritory?.id)
	}
%>	
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			.ui-dialog .ui-state-error { padding: .3em; }
		</style>
		
		<script src="${baseurl }/js/jquery.validate.js"></script>
		<script>
			 
			jQuery(document).ready(function()
		 	{
			 
				jQuery.validator.addMethod("phone", function(value, element) 
				{ 
				return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
				}, "Please enter a valid number.");
			  	jQuery.validator.addMethod("fax", function(value, element) 
				{ 
				return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
				}, "Please enter a valid number.");			  			  		
			    jQuery("#contactCreate").validate();
				   
			    jQuery("#contactCreate input:text")[0].focus();
				
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
							window.location.href = '${baseurl }/contact/create';
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
							if(jQuery("#logoId").val() == null || jQuery("#logoId").val() == "")
							{
								jAlert('Account Logo is mandatory field, Please add Logo first.', 'Create Account Alert');
							}
							else if(jQuery('#accountCreate').validate().form())
							{
								showLoadingBox();
    	    	   				jQuery.post( '${baseurl }/account/save', 
	                				  jQuery("#accountCreate").serialize(),
								      function( data ) 
								      {
    	    	   							hideLoadingBox();
								          if(data == 'invalidPhone')
								          {		  
								          		jAlert('Invalid phone number.', 'Alert Message'); 
									      }
									      else if(data == 'invalidMobile')
									      {
									      		jAlert('Invalid mobile number.', 'Alert Message');
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
				
				jQuery( "#saveBtn" ).click(function() 
				{
					if(jQuery('#contactCreate').validate().form())
					{
						showLoadingBox();
    	   				jQuery.post( '${baseurl }/contact/save', 
               				  jQuery("#contactCreate").serialize(),
						      function( data ) 
						      {
    	   						  hideLoadingBox();
						          if(data == 'invalidPhone')
						          {		  
						          		jAlert('Invalid phone number.', 'Alert Message'); 
							      }
							      else if(data == 'invalidMobile')
							      {
							      		jAlert('Invalid mobile number.', 'Alert Message');
							      }
							      else if(data == 'invalidFax')
							      {
							      		jAlert('Invalid fax number.', 'Alert Message');
							      }
							      else if(data == 'success')
							      {
							      		window.location.href = '${baseurl }/contact';
							      }
							      else
							      {
							      		jAlert('Contact creation failed.', 'Alert Message'); 
							      }
						          
						      });
                		
               		}
					return false;
				});

				jQuery(".cancelBtn").click( function() 
				{
					window.location.href = '${baseurl}/contact/list'	       
					return false;
				});
			});
  		</script>
  		
  		
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
            <span><A HREF="javascript:history.go(-1)" title="Go Back" class="buttons.button button">Back</A></span>
            <span><g:link class="buttons.button button" title="List Of Contacts"action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        
        <div class="body">
            <h2><g:message code="default.create.label" args="[entityName]" /></h2><hr>
            
            <div id="successDialog" title="Success">
				<p><g:message code="account.create.message.success.dialog" default=""/></p>
			</div>
	
			<div id="failureDialog" title="Failure">
				<p><g:message code="account.create.message.failure.dialog" default=""/></p>
			</div>
			
			<div id="newAccountForm" title="Create New Account">
				
			</div>
			
            <g:form action="save"  name="contactCreate">
            
                <div class="dialog">
                	
            		<table>
                        <tbody>
	                        
	                        <tr class="prop">
								<td valign="top" class="name">
								    <label for="account"><g:message code="contact.account.label" default="Select Account" /></label><em>*</em>
								</td>
								<td valign="top" class="value">
								    <g:select name="accountId" from="${accountList?.sort {it.accountName}}" value="" optionKey="id" optionValue="accountName" noSelection="['': 'Select Any One']" class="required"/>
									<button id="newAccount" class="roundNewButton" title="Create New Account">+</button>
								</td>
							</tr>
							
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstname"><g:message code="contact.firstname.label" default="Firstname" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'firstname', 'errors')}">
                                    <g:textField name="firstname" value="${contactInstance?.firstname}" class="required"/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="lastname"><g:message code="contact.lastname.label" default="Lastname" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'lastname', 'errors')}">
                                    <g:textField name="lastname" value="${contactInstance?.lastname}" class="required"/>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                
                                <td valign="top" class="name">
                                    <label for="phone"><g:message code="contact.phone.label" default="Phone" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${contactInstance?.phone}" class="required phone" />
                                </td>
                                
                            </tr>
                            
                            <tr class="prop">
                                
                                <td valign="top" class="name">
                                    <label for="email"><g:message code="contact.email.label" default="Email" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${contactInstance?.email}" class="required email"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="assignTo"><g:message code="contact.assignTo.label" default="Contact Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'assignTo', 'errors')}">
                                    <g:select name="assignToId" from="${new SalesController().generateAssignedToList(loginUser.id)}" value="${SecurityUtils.subject.principal}" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                            </tr>
                            
                            
                        </tbody>
                	</table>
                    	
                	
                     <hr>
                     <h1>Extra Information</h1>
                     <table>
                     	<tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="title"><g:message code="contact.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'title', 'errors')}">
                                    <g:textField name="title" value="${contactInstance?.title}" />
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="department"><g:message code="contact.department.label" default="Department" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'department', 'errors')}">
                                    <g:textField name="department" value="${contactInstance?.department}" />
                                </td>
                            </tr>    
                            <tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="altEmail"><g:message code="contact.altEmail.label" default="Alternative Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'altEmail', 'errors')}">
                                    <g:textField name="aleEmail" value="${contactInstance?.altEmail}" class="email"/>
                                </td>
								<td>&nbsp;&nbsp;</td>                          
                                <td valign="top" class="name">
                                    <label for="mobile"><g:message code="contact.mobile.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'mobile', 'errors')}">
                                    <g:textField name="mobile" value="${contactInstance?.mobile}" class="phone"/>
                                </td>
                        	</tr>
                        	<tr class="prop">
                        		
                                <td valign="top" class="name">
                                    <label for="fax"><g:message code="contact.fax.label" default="Fax" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'fax', 'errors')}">
                                    <g:textField name="fax" value="${contactInstance?.fax}" class="fax" />
                                </td>
                        	</tr>
                        </tbody>
                    </table>
                    <hr>
                    <h1>Contact Address</h1>
                    <table>
                    	<tbody>
                    		<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="address"><g:message code="contact.address.label" default="Address Line 1 : " /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'billingAddress?.billAddressLine1', 'errors')}">
                                    <g:textField name="billAddressLine1" value="${contactInstance?.billingAddress?.billAddressLine1}" size="50"/>
                                	
									(Street Address , P.O. box , Company Name , c/o)
                                	
                                </td>
							</tr>
                        	
                        	<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="address"><g:message code="contact.address.label" default="Address Line 2 : " /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'billingAddress?.billAddressLine2', 'errors')}">
                                    <g:textField name="billAddressLine2" value="${contactInstance?.billingAddress?.billAddressLine2}" size="50"/>
                                	
									(Apartment, suite, unit, building, floor, etc.)
                                	
                                </td>
							</tr>
                        	<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="city"><g:message code="contact.city.label" default="City" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'billingAddress?.billCity', 'errors')}">
                                    <g:textField name="billCity" value="${contactInstance?.billingAddress?.billCity}"/>
                                </td>
                        		<td>&nbsp;&nbsp;</td>
								<td valign="top" class="name">
                                    <label for="state"><g:message code="contact.state.label" default="State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'billingAddress?.billState', 'errors')}">
                                    <g:textField name="billState" value="${contactInstance?.billingAddress?.billState}"/>
                                </td>                        	
                        	</tr>
                        	
                        	<tr class="prop">
                            
                        		<td valign="top" class="name">
                                    <label for="postalcode"><g:message code="contact.postalcode.label" default="Postal Code" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'billingAddress?.billPostalcode', 'errors')}">
                                    <g:textField name="billPostalcode" value="${contactInstance?.billingAddress?.billPostalcode}" />
                                </td>
								<td>&nbsp;&nbsp;</td>
								<td valign="top" class="name">
                                    <label for="country"><g:message code="contact.country.label" default="Country" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'billingAddress?.billCountry', 'errors')}">
                                    <g:countrySelect name="billCountry"
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
						                 value="${primaryTerritory?.country}" noSelection="['':'-Choose your country-']" />
                                
                                </td>
                        	</tr>
                        	
                    	</tbody>
                    </table>
                </div>
                <!-- <div class="buttons">
                    <span class="button"><button id="save" title="Save Contact">Save</button></span>
                </div> -->
                
                <div class="buttons">
                    <span class="button"><input type="button" id="saveBtn" class="saveBtn" name="save" title="Save Contact" value="Save"/></span>
                    <span class="button"><input type="button" id="cancelBtn" class="cancelBtn" name="cancel" title="Cancel" value="Cancel"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
