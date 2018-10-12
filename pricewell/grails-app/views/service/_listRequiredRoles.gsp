<%@ page import="com.valent.pricewell.ServiceProfile" %>
<div class="body">
	<div class="list"> 
	    <table>
	        <thead>
	            <tr>
	                <th> Role </th>
					<th> Base Hrs </th>
					<th> Add. Hrs Per Unit</th>
					<th> Details </th>   
	            </tr>
	        </thead>
	        <tbody>
	        
	        <g:set var="rolesMap" value="${serviceProfileInstance.listRolesRequiredTable()}"/>
	        
	        <% BigDecimal totalFlat = new BigDecimal(0) 
			
			for(key in rolesMap.keySet())
			{
				totalFlat += (rolesMap[key]["totalFlat"]?:0)
			}
			
			totalFlat = totalFlat.setScale(2, BigDecimal.ROUND_HALF_EVEN)
			
			BigDecimal totalExtra = new BigDecimal(0)
			
			for(key in rolesMap.keySet())
			{
				totalExtra += (rolesMap[key]["totalExtra"]?:0)
			}
			
			totalExtra = totalExtra.setScale(2, BigDecimal.ROUND_HALF_EVEN)
			%>
			
	        <g:each in="${rolesMap.keySet()}" status="i" var="roleName">
	            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                <td>${roleName}</td>
	                <td> ${rolesMap.get(roleName)["totalFlat"]} </td>
	                <td> ${rolesMap.get(roleName)["totalExtra"]} </td>
	                <td>  
                		<table>
                			<tr>
                				<th> Deliverable</th>
                				<th> Activity</th>
                				<th> Est Hrs</th>
                				<th> Additional Hrs</th>
                			</tr>
                			<g:each in="${rolesMap.get(roleName)['activities']}"  var="detail" status="j">
                				<tr>
                					<td> 
                						${rolesMap.get(roleName)['deliverables'][j]}
                					</td>
                					<td> 
                						${rolesMap.get(roleName)['activities'][j]}
                					</td>		
                					<td> 
                						${rolesMap.get(roleName)['flat'][j]}
                					</td>
                					<td> 
                						${rolesMap.get(roleName)['extra'][j]}
                					</td> 
                				</tr>
                				</g:each>
                			</table>	
	                </td>
	            </tr>
	        </g:each>
	        <tr>
	        	<th> Total Time in Hrs </th>
	        	<td> <%=totalFlat %> </td>
	        	<td> <%=totalExtra %> </td>
	        	<td> </td>
	        </tr>
	        </tbody>
	    </table>
	</div>
</div>