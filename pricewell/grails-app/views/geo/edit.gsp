
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'default.geo.label', default: 'Geo')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    	<ckeditor:resources />
    	<script>
			 jQuery(document).ready(function()
			 {
				jQuery("#geoEdit").validate();
				jQuery("#geoEdit input:text")[0].focus();

			    var name = 'sowTemplate'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '700px',
				    	toolbar: 'Basic'});

				var name = 'terms'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '900px',
				    	toolbar: 'Basic'});
				    	
				 var name = 'billing_terms'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '900px',
				    	toolbar: 'Basic'});
				
				var name = 'signature_block'
					var editor = CKEDITOR.instances[name];
				    if (editor) { editor.destroy(true); }
				    CKEDITOR.replace(name, {
				    	height: '90%',
				    	width: '900px',
				    	toolbar: 'Basic'}); 
			 });
  		</script>
    </head>
    <body>
        <div class="nav">
        	<span><g:link class="buttons.button button" title="List Of Territories" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	            
        	<g:if test="${createPermission}">
	            <span><g:link class="buttons.button button" title="Create Territory" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
        </div>
        <div class="body">
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.edit.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
		            <g:hasErrors bean="${geoInstance}">
		            <div class="errors">
		                <g:renderErrors bean="${geoInstance}" as="list" />
		            </div>
		            </g:hasErrors>
		            <g:form method="post" name="geoEdit" >
		                <g:hiddenField name="id" value="${geoInstance?.id}" />
		                <g:hiddenField name="version" value="${geoInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="geo.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'name', 'errors')}">
		                                    <g:textField name="name" value="${geoInstance?.name}" class="required"/>
		                                </td>
		                                
		                                <td>&nbsp;&nbsp;</td>
		                                
		                                <td valign="top" class="name">
		                                    <label for="description"><g:message code="geo.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'description', 'errors')}">
		                                    <g:textField name="description" value="${geopInstance?.description}" size='75' />
		                                </td>
		                            </tr>
		                        
		                        	<tr>
									  <g:if test="${!SecurityUtils.subject.hasRole('SALES MANAGER')}">
								          <g:if test="${salesManagerList.size() > 0}">
									          <td valign="top" class="name"><label for="salesManager">Assign Sales Manager</label><em>*</em></td>
									          <td valign="top">
									          	<g:select name="salesManagerId" from="${salesManagerList?.sort {it.profile.fullName}}" optionKey="id" value="${geoInstance?.salesManager?.id}"  noSelection="${['':'Select One...']}" class="required" />
									          </td>
								          </g:if>
							          </g:if>
							          
							          <g:if test="${salesPersonList.size() > 0}">
								          <td valign="top" class="name"><label for="salesPersons">Assign Sales Persons</label></td>
								          <td valign="top">
								          	<g:select name="salesPersons" from="${salesPersonList?.sort {it.profile.fullName}}" optionKey="id" value="${geoInstance?.salesPersons*.id}"  noSelection="${['':'Select Multiple...']}" multiple="true"/>
								          </td>
							          </g:if>
							        </tr>
							        
		                        	<tr class="prop">
		                        		<td valign="top" class="name">
											<label for="dateFormat">Select Date Format</label>
											<em>*</em>
										 </td>
									
										 <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'dateFormat', 'errors')}">
											<g:select name="dateFormat" from="${['dd/mm/yy', 'dd.mm.yy', 'dd-mm-yy',
																				 'mm/dd/yy', 'mm.dd.yy', 'mm-dd-yy',
																				 'yy/dd/mm', 'yy.dd.mm', 'yy-dd-mm',
																				 'yy/mm/dd', 'yy.mm.dd', 'yy-mm-dd']}"  value="${geoInstance?.dateFormat}" noSelection="${['null':'Select One...']}" class="required"/>
										 </td>
								   </tr>
								   <tr>		 
										 <td valign="top" class="name">
		                                    <label for="country"><g:message code="geo.country.label" default="Country" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'country', 'errors')}">
		                                    <g:countrySelect name="country"
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
								                 value="${geoInstance?.country}" noSelection="['':'-Choose your country-']" />
		                                
		                                </td>
		                        	</tr>
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="currency"><g:message code="geo.currency.label" default="Currency" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'currency', 'errors')}">
		                                    <g:select name="currency" from="${['AFN','ALL','DZD','AOA','XCD','ARS','AMD','AWG','AUD','EUR','AZN','BSD',
																			'BHD','BDT','BBD','BYR','BZD','XOF','BMD','BTN','BOB','BAM','BWP','BRL',
																			'BND','BGN','BIF','KHR','XAF','CAD','CVE','KYD','CLP','CNY','COP','KMF',
																			'CDF','CRC','HRK','CUC','CZK','DKK','DJF','DOP','EGP','GQE','ERN','EEK',
																			'ETB','FKP','FJD','XPF','GMD','GEL','GHS','GIP','GTQ','GNF','GYD','HTG',
																			'HNL','HKD','HUF','ISK','INR','IDR','XDR','IRR','IQD','ILS','JMD','JPY',
																			'JOD','KZT','KES','KPW','KRW','KWD','KGS','LAK','LVL','LBP','LSL','LRD',
																			'LYD','LTL','MOP','MKD','MGA','MWK','MYR','MVR','MRO','MUR','MXN','MDL',
																			'MNT','MAD','MZM','MMK','NAD','NPR','ANG','NZD','NIO','NGN','NOK','OMR',
																			'PKR','PAB','PGK','PYG','PEN','PHP','PLN','QAR','RON','RUB','RWF','STD',
																			'SAR','RSD','SCR','SLL','SGD','SBD','SOS','ZAR','LKR','SHP','SDG','SRD',
																			'SZL','SEK','CHF','SYP','TWD','TJS','TZS','THB','TTD','TND','TRY','TMT',
																			'UGX','UAH','WON','AED','GBP','USD','UYU','UZS','VUV','VEB','VND','WST','YER',
																			'ZMK','ZWR'].sort{it}}" 
													value="${geoInstance?.currency}" noSelection="['':'-Choose your currency-']" class="required"/>
		                                </td>
		                                
		                                <td>&nbsp;&nbsp;</td>
		                                
		                                <td valign="top" class="name">
		                                    <label for="currencySymbol"><g:message code="geo.currencySymbol.label" default="CurrencySymbol" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'currencySymbol', 'errors')}">
		                                    <g:textField name="currencySymbol" value="${geoInstance?.currencySymbol}" class="required"/>
		                                </td>
		                            </tr>
		                        	
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="taxPercent"><g:message code="geo.taxPercent.label" default="Tax (%)" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'taxPercent', 'errors')}">
		                                    <g:textField name="taxPercent" value="${geoInstance?.taxPercent}" class="number"/>
		                                </td>
		                                
		                                <td>&nbsp;&nbsp;</td>
		                                
		                                <g:if test="${baseCurrency}">
			                               	<td valign="top" class="name">
			                               		<label>Convert rate: 1 ${baseCurrency} = </label>
			                               	</td>
			                               	<td>
			                               		<g:textField name="convert_rate" value="${geoInstance?.convert_rate}" class="number"/>
			                               	</td>
		                             	</g:if>
		                            </tr>
		                        
		                        	
	    		
	    						</tbody>
		                    </table>
		                    <table>
		                    	<!--<tbody>-->
		                        	<tr>
						    			<td>
						    				<label>SOW Label</label><em>*</em>
						    			</td>
						    			<td>
						    				<g:textField name="sowLabel" value="${geoInstance?.sowLabel }" class="required" size='75'/>
						    			</td>
						    		</tr>
		                        	<tr> 
						    			<td> 
						    				<label> SOW Template </label>
						    			</td>
						    			
						    			<td> 
						    				<g:textArea name="sowTemplate" value="${geoInstance?.sowTemplate}" rows="5" cols="80" style="width: 90%">
						    					<p> Use following tags to put place holder for dynamically generated contents. </p>
								    			<ul>
								    				<li> [@@services@@] for print services details </li>
								    				<li> [@@terms@@] for terms and conditions for given GEO </li>
								    				<li> [@@billing_terms@@] for billing terms for given GEO </li>
								    				<li> [@@signature_block@@] </li>
								    			</ul>
						    				</g:textArea> 
					    				</td>
						    		</tr>
		                        <!--</tbody>
		                    </table>-->
		                    <tr>
		                    	<td><label>SOW Template Tags</label></td>
		                    	<td></td>
	                    	</tr>
					    	<!--<table>-->
					    		<tr>
					    			<td>
					    				<label>[@@terms@@]</label>
				    				</td>
				    				<td>
				    					<g:textArea name="terms" value="${geoInstance?.terms}" rows="10" cols="80" style="width: 90%"/>
				    				</td>
					    		</tr>
					    		<tr>
					    			<td>
					    				<label>[@@billing_terms@@]</label>
				    				</td>
				    				<td>
				    					<g:textArea name="billing_terms" value="${geoInstance?.billing_terms}" rows="10" cols="80" style="width: 90%"/>
				    				</td>
					    		</tr>
					    		<tr>
					    			<td>
					    				<label>[@@signature_block@@]</label>
				    				</td>
				    				<td>
				    					<g:textArea name="signature_block" value="${geoInstance?.signature_block}" rows="5" cols="80" style="width: 90%"/>
				    				</td>
					    		</tr>
					    	</table>
		                </div>
		                <div class="buttons">
		                    <span class="button"><g:actionSubmit title="Update Territory" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
		                    <g:if test="${createPermission}">
		                    	<span class="button"><g:actionSubmit class="delete" title="Delete Territory" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
	                    	</g:if>
		                </div>
		            </g:form>
				
				</div>
				
			</div>
				
            
            
        </div>
    </body>
</html>
