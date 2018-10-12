
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%
	def baseurl = request.siteUrl
%>
<html>
    
        <div class="body">
            
            <!-- <div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div>Import Opportunities From Connectwise</div>
				</div>
			
				<div class="collapsibleContainerContent ui-widget-content">-->
					<div id="dvImportOpportunityContent">
						<g:if test="${lastUpdateRecord != null && lastUpdateRecord != 'NULL'}">
							<g:render template="importOpportunities" model="['lastUpdateRecord': lastUpdateRecord]"/>
						</g:if>
						<g:else>
							<g:render template="importOpportunitiesFirstTime" />
						</g:else>						
					</div>
				<!-- </div>
				
			</div>-->
        </div>
    <!-- </body> -->
</html>
