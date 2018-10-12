<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<style>
a.menu {
	font-weight: bold;
	font-size: 150%
}

a.submenu {
	font-weight: bold;
	font-size: 100%
}

div.menu {
	width: 160px;
	text-align: left;
	padding: 5px;
	border: 1px solid #A7A0B8;
	background: #FEFDFF
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<title>Product Manager Home page</title>
</head>
<body bgcolor="#FFFFFF" text="#000000" link="#000000" vlink="#333333"
	alink="#666666" leftmargin="8" topmargin="5" marginwidth="8"
	marginheight="8">
<g:render template="adminNavigation" />
	<center>
		<table height=100%>
			<tr>
				<td>
					<div class="menu">
						<a class="menu" href="<g:createLink controller='admins'/>">Administration</a>
						<hr>
						<p>Manage roles, users and permissions</p>
						<ul>
							<li><a class="submenu"
								href="<g:createLink controller='role'/>">Manage Roles</a></li>
							<li><a class="submenu"
								href="<g:createLink controller='user'/>">Manage Users</a></li>
						</ul>
						<br/>
					</div></td>
				<td>
					<div class="menu">
						<a class="menu" href="<g:createLink controller='deliveryRole'/>">Delivery
							Roles</a>
						<hr>
						<ul>
							<li><a class="submenu"
								href="<g:createLink controller='deliveryRole'/>">Manage Delivery Roles, rate card and cost card</a></li>
							<li><a class="submenu"
								href="<g:createLink controller='geo'/>">Manage GEOs</a></li>
						</ul>		
						
						<br/>
						<br/>
					</div></td>
				<td>
					<div class="menu">
						<a class="menu" href="<g:createLink controller='portfolio'/>">Portfolio</a>
						<hr>
						<p>Manage Portfolios</p>
						<ul>
							<li><a class="submenu"
								href="<g:createLink controller='portfolio' action='create'/>">Define new portfolio </a></li>
							<li><a class="submenu"
								href="<g:createLink controller='portfolio' action='list'/>">List existing portfolios </a></li>
						</ul>
						
						<br/>
						<br/>
						
					</div></td>
				<td>
					<div class="menu">
						<a class="menu" href="<g:createLink controller='service'/>">Service</a>
						<hr>
						<ul>
							<li><a class="submenu"
								href="<g:createLink controller='service' action='myServices'/>">Manage Services</a></li>
							<li><a class="submenu"
								href="<g:createLink controller='service' action='searchServices'/>">Search Services</a></li>
							<li><a class="submenu"
								href="<g:createLink controller='service' action='pricelist'/>">Generate Price list</a></li>	
						</ul>
						<br/>
						<br/>
						<br/>
					</div></td>
				<td>
					<div class="menu">
						<a class="menu" href="<g:createLink controller='reviewRequest'/>">Review Requests</a>
						<hr>
						<p>Create and review requests for approval </p>
						<ul>
							<li><a class="submenu"
								href="<g:createLink controller='reviewRequest' action='myAssigned'/>">My Assigned</a></li>
							<li><a class="submenu"
								href="<g:createLink controller='reviewRequest' action='mySubmitted'/>">My Submitted</a></li>
							<li><a class="submenu"
								href="<g:createLink controller='reviewRequest' action='all'/>">All Requests</a></li>
						</ul>
						
					</div></td>
				<td>
					<div class="menu">
						<a class="menu" href="<g:createLink controller='reports'/>">Reports</a>
						<hr>
						<ul>
							<li> <a class="submenu"
								href="<g:createLink controller='reports' action="statusOfQuotes"/>"> Status of Quotes </a> </li>
							<li><a class="submenu"
								href="/pricewell/reports/totalunitssoldsample.gsp">Total Units sold per Service</a></li>
							<li><a class="submenu"
								href="/pricewell/reports/profitmarginsample.gsp">Profit Margins </a></li>
							<li><a class="submenu"
								href="/pricewell/reports/designestimatesample.gsp">Service Designers' Estimates</a></li>														
						</ul>
						
					</div></td>
			</tr>
		</table>
		
	</center>
</body>
</html>

