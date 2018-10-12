
<%@ page import="com.valent.pricewell.SalesController" %>
<%@ page import="com.valent.pricewell.Account" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'account.label', default: 'Account')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <g:setProvider library="prototype"/>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
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

				jQuery.validator.addMethod("website", function(value, element)
  		  		{
  	  		  		return this.optional(element) || /((ftp|http|https):\/\/)?(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/.test(value);
  	  			}, "Please enter valid website url.");  
  	  			
			    jQuery("#accountEdit").validate();
			    jQuery("#accountEdit input:text")[0].focus();
			    
			    jQuery( "#update" )
					.button()
					.click(function() 
					{
						/*if(jQuery("#logoId").val() == null || jQuery("#logoId").val() == "")
						{
							jAlert('Account Logo is mandatory field, Please add Logo first.', 'Create Account Alert');
						}
						else */if(jQuery('#accountEdit').validate().form())
						{
							showLoadingBox();
	    	   				jQuery.post( '${baseurl}/account/update', 
                				  jQuery("#accountEdit").serialize(),
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
								      		window.location.href = '${baseurl}/account';
								      }
								      else
								      {
								      		jAlert('Contact creation failed.', 'Alert Message'); 
								      }
							          
							      });
	                		
                		}
						return false;
					});

			    	jQuery( ".dvUploadLogo" ).dialog(
				 	{
						modal: true,
						height: 220,
						width: 330,
						autoOpen: false,
						resizable: false,
						zIndex: 4050,
						close: function( event, ui ) {
							jQuery(this).html('');
						}
					});
				
			    	jQuery( "#btnChange" ).click(function() 
					{
			    		jQuery.ajax({type:'POST',
		   					 url:'${baseurl}/logoImage/uploadImage',
		   					 data: {logoFor: 'account'},
		   					 success:function(data,textStatus)
		   					 {
		   						jQuery( ".dvUploadLogo" ).dialog( "open" );
		   						jQuery( ".dvUploadLogo" ).html(data); 
			   				 },
		   					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
	   					 
						
						return false;
					});
	
			 });
  		</script>
        
    </head>
    <body>
        <div class="nav">
            <span><a HREF="javascript:history.go(-1)" title="Go Back" class="buttons.button button">Back</a></span>
            <span><g:link action="list" title="List Of Accounts" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span><g:link action="create" title="Create Account" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
          <!--   <g:hasErrors bean="${accountInstance}">
            <div class="errors">
                <g:renderErrors bean="${accountInstance}" as="list" />
            </div>
            </g:hasErrors>-->
            
            <div id="dvUploadLogo" class="dvUploadLogo" title="Upload New Logo">
				
			</div>
			
            <g:form method="post" name="accountEdit" >
                <g:hiddenField name="id" value="${accountInstance?.id}" />
                <g:hiddenField name="version" value="${accountInstance?.version}" />
                <g:hiddenField name="logoId" value="${accountInstance?.logo?.id}" />
                <g:hiddenField name="filePath" value="${accountInstance?.imageFile?.filePath }" />
                <div class="dialog">
                    <table>
                        <tbody>
							<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="accountName"><g:message code="account.accountName.label" default="Account Name" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'accountName', 'errors')}">
                                    <g:textField name="accountName" value="${accountInstance?.accountName}" class="required" />
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
                                    <label for="assignTo"><g:message code="account.assignto.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'assignTo', 'errors')}">
                                    <!--<g:select name="accountAssignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${accountInstance?.assignTo?.id}" optionKey="id" noSelection="['': 'Select Any One']" class="required"/>-->
                                    <g:select name="accountAssignToId" from="${new SalesController().generateAssignedToList(accountInstance?.assignTo?.id)}" value="${accountInstance?.assignTo?.id}" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                            </tr>
                            
                            <tr>
                            	<td valign="top" class="name">
                                    <label for="logo"><g:message code="account.logo.label" default="Logo" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'logo', 'errors')}">
                                    <div id="dvAccountLogo">
                                    	<g:if test="${accountInstance?.logo?.id != null && isLogoAvailable}">
		                        			<img src="<g:createLink controller='logoImage' action='renderImage' id='${accountInstance?.logo?.id}'/>" hight="80" width="100" />
		                    			</g:if>
                                    </div>
                                    <button id="btnChange">Change Logo</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <hr>
                    <h1>Account Contact Information</h1>
                    <table>
                    	<tbody>
                       		<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="website"><g:message code="account.website.label" default="Website" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'website', 'errors')}">
                                    <g:textField name="website" value="${accountInstance?.website}" class="url"/>
                                </td>
								
								<td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
                                    <label for="email"><g:message code="account.email.label" default="Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${accountInstance?.email}" class="email" />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="phone"><g:message code="account.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${accountInstance?.phone}" class="phone" />
                                </td>
								
                                <td>&nbsp;&nbsp;</td>
								
                                <td valign="top" class="name">
                                    <label for="fax"><g:message code="account.fax.label" default="Fax" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'fax', 'errors')}">
                                    <g:textField name="fax" value="${accountInstance?.fax}" class="fax" />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                    <hr>
                    <h1> Billing Address </h1>
                    <g:hiddenField name="billingAddressId" value="${accountInstance?.billingAddress?.id}" />
                    <table>
						<tbody>
									  
							<tr class="prop">
								<td valign="top" class="name">
									<label for="address"><g:message code="account.address.label" default="Address Line 1 : " /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'billingAddress?.billAddressLine1', 'errors')}">
									<g:textField name="billAddressLine1" value="${accountInstance?.billingAddress?.billAddressLine1}" size="50"/>
									
									(Street Address , P.O. box , Company Name , c/o)
									
								</td>
							</tr>
				
							<tr class="prop">
								<td valign="top" class="name">
									<label for="address"><g:message code="account.address.label" default="Address Line 2 : " /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'billingAddress?.billAddressLine2', 'errors')}">
									<g:textField name="billAddressLine2" value="${accountInstance?.billingAddress?.billAddressLine2}" size="50"/>
									
									(Apartment, suite, unit, building, floor, etc.)
																	
								</td>
							</tr>
							
							<tr class="prop">
								<td valign="top" class="name">
									<label for="city"><g:message code="account.city.label" default="City" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'billingAddress?.billCity', 'errors')}">
									<g:textField name="billCity" value="${accountInstance?.billingAddress?.billCity}"/>
								</td>
								<td>&nbsp;&nbsp;</td>
								<td valign="top" class="name">
									<label for="state"><g:message code="account.state.label" default="State" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'billingAddress?.billState', 'errors')}">
									<g:textField name="billState" value="${accountInstance?.billingAddress?.billState}"/>
								</td>
								
							</tr>
							<tr class="prop">
								<td valign="top" class="name">
									<label for="postalcode"><g:message code="account.postalcode.label" default="Postal Code" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'billingAddress?.billPostalcode', 'errors')}">
									<g:textField name="billPostalcode" value="${accountInstance?.billingAddress?.billPostalcode}"/>
								</td>
								<td>&nbsp;&nbsp;</td>
								<td valign="top" class="name">
									<label for="country"><g:message code="account.country.label" default="Country" /></label><em>*</em>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'billingAddress?.billCountry', 'errors')}">
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
						                 value="${accountInstance?.billingAddress?.billCountry}" noSelection="['':'-Choose your country-']" />
                                
								</td>
							
							</tr>
																											
						</tbody>
					</table>
					<hr>
					<h1> Shipping Address </h1>
					<g:hiddenField name="shippingAddressId" value="${accountInstance?.shippingAddress?.id}" />    				    
                    <table>
                        <tbody>
							<tr class="prop">
								<td valign="top" class="name">
									<label for="address"><g:message code="account.address.label" default="Address Line 1 : " /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'shippingAddress?.shipAddressLine1', 'errors')}">
									<g:textField name="shipAddressLine1" value="${accountInstance?.shippingAddress?.shipAddressLine1}" size="50"/>
									
									(Street Address , P.O. box , Company Name , c/o)
									
								</td>
							</tr>
                        	
							<tr class="prop">
								<td valign="top" class="name">
									<label for="address"><g:message code="account.address.label" default="Address Line 2 : " /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'shippingAddress?.shipAddressLine2', 'errors')}">
									<g:textField name="shipAddressLine2" value="${accountInstance?.shippingAddress?.shipAddressLine2}" size="50"/>
									
									(Apartment, suite, unit, building, floor, etc.)
									
								</td>
							</tr>
							
							<tr class="prop">
								<td valign="top" class="name">
									<label for="city"><g:message code="account.city.label" default="City" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'shippingAddress?.shipCity', 'errors')}">
									<g:textField name="shipCity" value="${accountInstance?.shippingAddress?.shipCity}"/>
								</td>
								<td>&nbsp;&nbsp;</td>
								<td valign="top" class="name">
									<label for="state"><g:message code="account.state.label" default="State" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'shippingAddress?.shipState', 'errors')}">
									<g:textField name="shipState" value="${accountInstance?.shippingAddress?.shipState}"/>
								</td>
							</tr>
							
							<tr class="prop">
								<td valign="top" class="name">
									<label for="postalcode"><g:message code="account.postalcode.label" default="Postal Code" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'shippingAddress?.shipPostalcode', 'errors')}">
									<g:textField name="shipPostalcode" value="${accountInstance?.shippingAddress?.shipPostalcode}" />
								</td>
								<td>&nbsp;&nbsp;</td>
								<td valign="top" class="name">
									<label for="country"><g:message code="account.country.label" default="Country" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: accountInstance, field: 'shippingAddress?.shipCountry', 'errors')}">
									<g:countrySelect name="shipCountry"
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
												,'vut','ven','vnm','wlf','esh','yem','zmb','zwe']"
						                 value="${accountInstance?.shippingAddress?.shipCountry}" noSelection="['':'-Choose your country-']" />
                                
								</td>
							</tr>             	
							                    	
                       </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><button title="Update Account" id="update">Update</button></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
