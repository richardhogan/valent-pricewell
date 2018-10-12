<%
	def baseurl = request.siteUrl
%>
<script>
	var discountPercent = <%=quotationInstance?.discountPercent%>
	var flatDiscount = <%=quotationInstance?.flatDiscount%>
	var allowedLowRange = <%=allowedDiscountRange[0]%>
	var allowedHighRange = <%=allowedDiscountRange[1]%>

	jQuery(function() 
	{
		jQuery('#flatDiscount').val(flatDiscount + "");
		var i=allowedLowRange;
		var values = [];
		
		for(i=allowedLowRange; i<=allowedHighRange; i++){
				values.push([i, i + "%" ]);		
			}
		addOptions("discountPercent", values);
		jQuery('#discountPercent').val(discountPercent);
		toggleFlatPercent();
		
		jQuery('#flatDiscount').change(function(){
				toggleFlatPercent();
			}); 
		jQuery('#save').button();
		
		jQuery('#moreDiscount').click(function() 
		{
			jQuery( "#dvQutationServices" ).dialog( "option", "title", 'Notification Request' );
			jQuery( "#dvQutationServices" ).dialog( "option", "zIndex", index+1000 );
			index = index+1000;
			jQuery( "#dvQutationServices" ).dialog( "open" );
			jQuery.ajax({type:'POST',data:jQuery('#frmDiscount').serialize(),
						 url:'${baseurl}/quotation/discountRequest',
						 success:function(data,textStatus){jQuery('#dvQutationServices').html(data);},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
		});
		jQuery('#btnSaveDiscount').click(function()
		{
			showLoadingBox();
			jQuery.ajax({type:'POST',data:jQuery('#frmDiscount').serialize(),
				 url:'${baseurl}/quotation/saveDiscount',
				 success:function(data,textStatus)
				 {
					 hideLoadingBox();
					 jQuery( "#dvQutationServices" ).dialog( "close" );
					 jQuery('#dvQuote').html(data);
					 	
					 	refreshForecastValue();
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false
		});

		jQuery('#localDiscount').bind("keyup", function(event){	
			var discountValue = jQuery( "#localDiscount" ).val()
			if(discountValue.length == 0)
			{
				jQuery('#localDiscount').val(0);
			}
			
		});
	});
	function toggleFlatPercent(){
		var val = jQuery('#flatDiscount').val();
		if(val == 'true'){
			jQuery('#discountPercent').hide();
			jQuery('#localDiscount').show();
			jQuery('#currencySymbol').show();
			jQuery('#discountText').text('Amount')
		} else {
			jQuery('#discountPercent').show();
			jQuery('#localDiscount').hide();
			jQuery('#currencySymbol').hide();
			jQuery('#discountText').text('Percent')
		}

	}
	
	function addGlobalSowDiscount()
	{
		if(${quotationInstance?.geo?.sowDiscounts?.size()} > 0)
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/sowDiscount/addSowDiscount",
				data: {'quotationId': ${quotationInstance?.id}},
				success: function(data){jQuery("#dvQutationServices").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
		}
		else
		{
			jAlert('There is no any global discount defined in SETUP, please define there first and try to add here again.', 'Add Global Discount Alert');
		}
		
		return false;
	}
	
	function addOptions(id, selectedValues)
	{
		var output = [];
		if(selectedValues != null && selectedValues != undefined){
			var len = selectedValues.length
			for(var i=0; i< len; i++){
				output.push('<option value="'+ selectedValues[i][0] +'">'+ selectedValues[i][1] +'</option>');
			}				
		}
		jQuery('#' + id).html(output.join(''));
		
	}
	function removeDiscount(discountId)
	{
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/quotation/removeSowDiscount",
			data: {'quotationId': ${quotationInstance?.id}, discountId: discountId},
			success: function(data){jQuery("#dvQutationServices").html(data);}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
		});
	} 
	
</script>

<div class="body">
	<div class="nav">
		<g:if test="${quotationInstance?.geo?.sowDiscounts?.size() > 0}"></g:if>
		<span>
			<a id="idAddSowGlobalDiscount" onclick="addGlobalSowDiscount();" class="buttons.button button" title="Add Global Discount">Add Global Discount</a>
		</span>
		<span>|</span>
		<span>Total SOW Amount : <label> ${quotationInstance?.totalQuotedPrice} </label> <label> ${quotationInstance?.geo?.currency} </label></span>
		<span>|</span>
		<span>Total Discounted Amount : <label> ${quotationInstance?.discountAmount } </label> <label> ${quotationInstance?.geo?.currency} </label></span>
	</div>

	<br/>
	<div class="list">
		<g:form  name="frmDiscount" url="[action:'saveDiscount',controller:'quotation']">
			<g:hiddenField name="qid" value="${quotationInstance?.id}" />
			<table>
				<thead>
					<tr>
						<th> Description </th>
						<th> Discount </th>
						<th> <span id="discountText"></span> </th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td>
							<textarea name="localDiscountDescription" rows="3" cols="50">${quotationInstance?.localDiscountDescription}</textarea>
						</td>
						
						<td> 
							<select id="flatDiscount" name="flatDiscount">
								<option value="true"> Flat Amount </option>
								<option value="false"> Percentage </option>
							</select>  
						</td>
						
						<td>
							<select id="discountPercent" name="discountPercent" style="width: 4em"></select>
							<%--<g:textField name="discountAmount" value="${quotationInstance?.discountAmount}" style="width: 6em"/>--%>
							<label id="currencySymbol">${quotationInstance?.geo?.currencySymbol}</label><g:textField name="localDiscount" value="${quotationInstance?.localDiscount}" style="width: 6em"/>
						</td>	
						
					</tr>
				</tbody>
			</table>
			<input id="btnSaveDiscount" title="Save Discount" class="save" value="Save" type="button"/>
			<g:if test="${moreDiscountAllowed}">
				<input id="moreDiscount" type="button" title="Need More Discount" value="Need More Discount" class="button"/>
			</g:if>
		</g:form>
	</div>
		
	<g:if test="${quotationInstance?.sowDiscounts?.size() > 0}">
		<hr/>
		<div class="list">
			<h1>Added Global Discounts</h1>
			
			<table>
				<thead>
					<tr>
						<th>Description</th>
						<th>Amount</th>
						<th></th>
					</tr>
				</thead>
				
				<tbody>
					<g:each in="${quotationInstance?.sowDiscounts}" status="i" var="sowDiscountInstance">
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td>${sowDiscountInstance?.description}</td>
							<td>${quotationInstance?.geo?.currencySymbol}${sowDiscountInstance?.amount}</td>
							<td>
								<a id="idRemoveDiscount-${sowDiscountInstance?.id}" onclick="removeDiscount(${sowDiscountInstance?.id});" class="buttons.button button" title="Add Discount">Remove</a>
							</td>
						</tr>
					</g:each>
				</tbody>
			</table>
		</div>
	</g:if>
		
</div>