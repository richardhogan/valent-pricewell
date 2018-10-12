<meta charset="utf-8">
	
	<%
		def genId = "list-" + quotationInstance.id + "-cp";
		def value = new BigDecimal(quotationInstance.confidencePercentage);
		value = value.setScale(0, BigDecimal.ROUND_HALF_EVEN); 
		
	 %>
	
	<script>
	jQuery(function() {
		jQuery( "#<%=genId%>" ).progressbar({
			value: <%=value%>
		});
	});
	</script>


<div id="<%=genId%>" style="height: 0.5em;"></div>${value}%

