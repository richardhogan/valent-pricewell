<%@ page import="com.valent.pricewell.Service"%>
<%
	def baseurl = request.siteUrl
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<script>

	function refreshNavigation(){
		// no-op: GEO assignment page has no sidebar nav to refresh
	}

	jQuery(document).ready(function() {
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/userSetup/listgeoassignmentroles",
			data: {source: "geoassignment"},
			success: function(data) {
				jQuery('#contents').html(data);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {}
		});
	});

</script>
</head>
<body>
	<div class="body">
		<h1>Assign GEOs to Users</h1>
		<hr />
		<div id="contents">
			<p>Loading...</p>
		</div>
	</div>
</body>
</html>
