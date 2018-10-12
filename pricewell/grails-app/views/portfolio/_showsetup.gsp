
<%@ page import="com.valent.pricewell.Portfolio" %>
<%@ page import="com.valent.pricewell.TicketPlanner" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'portfolio.label', default: 'Portfolio')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
        <script>
	  		jQuery(document).ready(function()
			{
        		jQuery("#listPortfolio").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/portfolio/listsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	
        		jQuery("#listTicketPlanner").click(function()
        				{
        					showLoadingBox();
        					jQuery.ajax({
        						type: "POST",
        						url: "${baseurl}/ticketPlanner/list",
        						data: {source: "firstsetup",portfolioId: ${portfolioInstance.id}},
        						success: function(data){
        							hideLoadingBox();
        				          	jQuery('#contents').html('').html(data);
        						}, 
        						error:function(XMLHttpRequest,textStatus,errorThrown){}
        					});
        					return false;
        				});	
			});
		</script>
    </head>
    <body>
        <div class="body">
        	<g:if test="${source=='firstsetup'}">
	        	<div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Show Portfolio<span class="button"><button id="listPortfolio" title="Portfolio List"> Go To List </button>
						<button id="listTicketPlanner" title="Go To Ticket Planner" > Go To Ticket Planner </button>
						</span></div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
		            <div class="dialog">
		                <g:render template="portfolioDetails" model="['portfolioInstance': portfolioInstance]"> </g:render>
		            </div>
	            <g:if test="${source=='firstsetup'}">
			            </div>
		            </div>
	            </g:if>
	
        </div>
    </body>
</html>
