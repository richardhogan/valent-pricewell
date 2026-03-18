<%@ page import="com.valent.pricewell.PricewellSecurity"%>
<%@ page import="com.valent.pricewell.SalesController"%>
<%
	def baseurl = request.siteUrl
%>
<html> 


	<ul id="nav-one" class="dropmenu"> 
		<li><a href="${baseurl}/home">Home</a></li>
		<li><a href="${baseurl}/reviewRequest">Inbox</a></li>
<!--
		<g:if test="${PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR')}">
			
			<li><a href="${baseurl}/setup/firstsetup">Administration</a>
				
			</li>
		</g:if>	-->
		
		<g:if test="${PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR') || PricewellSecurity.hasRole('PORTFOLIO MANAGER') || PricewellSecurity.hasRole('PRODUCT MANAGER') || PricewellSecurity.hasRole('SALES PRESIDENT') || PricewellSecurity.hasRole('GENERAL MANAGER') || PricewellSecurity.hasRole('SALES MANAGER')}">
			<li id="menu-item-1"><a href="${baseurl}/setup/firstsetup">Setup</a>
				<!--
				<ul>
					<g:if test="${PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR')}">
						<li><a href="${baseurl}/companyInformation/index">Company Information</a></li>
					</g:if>	
					
					<g:if test="${!PricewellSecurity.hasRole('SALES MANAGER') }">
						<li><a href="${baseurl}/geoGroup">GEOs</a></li>
					</g:if>
					
					<li><a href="${baseurl}/geo">Territories</a></li>
					<g:if test="${!PricewellSecurity.hasRole('SALES PRESIDENT') && !PricewellSecurity.hasRole('GENERAL MANAGER') && !PricewellSecurity.hasRole('SALES MANAGER')}">
						<li><a href="${baseurl}/deliveryRole">Delivery Roles</a></li>
					</g:if>
				</ul> -->
			</li>
		</g:if>
		<g:elseif test="${PricewellSecurity.hasRole('DELIVERY ROLE MANAGER')}">
			<li id="menu-item-1">
				<a href="${baseurl}/deliveryRole">Delivery Roles</a>
			</li>
		</g:elseif>
		<!--
		<g:if test="${PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR')}">
			<li id="menu-item-2"><a href="#">Customizations</a>
				<ul>					
					<li><a href="${baseurl}/staging">Workflow settings</a></li>
					<li><a href="${baseurl}/setting/territorySettings">SOW Settings</a></li>
					<li><a href="${baseurl}/emailSetting/emailSetting">Email Settings</a></li>
				</ul>
			</li> -->
			
			
			<!-- <li id="menu-item-3"><a href="${baseurl}/setup/firstsetup">Administration</a>
				<ul>					
					<li><a href="${baseurl}/administration/users/list">Users</a></li>
					<li><a href="${baseurl}/administration/roles/list">Roles</a></li>
					<li><a href="${baseurl}/administration/groups/list">Groups</a></li>
					<li><a href="${baseurl}/administration/adminstrators">Administrators</a></li>
				</ul>
			</li>
		</g:if>	-->
			
		<g:if test="${!PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR') && !PricewellSecurity.hasRole('PORTFOLIO MANAGER') && !PricewellSecurity.hasRole('PRODUCT MANAGER') && !PricewellSecurity.hasRole('SERVICE DESIGNER') && !PricewellSecurity.hasRole('DELIVERY ROLE MANAGER') && (PricewellSecurity.hasRole('GENERAL MANAGER') || PricewellSecurity.hasRole('SALES PRESIDENT') || PricewellSecurity.hasRole('SALES MANAGER') || PricewellSecurity.hasRole('SALES PERSON'))}">
			<li id="menu-item-3"><a href="${baseurl}/service">Services</a></li>
		</g:if>
		<g:else>
		
			<g:if test="${!PricewellSecurity.hasRole('PRODUCT MANAGER') && !PricewellSecurity.hasRole('SERVICE DESIGNER') && !PricewellSecurity.hasRole('DELIVERY ROLE MANAGER')}">
				<li id="menu-item-1"><a href="${baseurl}/portfolio/list">Portfolios</a></li>
			</g:if>
			
			<li id="menu-item-3"><a href="#">Catalogs</a>
				<ul>					
					<li id="menu-item-1"><a href="${baseurl}/product">Products</a></li>
					<li id="menu-item-1"><a href="${baseurl}/service">Services</a></li>
				</ul>
			</li>
			
		</g:else>
		
		<g:if test="${PricewellSecurity.hasRole('GENERAL MANAGER') || PricewellSecurity.hasRole('SALES PERSON') || PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR') || PricewellSecurity.hasRole('SALES PRESIDENT') || PricewellSecurity.hasRole('SALES MANAGER')}">
			<li id="menu-item-4"><a href="#">Sales</a>
				<ul>
					<li><a href="${baseurl}/lead/list">Leads</a></li>
					<li><a href="${baseurl}/contact/list">Contacts</a></li>
					<li><a href="${baseurl}/account/list">Accounts</a></li>
					<li><a href="${baseurl}/opportunity/list">Opportunities</a></li>
					
					<g:if test="${new SalesController().isConnectwiseIncluded() }">
						<li><a href="${baseurl}/serviceQuotationTicket/list">Service Ticket</a></li>
					</g:if>
				</ul>
			</li>
		</g:if>
		<!--
		<g:if test="${PricewellSecurity.isPermitted('reports:show')}">
			<li><a href="${baseurl}/reports/statusOfQuotes">Reports</a></li>
		</g:if>		 -->
	</ul> 

</html>