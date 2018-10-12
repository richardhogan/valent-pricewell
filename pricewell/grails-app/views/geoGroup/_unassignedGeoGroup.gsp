<div class="body">   
	             
	<div class="list">
	    <table class="display">
	        <thead>
	            <tr>
	            
	                <th>${message(code: 'geoGroup.name.label', default: 'Name')} </th>
                        
                    <th style="width: 60%;">${message(code: 'geoGroup.description.label', default: 'Description')}</th>
	            	
	            </tr>
	        </thead>
	        <tbody>
	         	<g:each in="${geoList}" status="i" var="geoGroupInstance">
					<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

						<td> ${fieldValue(bean: geoGroupInstance, field: "name")}</td>

						<td style="width: 60%;">${fieldValue(bean: geoGroupInstance, field: "description")}</td>

					</tr>
				</g:each>
	        </tbody>
	    </table>
	</div>
</div>