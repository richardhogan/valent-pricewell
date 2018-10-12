<%@ page import="com.valent.pricewell.ServiceProfile" %>
<div class="body" id="dvMargin">
	<div> 
		<g:form>
			<g:hiddenField name="profileId" value="${serviceProfileInstance.id}"/>
			<label for="geo">Select <g:message code="quotation.geo.label" default="Geo" /></label>
			<g:select name="marginFields.geoId" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${marginFields?.geoId}" />
			<label for="geo">Total Units</label>
			<g:textField name="marginFields.units" value="${marginFields?.units}"></g:textField>
			<g:submitToRemote name="calculateMargin" value="Calcualte Margin" controller="serviceProfile" action="calculateMargin" update="dvMargin"/>
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
		<p> Select GEO and add units to calculate margin </p>
	</g:else>
</div>