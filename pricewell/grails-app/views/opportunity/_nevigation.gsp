<%
	def baseurl = request.siteUrl
%>
<ul id="plain">
	 					
			<li class="navigation_first">
				<a href="${baseurl}/opportunity/pendingOpportunity" title="My Pending Opportunity">Pending</a>
			</li>
			
			<li>
				<a href="${baseurl}/opportunity/closedWonOpportunity" title="My Won Opportunity">Won</a>
			</li>	
			
			<li>
				<a href="${baseurl}/opportunity/closedLostOpportunity" title="My Lost Opportunity">Lost</a>
			</li>
			
			
		</ul>