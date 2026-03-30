<%@ page import="com.valent.pricewell.SalesController"%>
<%
	def baseurl = request.siteUrl
	// currentRole is set by HomeController.updaterole / changerole via session DEFAULTUSERROLE
	def currentRole = session.getAttribute('DEFAULTUSERROLE')?.value() ?: ""
%>
<html>


	<ul id="nav-one" class="dropmenu">
		<li><a href="${baseurl}/home">Home</a></li>
		<li><a href="${baseurl}/reviewRequest">Inbox</a></li>

		<g:if test="${currentRole == 'SYSTEM ADMINISTRATOR' || currentRole == 'SALES PRESIDENT'}">
			<li id="menu-item-geo"><a href="${baseurl}/userSetup/geoassignment">Assign GEOs</a></li>
		</g:if>
		<g:if test="${currentRole == 'SYSTEM ADMINISTRATOR' || currentRole == 'PORTFOLIO MANAGER' || currentRole == 'PRODUCT MANAGER' || currentRole == 'SALES PRESIDENT' || currentRole == 'GENERAL MANAGER' || currentRole == 'SALES MANAGER'}">
			<li id="menu-item-1"><a href="${baseurl}/setup/firstsetup">Setup</a>
			</li>
		</g:if>
		<g:elseif test="${currentRole == 'DELIVERY ROLE MANAGER'}">
			<li id="menu-item-1">
				<a href="${baseurl}/deliveryRole">Delivery Roles</a>
			</li>
		</g:elseif>

		<g:if test="${currentRole == 'GENERAL MANAGER' || currentRole == 'SALES PRESIDENT' || currentRole == 'SALES MANAGER' || currentRole == 'SALES PERSON'}">
			<li id="menu-item-3"><a href="${baseurl}/service">Services</a></li>
		</g:if>
		<g:else>

			<g:if test="${currentRole == 'SYSTEM ADMINISTRATOR' || currentRole == 'PORTFOLIO MANAGER' || currentRole == 'SERVICE DESIGNER'}">
				<li id="menu-item-1"><a href="${baseurl}/portfolio/list">Portfolios</a></li>
			</g:if>

			<li id="menu-item-3"><a href="#">Catalogs</a>
				<ul>
					<li id="menu-item-1"><a href="${baseurl}/product">Products</a></li>
					<li id="menu-item-1"><a href="${baseurl}/service">Services</a></li>
				</ul>
			</li>

		</g:else>

		<g:if test="${currentRole == 'GENERAL MANAGER' || currentRole == 'SALES PERSON' || currentRole == 'SYSTEM ADMINISTRATOR' || currentRole == 'SALES PRESIDENT' || currentRole == 'SALES MANAGER'}">
			<li id="menu-item-4"><a href="#">Sales</a>
				<ul>
					<li><a href="${baseurl}/lead/list">Leads</a></li>
					<li><a href="${baseurl}/contact/list">Contacts</a></li>
					<li><a href="${baseurl}/account/list">Accounts</a></li>
					<li><a href="${baseurl}/opportunity/list">Opportunities</a></li>

					<g:if test="${grailsApplication.allClasses.any { it.name == "com.connectwise.integration.ConnectwiseExporterService" } }">
						<li><a href="${baseurl}/serviceQuotationTicket/list">Service Ticket</a></li>
					</g:if>
				</ul>
			</li>
		</g:if>
	</ul>

</html>
