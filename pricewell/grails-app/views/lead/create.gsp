
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Lead" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.Geo" %>
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
        <g:set var="entityName" value="${message(code: 'lead.label', default: 'Lead')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
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
			  				  			  		
			    jQuery("#leadCreate").validate();
			    jQuery("#leadCreate input:text")[0].focus();
			    
			    jQuery( "#saveBtn" ).click(function() 
				{
					if(jQuery('#leadCreate').validate().form())
					{
						showLoadingBox();
    	   				jQuery.post( '${baseurl}/lead/save', 
               				  jQuery("#leadCreate").serialize(),
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
							      		window.location.href = '${baseurl}/lead';
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
					window.location.href = '${baseurl}/lead/list'	       
					return false;
				});
			    	
			 });
			  	 
  		</script>
    </head>
    <body>
        <div class="nav">
            <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
            <!--<span><A HREF="javascript:history.go(-1)" class="buttons.button button">Back</A></span>-->
            <span><g:link class="list" action="list" title="List Of Leads" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h2><g:message code="default.create.label" args="[entityName]" /></h2><hr>
           
            
            <g:form action="save" name="leadCreate">
                <g:hiddenField name="status" value="New" />
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
                                    <g:textField name="phone" value="${fieldValue(bean: leadInstance, field: 'phone')}" class="required phone" />
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
                                 <!-- <td valign="top" class="name">
                                    <label for="status"><g:message code="lead.status.label" default="Status" /></label>
                                 </td>
                                 <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'status', 'errors')}">
                                    <!--g:textField name="status" value="${leadInstance?.status}" /-->
                                    <!--<g:select name="status" from="${['New','Converted','Rejected']}"  value="${leadInstance?.status}"  />
                                 </td>
                               
                               	<td>&nbsp;&nbsp;</td>-->
                                
                                <td valign="top" class="name">
                                    <label for="assingTo"><g:message code="lead.assignTo.label" default="Assign To" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'assignTo', 'errors')}">
                                    <!--<g:select name="assignToId" from="${salesUsers?.sort {it.profile.fullName}}" value="${SecurityUtils.subject.principal}" optionKey="id" noSelection="['':'-Select Any One-']" class="required"/>-->
                                    <g:select name="assignToId" from="${new SalesController().generateAssignedToList(loginUser.id)}" value="" noSelection="['': 'Select Any One']" class="required"/>
                                </td>
                            </tr>
                        </tbody>
                     </table>
                     <hr>
                     <h1>Lead Information</h1>
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
                                    <g:textField name="mobile" value="${fieldValue(bean: leadInstance, field: 'mobile')}" class="phone"/>
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
                    <h1>Lead Address</h1>
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
                                    <label for="country"><g:message code="lead.country.label" default="Country" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: leadInstance, field: 'billingAddress?.billCountry', 'errors')}">
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
                    <span class="button"><input type="button" id="saveBtn" class="saveBtn" name="save" title="Save Lead" value="Save Lead"/></span>
                    <span class="button"><input type="button" id="cancelBtn" class="cancelBtn" name="cancel" title="Cancel" value="Cancel"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
