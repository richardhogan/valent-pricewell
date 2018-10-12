


<g:if test="${roleInstance.name=='SYSTEM ADMINISTRATOR'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b>What is "SYSTEM ADMINISTRATOR" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		Administrator is a role reserved for those users with un-restricted authority to globally configure and operate all capabilities of the Valent SLM solution. By default the admin user is configured as the only user with the Administrator role.
	</p>
		
</g:if>
<g:elseif test="${roleInstance.name=='PORTFOLIO MANAGER'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "PORTFOLIO MANAGER" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		Portfolio Manager is a role assigned to users that will have authority and responsibility for managing a collection of related service offerings, referred to as a service portfolio. A portfolio is a division of a service catalog. Portfolio Managers are responsible for defining and tentatively naming new service concepts and ideas. Portfolio Managers will also assign concepts to services Product Managers for development.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='PRODUCT MANAGER'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "PRODUCT MANAGER" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		Product Manager is a role assigned to users that are responsible for defining the customer Deliverables and the associated service specific Scoping Language that will be used when an SOW is generated that includes the service offering. Product Manager's document and forecast market opportunities and document and validate requirements for service offerings. Product Managers will also select an appropriate Service Designer to fill in details such as the work breakdown structure for the service offering.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='SERVICE DESIGNER'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "SERVICE DESIGNER" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		The Service Designer role is assigned to users with the responsibility for creating the work breakdown structure for a service, including the required Delivery Roles and the amount of time required from each of them in order to create all of the Deliverables that have been specified by the Product Manager for the service offering.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='GENERAL MANAGER'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "GENERAL MANAGER" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		The General Manager role is assigned to Executive Sales Leaders with broad responsibility for a significant Geography that typically spans a number of countries or territories. The General Manager reports to a global Sales President in the Valent SLM model and will have one or more Sales Managers and or Sales Representatives assigned to his leadership.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='SALES PRESIDENT'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "SALES PRESIDENT" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		The Sales President is a role assigned to one or more users that hold worldwide responsibility for all sales of solutions quoted and contracted using Valent SLM. Sales Presidents are responsible for determining the high level division of the world into one or more Sales Geography and assigning a General Manager responsibility for it. Sales President's will see a global roll-up of all dashboard metrics and all currency based metrics will be normalized using the configured global currency.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='SALES MANAGER'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "SALES MANAGER" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		The Sales Manager role is assigned to users that are responsible for one or more sales regions and the sales representatives (Sales Person) that report to him or her.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='SALES PERSON'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "SALES PERSON" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		The Sales Person role is assigned to services sales representatives that speak directly with customer contacts to gather requirements and develop and sell proposals including services quotes and contracts.
	</p>
</g:elseif>
<g:elseif test="${roleInstance.name=='DELIVERY ROLE MANAGER'}">
	<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b> What is "DELIVERY ROLE MANAGER" Role?</b></h1></br>
	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">
		Delivery Role Manager is a role assigned to users that have authority and responsibility to create, modify and delete periodic (hourly, daily) costs and rates for Delivery Roles in their assigned Geo or Territory.	
	</p>
</g:elseif>
