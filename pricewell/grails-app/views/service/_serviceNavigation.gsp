<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
							  
 		<table> 
 			
 			<g:if test="${SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') || SecurityUtils.subject.hasRole('PRODUCT MANAGER') || SecurityUtils.subject.hasRole('SERVICE DESIGNER') || SecurityUtils.subject.hasRole('DELIVERY ROLE MANAGER') }">
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
 					<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR') || SecurityUtils.subject.hasRole('PORTFOLIO MANAGER') || SecurityUtils.subject.hasRole('PRODUCT MANAGER') || SecurityUtils.subject.hasRole('SERVICE DESIGNER') || SecurityUtils.subject.hasRole('DELIVERY ROLE MANAGER') || (!SecurityUtils.subject.hasRole('GENERAL MANAGER') && !SecurityUtils.subject.hasRole('SALES PRESIDENT') && !SecurityUtils.subject.hasRole('SALES MANAGER') && !SecurityUtils.subject.hasRole('SALES PERSON'))}">
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