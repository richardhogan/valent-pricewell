<%@ page import="com.valent.pricewell.ServiceProfile" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<script>
	
	jQuery(document).ready(function()
	{
		
			jQuery("#marginCalculateFrm").validate();
			
			jQuery('#calculateMargin').click(function() 
			{
				var units = jQuery('#marginFields\\.units').val(); 
				if(units == null){ alert("Please add units first."); return false;}  
				if(!jQuery('#marginCalculateFrm').validate().form()){return false;}
				else
				{
					if(units > 0)
					{
						jQuery.ajax({type:'POST',data:jQuery("#marginCalculateFrm").serialize(),
							 url:'${baseurl}/service/calculateMargin',
							 success:function(data,textStatus)
							 {
							 	jQuery('#dvMargin').html(data);
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});
							 
					}
					else{
						alert("Please enter units more than 0.");
					}
					
				}
				return false;
			
			}); 

			jQuery("#marginFields\\.geoId").change(function() 
	    	{
	    	 
			  	jQuery("#errorMessagesDv").html("");
					 
				return false;
			  
			});
			
		
	});
</script>
<div class="body" id="dvMargin">
	<div> 
		<div id="errorMessagesDv">
			<g:if test="${errorMessage}">
				<div class="errors">
					 ${errorMessage}
				</div>
			</g:if>
		</div>
		
			
		<g:form name="marginCalculateFrm">
			<g:hiddenField name="profileId" value="${serviceProfileInstance.id}"/>
			<label for="geo">Select <g:message code="quotation.geo.label" default="Territory" /></label>
			<g:select name="marginFields.geoId" from="${Geo.list()?.sort {it.name}}" optionKey="id" value="${marginFields?.geoId}" />
			<label for="geo">Total Units</label>
			<g:textField name="marginFields.units" value="${marginFields?.units}" class="required number"></g:textField>
			
			<input id="calculateMargin" type="button" value="Calculate Margin" title="Calculate Margin" class="button"/>
		</g:form>
	</div>
	
	<g:if test="${marginMap}">
	
		<div class="list"> 
		    <table>
		        <thead>
		            <tr>
		                <th> Role </th>
						<th> Cost </th>
						<th> Rate </th>
						<th> Uplift </th>
						<th> Margin % </th>   
		            </tr>
		        </thead>
		        <tfoot>
				    <tr>
				      <th>Total</th>
				      <td>${marginMap["totalCost"]}</td>
				      <td>${marginMap["totalRate"]}</td>
				      <td>${marginMap["totalUplift"]}</td>
				      <td>${marginMap["totalMargin"]}</td>
				    </tr>
				    <tr>
				    	<td colspan="5">Total Price <b> <u> ${marginMap["finalPrice"]} ${marginMap["currency"]} </u></b> after adding Premium Percent ${marginMap["premiumPercent"]}% </td>
				    </tr>
				</tfoot>
		        <tbody>
		      <g:set var="rolesMap" value="${marginMap['roles']}"/>
		      <g:each in="${rolesMap.keySet()}" status="i" var="roleName">
		            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		                <td>${roleName}</td>
		                <td> ${rolesMap.get(roleName)["totalCost"]} </td>
		                <td> ${rolesMap.get(roleName)["totalRate"]} </td>
		                <td> ${rolesMap.get(roleName)["uplift"]} </td>
		                <td> <g:formatNumber number="${rolesMap.get(roleName)['margin']}" type="number" maxFractionDigits="2" roundingMode="HALF_DOWN" /> </td>
		            </tr>
		        </g:each>     
		        </tbody>
		    </table>
		</div>
	</g:if>
	<g:else>
		<p style="font-size: 1%"> Select GEO and add units to calculate margin </p>
	</g:else>
</div>