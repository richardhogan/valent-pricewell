<script>			 
	jQuery(document).ready(function()
	{
		jQuery( "#importBtn" ).click(function() 
		{
			//window.parent.closePP();
		});
	});
</script>
  		
<h1>${responseMessage }</h1>

<g:if test="${importedOpportunities.size() > 0 || existedOpportunities.size() > 0}">
	<hr/>
	<div class="list">
	    <table cellpadding="0" cellspacing="0" border="0" class="display">
	        <thead>
	            <tr>
	            	<th>Id</th>
	            	
	            	<th>Opportunity Name</th>
	            	
	            	<th>Status</th>
	            
	            </tr>
	        </thead>
	        <tbody>
		        <g:each in="${importedOpportunities}" status="i" var="opportunityInstance">
		            <tr>
		            
		                <td>${fieldValue(bean: opportunityInstance, field: "id")}</td>
		            
		                <td>${fieldValue(bean: opportunityInstance, field: "name")}</td>
		            
		                <td>Imported Successfully</td>
		            
		            </tr>
		        </g:each>
		        
		        <g:each in="${existedOpportunities}" status="j" var="eOpportunityInstance">
		            <tr>
		            
		                <td>${fieldValue(bean: eOpportunityInstance, field: "id")}</td>
		            
		                <td>${fieldValue(bean: eOpportunityInstance, field: "name")}</td>
		            
		                <td>Already Exist</td>
		            
		            </tr>
		        </g:each>
	        </tbody>
	    </table>
	</div>
</g:if>

<g:if test="${importedOpportunities?.size() > 0}">
	<hr/>
	<h2>
		Note : Notifications have been generated for all imported opportunities.
		
		<div class="buttons">
	        <!-- <span class="button"><button id="closeBtn" title="Close Window">Close</button></span> -->
	    </div>
	</h2>
</g:if>
