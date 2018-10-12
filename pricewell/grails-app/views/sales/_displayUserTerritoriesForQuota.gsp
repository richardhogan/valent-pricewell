<%
	def baseurl = request.siteUrl
%>
<script>
	  jQuery(document).ready(function()
	  {
		  	jQuery("#territoryId").change(function() 
	    	{
	    	 
			  	jQuery.ajax({type:'POST',data: {id: this.value },
					 url:'${baseurl}/geo/getCurrency',
					 success:function(data,textStatus){jQuery('#currency').val(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			  
			});
	  });	
</script>


<g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="" class="required" noSelection="['': 'Select Any One']" />