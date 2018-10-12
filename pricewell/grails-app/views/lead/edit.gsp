

<%@ page import="com.valent.pricewell.Lead" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'lead.label', default: 'Lead')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<g:javascript library="jquery" plugin="jquery"/>
		<script src="${baseurl}/js/jquery.validate.js"></script>
		<script>
			 
			 jQuery(document).ready(function()
			 {
				 	jQuery.validator.addMethod("phone", function(value, element) 
					{ 
					return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
					}, "Please enter a valid number.");
				  				  			  		
				    jQuery("#leadEdit").validate();
				    jQuery("#leadEdit input:text")[0].focus();
			    		
			    	jQuery( "#update" )
					.button()
					.click(function() 
					{
						if(jQuery('#leadEdit').validate().form())
						{
							showLoadingBox();
	    	   				jQuery.post( '${baseurl}/lead/update', 
                				  jQuery("#leadEdit").serialize(),
							      function( data ) 
							      {
	    	   						  hideLoadingBox();
							          if(data == 'invalidPhone')
							          {		  
							          		jAlert('Invalid phone number or Format.', 'Alert Dialog'); 
								      }
								      else if(data == 'invalidMobile')
								      {
								      		jAlert('Invalid mobile number.', 'Alert Dialog');
								      }
								      else if(data == 'success')
								      {
								      		window.location.href = '${baseurl}/lead/show/'+<%=contactInstance.id%>;
								      }
								      else
								      {
								      		jAlert('Contact creation failed.', 'Alert Dialog'); 
								      }
							          
							      });
	                		
                		}
						return false;
					});
			    	
			 });  
		 })(jQuery);
  		</script>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><A HREF="javascript:history.go(-1)" title="Go Back">Back</A></span>
            <span class="menuButton"><g:link class="list" action="list" title="List Of Lead"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create" title="Create Lead"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h2><g:message code="default.edit.label" args="[entityName]" /></h2><hr>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${leadInstance}">
            <div class="errors">
                <g:renderErrors bean="${leadInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" name="leadEdit" >
                <g:hiddenField name="id" value="${leadInstance?.id}" />
                <g:hiddenField name="version" value="${leadInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstname"><g:message code="lead.firstname.label" default="Firstname" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'firstname', 'errors')}">
                                    <g:textField name="firstname" value="${leadInstance?.firstname}" class="required"/>
                                </td>
                              	<td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="lastname"><g:message code="lead.lastname.label" default=" Lastname" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'lastname', 'errors')}">
                                    <g:textField name="lastname" value="${leadInstance?.lastname}" class="required"/>
                                </td>
                            </tr>
                        	<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="phone"><g:message code="lead.phone.label" default="Phone" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${fieldValue(bean: leadInstance, field: 'phone')}" class="required" number="true" maxlength="12"/>
                                </td>
                                
                               
                                <td>&nbsp;&nbsp;</td>
                               
                                <td valign="top" class="name">
                                    <label for="iso"><g:message code="lead.iso.label" default="ISO" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'iso', 'errors')}">
                                    <g:textField name="iso" value="${leadInstance?.iso}" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="format"><g:message code="lead.format.label" default="Format" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'format', 'errors')}">
                                    <g:select name="format" from="${['INTERNATIONAL', 'NATIONAL', 'E164']}" class="required" value="${leadInstance?.format}"
    										noSelection="${['null':'Select Format']}"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="email"><g:message code="lead.email.label" default=" Email" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${leadInstance?.email}" class="required email"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                 <td valign="top" class="name">
                                    <label for="status"><g:message code="lead.status.label" default="Status" /></label>
                                 </td>
                                 <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'status', 'errors')}">
                                    <!--g:textField name="status" value="${leadInstance?.status}" /-->
                                    <g:select name="status" from="${['New','Converted','Rejected']}"  value="${leadInstance?.status}"  />
                                 </td>
                               
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="assignTo"><g:message code="lead.assignTo.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'assignTo', 'errors')}">
                                    <g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${leadInstance?.assignTo?.id}" optionKey="id" />
                                </td>
                            </tr>
                        </tbody>
                     </table>
                     <hr>
                     <h1>lead Information</h1>
                     <table>
                     	<tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="title"><g:message code="lead.title.label" default="Title" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'title', 'errors')}">
                                    <g:textField name="title" value="${leadInstance?.title}" />
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="company"><g:message code="lead.company.label" default=" Company" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'company', 'errors')}">
                                    <g:textField name="company" value="${leadInstance?.company}" />
                                </td>
                            </tr>
                                               
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="mobile"><g:message code="lead.mobile.label" default=" Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'mobile', 'errors')}">
                                    <g:textField name="mobile" value="${fieldValue(bean: leadInstance, field: 'mobile')}" number="true" maxlength="12"/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="atlEmail"><g:message code="lead.altEmail.label" default="Alternative Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'altEmail', 'errors')}">
                                    <g:textField name="altEmail" value="${leadInstance?.altEmail}"  class="email"/>
                                </td>
                             </tr>
                            
                        </tbody>
                    </table>
                    <hr>
                    <h1>lead Address</h1>
                    <g:hiddenField name="billingAddressId" value="${leadInstance?.billingAddress?.id}" />
                    <table>
                    	<tbody>
                    		<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="address"><g:message code="lead.address.label" default="Address Line 1 :" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billAddressLine1', 'errors')}">
                                    <g:textField name="billAddressLine1" value="${leadInstance?.billingAddress?.billAddressLine1}" size="50"/>
                               		(Street Address , P.O. box , Company Name , c/o)
                                </td>
							</tr>
                        	
                        	<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="address"><g:message code="lead.address.label" default="Address Line 2 :" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billAddressLine2', 'errors')}">
                                    <g:textField name="billAddressLine2" value="${leadInstance?.billingAddress?.billAddressLine2}" size="50"/>
                                	(Apartment, suite, unit, building, floor, etc.)
                                </td>
							</tr>
                        	<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="city"><g:message code="lead.city.label" default="City" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billCity', 'errors')}">
                                    <g:textField name="billCity" value="${leadInstance?.billingAddress?.billCity}"/>
                                </td>
                                <td>&nbsp;&nbsp;</td>	
                        		<td valign="top" class="name">
                                    <label for="state"><g:message code="lead.state.label" default="State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billState', 'errors')}">
                                    <g:textField name="billState" value="${leadInstance?.billingAddress?.billState}"/>
                                </td>
                        	</tr>
                        	<tr class="prop">
                        		<td valign="top" class="name">
                                    <label for="postalcode"><g:message code="lead.postalcode.label" default="Postal Code" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billPostalcode', 'errors')}">
                                    <g:textField name="billPostalcode" value="${leadInstance?.billingAddress?.billPostalcode}" />
                                </td>
								<td>&nbsp;&nbsp;</td>
                        		<td valign="top" class="name">
                                    <label for="country"><g:message code="lead.country.label" default="Country" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billCountry', 'errors')}">
                                    <g:countrySelect name="billCountry"
						                 from="${['afg','alb','dza','asm','and','ago','aia','ata','atg','arg','arm','abw','aus','aut','aze'
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
												,'vut','ven','vnm','wlf','esh','yem','zmb','zwe'].sort{it}}"
						                 value="${leadInstance?.billingAddress?.billCountry}" noSelection="['':'-Choose your country-']" />
                                
                                </td>
                        		
							</tr>
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit title="Update Lead" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                    <span class="button"><g:actionSubmit title="Delete Lead" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
