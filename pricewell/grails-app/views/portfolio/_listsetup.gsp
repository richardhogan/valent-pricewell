<%@ page import="com.valent.pricewell.Portfolio" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    
        <style>
			h1, button, #successDialogInfo
			{
				font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
			}
			button{
				cursor:pointer;
			}
		</style>
		<script>
		
			function refreshGeoGroupList(source){
				refreshNavigation();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/portfolio/listsetup",
					data: {source: "firstsetup"},
					success: function(data){
						jQuery('#contents').html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			}
			
			var ajaxList = new AjaxPricewellList("Portfolio", "Portfolio", "${baseurl}", "setup", 750, 600, "${allowCreate}", "${allowEdit}", "${allowDelete}", "${allowShow}");
			
			jQuery(document).ready(function()
		 	{	
				ajaxList.init();
				
				var deleteMsgSetup = "<div>Are you sure you want to delete Portfolio?</div>";
				
				jQuery('.createPortfolioSetup').click(function () 
				{
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" ); jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "title", "Create Portfolio" );
					jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST", 
						url: "${baseurl}/portfolio/createsetup",
						data: {source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
					return false;
						
				});
				
				jQuery(".editPortfolioSetup").click(function(){
					jQuery( xdialogDiv ).html('Loading, please wait.....');
					jQuery( xdialogDiv ).dialog( "open" ); jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "title", "Edit Portfolio" );
					jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/portfolio/editsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery( xdialogDiv ).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".showPortfolioSetup").click(function(){
					jQuery(xdialogDiv).html('Loading, please wait.....');
					jQuery(xdialogDiv).dialog( "open" );
					jQuery(xdialogDiv).dialog( "option", "title", "Show Portfolio" );
					jQuery(xdialogDiv).dialog( "option", "zIndex", 1500 ); jQuery(xdialogDiv).dialog( "option", "width", 'auto');
					jQuery(xdialogDiv).dialog( "option", "maxHeight", 600);
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/portfolio/showsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery(xdialogDiv).html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
				
				jQuery(".deletePortfolioSetup").click(function()
				{
					var myid = this.id;
					var btns = {};
					btns["Yes"] = function()
					{ 
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/portfolio/deletesetup",
							data: {id: myid, source: 'setup'},
							success: function(data)
							{
								if(data == "success")
								{								    		         
									hideUnhideNextBtn();
									jQuery(".resultDialog").html('Loading, please wait.....'); 
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('Portfolio deleted successfully.'); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
								else{
									jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to delete portfolio."); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
					    jQuery(this).dialog("close");
					};
					btns["No"] = function(){ 
						jQuery(this).dialog("close");
					};
					jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/portfolio/getName",
						data: {id: myid},
						success: function(data){
							jQuery(deleteMsgSetup).dialog({
							    autoOpen: true,
							    title: "Delete Portfolio : " + data,
							    modal:true,
							    buttons:btns
							});
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
						  
				});
			});
		</script>
    
    <body>
        <div class="body">
        	<g:if test="${source == 'firstsetup'}">
        		<h1> ${portfolioInstanceTotal} Portfolios defined &nbsp; &nbsp;
        			<g:if test="${allowCreate == true}">
        				<span><button id="createPortfolio" title="Add New Portfolio"> Add Portfolio </button></span>
       				</g:if>
       			</h1><hr />
	        
	            <div class="list">
	                <table cellpadding="0" cellspacing="0" border="0" class="display" id="portfoliosList">
        	</g:if>
        	<g:else>
	            <div class="nav">
		            <a id="createPortfolioSetup" class="createPortfolioSetup button" href="#" title="Add New Portfolio">Add Portfolio</a>
		        </div>
		        
	            <div class="list childtab">
	                <table cellpadding="0" cellspacing="0" border="0" class="display1" id="portfoliosSetupList">
            </g:else>
            
                    <thead>
                        <tr>
                        
                            <th>${message(code: 'portfolio.portfolioName.label', default: 'Name')} </th>
                        
                            <th>${message(code: 'portfolio.dateModified.label', default: 'Date Modified')}</th>
                        
                            <th>${message(code: 'portfolio.stagingStatus.label', default: 'Staging Status')}</th>
                        
                            <th>${message(code: 'portfolio.portfolioManager.label', default:'Portfolio Manager')}</th>
                            
                            <g:if test="${source == 'firstsetup'}">
								<g:if test="${allowEdit == true}"><th></th></g:if>
                            
                            	<g:if test="${allowDelete == true}"><th></th></g:if>
                           	</g:if>
                           	<g:else><th></th><th></th></g:else>
                            
                        
                        </tr>
                    </thead>
                    <tbody>
	                    <g:each in="${portfolioInstanceList}" status="i" var="portfolioInstance">
	                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	                        	<g:if test="${source == 'firstsetup'}">
		                        	<g:if test="${allowShow == true}">
		                        		<td><a id="${portfolioInstance.id}" href="#" class="showPortfolio hyperlink">${fieldValue(bean: portfolioInstance, field: "portfolioName")}</a></td>
		                            </g:if>
		                            <g:else>
	                            		${fieldValue(bean: portfolioInstance, field: "portfolioName")}
	                            	</g:else>
	                            </g:if>
	                            <g:else>
	                            	<td><a id="${portfolioInstance.id}" href="#" class="showPortfolioSetup hyperlink">${fieldValue(bean: portfolioInstance, field: "portfolioName")}</a></td>
	                            </g:else>
	                            
	                            
	                            
	                        	<td><g:formatDate format="MMMMM d, yyyy" date="${portfolioInstance.dateModified}" /></td>
	                        
	                            <td>${fieldValue(bean: portfolioInstance, field: "stagingStatus")}</td>
	                        
	                            <td>${fieldValue(bean: portfolioInstance, field: "portfolioManager")}</td>
	                        
	                        	<g:if test="${source == 'firstsetup'}">
									<g:if test="${allowEdit == true}">
										<td> <a id="${portfolioInstance.id}" title="Edit Portfolio" href="#" class="editPortfolio hyperlink"> Edit </a></td>
									</g:if>
									<g:if test="${allowDelete == true}">
										<td> <a id="${portfolioInstance.id}" title="Delete Portfolio" href="#" class="deletePortfolio hyperlink"> Delete </a></td>
									</g:if>
								</g:if>
								<g:else>
		                        	<td> <a id="${portfolioInstance.id}" title="Edit Portfolio" href="#" class="editPortfolioSetup hyperlink"> Edit </a></td>
	                        		<td> <a id="${portfolioInstance.id}" title="Delete Portfolio" href="#" class="deletePortfolioSetup hyperlink"> Delete </a></td>
									
								</g:else>
	                        </tr>
	                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div id="portfolioDialog" title="">
			
		</div>
    </body>
</html>
