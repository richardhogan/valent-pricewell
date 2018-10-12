
<%@ page import="grails.converters.JSON" %>
<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<style>
		.vertaligntop 	{ 	
						vertical-align:top; 
						margin-top:0; 
						height: 14em;
					}
		.horizontal {
			margin-top:0; 
			margin-left: 0px;
			margin-bottom: 0px;
			padding-top:0px;
padding-bottom:0px;
padding-right:0px;
padding-left:0px;
		}
		
		.readOnly {
background      : transparent;
    }
		
	</style>
    <script>

		var catcalogCache = <%=catcalogCache as JSON %>
		var catcalogSortedCache = <%=catcalogSortedCache as JSON %>
		
		var allServices = catcalogCache['services'];
		
		function loadServices(val){
			if(val == null){
				val = -1;
			}
			var box2 = 	jQuery('#serviceSelect').flexbox(catcalogSortedCache['portfolioServices'][val],
				{autoCompleteFirstMatch: true, 
					watermark: 'Type Service',
					paging: false,
					maxVisibleRows: 10,
				    noResultsText: 'no results found',  
					width: 160,
				    onSelect: function() { 
					 	jQuery('#service\\.id').val(jQuery('input[name=serviceSelect]').val());
						//jQuery('#geo\\.id').val(jQuery('input[name=geoSelect]').val());  
				    }});
		}

		jQuery(document).ready(function()
		{
			jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {
				jQuery("#fmAddQuote").validate({
					rules: {
						totalUnits: {
								number: true,
								required: true
							}
					},
					messages: {
						totalUnits: {
								min: "Please enter a value greater than " + (jQuery("#totalUnits").attr('min') - 1),
								required: "This is required"
							}
					}

				});
			});

			jQuery('#create').button();

			jQuery('#create').click(function(){
					var id = jQuery('#service\\.id').val(); 
					if(id == null){ jQuery('#dialog').dialog('open'); return false;}  
					if(!jQuery('#fmAddQuote').validate().form()){return false;}
				});

			jQuery("#dialog").dialog({ autoOpen: false })
			
			var box = jQuery('#portfolioSelect').flexbox(catcalogSortedCache['portfolios'],
			{autoCompleteFirstMatch: true, 
				watermark: 'Type Portfolio',
				paging: false,
				maxVisibleRows: 10,
			    noResultsText: 'no results found',  
				width: 160,
			    onSelect: function() {
				 	jQuery('#serviceSelect').html('');
				 	loadServices(jQuery('input[name=portfolioSelect]').val());
					//jQuery('#geo\\.id').val(jQuery('input[name=geoSelect]').val());  
			    }});
			
			loadServices(-1);

			jQuery('#service\\.id').change(function() {
					jQuery('#totalUnits').val(0);
					jQuery('#price').val(0);
				});

			jQuery('#totalUnits').bind("keyup", function(event){	
				var id = jQuery('#service\\.id').val();
				if(id == null)
				{
					 jQuery('#dialog').dialog('open');
					 return false;
				}
				var totalUnits = jQuery( "#totalUnits" ).val()
				if(totalUnits.length == 0)
				{
					jQuery('#totalUnits').val(0);
				}
				
				jQuery.post( '${baseurl}/serviceQuotation/displayCalculatedPrice', jQuery("#fmAddQuote").serialize(),
					      function( data ) {
					          jQuery('#price').val(data);
					      }); 
				
			});
		
			
		});

		

	
		
		
	</script>
    <body>
       
        <div class="body">
             
            <g:hasErrors bean="${serviceQuotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceQuotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            
            <g:form action="save" name="fmAddQuote">
                    
				                       
                <g:hiddenField name="quotation.id" value="${serviceQuotationInstance?.quotation?.id}"/>
                	<div id="dialog" title="Validation">
						<p> Oops, You forgot to select service. </p>
					</div>
                <div class="dialog">
                    <table border="1" style="border-style:solid;width: 100%">
                    	<thead>
                    		<tr>
                    			<th> Portfolio </th>
                    			<th> Service </th>
                    			<th> Units </th>
                    			<th> Price </th>
                    			<th> </th>
                    		</tr>
                    	</thead>
                        <tbody>
                        	 <tr class="prop">
								<td style="width: 100%; vertical-align: top">
									<div id="portfolioSelect" style="width: 170px"></div>  
								</td>
								<td style="width: 100%; vertical-align: top">
									<div id="serviceSelect" style="width: 170px"></div> 
									<g:hiddenField name="service.id" /> 
								</td>
                                
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'totalUnits', 'errors')}">
                                	<div class="vertaligntop">
	                                    <g:textField name="totalUnits" id="totalUnits" value="${fieldValue(bean: serviceQuotationInstance, field: 'totalUnits')}" class="required" number="true" style="width: 5em"/>
                                    </div>
                                </td>
                                
                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'price', 'errors')}">
                                	<div class="vertaligntop" width="100%">
                                		<label> <g:textField name="price" value="${fieldValue(bean: serviceQuotationInstance, field: 'price')}" readOnly="true" style="width: 7em"/> </label>
	                                    <label> ${serviceQuotationInstance?.geo?.currency} </label>
	                                 </div>
                                </td>
                                
                                <td>
                                	<div class="vertaligntop">
					                    <span class=""><g:submitToRemote name="create" class="save" value="Add" controller="serviceQuotation" action="save" update="dvQuotationMain" onSuccess="refreshForecastValue();"/>
					                    </span>
                					</div>
                                </td>
                               
                              </tr>
                              
                                                     		
                       </tbody>
                    </table>
                </div>
                
              
            </g:form>
        </div>
        <br/>
        <br/>
    </body>
</html>
