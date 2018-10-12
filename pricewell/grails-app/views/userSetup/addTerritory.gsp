
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.Geo" %>

<html>
<%
	def baseurl = request.siteUrl
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Add Country</title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			.ui-dialog .ui-state-error { padding: .3em; }
		</style>
		
		<script>
			 
			jQuery(document).ready(function()
		 	{
				jQuery("#addTerritory").validate();

				jQuery( "#save" ).click(function() 
				{
					if(jQuery('#addTerritory').validate().form())
					{
						showLoadingBox();
    	   				jQuery.post( '${baseurl }/userSetup/savePrimaryTerritory', 
               				  jQuery("#addTerritory").serialize(),
						      function( data ) 
						      {
    	   						  hideLoadingBox();
						          if(data == 'success')
						          {		  
						          		window.location.href = '${baseurl }/home';
						          		//${controller}/create';
							      }

						      });
                		
               		}
					return false;
				});

				jQuery("#primaryTerritory").change(function () 
		    	{
			    	
			    	if(this.value != "")
				    {
			    		 jQuery.ajax(
					     {
						     type:'POST',data: {id: this.value },
						 	 url:'${baseurl}/geo/isCountryDefined',
						 	 success:function(data,textStatus)
						 	 {
							 	 if(data != "countryDefined")
							 	 {
								 	 jQuery('.countryForTerritory').html(data);
							 	 }
							 	 else
								 {
							 		jQuery('.countryForTerritory').html("");
								 }
							 },
						 	 error:function(XMLHttpRequest,textStatus,errorThrown){}
					 	 });
						 
					}
			    	else
			    	{
			    		jQuery('#countryForTerritory').html("");
			    	}
		    		return false;
		    	});
				  
			});
  		</script>
  		
  		
    </head>
    <body>
        <div class="body">
            <h2>Please configure your default territory and country</h2><hr>
            
            <g:form action="save"  name="addTerritory">
            
                <div class="dialog">
                
                	<table>
                		<tr class="primaryTerritoryForUser">
                			<td><label>Primary Territory</label><em>*</em></td>
                			<td><g:select name="primaryTerritory" from="${territoryList?.sort {it.name}}" value="${userInstance?.primaryTerritory?.id }" optionKey="id"  noSelection="['': 'Select Any One']" class="required"/></td>
                		</tr>
                		
                		<tr class="countryForTerritory"></tr>
                	</table>
                	<!-- <div id="primaryTerritoryForUser">
                		<span>
                			<label>Primary Territory<em>*</em></label>
                			<g:select name="primaryTerritory" from="${Geo?.list()?.sort {it.name}}" value="" optionKey="id"  noSelection="['': 'Select Any One']" class="required"/>
                		</span>
                	</div>
                	
                	<div id="countryForTerritory" style="position: relative;">
				           			
				    </div>-->
                    
                </div>
                <div class="buttons">
                     <span class="button"><button id="save" title="Save">Save</button></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
