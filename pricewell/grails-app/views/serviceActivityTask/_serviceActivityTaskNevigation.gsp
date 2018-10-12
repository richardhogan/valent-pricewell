<%@ page import="com.valent.pricewell.ServiceActivityTask"%>
<%
	def baseurl = request.siteUrl
%>

<script>
	jQuery(document).ready(function()
	{
		jQuery( "#dvAddActivityTask" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			height: 200,
			width: 500,
			close: function( event, ui ) {
				jQuery(this).html('');
			}
			
		});
		
		jQuery('#addTask').click(function() 
		{
			alert(1);
			jQuery( "#dvAddActivityTask" ).dialog( "open" );
			jQuery.ajax(
			{
				type:'POST',
			 	url:'${baseurl}/serviceActivityTask/createFromServiceActivity',
			 	success:function(data,textStatus)
			 		{jQuery('#dvAddActivityTask').html(data);},
			 	error:function(XMLHttpRequest,textStatus,errorThrown)
			 		{}
			});
			return false;
		}); 
	});
			
</script>



<div>
	<input id="addTask" title="Add Service Activity Task" type="button" value="Add Task"/>
	
	
	<div id="dvAddActivityTask" title="Add Service Task"></div>
</div>