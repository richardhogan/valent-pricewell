<%
	def baseurl = request.siteUrl
%>
	
	<script type="text/javascript">
   		
		function showList(action)
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/reviewRequest/"+action,
				data: {'type': 'Pending'},
				success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}

	</script>
	
	  		
<ul class="navigation" id="plain">
	<li class="navigation_first">
		<a id="idMyAssignedList" onclick="showList('myAssigned');" class="hyperlink" title="Assigned Review Requests">My Assigned</a>
	</li>
	
	<li>
		<a id="idMySubmittedList" onclick="showList('mySubmitted');" class="hyperlink" title="Submitted Review Requests">My Submitted</a>
	</li>
	
	<li class="navigation_last">
		<a id="idAllRequest" onclick="showList('all');" class="hyperlink" title="All Review Requests">All</a>
	</li>
</ul>		 

