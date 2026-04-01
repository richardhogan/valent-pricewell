<%
	def baseurl = request.siteUrl
%>
<html>
<head>
<style>
	.geo-section {
		margin-bottom: 28px;
		border: 1px solid #C0C0C0;
		padding: 12px 16px;
		background: #FAFAFA;
	}
	.geo-section h2 {
		font-family: Georgia, Times, serif;
		font-size: 16px;
		font-weight: bold;
		margin: 0 0 10px 0;
		color: #333;
		border-bottom: 2px solid #888;
		padding-bottom: 4px;
	}
	.territory-section {
		margin: 10px 0 10px 20px;
		border-left: 3px solid #C0C0C0;
		padding-left: 12px;
	}
	.territory-section h4 {
		font-family: Georgia, Times, serif;
		font-size: 14px;
		font-weight: bold;
		margin: 6px 0 4px 0;
		color: #444;
	}
	.role-label {
		font-family: Georgia, Times, serif;
		font-size: 13px;
		font-weight: bold;
		color: #555;
		margin: 8px 0 4px 0;
		display: block;
	}
	.assign-table {
		font-family: Georgia, Times, serif;
		font-size: 13px;
		border-collapse: collapse;
		width: 100%;
		max-width: 720px;
		margin-bottom: 4px;
	}
	.assign-table th {
		background: #E8E8E8;
		border: 1px solid #D0D0D0;
		padding: 4px 10px;
		text-align: left;
	}
	.assign-table td {
		border: 1px solid #E0E0E0;
		padding: 4px 10px;
		vertical-align: middle;
	}
	.assign-table tr:nth-child(even) td {
		background: #F5F5F5;
	}
	.none-assigned {
		font-family: Georgia, Times, serif;
		font-size: 13px;
		color: #999;
		font-style: italic;
		margin: 2px 0 6px 0;
	}
	.edit-link {
		color: #1874CD;
		text-decoration: underline;
		cursor: pointer;
	}
	.unassigned-section {
		margin-bottom: 20px;
		border: 1px solid #F0A0A0;
		padding: 12px 16px;
		background: #FFF8F8;
	}
	.unassigned-section h2 {
		font-family: Georgia, Times, serif;
		font-size: 15px;
		font-weight: bold;
		color: #A00;
		margin: 0 0 8px 0;
	}
</style>
<script>
	var baseurl = "${baseurl}";

	function refreshGeoGroupList() {
		refreshNavigation();
		jQuery.ajax({
			type: "POST",
			url: baseurl + "/userSetup/geoassignmentsetup",
			success: function(data) {
				jQuery('#contents').html(data);
			},
			error: function() {}
		});
	}

	function editGeoUser(userId, roleId) {
		jQuery("#userDialog").html('<p style="font-family:Georgia,Times,serif;font-size:14px;padding:20px;">Loading, please wait...</p>');
		jQuery("#userDialog").dialog("option", "title", "Edit User");
		jQuery("#userDialog").dialog("open");
		jQuery.ajax({
			type: "POST",
			url: baseurl + "/userSetup/editsetup",
			data: {id: userId, source: "geoassignment", roleId: roleId},
			success: function(data) {
				jQuery("#userDialog").html(data);
			},
			error: function() {}
		});
	}

	jQuery(document).ready(function() {
		jQuery("#userDialog").dialog({
			autoOpen: false,
			position: { my: "center", at: "center", of: window },
			modal: true,
			width: 620,
			maxHeight: 700,
			close: function(event, ui) { jQuery(this).html(''); }
		});

		jQuery(".resultDialog").dialog({
			modal: true,
			autoOpen: false,
			resizable: false,
			close: function(event, ui) { jQuery(this).html(''); },
			buttons: {
				OK: function() {
					jQuery(".resultDialog").dialog("close");
					refreshGeoGroupList();
					return false;
				}
			}
		});

		jQuery(".geo-edit-btn").click(function() {
			editGeoUser(jQuery(this).data('userid'), jQuery(this).data('roleid'));
			return false;
		});
	});
</script>
</head>
<body>

