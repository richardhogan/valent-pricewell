<%@ page import="com.valent.pricewell.SowDiscount" %>
<%
	def baseurl = request.siteUrl
%>

<!doctype html>
<html>
	<head>
		<g:set var="entityName" value="${message(code: 'sowDiscount.label', default: 'SowDiscount')}" />
		<title><g:message code="default.edit.label" args="[entityName]" /></title>
		
		<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
        <script>
	  		jQuery(document).ready(function()
			{
	  			jQuery("#updateSowDiscountFrm").validate();
				
			    jQuery("#updateSowDiscountFrm input:text")[0].focus();
			    
				jQuery("#updateSowDiscount").click(function()
				{
					if(jQuery("#updateSowDiscountFrm").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/sowDiscount/update",
							data:jQuery("#updateSowDiscountFrm").serialize(),
							success: function(data)
							{
								if(data == "sowDiscount_available")
					      		{
					        		//jQuery("#nameMsg").html('Error: This portfolio is already available.');
					       		}
								else if(data['result'] == "success"){
									refreshGeoGroupList();
								}
								else{
									//jQuery('#portfolioErrors').html(data);
									//jQuery('#portfolioErrors').show();
								}
								hideLoadingBox();
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								hideLoadingBox();
								alert("Error while saving");
							}
						});
					}
					return false;
				}); 

				jQuery("#cancelSowDiscount").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/sowDiscount/listsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	

				jQuery.each(${sowDiscountInstance?.territories*.id}, function( index, value ) {
					//alert( index + ": " + value );
					jQuery('select[name="territoryId"]').find('option[value="'+value+'"]').attr("selected",true);
					getCurrencySymbol(value);
				});

				jQuery("#territoryId").change(function() 
		    	{
		    		getCurrencySymbol(this.value);
		    		return false;
				  
				});

				jQuery('#amount').keyup(function(){
				    this.value = numberWithCommas(this.value);
				});
			});

	  		function numberWithCommas(x) {
			  	x = x.split(",").join("");
		  		var parts = x.toString().split(".");
		    	parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		    	return parts.join(".");
			}
			
	  		function getCurrencySymbol(territoryId)
			{
			 	jQuery.ajax({type:'POST',data: {id: territoryId },
					 url:'${baseurl}/geo/getCurrencySymbol',
					 success:function(data,textStatus){jQuery('#currencySymbol').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			}
		</script>
	</head>
	<body>
		
		<div>
			<div class="collapsibleContainer" >
				<div class="collapsibleContainerTitle ui-widget-header" >
					<div>Edit SOW Discount</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content" >
					<g:form method="post" name="updateSowDiscountFrm" >
						<g:hiddenField name="id" value="${sowDiscountInstance?.id}" />
						<g:hiddenField name="version" value="${sowDiscountInstance?.version}" />
						
						<div class="dialog">
							<g:render template="form"/>
						</div>
						
						<div class="buttons">
							<span class="button"><button id="updateSowDiscount" title="Update Discount"> Update </button></span>
		                    <span class="button"><button id="cancelSowDiscount" title="Cancel"> Cancel </button></span>
						</div>
					</g:form>
				</div>
			</div>
			
		</div>
	</body>
</html>
