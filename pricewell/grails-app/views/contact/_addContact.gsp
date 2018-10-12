<%@ page import="com.valent.pricewell.Account" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
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
		<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<g:set var="entityName" value="${message(code: 'contact.label', default: 'Contact')}" />
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
			    
			    jQuery( "#save" ).click(function() 
				{
					if(jQuery('#contactCreate').validate().form())
					{
						//showLoadingBox();
    	   				jQuery.post( '${baseurl}/contact/save', 
               				  jQuery("#contactCreate").serialize(),
						      function( data ) 
						      {
    	   						  //hideLoadingBox();
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
							      		//window.location.href = '${baseurl}/account/show/'+<%=accountId%>;
							      		window.location.reload();
							      }
							      else
							      {
							      		jAlert('Contact creation failed.', 'Alert Message');
							      	
							      }
						          
						      });
                		
               		}
					return false;
				});
				  
			    	
			 });
  		</script>
    </head>
    <body>
        
        <div class="body">
            <h2><g:message code="default.create.label" args="[entityName]" /></h2><hr>
            
            <g:form action="save"  name="contactCreate">
                <div class="dialog">
                	<g:hiddenField name="accountId" value="${accountId}"></g:hiddenField>
                	<g:hiddenField name="createdFrom" value="account"></g:hiddenField>
                    <table>
                        <tbody>
                        
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
                                    <g:textField name="phone" value="${contactInstance?.phone}" class=" required phone"/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="email"><g:message code="contact.email.label" default="Email" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'email', 'errors')}">
                                    <g:textField name="email" value="${contactInstance?.email}" class="required email"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                
                               <td valign="top" class="name">
                                    <label for="assignTo"><g:message code="contact.assignTo.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: contactInstance, field: 'assignTo', 'errors')}">
                                    <!--<g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${SecurityUtils.subject.principal}" optionKey="id" noSelection="['': 'Select Any One']" class="required"/>-->
                                    <g:select name="assignToId" from="${new SalesController().generateAssignedToList(loginUser.id)}" value="" noSelection="['': 'Select Any One']" class="required"/>
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
                <div class="buttons">
                    <span class="button"><button id="save" title="Save Contact">Add</button></span>                 
                </div>
            </g:form>
        </div>
    </body>
</html>
		