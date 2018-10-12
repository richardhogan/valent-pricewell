<%@ page import="com.valent.pricewell.SowDiscount" %>
<%
	def baseurl = request.siteUrl
%>

<!doctype html>
<html>
	<head>
		<g:set var="entityName" value="${message(code: 'sowDiscount.label', default: 'SowDiscount')}" />
		<title><g:message code="default.create.label" args="[entityName]" /></title>
		
		<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<script>
			jQuery(document).ready(function()
			{
				jQuery("#createSowDiscountFrm").validate();

				jQuery('#description').keyup(function(){
				    this.value = this.value.toUpperCase();
				}); 

				jQuery("#createSowDiscountFrm input:text")[0].focus()

				jQuery('#amount').keyup(function(){
				    this.value = numberWithCommas(this.value);
				});
				
				jQuery("#saveSowDiscount").click(function()
				{
					//loadValues();
					if(jQuery("#createSowDiscountFrm").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/sowDiscount/save",
							data:jQuery("#createSowDiscountFrm").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "sowDiscount_available")
					      		{
					        		//jQuery("#geoNameMsg").html('Error: This territory is already available.');
					       		}
								else if(data['result'] == "success"){
									refreshGeoGroupList();
								} else{
									
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

				jQuery("#territoryId").change(function() 
		    	{
		    		getCurrencySymbol(this.value);
		    		return false;
				  
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
		
		<div id="create-sowDiscount" class="content scaffold-create" role="main">
		
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Add New SOW Discount</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">
					<g:form action="save" name="createSowDiscountFrm">
						<g:hiddenField name="quotationId" value="${quotationInstance?.id }"/>
						<div class="dialog">
							<g:render template="form"/>
						</div>
						<div class="buttons">
							<span class="button"><button id="saveSowDiscount" title="Save Discount"> Save </button></span>
			                <span class="button"><button id="cancelSowDiscount" title="Cancel"> Cancel </button></span>
						</div>
					</g:form>
				</div>
			</div>
		</div>
	</body>
</html>
