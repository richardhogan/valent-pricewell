<%
	def baseurl = request.siteUrl
%>
<html>
<style>
		h1, button, #successDialogInfo
		{
			font-family:Georgia, Times, serif; font-size:15px; font-weight: bold;
		}
		button, a{
			cursor:pointer;
		}
		hr {
		    border: none;
    		background-color: black;
    		color: black;
		    width: 700px;
		}
		
		.headingText {
			font-family:Georgia, Times, serif; font-size:15px;
		}
		.headingBold {
			 font-weight: bold;
		}
		.dataTables_wrapper {
			position: relative;
			min-height: 0px;
			clear: both;
			_height: 0px;
			zoom: 1; /* Feeling sorry for IE */
		}
		
		.dataTables_filter {
			width: 50%;
			float: right;
			text-align: left;
		}
		
		.childtab {
			margin-left: 0px;
			border:1px solid;
			border-width: thin;
			border-color: #C0C0C0
		}
		
		.linkclass {	
		color: #1874CD;
	 	text-decoration:underline;
	 	hover-color: #fff;
	 	}
		
	</style>
	
		<script>
		
		    var xdialogDiv = "#deliveryRoleSetupDialog";
			jQuery(document).ready(function()
		 	{
				var icons = {
				    header: "ui-icon-circle-arrow-e",
				    headerSelected: "ui-icon-circle-arrow-s"
				   };
				
				    jQuery( "#accordion" ).accordion({
				      autoHeight: false,
				      icons: icons,
				      navigation : true
				      
				    });
				    
				 jQuery(xdialogDiv).dialog({
		            autoOpen: false,
		            position: [400,200],
		            modal: true,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
		        });
			    
			    jQuery( ".resultDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					close: function( event, ui ) {
						jQuery(this).html('');
					},
					buttons: 
					{
						OK: function() 
						{
							jQuery.ajax(
							{
								type: "POST", 
								url: "${baseurl}/deliveryRole/listsetup",
								data: {source: 'setup'},
								success: function(data){
									jQuery( ".dvheader" ).html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   List Of Delivery Roles");
				  					jQuery(".dvdeliveryrole").html(data);
									jQuery( ".resultDialog" ).dialog( "close" );
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){}
							});
							
							return false;
						}
					}
				 });
					
			});
			function hideUnhideNextBtn()
				 {
					jQuery.ajax({
			            url: '${baseurl}/deliveryRole/isDeliveryRoleDefined',
			            type: 'POST', async: false, cache: false, timeout: 30000,
			            error: function(){
			                return false;
			            },
			            success: function(msg)
			            { 
			               if(msg == 'true')
			               {
			               		if(jQuery('.swMain .buttonFinish').hasClass('buttonDisabled'))
			               		{
			            			jQuery('.swMain .buttonFinish').removeClass("buttonDisabled").removeClass("buttonHide");
			            			
			            		}
			    				
			               }
			               else
			               {
			               		if(!jQuery('.swMain .buttonFinish').hasClass('buttonDisabled'))
			               		{
			            			jQuery('.swMain .buttonFinish').addClass("buttonDisabled").addClass("buttonHide");
			            			
			            		}
			        			
			               }
			                  
			               return false;  
			            }
			        });
				}
			
			
		</script>
	
		<div class="body">	
        
	        <div id="accordion" class="accordion">
			    <h3 style="font-size: 130%"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; About Delivery Role</h3>
				  <div>
					   <h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b>What is a Delivery Role?</b></h1>
					   	<br />
							<p style="font-family:Arial Rounded MT Bold;font-size:15px;">A Delivery Role is a type of professional with a specific capability and accreditation or 
							certification to perform a specific range of tasks. Delivery Roles are the building blocks 
							for all professional services. Each Delivery Role has a standard cost per period (hour/day) 
							and a standard price charged by the vendor for the same period of time.</p>
				  </div>
				  
				<h3 style="font-size: 130%"> <div id="dvheader" class="dvheader"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	<g:if test="${deliveryRoleList.size() > 0}">List Of Delivery Roles</g:if><g:else>Create New Delivery Role</g:else></div>
			    </h3>
			    
			    	<div id="dvdeliveryrole" class="dvdeliveryrole">
			    		<g:if test="${deliveryRoleList.size() > 0}">
			    			<g:render template="../deliveryRole/listsetup" model="['deliveryRoleInstanceList': deliveryRoleList, 'deliveryRoleInstanceTotal': deliveryRoleList.size(), 'source': source]"/>
		    			</g:if>
		    			<g:else>
		    				<g:render template="../deliveryRole/createsetup" model="['deliveryRoleInstance': deliveryRoleInstance, 'source': source]"/>
		    			</g:else>
		    			
					</div>
				  
			  </div>
			  
			<div id="deliveryRoleSetupDialog" ></div>
			<div id="resultDialog" class="resultDialog"></div>
		</div>
	</html>