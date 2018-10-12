<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>

							  
	<table> 
		<tr> 
			<td> 
				<b>  My Leads </b> 
			</td> 
		</tr> 
		<tr> 
			<td>     		
 				<ul id="plain">
 					<li class="navigation_first"><a href="${baseurl}/lead/pending" title="Pending Leads">Pending Leads</a></li>
 					<li><a href="${baseurl}/lead/converted" title="Converted Leads">Converted Leads</a></li>	
 				</ul>		 
			</td> 
		</tr> 
	</table> 