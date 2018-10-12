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
			var xdialogDiv = "#userSetupDialog";
			jQuery(document).ready(function()
		 	{
		 		var icons = {
				    header: "ui-icon-circle-arrow-e",
				    headerSelected: "ui-icon-circle-arrow-s"
				   };
				
			    jQuery( ".accordion" ).accordion({
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
						location.reload();
					},
					buttons: 
					{
						OK: function() 
						{
							jQuery.ajax(
							{
								type: "POST", data: {roleId: ${roleInstance.id}, source: "${source}"},
								url: "${baseurl}/userSetup/listsetup",
								success: function(data){
									jQuery( ".dvheader" ).html("      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   List Of ${roleInstance.name}");
				  					jQuery(".dvusersinfo").html(data);
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
		            url: '${baseurl}/setup/isUserDefined',
		            type: 'POST', async: false, cache: false, timeout: 30000,
		            error: function(){
		                return false;
		            },
		            success: function(msg)
		            { 
		               if(msg == 'true')
		               {
		               		if(stepNumber != 9 && jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
		               		{
		            			jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
		            			
		            		}
		               		else if(stepNumber == 9 && jQuery('.swMain .buttonFinish').hasClass('buttonDisabled'))
	            			{
	            				jQuery('.swMain .buttonFinish').removeClass("buttonDisabled").removeClass("buttonHide");
	            			}
		               }
		               else
		               {
		               		if(stepNumber != 9 && !jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
		               		{
		            			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
		            			
		            		}
		               		else if(stepNumber == 9 && !jQuery('.swMain .buttonFinish').hasClass('buttonDisabled'))
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
        
	        <div id="accordion-${roleInstance.id}" class="accordion">
			    <h3 style="font-size: 130%"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; About ${roleInstance.name}</h3>
				  <div>
					   <g:render template="../userSetup/aboutRole" model="['roleInstance': roleInstance]"/>
				  </div>
				  
			    <h3 style="font-size: 130%"> <div id="dvheader-${roleInstance.id}" class="dvheader"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	<g:if test="${roleUserList.size() > 0}">List Of</g:if><g:else>Create New</g:else> ${roleInstance.name} </div>
			    </h3>
			    
			    	<div id="dvusersinfo-${roleInstance.id}" class="dvusersinfo">
			    		<g:if test="${roleUserList.size() > 0}">
			    			<g:render template="../userSetup/usersbyrole" model="['roleInstance': roleInstance, 'users': roleUserList, 'source': source]"/>
		    			</g:if>
		    			<g:else>
		    				<g:render template="../userSetup/createsetup2" model="['user': user, 'roleInstance': roleInstance, 'randomPassword': randomPassword, 'source': source, 'geoGroupList': geoGroupList, 'territoriesList': territoriesList]"/>
		    			</g:else>
		    			
					</div>
			</div>
			
			<div id="userSetupDialog" title=""></div>
			<div id="resultDialog-${roleInstance.id}" class="resultDialog"></div>
		</div>
	</html>