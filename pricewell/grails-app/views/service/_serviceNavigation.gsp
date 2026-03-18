<%@ page import="com.valent.pricewell.PricewellSecurity"%>
<%
	def baseurl = request.siteUrl
%>
							  
 		<table> 
 			
 			<g:if test="${PricewellSecurity.hasRole('PORTFOLIO MANAGER') || PricewellSecurity.hasRole('PRODUCT MANAGER') || PricewellSecurity.hasRole('SERVICE DESIGNER') || PricewellSecurity.hasRole('DELIVERY ROLE MANAGER') }">
    			<tr> 
    				<td> 
    					<b>  My Services </b> 
    				</td> 
    			</tr> 
    			<tr> <td>     		
	 				<ul id="plain">
	 					
	 					<li class="navigation_first"><a href="${baseurl}/service/catalog" title="My Published Services">My Published Services</a></li>
	 					<li><a href="${baseurl}/service/inStaging" title="My Services In Development">In Development</a></li>	
	 					
	 					<li><a href="${baseurl}/service/endOfLife" title="Archive Services">Archive</a></li>
	 					<li class="navigation_first"><a href="${baseurl}/service/pricelist" title="Service Pricelist">Pricelist</a></li>
	 				<!--  	
	 					<li><a href="${baseurl}/service/currentlyAvailable">My Published </a></li>
	 					
	 					<li><a href="${baseurl}/service/search">Search</a></li>
 					 -->
	 					
	 				</ul>		 
	 				</td> 
	 			</tr> 
	 		</g:if>
 			
 			<tr>
 				<td>
 					<b> All Services <b>
 				</td>
 			</tr>
 			<tr>
 				<td>
 					<g:if test="${PricewellSecurity.hasRole('SYSTEM ADMINISTRATOR') || PricewellSecurity.hasRole('PORTFOLIO MANAGER') || PricewellSecurity.hasRole('PRODUCT MANAGER') || PricewellSecurity.hasRole('SERVICE DESIGNER') || PricewellSecurity.hasRole('DELIVERY ROLE MANAGER') || (!PricewellSecurity.hasRole('GENERAL MANAGER') && !PricewellSecurity.hasRole('SALES PRESIDENT') && !PricewellSecurity.hasRole('SALES MANAGER') && !PricewellSecurity.hasRole('SALES PERSON'))}">
 						<ul id="plain">
	 						<li><a href="${baseurl}/service/allInCatalog" title="Published Services">Published Services</a></li>
	 						<li><a href="${baseurl}/service/allInStaging" title="In Development Services">In Development</a></li>
	 						
	 						<li><a href="${baseurl}/service/allInEndOfLife" title="Archive Services">Archive</a></li>
	 						<li><a href="${baseurl}/service/pricelist" title="Service Pricelist">Pricelist</a></li>
	 						<li><a href="${baseurl}/solutionBundle/list" title="Solution Bundles">Solution Bundles</a></li>
 						</ul>
 					</g:if>
 					<g:else>
 						<ul id="plain">
	 						<li><a href="${baseurl}/service/allInCatalog" title="Published Services">Published Services</a></li>
	 						<!-- <li><a href="${baseurl}/service/pricelist" title="Service Pricelist">Pricelist</a></li>-->
 						</ul>
 					</g:else>
 					
 				</td>
 			</tr>
 		</table> 