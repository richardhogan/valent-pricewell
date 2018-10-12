
<%@ page import="com.valent.pricewell.CompanyInformation" %>
<%
	def baseurl = request.siteUrl
%>		
	<div id="mainInformationTab">
		<style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
		</style>
		<script>
		
			jQuery(document).ready(function()
		 	{			
			 	
				jQuery( "#btnEdit" ).click(function() 
				{
					showLoadingBox();
					jQuery.ajax({type:'POST',
						 url:"${baseurl}/companyInformation/edit",
						 data: {id: "${companyInformationInstance.id}", source: "${source}"},
						 success:function(data,textStatus)
						 {
								if("firstsetup" == "${source}")
								{
									jQuery("#mainInformationTab").html(data);
									hideLoadingBox();
								} /*else{
									jQuery('#mainInformationTab').html(data);
								}*/
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
						 
					return false;
				});
					
				
				  
			});
		
			function doRefreshInformation()
			{
				jQuery.ajax({type:'POST',
					 url:'${baeurl}/companyInformation/showsetup',
					 data: {source: 'firstsetup'},
					 success:function(data,textStatus){jQuery('#mainInformationTab').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			}
		
			
		
		</script>
		
        <div class="body">
        	<g:if test="${source=='firstsetup'}">
	            <div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header">
						<div>Company Information</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content">
			</g:if>
			
        	
        	<div class="dialog">
                <table>
                    <tbody>
                    
                    	<tr class="prop">
                            <td valign="top" class="name"><b><g:message code="companyInformation.name.label" default="Name : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "name")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="companyInformation.logo.label" default="Logo : " /></b></td>
                            <td>
                        		<g:if test="${companyInformationInstance?.logo?.id != null}">
                        			<img src="<g:createLink controller='logoImage' action='renderImage' id='${companyInformationInstance?.logo?.id}'/>" hight="80" width="100" />
                    			</g:if>
                			</td>
                        </tr>
                	</tbody>
                </table>
                <hr>
                <table>
                	</tbody>
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="companyInformation.website.label" default="Website : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "website")}</td>
                            
                        </tr>
                    
                        <!-- <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="companyInformation.SMTPserver.label" default="SMTP server : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "SMTPserver")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="companyInformation.fromEmail.label" default="From Email : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "fromEmail")}</td>
                        </tr>-->
                    
                        <tr class="prop">
                            <td valign="top" class="name"><b><g:message code="companyInformation.phone.label" default="Phone : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "phone")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="companyInformation.mobile.label" default="Mobile : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "mobile")}</td>
                        </tr>
                    
                    	<tr class="prop">
                            <td valign="top" class="name"><b><g:message code="companyInformation.baseCurrency.label" default="Base Currency : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "baseCurrency")}</td>
                            
                            <td>&nbsp;&nbsp;</td>
                            
                            <td valign="top" class="name"><b><g:message code="companyInformation.baseCurrencySymbol.label" default="Base Currency Symbol : " /></b></td>
                            <td valign="top" class="value">${fieldValue(bean: companyInformationInstance, field: "baseCurrencySymbol")}</td>
                        </tr>
                        
                    </tbody>
                </table>
                
                <hr>
                <h1>Shipping Address</h1>
                <table>
                	<tbody>
                		
                		 <tr class="prop">    
                            <td valign="top" class="name"><b><g:message code="companyInformation.address.label" default="Address Line 1 : " /></b></td>
                            <td valign="top" class="value">${companyInformationInstance?.shippingAddress?.shipAddressLine1}</td>
						</tr>
						<tr class="prop">
							<td valign="top" class="name"><b><g:message code="companyInformation.address.label" default="Address Line 2 : " /></b></td>
                            <td valign="top" class="value">${companyInformationInstance?.shippingAddress?.shipAddressLine2}</td>                        
                        </tr>
                		
                		<tr class="prop">
                    		<td valign="top" class="name"><b><g:message code="companyInformation.city.label" default="City : " /></b></td>
                            <td valign="top" class="value">${companyInformationInstance?.shippingAddress?.shipCity}</td>
                            <td>&nbsp;&nbsp;</td>
                        	<td valign="top" class="name"><b><g:message code="companyInformation.state.label" default="State : " /></b></td>
                        	<td valign="top" class="value">${companyInformationInstance?.shippingAddress?.shipState}</td>
                		
                        </tr>
                		
                		<tr class="prop">
                			<td valign="top" class="name"><b><g:message code="companyInformation.postalcode.label" default="Postal Code : " /></b></td>
                            <td valign="top" class="value">${companyInformationInstance?.shippingAddress?.shipPostalcode}</td>
                    		<td>&nbsp;&nbsp;</td>
                    		<td valign="top" class="name"><b><g:message code="companyInformation.country.label" default="Country : " /></b></td>
                            <td valign="top" class="value">
                            	<g:if test="${companyInformationInstance?.shippingAddress?.shipCountry?.size() > 3}">
                            		${companyInformationInstance?.shippingAddress?.shipCountry}
                        		</g:if>
                        		<g:elseif test="${companyInformationInstance?.shippingAddress?.shipCountry?.size() == 3}">
                        			<g:country code="${companyInformationInstance?.shippingAddress?.shipCountry}"/>
                    			</g:elseif>
                            </td>
                    		
                    	</tr>
                		                       
                	</tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${companyInformationInstance?.id}" />
                    <button id="btnEdit" title="Edit Company Information">Edit</button>
                </g:form>
            </div>
        </div>
        
        <g:if test="${source=='firstsetup'}">
	            </div>
            </div>
		</g:if>
    </div>
    