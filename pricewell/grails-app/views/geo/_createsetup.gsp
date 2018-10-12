<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="grails.plugins.nimble.core.Role" %>
<%
	def baseurl = request.siteUrl
	Role sManagerRole = Role.findByCode('SALES MANAGER')
	Role sPersonRole = Role.findByCode('SALES PERSON')
%>
<html>
<head>
	<style>
		.msg {
			color: red;
		}
		em { font-weight: bold; padding-right: 1em; vertical-align: top; }
	</style>
		<script>
			 
				  jQuery(document).ready(function()
				  {				 
					    jQuery(".geoCreate").validate();
					    jQuery('#geoName').keyup(function(){
						    this.value = this.value.toUpperCase();
						 });  

					    jQuery(".geoCreate input:text")[0].focus()
					    
						jQuery("#saveGeo").click(function()
						{
							//loadValues();
							if(jQuery(".geoCreate").valid())
							{
								showLoadingBox();
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/geo/save",
									data:jQuery(".geoCreate").serialize(),
									success: function(data)
									{
										hideLoadingBox();
										if(data == "territory_Available")
							      		{
							        		jQuery("#geoNameMsg").html('Error: This territory is already available.');
							       		}
										else if(data['res'] == "success"){
											refreshGeoGroupList();
										} else{
											jQuery('#territoryErrors').html(data);
											jQuery('#territoryErrors').show();
										}
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){
										hideLoadingBox();
										alert("Error while saving");
									}
								});
							}
							return false;
						}); 
						
			        	
			        	/*var name = 'sowTemplate'
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
						    	toolbar: 'Basic'}); */   	   	
						    	   	
						jQuery("#saveFromOther").click(function()
						{
							//loadValues();
							if(jQuery(".geoCreate").validate().form())
							{
								showLoadingBox();
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/geo/save",
									data:jQuery(".geoCreate").serialize(),
									success: function(data)
									{
										hideLoadingBox();
										if(data == "territory_Available")
							      		{
							        		jQuery("#geoNameMsg").html('Error: This territory is already available.');
							       		}
										else if(data['res'] == "success")
										{
											if("firstsetup" == "${source}")
												{refreshNavigation();}
											if("geoGroup" == "${sourceFrom}" || "user" == "${sourceFrom}")
											{
												var id = data['id']; var name = data['name'];

												if("geoGroup" == "${sourceFrom}")
												{
													var selected = jQuery('select[name="geos"] option:selected').text();

													if(selected.search('Select Multiple...') != -1)
													{
														jQuery("#geos option[value='']").removeAttr('selected');
													}
													jQuery("#geos").append('<option value='+id+' selected="selected">'+name+'</option>');
													
													jQuery( "#successDialog_1" ).dialog( "open" );
												}
												else if("user" == "${sourceFrom}")
												{
													if("primaryTerritory" == "${territoryType}")
													{
														jQuery("#primaryTerritory").append('<option value='+id+' selected="selected">'+name+'</option>');
														//jQuery("#territoriesList").append('<option value='+id+'>'+name+'</option>');
													}
													else if("secondaryTerritory" == "${territoryType}")
													{
														var selected = jQuery('select[name="territoriesList"] option:selected').text();

														if(selected.search('Select Multiple...') != -1)
														{
															jQuery("#territoriesList option[value='']").removeAttr('selected');
														}
														jQuery("#territoriesList").append('<option value='+id+' selected="selected">'+name+'</option>');
														jQuery("#primaryTerritory").append('<option value='+id+'>'+name+'</option>');
														
													}
													
												}
												jQuery( "#dvNewterritory" ).dialog( "close" );
											}
											
												 
										} else{
											jQuery('#territoryErrors').html(data);
											jQuery('#territoryErrors').show();
										}
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){
										hideLoadingBox();alert("Error while saving");
									}
								});
							}
							return false;
						}); 

						jQuery( "#newSManager" ).click(function() 
						{
							jQuery( "#userDialog" ).dialog( "option", "title", 'Create Sales Manager' );
							jQuery('#userDialog').html("Loading Data, Please Wait.....");
							jQuery( "#userDialog" ).dialog( "open" );
							jQuery.ajax({type:'POST',
								 url:'${baseurl}/userSetup/createsetup',
								 data: {sourceFrom: "geo", roleId: ${sManagerRole?.id}, source: "${source}"},
								 success:function(data,textStatus)
								 {
									 jQuery('#userDialog').html(data);
									 
								},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							return false;
						});
						
						jQuery( "#newSPerson" ).click(function() 
						{
							jQuery( "#userDialog" ).dialog( "option", "title", 'Create Sales Person' );
							jQuery('#userDialog').html("Loading Data, Please Wait.....");
							jQuery( "#userDialog" ).dialog( "open" );
							jQuery.ajax({type:'POST',
								 url:'${baseurl}/userSetup/createsetup',
								 data: {sourceFrom: "geo", roleId: ${sPersonRole?.id}, source: "${source}"},
								 success:function(data,textStatus)
								 {
									 jQuery('#userDialog').html(data);
									 
								},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							return false;
						});

						jQuery( "#userDialog" ).dialog(
						{
							maxHeight: 600,
							width: 'auto',
							modal: true,
							autoOpen: false,
							close: function( event, ui ) {
									jQuery(this).html('');
								}
							
						});

						jQuery("#cancelGeo").click(function()
						{
							showLoadingBox();
							jQuery.post( '${baseurl}/geo/listsetup' , 
							  	{source: "firstsetup"},
						      	function( data ) 
						      	{
								  	hideLoadingBox();
						          	jQuery('#contents').html('').html(data);
						      	});							
							
							return false;
						});

						jQuery( "#dvNewGeo" ).dialog(
						{
							maxHeight: 600,
							width: 'auto',
							modal: true,
							autoOpen: false,
							close: function( event, ui ) {
									jQuery(this).html('');
								}
							
						});

						jQuery( "#newGeo" ).click(function() 
						{
							
							jQuery("#dvNewGeo").dialog( "option", "title", 'Create New GEO' );
							jQuery('#dvNewGeo').html("Loading Data, Please Wait.....");
							jQuery("#dvNewGeo").dialog( "open" );
							jQuery.ajax({type:'POST',
								 url:'${baseurl}/geoGroup/createsetup',
								 data: {sourceFrom: "territory", source: "${source}"},
								 success:function(data,textStatus)
								 {
									 jQuery('#dvNewGeo').html(data);
									 
								 },
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							
							return false;
						});
										
				  });
				  
			

			 /*function loadValues(){
	    			jQuery('#sowTemplate').val(CKEDITOR.instances["sowTemplate"].getData());
	    			jQuery('#terms').val(CKEDITOR.instances["terms"].getData());
	    			jQuery('#billing_terms').val(CKEDITOR.instances["billing_terms"].getData());
	    			jQuery('#signature_block').val(CKEDITOR.instances["signature_block"].getData());
	    		}*/
  		</script>
</head>
    <body>
    	<div id="dvNewGeo"> </div>
    	<div id="userDialog"> </div>
			
        <div class="body">
					
				<div id="territoryErrors" class="errors" style="display: none;">
	            </div>
	            
	            <g:if test="${source=='firstsetup' && sourceFrom != 'geoGroup' && sourceFrom != 'user'}">
		            <div class="collapsibleContainer">
						<div class="collapsibleContainerTitle ui-widget-header">
							<div>Add New Territory</div>
						</div>
					
						<div class="collapsibleContainerContent ui-widget-content">
				</g:if>
			            <g:form action="save" name="geoCreate" class="geoCreate">
							<g:hiddenField name="source" value="${source}"/>
							<g:hiddenField name="sourceFrom" value="${sourceFrom}"/>
			                <div class="dialog">
			                    <table>
			                        <tbody>
			                        
			                            <tr class="prop">
			                                <td valign="top" class="name">
			                                    <label for="name"><g:message code="geo.name.label" default="Name" /></label>
			                                	<em>*</em>
			                                </td>
			                                <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'name', 'errors')}">
			                                    <g:textField name="geoName" value="${geoInstance?.name}" class="required"/>
			                                    <br/><div id="geoNameMsg" class="msg"></div>
			                                </td>
			                                
			                                <g:if test="${sourceFrom != 'geoGroup' && sourceFrom != 'user' && !SecurityUtils.subject.hasRole('GENERAL MANAGER')}">
				                                <td valign="top" class="name">
				                                	<label for="geoGroup">Select GEO</label>
				                                	<em>*</em>
			                                	</td>
									            <td valign="top" class="value">
									          		<g:select name="geoGroupId" from="${GeoGroup.list()?.sort {it.name}}" optionKey="id" optionValue="name" value=""  noSelection="${['':'Select One...']}" class="required"/>
									          		<button id="newGeo" class="roundNewButton" title="Create New Geo">+</button>
									            </td>
								            </g:if>
								            <g:elseif test="${geoGroupInstance?.id != null && geoGroupInstance?.id != ''}">
								            	<g:hiddenField name="geoGroupId" value="${geoGroupInstance?.id}"/>
								            	<td valign="top" class="name">
				                                	
				                                	
			                                	</td>
									            <td valign="top" class="value">
									            	<label>Note : </label>
									          		This territory will directly added into selected GEO : ${geoGroupInstance?.name }
									            </td>
								            </g:elseif>
			                            </tr>
										<tr class="prop">
											 <td valign="top" class="name">
				                                    <label for="description"><g:message code="geo.description.label" default="Description" /></label>
				                                </td>
											 <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'description', 'errors')}" colspan="3">
												<g:textArea name="description" value="${geoInstance?.description}" cols="40" rows="2"/>
											
											 </td>
										</tr>
										
										<tr>
											<g:if test="${source!='setup' && sourceFrom != 'user'}">
									          	<td valign="top" class="name"><label for="salesManager">Assign Sales Manager</label></td>
									          	<td valign="top">
									          		<g:select name="salesManagerId" from="${salesManagerList?.sort {it.profile.fullName}}" optionKey="id" value=""  noSelection="${['':'Select One...']}" />
									          	
									          		<button id="newSManager" class="roundNewButton" title="Create New Sales Manager">+</button>
									          	</td>
								            
									          	<td valign="top" class="name"><label for="salesPersons">Assign Sales Persons</label></td>
									          	<td valign="top">
									          		<g:select name="salesPersons" from="${salesPersonList?.sort {it.profile.fullName}}" optionKey="id" value=""  noSelection="${['':'Select Multiple...']}" multiple="true"/>
									          	
									          		<button id="newSPerson" class="roundNewButton" style="vertical-align: top; margin: 30px 0px 0px 0px" title="Create New Sales Person">+</button>
									          	</td>
							            	</g:if>
								        </tr>
			                        
			                        	<tr class="prop">
											 <td valign="top" class="name">
												<label for="dateFormat">Select Date Format</label><em>*</em>
											 </td>
											 <td valign="top" class="value ${hasErrors(bean: geoInstance, field: 'dateFormat', 'errors')}">
												<g:select name="dateFormat" from="${['dd/mm/yy', 'dd.mm.yy', 'dd-mm-yy',
																					 'mm/dd/yy', 'mm.dd.yy', 'mm-dd-yy',
																					 'yy/dd/mm', 'yy.dd.mm', 'yy-dd-mm',
																					 'yy/mm/dd', 'yy.mm.dd', 'yy-mm-dd']}"  value="mm/dd/yy" noSelection="${['null':'Select One...']}" class="required"/>
											 </td>
											 
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
			                                <g:if test="${baseCurrency}">
				                               	<td valign="top" class="name">
				                               		<label>Convert rate: 1 ${baseCurrency} = </label>
				                               	</td>
				                               	<td>
				                               		<g:textField name="convert_rate" value="${geoInstance?.convert_rate}" class="number"/>                            	</td>
			                             	</g:if>
			                            </tr>
			                        
			                        </tbody>
			                    </table>	                 
			                </div>
			                <div class="buttons">
			                	<g:if test="${sourceFrom == 'geoGroup' || sourceFrom == 'user'}">
			                		<span class="button"><button id="saveFromOther" title="Save Territory"> Save </button></span><!--  From GEO  -->
		                		</g:if>
		                		<g:else>
			                    	<span class="button"><button id="saveGeo" title="Save Territory"> Save </button></span>
			                    	<span class="button"><button id="cancelGeo" title="Cancel"> Cancel </button></span>
		                    	</g:else>
			                </div>
			            </g:form>
		            
		            <g:if test="${source=='firstsetup' && sourceFrom != 'geoGroup' && sourceFrom != 'user'}">
				            </div>
			            </div>
					</g:if>
        </div>
    </body>
</html>
