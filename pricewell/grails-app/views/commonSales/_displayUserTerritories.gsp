<%
	def baseurl = request.siteUrl
%>
<script>
	  jQuery(document).ready(function()
	  {
		  jQuery("#territoryId").change(function() 
	    	{
	    	 
			  	jQuery.ajax({type:'POST',data: {id: this.value },
					 url:'${baseurl}/geo/getCurrencySymbol',
					 success:function(data,textStatus){jQuery('#currencySymbol').html(data);},
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
				jQuery.ajax({type:'POST',data: {id: this.value },
					 url:'${baseurl}/geo/getDateFormat',
					 success:function(data,textStatus)
					 {
					 	if(data != '' && data != null)
					 		{jQuery( "#closeDate" ).datepicker( "option", "dateFormat", data );}
					 	else
					 		{jQuery( "#closeDate" ).datepicker( "option", "dateFormat", "mm/dd/yy" );}
				 	 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					 
				return false;
			  
			});
	  });	
</script>


<g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="" class="required" noSelection="['': 'Select Any One']" />