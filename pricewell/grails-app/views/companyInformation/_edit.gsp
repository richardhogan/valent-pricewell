<%@ page import="com.valent.pricewell.CompanyInformation" %>
<%
	def baseurl = request.siteUrl
%>

		<g:setProvider library="prototype"/>
		<g:set var="entityName" value="${message(code: 'companyInformation.label', default: 'Company Information')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <style>
			h1, button, #successDialogInfoEdit, #failureDialogInfoEdit
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
		</style>
        <script>
		
			jQuery(document).ready(function()
		 	{
			 	var index = 5000;
			 	jQuery( "#successDialogInfoEdit" ).hide();
			 	
				jQuery( "#failureDialogInfoEdit" ).hide();
				
				jQuery( "#editInfoMain" ).show();

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
				
				jQuery( "#btnDelete" ).click(function() 
				{
					var r = confirm('Are you sure? You want to delete this?');
					if (r==true)
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/companyInformation/delete?id='+${companyInformationInstance.id} , 
	    				  function( data ) 
					      {
					      	  if(data == 'success')
					          {		
					      			hideLoadingBox();               
					          		jQuery.ajax({type:'POST',
										 url:'${baseurl}/companyInformation/create',
										 success:function(data,textStatus){jQuery('#mainInformationTab').html(data);},
										 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							  }
					          
					      });
				    }
					return false;
				});

				jQuery.validator.addMethod("website", function(value, element)
  		  		{
  	  		  		return this.optional(element) || /((ftp|http|https):\/\/)?(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/.test(value);
  	  			}, "Please enter valid website url.");  
	  			
				jQuery("#editCompanyInformation").validate();
				jQuery("#editCompanyInformation input:text")[0].focus();
				
				jQuery( "#btnUpdate" ).click(function() 
				{
					if(jQuery("#logoId").val() == null || jQuery("#logoId").val() == "")
					{
						jAlert('Company Logo is mandatory field, Please add Logo first.', 'Create Company Information Alert');
					}
					else if(jQuery("#editCompanyInformation").validate().form())
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/companyInformation/update' , 
	    				  jQuery("#editCompanyInformation").serialize(),
					      function( data ) 
					      {
							  hideLoadingBox();
					      	  if(data == 'success')
					          {		               
						      		jQuery( "#successDialogInfoEdit" ).dialog( "option", "zIndex", index+1000 );
						    		index = index+1000;
					          		jQuery( "#successDialogInfoEdit" ).show();
									jQuery( "#failureDialogInfoEdit" ).hide();
									jQuery( "#editInfoMain" ).hide();
						      }
						      else
						      {
						    	  	jQuery( "#failureDialogInfoEdit" ).dialog( "option", "zIndex", index+1000 );
						  			index = index+1000;
			                  		jQuery( "#failureDialogInfoEdit" ).show();
									jQuery( "#editInfoMain" ).hide();
									jQuery( "#successDialogInfoEdit" ).hide();
						      }
					          
					      });
					  }
					  return false;
				});
					
				jQuery( "#btnShow" ).click(function() 
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/companyInformation/showsetup' , 
						{source: "${source}"},
    				  function( data ) 
				      {
							hideLoadingBox();
						  	if("firstsetup" == "${source}")
						  	{
						  		jQuery("#mainInformationTab").html(data);
						  	}
						  	else
							{
						      	  jQuery( "#dvheader" ).html("      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   Show Company Information");
						      	  jQuery( "#dvCompanyInfo" ).html("Loading..., Please wait.....");
						      	  jQuery( "#dvCompanyInfo" ).html("");
						      	  jQuery( "#dvCompanyInfo" ).html(data);
							}					      
				      });
						return false;
				});

				jQuery( ".btnChange" ).click(function() 
				{
					jQuery.ajax({type:'POST',
	   					 url:'${baseurl}/logoImage/uploadImage',
	   					data: {logoFor: 'companyInformation', source: '${source}'},
	   					 success:function(data,textStatus)
	   					 {
	   						jQuery( ".dvUploadLogo" ).dialog( "open" );
	   						jQuery( ".dvUploadLogo" ).html(data); 
		   				 },
	   					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
  					 
					
					return false;
				});

				jQuery("#cancelCompanyInfo").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/companyInformation/showsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	
			});
		
			function refreshEditedInformation()
			{
				jQuery.ajax({type:'POST',
					 url:'${baseurl}/companyInformation/show',
					 success:function(data,textStatus){jQuery('#mainInformationTab').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			}
		
			
		
		</script>
		
		<div id="successDialogInfoEdit">
			<p><g:message code="companyInformation.edit.message.success.dialog" default=""/> <img src="${resource(dir: 'images', file: 'ok.png')}"/></p>
			<button id="btnShow" title="Show Company Information">Show Info</button>
		</div>

		<div id="failureDialogInfoEdit">
			<p><g:message code="companyInformation.edit.message.failure.dialog" default=""/></p>
		</div>
		
		<div id="dvUploadLogo" class="dvUploadLogo" title="Upload New Logo">
			
		</div>
        <div id="editInfoMain" class="body" >
        
        	<g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header">
						<div><g:message code="default.edit.label" args="[entityName]" /></div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content">
			</g:if>
            
            <g:uploadForm method="post" name="editCompanyInformation" enctype="multipart/form-data">
				<g:hiddenField name="source" value="${source}" />
                <g:hiddenField name="id" value="${companyInformationInstance?.id}" />
                <g:hiddenField name="version" value="${companyInformationInstance?.version}" />
                <g:hiddenField name="logoId" value="${companyInformationInstance?.logo?.id}" />
                <g:hiddenField name="filePath" value="" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="companyInformation.name.label" default="Name" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${companyInformationInstance?.name}" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="logo"><g:message code="companyInformation.logo.label" default="Logo" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'logo', 'errors')}">
                                    <div id="dvCompanyLogo">
                                    	<g:if test="${companyInformationInstance?.logo?.id != null}">
		                        			<img src="<g:createLink controller='logoImage' action='renderImage' id='${companyInformationInstance?.logo?.id}'/>" hight="80" width="100" />
		                    			</g:if>
                                    </div>
                                    <button id="btnChange" class="btnChange">Change Logo</button>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="website"><g:message code="companyInformation.website.label" default="Website" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'website', 'errors')}">
                                    <g:textField name="website" value="${companyInformationInstance?.website}" class="url"/>
                                </td>
                            </tr>
                        
                            <!--<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="SMTPserver"><g:message code="companyInformation.SMTPserver.label" default="SMTP server" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'SMTPserver', 'errors')}">
                                    <g:textField name="SMTPserver" value="${companyInformationInstance?.SMTPserver}" />
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="fromEmail"><g:message code="companyInformation.fromEmail.label" default="From Email" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'fromEmail', 'errors')}">
                                    <g:textField name="fromEmail" value="${companyInformationInstance?.fromEmail}" />
                                </td>
                            </tr>-->
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="phone"><g:message code="companyInformation.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'phone', 'errors')}">
                                    <g:textField name="phone" value="${companyInformationInstance?.phone}" />
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="mobile"><g:message code="companyInformation.mobile.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'mobile', 'errors')}">
                                    <g:textField name="mobile" value="${companyInformationInstance?.mobile}" />
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="baseCurrency"><g:message code="companyInformation.baseCurrency.label" default="Base Currency" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'baseCurrency', 'errors')}">
                                    <g:select name="baseCurrency" from="${['AFN','ALL','DZD','AOA','XCD','ARS','AMD','AWG','AUD','EUR','AZN','BSD',
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
													value="${companyInformationInstance?.baseCurrency}" noSelection="['':'-Choose your currency-']" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
                                
                                <td valign="top" class="name">
                                    <label for="baseCurrencySymbol"><g:message code="companyInformation.baseCurrencySymbol.label" default="Base Currency Symbol" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'baseCurrencySymbol', 'errors')}">
                                    <g:textField name="baseCurrencySymbol" value="${companyInformationInstance?.baseCurrencySymbol}" class="required"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                    
                    <hr>
					<h1> Shipping Address </h1>
					<g:hiddenField name="shippingAddressId" value="${companyInformationInstance?.shippingAddress?.id}" />
					<table>
                        <tbody>
							<tr class="prop">
								<td valign="top" class="name">
									<label for="address"><g:message code="companyInformation.address.label" default="Address Line 1:" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'shippingAddress?.shipAddressLine1', 'errors')}">
									<g:textField name="shipAddressLine1" value="${companyInformationInstance?.shippingAddress?.shipAddressLine1}" size="50"/>
									
									<br>
									(Street Address , P.O. box , Company Name , c/o)
								</td>
							</tr>
                        	
                        	<tr class="prop">
								<td valign="top" class="name">
									<label for="address"><g:message code="companyInformation.address.label" default="Address Line 2:" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'shippingAddress?.shipAddressLine2', 'errors')}">
									<g:textField name="shipAddressLine2" value="${companyInformationInstance?.shippingAddress?.shipAddressLine2}" size="50"/>
									<br>
									(Apartment, suite, unit, building, floor, etc.)
								</td>
							</tr>
                        	
                        	<tr class="prop">
                        		<td valign="top" class="name">
									<label for="city"><g:message code="companyInformation.city.label" default="City" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'shippingAddress?.shipCity', 'errors')}">
									<g:textField name="shipCity" value="${companyInformationInstance?.shippingAddress?.shipCity}"/>
								</td>
								
                        	</tr>
                        	<tr class="prop">
                        		
                        		<td valign="top" class="name">
									<label for="state"><g:message code="companyInformation.state.label" default="State/Province/Region" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'shippingAddress?.shipState', 'errors')}">
									<g:textField name="shipState" value="${companyInformationInstance?.shippingAddress?.shipState}"/>
								</td>
                        		
                        	</tr>
                        	<tr class="prop">
								<td valign="top" class="name">
									<label for="postalcode"><g:message code="companyInformation.postalcode.label" default="ZIP/Postcode/Postal Code" /></label>
								</td>
								<td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'shippingAddress?.shipPostalcode', 'errors')}">
									<g:textField name="shipPostalcode" value="${companyInformationInstance?.shippingAddress?.shipPostalcode}" />
								</td>
								
							</tr>
                        	<tr class="prop">
								
								<td valign="top" class="name">
									<label for="country"><g:message code="companyInformation.country.label" default="Country" /></label><em>*</em>
								</td>
								<td valign="top" class="value ${hasErrors(bean: companyInformationInstance, field: 'shippingAddress?.shipCountry', 'errors')}">
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
						                 value="${companyInformationInstance?.shippingAddress?.shipCountry}" noSelection="['':'-Choose your country-']" class="required"/>
                                
								</td>
							</tr> 
                        	    						            	
                       </tbody>
                    </table>
                </div>
              
                <div class="buttons">
                    <button id="btnUpdate" title="Update Company Information">Update</button>
                    <button id="cancelCompanyInfo" title="Cancel"> Cancel </button>
                </div>
            </g:uploadForm>
            
            <g:if test="${source=='firstsetup'}">
		            </div>
	            </div>
			</g:if>
         </div>
    