<g:each in="${geoGroups}" var="geoGroup">
<div class="geo-section">
	<h2>${geoGroup.name?.encodeAsHTML()}<g:if test="${geoGroup.description}"> &mdash; <span style="font-weight:normal;font-size:13px;">${geoGroup.description?.encodeAsHTML()}</span></g:if></h2>

	<%-- General Managers --%>
	<span class="role-label">General Managers</span>
	<g:if test="${geoGroup.generalManagers}">
		<table class="assign-table">
			<thead><tr><th>Name</th><th>Email</th><th>Primary Territory</th><th></th></tr></thead>
			<tbody>
			<g:each in="${geoGroup.generalManagers?.sort { it.profile?.fullName }}" var="gm">
				<tr>
					<td>${gm.profile?.fullName?.encodeAsHTML()}</td>
					<td>${gm.profile?.email?.encodeAsHTML()}</td>
					<td>${gm.primaryTerritory?.name?.encodeAsHTML() ?: '—'}</td>
					<td><a href="#" class="edit-link geo-edit-btn" data-userid="${gm.id}" data-roleid="${gmRole?.id}">Edit</a></td>
				</tr>
			</g:each>
			</tbody>
		</table>
	</g:if>
	<g:else>
		<p class="none-assigned">No General Managers assigned to this GEO group</p>
	</g:else>

	<%-- Territories --%>
	<span class="role-label" style="margin-top:14px;">Territories</span>
	<g:if test="${geoGroup.geos}">
		<g:each in="${geoGroup.geos?.sort { it.name }}" var="geo">
		<div class="territory-section">
			<h4>${geo.name?.encodeAsHTML()}</h4>

			<%-- Sales Manager --%>
			<span class="role-label" style="font-size:12px;">Sales Manager</span>
			<g:if test="${geo.salesManager}">
				<table class="assign-table" style="max-width:640px;">
					<thead><tr><th>Name</th><th>Email</th><th>Territories</th><th></th></tr></thead>
					<tbody>
					<tr>
						<td>${geo.salesManager.profile?.fullName?.encodeAsHTML()}</td>
						<td>${geo.salesManager.profile?.email?.encodeAsHTML()}</td>
						<td>
							<g:each in="${geo.salesManager.territories?.sort { it.name }}" var="t" status="ti">
								<g:if test="${t.id == geo.salesManager.primaryTerritory?.id}"><strong>${t.name?.encodeAsHTML()}</strong></g:if>
								<g:else>${t.name?.encodeAsHTML()}</g:else>
								<g:if test="${ti < (geo.salesManager.territories?.size() ?: 0) - 1}">, </g:if>
							</g:each>
						</td>
						<td><a href="#" class="edit-link geo-edit-btn" data-userid="${geo.salesManager.id}" data-roleid="${smRole?.id}">Edit</a></td>
					</tr>
					</tbody>
				</table>
			</g:if>
			<g:else>
				<p class="none-assigned">No Sales Manager assigned</p>
			</g:else>

			<%-- Sales Persons --%>
			<span class="role-label" style="font-size:12px;">Sales Persons</span>
			<g:if test="${geo.salesPersons}">
				<table class="assign-table" style="max-width:640px;">
					<thead><tr><th>Name</th><th>Email</th><th>Territory</th><th></th></tr></thead>
					<tbody>
					<g:each in="${geo.salesPersons?.sort { it.profile?.fullName }}" var="sp">
						<tr>
							<td>${sp.profile?.fullName?.encodeAsHTML()}</td>
							<td>${sp.profile?.email?.encodeAsHTML()}</td>
							<td>${sp.territory?.name?.encodeAsHTML() ?: sp.primaryTerritory?.name?.encodeAsHTML() ?: '—'}</td>
							<td><a href="#" class="edit-link geo-edit-btn" data-userid="${sp.id}" data-roleid="${spRole?.id}">Edit</a></td>
						</tr>
					</g:each>
					</tbody>
				</table>
			</g:if>
			<g:else>
				<p class="none-assigned">No Sales Persons assigned</p>
			</g:else>
		</div>
		</g:each>
	</g:if>
	<g:else>
		<p class="none-assigned">No territories in this GEO group</p>
	</g:else>
</div>
</g:each>

<%-- Unassigned GMs --%>
<g:if test="${unassignedGMs}">
<div class="unassigned-section">
	<h2>General Managers — No GEO Group Assigned</h2>
	<table class="assign-table" style="max-width:640px;">
		<thead><tr><th>Name</th><th>Email</th><th></th></tr></thead>
		<tbody>
		<g:each in="${unassignedGMs?.sort { it.profile?.fullName }}" var="gm">
			<tr>
				<td>${gm.profile?.fullName?.encodeAsHTML()}</td>
				<td>${gm.profile?.email?.encodeAsHTML()}</td>
				<td><a href="#" class="edit-link geo-edit-btn" data-userid="${gm.id}" data-roleid="${gmRole?.id}">Assign GEO</a></td>
			</tr>
		</g:each>
		</tbody>
	</table>
</div>
</g:if>

<%-- Unassigned Territories --%>
<g:if test="${unassignedGeos}">
<div class="unassigned-section">
	<h2>Territories — No GEO Group Assigned</h2>
	<table class="assign-table" style="max-width:640px;">
		<thead><tr><th>Territory</th><th>Sales Manager</th><th>Sales Persons</th></tr></thead>
		<tbody>
		<g:each in="${unassignedGeos?.sort { it.name }}" var="geo">
			<tr>
				<td>${geo.name?.encodeAsHTML()}</td>
				<td>
					<g:if test="${geo.salesManager}">
						<a href="#" class="edit-link geo-edit-btn" data-userid="${geo.salesManager.id}" data-roleid="${smRole?.id}">${geo.salesManager.profile?.fullName?.encodeAsHTML()}</a>
					</g:if>
					<g:else><span class="none-assigned">—</span></g:else>
				</td>
				<td>${geo.salesPersons?.size() ?: 0} assigned</td>
			</tr>
		</g:each>
		</tbody>
	</table>
</div>
</g:if>

<div id="userDialog" title=""></div>
<div class="resultDialog"></div>

</body>
</html>
