<%
	def baseurl = request.siteUrl
%>
<html>
	<g:setProvider library="prototype"/>	
		<script>
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
					
			});
			
			function hideUnhideNextBtn()
			{
				jQuery.ajax({
		            url: '${baseurl}/companyInformation/isInfoDefined',
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
        
	        <div id="accordion">
			    <h3 style="font-size: 130%"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; About Company Information</h3>
				  <div>
					    <h1 style="font-family:Arial Rounded MT Bold;font-size:20px;"><b>What is "Company Information Setup"?</b></h1>
					    <br />
					    	<p style="font-family:Arial Rounded MT Bold;font-size:15px;">Company Information Setup is the process of configuring Valent Software products for first use.
					    	   It involves providing all of the critical information about a vendor needed to design, publish 
					    	   and retire services, and to produce quotes and contracts.</p>
				  </div>
				  
			    <h3 style="font-size: 130%"> <div id="dvheader"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	<g:if test="${companyInformationId == null}">Add</g:if><g:else>Show</g:else> Company Information </div> </h3>
			    
			    	<div id="dvCompanyInfo">
			    		<g:if test="${companyInformationId == null}">
			    			<g:render template="../companyInformation/create" model="['companyInformationInstance': companyInformationInstance, 'source': source]"/>
		    			</g:if>
		    			<g:else>
		    				<g:render template="../companyInformation/show" model="['companyInformationInstance': companyInformationInstance, 'source': source]"/>
		    			</g:else>
					</div>
			</div>
		</div>
	</html>