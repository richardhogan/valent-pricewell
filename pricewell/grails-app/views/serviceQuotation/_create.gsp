
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
		background : transparent;
    }
		
	</style>
    <script>
		//var totalAddtionalUnits=0;

		var catcalogCache = <%=catcalogCache as JSON %>
		var allServices = catcalogCache['portfolioServices'][-1];
		var portfolioServices = catcalogCache['portfolioServices'];
		var portfolios = catcalogCache['portfolios']
		var additionalUnitOfSaleJson = null;
		
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

			/*jQuery('#create').button();

			jQuery('#create').click(function(){
					var id = jQuery('#service\\.id').val(); 
					if(id == null){ jQuery('#dialog').dialog('open'); return false;}  
					if(!jQuery('#fmAddQuote').validate().form()){return false;}
				});
			*/
			jQuery('#create').click(function() 
			{
				
				var id = jQuery('#serviceProfile\\.id').val(); 
				var baseUnits = parseInt(jQuery("#baseUnits").val());
				var totalUnits = parseInt(jQuery("#totalUnits").val());

				jQuery("#additionalUnitOfSaleJson").val(JSON.stringify(additionalUnitOfSaleJson));

				//alert(jQuery("#additionalUnitOfSaleJson").val());
				//return false;
				if(id == null){ jQuery('#dialog').dialog('open'); return false;}  
				if(totalUnits == 0){jAlert('Please add required total units of service first.', 'Add Service Alert'); return false;}
				if(totalUnits < baseUnits){jAlert('${message(code:'smallerTotalUnitsOfService.message.alert')}', 'Add Service Alert'); return false;}
				if(!jQuery('#fmAddQuote').validate().form()){return false;}
				else
				{
					jQuery.ajax({type:'POST',data:jQuery("#fmAddQuote").serialize(),
							 url:'${baseurl}/serviceQuotation/save',
							 success:function(data,textStatus)
							 {
							 	jQuery('#dvQuote').html(data);
							 	//jQuery("#dvQuotationMain").html(data);
							 	refreshForecastValue();
							 	//jQuery('#toggleAddQuote').click();
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
				}

				jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Expenses' );
				jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
				index = index+1000;
				jQuery( "#dvQutationServices" ).dialog( "open" );
			
			}); 
			
			jQuery("#dialog").dialog({ autoOpen: false })
			
			loadPortfolios();

			jQuery('#portfoliosList').change(function() {
				jQuery('#searchService').val('');
				loadServices();
				
			});
			
			jQuery('#serviceProfile\\.id').change(function()
			{
				jQuery('#totalUnits').val(0);
				jQuery('#price').val(0);
				jQuery.post( '${baseurl}/serviceQuotation/displayUnitOfSaleAndBaseUnits', jQuery("#fmAddQuote").serialize(),
					function( data ) 
				    {
						additionalUnitOfSaleJson = JSON.parse(data.additionalUnitOfSaleJson);
						//alert(data.additionalUnitOfSaleJson);
						var totalAddtionalUnits = 1;
								
					    var additionalUnitOfSaleList=data['additionalUnitOfSaleList'];
					      	
				    	jQuery('#unitOfsaleExtraUnit').empty();
				    	jQuery('#totalExtraUnits').empty();

				    	jQuery.each(additionalUnitOfSaleJson.additionalUnitOfSaleJSONArray, function( index, item )
						{
				    		totalAddtionalUnits = totalAddtionalUnits * parseInt(item.units);
				    		jQuery('#unitOfsaleExtraUnit').append("<label><input type='text' value='"+item.unitOfSale+"'readOnly='true' style='width: 10em'/> </label>");
				    	  	jQuery('#totalExtraUnits').append("<label><input type='text' name='additionalUnits_"+item.id+"' id='additionalUnits_"+item.id+"' value='"+item.units+"' class='required number additionalUnits' min='"+1+"' style='width: 4em'/> </label>");
					
				    	  	
						});
				    	jQuery('#unitOfSale').val(data['unitOfSale']);
				        jQuery('#baseUnits').val(data['baseUnits']);
				        jQuery("#addtionalExtraUnit").val(totalAddtionalUnits);

				        
				        //function operates on each changed value of additional units of service
				      	jQuery( ".additionalUnits" ).keyup(function()
						{
							var id = this.id;
							var changedAdditionalUnits = jQuery("#"+id).val();
							var sequenceId = id.substring(16);
							totalAddtionalUnits = 1;
							
							if(changedAdditionalUnits == "" || changedAdditionalUnits == 0)
							{
								jQuery("#"+id).val(1);
								changedAdditionalUnits = 1;
							}
							
							jQuery.each(additionalUnitOfSaleJson.additionalUnitOfSaleJSONArray, function( index, item )
							{
							  	if(item.id == sequenceId)
								{
									var old = item.units;
									item.units = changedAdditionalUnits;
							  		//return false;
							  	}

							  	if(item.units > 0)
								{
							  		totalAddtionalUnits = totalAddtionalUnits * parseInt(item.units);
								}
							});

							jQuery("#addtionalExtraUnit").val(totalAddtionalUnits);
							loadServiceQuotationPrice();
						});				     	
				        
				    });
			});

			

			jQuery("#searchService").keyup(function(e) {
				loadServices();
			});

			jQuery("#searchPortfolio").keyup(function(e) {
				loadPortfolios();
			});

			jQuery('#totalUnits').bind("keyup", function(event){	
				var id = jQuery('#serviceProfile\\.id').val();
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
				//var totalUnits=jQuery("#totalUnits").val();
				//var totalPlusAdditionalUnits=parseInt(totalUnits)+parseInt(totalAddtionalUnits);
				//jQuery("#totalUnits").val(totalPlusAdditionalUnits);
				//alert(jQuery("#totalUnits").val());

				loadServiceQuotationPrice();
				
			});
		
			jQuery('#portfoliosList').trigger("change");//This line populate service values when page is loaded by default
		});

		function loadServiceQuotationPrice()
		{
			jQuery.post( '${baseurl}/serviceQuotation/displayCalculatedPrice',
				jQuery("#fmAddQuote").serialize(),
		  		function( data )
		  		{
		  			//alert(data + ", additionalUnits : " + totalAddtionalUnits + ", hence price will be : " + (data * totalAddtionalUnits));
		          	jQuery('#price').val(data);
		      	});
		}
		
		function loadPortfolios() {
			addOptions('portfoliosList', filterData(portfolios, getFilter(jQuery('#searchPortfolio').val())));
			if(jQuery('#portfoliosList').val() == null) {
					jQuery('#portfoliosList').val(-1);
					loadServices();
				};
		}

		function loadServices() {
			var pid = jQuery('#portfoliosList').val();
			addOptions('serviceProfile\\.id', filterData(portfolioServices[pid], getFilter(jQuery('#searchService').val())));	
		}

		function filterData(dataStore, filter) {
		    return jQuery(dataStore).filter(function(index, item) {
		        for( var i in filter ) {
				   if(item[i] == undefined) return null;
		           if( ! item[i].toString().match( filter[i] ) ) return null;
		        }
		        return item;
		    });
		}
		
		function getFilter(val){
			return {"name": new RegExp(val, 'gi')}
		}

		function addOptions(id, selectedValues){
			var output = [];
			if(selectedValues != null && selectedValues != undefined){
				var len = selectedValues.length
				for(var i=0; i< len; i++){
					output.push('<option value="'+ selectedValues[i]['id'] +'">'+ selectedValues[i]['name'] +'</option>');
				}				
			}

			jQuery('#' + id).html(output.join(''));
			
		}
		
	</script>
    <body>
       
        <div class="body" id="createQuoteDiv">
             
            <g:hasErrors bean="${serviceQuotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${serviceQuotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:if test="${portfolioCount > 0}">
            	<g:form action="save" name="fmAddQuote">
                    
					<g:hiddenField name="quotation.id" value="${serviceQuotationInstance?.quotation?.id}"/>
					<g:hiddenField id="addtionalExtraUnit" name="addtionalExtraUnit" value="0"/>
					<g:hiddenField id="additionalUnitOfSaleJson" name="additionalUnitOfSaleJson" value=""/>

	                	<div id="dialog" title="Validation">
							<p> Oops, You forgot to select service. </p>
						</div>
	                <div id="addPortfolioSelection">	                                	
                          		Portfolio <g:select name="portfoliosList" from="${portfolioList}" optionValue="portfolioName" optionKey="id" style="width: 20em"/>
							        
						</div>
	                <div class="dialog" >
	                    <table border="1" style="border-style:solid;" id="divAddPortfolio">

	                    	<thead>
	                    		<tr>
	                    			<th> Service </th>
	                    			<th style="text-align: center";> Unit Of <br />Sale </th>
	                    			<th> Base <br/>Units </th>
	                    			<th> Total Units </th>
	                    			<th> Price </th>
	                    			<th> </th>
	                    		</tr>
	                    	</thead>
	                    	
	                        <tbody>
	                        	
	                            <tr class="prop">                           
	                              
	                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'service', 'errors')}" class="vertaligntop">
	                                	<div class="vertaligntop">
	                                		<div class="horizontal">
			                                	<g:hiddenField name="geo.id" value="${serviceQuotationInstance?.geo.id}"></g:hiddenField>
			                                	
			                                	<g:select name="serviceProfile.id" from="" optionValue="serviceName" optionKey="id" size="10" style="width: 25em"/>
										    </div>
										    
										</div>
									</td>
									  
									<!-- <td colspan="5">
									
										<table>
											<tbody>
												<tr></tr>
											</tbody>
										</table>
									</td> -->
									
	                                <td>
		                                <div class="vertaligntop">
		                                	<label> <g:textField name="unitOfSale" value="${serviceQuotationInstance?.profile?.unitOfSale}" readOnly="true" style="width: 10em"/> </label>
		                                	<div id="unitOfsaleExtraUnit" class="vertaligntop">
		                                	
		                                	</div>
	                                	</div>
                                	</td>
                                	
                                	
                                	<td>
		                                <div class="vertaligntop">
		                                	<label> <g:textField name="baseUnits" value="${serviceQuotationInstance?.profile?.baseUnits}" readOnly="true" style="width: 4em"/> </label>
		                                	<div id="baseUnitExtraUnit" class="vertaligntop">
		                                	
		                                	</div>
	                                	</div>
                                	</td>
                                	
	                                <td valign="top" class="value ${hasErrors(bean: serviceQuotationInstance, field: 'totalUnits', 'errors')}">
	                                	<div class="vertaligntop">
		                                	<label><g:textField name="totalUnits" id="totalUnits" value="${fieldValue(bean: serviceQuotationInstance, field: 'totalUnits')}" class="required" number="true" style="width: 5em"/></label>
		                                	<div id="totalExtraUnits" class="vertaligntop">
		                                	
		                                	</div>
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
						                    <span class="">
						                    	<input id="create" type="button" value="Add" title="Add Service" class="button"/>
						                    </span>
	                					</div>
	                                </td>
	                             
	                              </tr>
	                              <tr id="extraUnitbody">

	                              </tr>

	                                                     		
	                       </tbody>
	                    </table>
	                </div>
	                
	              
	            </g:form>
	            	
            </g:if>
            <g:else>
            	<p><b>${territory} territory doesn't have any rates and prices defined, so please contact administrator.</b></p>
            </g:else>
        </div>
        <br/>
        <br/>
    </body>
</html>
