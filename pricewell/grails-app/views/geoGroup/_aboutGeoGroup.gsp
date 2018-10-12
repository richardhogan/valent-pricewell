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
			var xdialogDiv = "#geoGroupSetupDialog";
			
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
					position:[400,200],
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
								url: "${baseurl}/geoGroup/listsetup",
								data: {source: "setup"},
								success: function(data){
									jQuery( ".dvheader" ).html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   List Of GEOs");
				  					jQuery(".dvgeogroup").html(data);
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
			            url: '${baseurl}/geoGroup/isGeoGroupDefined',
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
			    <h3 style="font-size: 130%"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; About GEO</h3>
				  <div>
					    <h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b>What is a GEO?</b></h1>
						
							<p style="font-family:Arial Rounded MT Bold;font-size:15px;">GEO is short for a sales "Geography" and it refers to a high level division of the world into broad sales 
							   regions that typically span national borders and are under the direction of a "General Manager".  For 
							   example many organizations have GEO's such as APAC (Asia Pacific), EMEA (Europe Middle East and Africa), 
							   and AMERICAS. In this example, each of these three GEO's would be led by a General Manager responsible for 
							   sales and profitability within the GEO.</p>
							   
						<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b>What is a Territory?</b></h1>
						
							<p style="font-family:Arial Rounded MT Bold;font-size:15px;">A sales "Territory" is a subdivision of a GEO. The division may be a country or a portion of a country or 
							   GEO.  Each Territory will have a responsible "Sales Manager" that is responsible to the General Manager for 
							   his or her assigned Territory.</p>
							   
						<h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b>What is an SOW?</b></h1>
						
							<p style="font-family:Arial Rounded MT Bold;font-size:15px;">An SOW or "Statement of Work" is a contractual agreement for services between a vendor and a customer. 
							   The SOW specifies the specific activities, documents, files and other "deliverables" that the vendor 
							   will provide the customer and includes legal and financial terms and conditions that govern the agreement.  
							   Sometimes, an SOW is governed under a broader type of contractual agreement often referred to as an "MSA" 
							   or "Master Services Agreement".</p>
				  </div>
				  
			    <h3 style="font-size: 130%"> <div id="dvheader" class="dvheader"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	<g:if test="${geoGroupList.size() > 0}">List Of GEOs</g:if><g:else>Create New GEO</g:else></div>
			    </h3>
			    
			    	<div id="dvgeogroup" class="dvgeogroup">
			    		<g:if test="${geoGroupList.size() > 0}">
			    			<g:render template="../geoGroup/listsetup" model="['geoGroupInstanceList': geoGroupList, 'geoGroupInstanceTotal': geoGroupList.size(), 'source': source]"/>
		    			</g:if>
		    			<g:else>
		    				<g:render template="../geoGroup/createsetup" model="['geoGroupInstance': geoGroupInstance, 'generalManagerList': generalManagerList, 'source': source, 'territoriesList': territoriesList]"/>
		    			</g:else>
		    			
					</div>
			</div>
			
			<div id="geoGroupSetupDialog" ></div>
			<div id="resultDialog" class="resultDialog"></div>
		</div>
	</html>