
<%@ page import="org.apache.shiro.SecurityUtils"%>

<%
	def baseurl = request.siteUrl
%>	
        <g:set var="entityName" value="${message(code: 'cw.label', default: 'Connectwise')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			.ui-dialog .ui-state-error { padding: .3em; }
		</style>
		
		<script>
			 
			jQuery(document).ready(function()
		 	{
			 
				jQuery("#importOpportunitiesFrm").validate();
				//jQuery("#importOpportunitiesFrm input:text")[0].focus();
				   
				dateRange('opportunity_dateRange', 'This quarter to date', function(val)
	      		{
	      			return false;
	      		});
	      		
				
				jQuery( "#importOpportunitySuccessDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					height:500,
					width: 800,
					buttons: {
						OK: function() 
						{
							jQuery( "#importOpportunitySuccessDialog" ).dialog( "close" );
							window.location.href = '${baseurl }/opportunity/list';
							return false;
						}
					}
				});

				jQuery( "#mapOpportunityTerritoryDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					height: 'auto',
					width: 900
				});
				
				jQuery( "#importOpportunityFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#importOpportunityFailureDialog" ).dialog( "close" );
							return false;
						}
					}
				});
						
				
				jQuery( "#import" ).click(function() 
				{					
					var obj = jQuery.parseJSON(jQuery("#opportunity_dateRange").val());
					jQuery("#startDate").val(obj.end);
					jQuery("#endDate").val(obj.start);
					//Note : change as per the requirement because in date range jquery these values are swaped...
					
					if(jQuery('#importOpportunitiesFrm').validate().form())
					{
						showLoadingBox();
						
    	   				jQuery.ajax(
						{
			                url: '${baseurl }/cw/saveOpportunitiesFromConnectwise',
			                type: 'POST',
			                data: jQuery("#importOpportunitiesFrm").serialize(),
			                success: function (data) 
			           		{
			           			hideLoadingBox();
			           			if(data['result'] == "success")
					           	{
				           			jQuery( "#importOpportunitySuccessDialog" ).html(data['content']).dialog("open");

				           			jQuery( "#importDialoag" ).dialog( "close" );

			           				//jQuery( "#dvImportOpportunityContent" ).html(data['content']);//for saperate window...
						        }
						        if(data['result'] == "mapTerritory")
							    {
						        	jQuery( "#mapOpportunityTerritoryDialog" ).html(data['content']).dialog("open");

				           			jQuery( "#importDialoag" ).dialog( "close" );
						        	//jQuery( "#dvImportOpportunityContent" ).html(data['content']);//for saperate window...
								}
				           		else
					           	{
				           			jQuery( "#importOpportunityFailureDialog" ).html(data['failureMessage']).dialog("open");
						           	
					           	}
				           		
			                }, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								//alert("Error while saving");
								hideLoadingBox();
								jQuery( "#importOpportunityFailureDialog" ).dialog("open");
							}
			            });
               		}
					return false;
				});
				  
			});
  		</script>
  		
  		
    
       
        <div class="body">
            
            <div id="mapOpportunityTerritoryDialog" title="Import Opportunity Territory Mapping">
				
			</div>
			
			<div id="importOpportunitySuccessDialog" title="Success">
				
			</div>
	
			<div id="importOpportunityFailureDialog" title="Failure">
				
			</div>
			
            <g:form action="saveOpportunitiesFromConnectwise"  name="importOpportunitiesFrm">
            	<g:hiddenField name="startDate" value="" />
                <g:hiddenField name="endDate" value="" />
                
            	<div>
                	
                	<!-- <h1>URL and Credentials</h1><hr>
            		<table>
                        <tbody>
	                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="url"><g:message code="cw.url.label" default="Site URL" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value">
                                    <g:textField name="url" value="" class="required"/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for="companyId"><g:message code="cw.companyId.label" default="Company ID" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value">
                                    <g:textField name="companyId" value="" class="required"/>
                                </td>
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="loginId"><g:message code="cw.loginId.label" default="Login ID" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value">
                                    <g:textField name="loginId" value="" class="required"/>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td valign="top" class="name">
                                    <label for=password><g:message code="cw.password.label" default="Password" /></label><em>*</em>
                                </td>
                                <td valign="top" class="value">
                                    <input type="password" id="password" name="password" class="password required"/>
                                </td>
                            </tr>
                        
                        </tbody>
               		</table>
                   	
                   	
                   	<h1>Opportunity Filter Criteria</h1><hr>-->
                   	<table>
               			<tbody>
               			
               				<!-- <tr class="prop">
								<td valign="top" class="name">
								    <label for="status"><g:message code="cw.status.label" default="Opportunity Status" /></label>
								</td>
								<td valign="top" class="value">
								    <g:select name="status" from="['Lost', 'No Decision', 'Open', 'Won']" value=""  noSelection="['': 'Select Multiple']" multiple="true"/>
									
								</td>
								
								<td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
								    <label for="stages"><g:message code="cw.stage.label" default="Opportunity Stages" /></label>
								</td>
								<td valign="top" class="value">
								    <g:select name="stages" from="['1.Prospect', '2.Qualification', '3.Quote', '4.Evaluation', '5.Commitment']" value="" noSelection="['': 'Select Multiple']" multiple="true"/>
									
								</td>
							</tr>
							
							<tr class="prop">
								<td valign="top" class="name">
								    <label for="productTypes"><g:message code="cw.productTypes.label" default="Product Types" /></label>
								</td>
								<td valign="top" class="value">
								    <g:select name="productTypes" from="['Fixed Cost Service', 'Hardware', 'Miscellaneous', 'Software']" value="" noSelection="['': 'Select Multiple']" multiple="true"/>
									
								</td>
								
								<td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
								    <label for="estimateTypes"><g:message code="cw.estimateTypes.label" default="Estimate Types" /></label>
								</td>
								<td valign="top" class="value">
								    <g:select name="estimateTypes" from="['Product', 'Service', 'Agreement', 'Managed Service', 'Other']" value="" noSelection="['': 'Select Multiple']" multiple="true"/>
									
								</td>
								
							</tr>-->
							
							<!--<tr class="prop">
								<td valign="top" class="name">
								    <label for="forecastStatus"><g:message code="cw.forecastStatus.label" default="Opportunity Forecast Status" /></label>
								</td>
								<td valign="top" class="value">
								    <g:select name="forecastStatus" from="['Lost', 'No Decision', 'Open', 'Won']" value=""  noSelection="['': 'Select Multiple']" multiple="true"/>
									
								</td>
								
								<td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
								    <label for="dateRange">Select Date Range</label>
								</td>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td valign="top" class="value">
								    <select id="opportunity_dateRange" ></select>
									
								</td>
								
							</tr>-->
								<tr>
									<td valign="top" class="name">
									    <label for="dateRange">Select Date Range</label>
									</td>
									<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td valign="top" class="value">
									    <select id="opportunity_dateRange" ></select>
										
									</td>
								</tr>
								
								<tr>
									<td valign="top" class="name">
									    <label for="dateRange">Note : </label>
									</td>
									<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td valign="top" class="value">
									    Select first time import range. Next time will import from where it is left to import.
									</td>
								</tr>
                        </tbody>
                	 </table>
                    	
                </div>
                <div class="buttons">
                    <span class="button"><button id="import" title="Import Opportunities">Import</button></span>
                </div>
            </g:form>
        </div>
    