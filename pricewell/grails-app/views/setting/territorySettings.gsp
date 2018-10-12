<%@ page import="com.valent.pricewell.Geo" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
    	<script type="text/javascript" src="../js/tiny_mce/tiny_mce.js"></script>
		<ckeditor:resources />
    	<script> 

        	jQuery(document).ready(function()
  		 	{

        		jQuery("#territorySettings").validate();
        		
        		jQuery('#territoryId').change(function() {
        			var territoryId = jQuery( "#territoryId" ).val();

        			jQuery.ajax({type:'POST',data: {territoryId: territoryId},
	   					url:'${baseurl}/setting/getTerritorySetting',
	   					success:function(data,textStatus){jQuery('#mainterritorySettingTab').html(data);},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
	   		 			return false;
        			  //alert('Territory Id : '+territoryId);
        		});

        	});
        	
		</script>  
    </head>
    <body>
    
    	<div class="nav">
       		<span><g:link class="buttons.button button" title="Globle Settings" action="sowSettings">Globle Settings</g:link></span>
            
       	</div>
	        	
    	<div class="collapsibleContainer">
			<div class="collapsibleContainerTitle ui-widget-header">
				<div>Territory Settings</div>
			</div>
		
			<div class="collapsibleContainerContent">
			
				<div id="territorySettingsTab">
					<table>
						<tr>
							<td><b>Select Territory : </b></td><td><g:select name="territoryId" from="${Geo.list()?.sort {it.name}}" value="" optionKey="id" noSelection="['':'Select Any One']"/></td>
						</tr>
					</table>
					<hr>
					<div id="mainterritorySettingTab">
						
					</div>
				</div>
			
			</div>
			
		</div>
			
			
			
    </body>
    
</html>