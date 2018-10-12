<meta charset="utf-8">
	
	<%
	
		BigDecimal percent = (value / total) * 100
		percent = percent.setScale(0, BigDecimal.ROUND_HALF_EVEN);
		def genId = "list-" + id + "-fv";
		 
	 %>
	
	<script>
		jQuery(document).ready(function()
		{

			jQuery( "#${genId}" ).progressbar({
		      	value: ${percent}
		    });
			//jQuery( "#${genId}" ).progressbar( "option", "value", ${percent} );
			
			//jQuery( ".progressbar" ).progressbar( "option", "value", 0 );
		      /*jQuery('#<%=genId%>').qtip({
		         content: "<%=value%> / <%=total%> <%=currency%>" , // Use the tooltip attribute of the element for the content
		         style: 'dark', // Give it a crea mstyle to make it stand out
		        	 
		               position: {
		                  corner: {
		                      // Use the corner...
		                     target: 'bottomLeft' // ...and opposite corner
		                  }
		               }
		      });*/
			
		});
	</script>

<table style="margin:0;padding:0;">
	<tr>
		<td style="width:100px;">
			<div id="${genId}" class="progressbar" style="height: 1em" title="${value} / ${total} ${currency}"> </div>
		</td>
		<td style="float: left; width: 20%"> 
			${percent}%
		</td>
	</tr>
</table> 

