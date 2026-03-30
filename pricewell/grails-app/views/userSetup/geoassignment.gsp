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

	function refreshGeoGroupList(){
		jQuery.ajax({
			type: "POST",
			url: "${baseurl}/userSetup/geoassignmentview",
			success: function(data) {
				jQuery('#contents').html(data);
				initResultDialog();
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {}
		});
	}

	function initResultDialog(){
		jQuery(".resultDialog").dialog({
			modal: true,
			autoOpen: false,
			resizable: false,
			close: function(event, ui){ jQuery(this).html(''); },
			buttons: {
				OK: function(){
					jQuery(".resultDialog").dialog("close");
					refreshGeoGroupList();
					return false;
				}
			}
		});
	}

	jQuery(document).ready(function() {

		jQuery("#userDialog").dialog({
			autoOpen: false,
			position: { my: "center", at: "center", of: window },
			modal: true,
			close: function(event, ui){ jQuery(this).html(''); }
		});

		initResultDialog();

		refreshGeoGroupList();
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

	<div id="userDialog" title=""></div>
	<div class="resultDialog"></div>
</body>
</html>
