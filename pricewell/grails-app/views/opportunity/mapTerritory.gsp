
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.Opportunity" %>
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
	def primaryTerritory = null
	if(loginUser?.primaryTerritory!=null && loginUser?.primaryTerritory!='null' && loginUser?.primaryTerritory!='NULL')
	{
		primaryTerritory = Geo.get(loginUser?.primaryTerritory?.id)
	}
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<script>
			  jQuery(document).ready(function()
			  {		
			  		jQuery("#mapTerritoryFrm").validate();

			  		jQuery('.doMapping').click(function()
					{
					    jQuery("#territoryId").addClass( "required" ); 
					    jQuery("#mapValue").val("doMapping");
					});
					
			  		jQuery('.createNew').click(function(){

						jQuery("#territoryId").val("");
						jQuery("#territoryId").removeClass( "required" );
						jQuery("#mapValue").val("createNew");
					});

			  		jQuery("#territoryId").change(function() 
			    	{
				    	if(jQuery(this).val() != "" && jQuery(this).val() != null)
						 {
							jQuery('input:radio[class=doMapping][id=mapTerritory]').prop('checked', true);
							jQuery("#mapValue").val("doMapping");
							
							if(!jQuery("#territoryId").hasClass( "required" ))
							{
								jQuery("#territoryId").addClass( "required" );
							}
						 }
						else
						{
							
							jQuery('input:radio[class=doMapping][id=mapTerritory]').prop('checked', false);
							jQuery('input:radio[class=createNew][id=mapTerritory]').prop('checked', true);
							jQuery("#mapValue").val("createNew");
							
							jQuery("#territoryId").removeClass( "required" );
						}
					  	
					  
					});
					
			  		jQuery("#saveBtn").click( function() 
					{
						if(jQuery("#mapTerritoryFrm").validate().form())
						{
							
							showLoadingBox();
							jQuery.ajax(
							{
				                url: '${baseurl}/opportunity/saveTerritoryMapping',
				                type: 'POST',
				                data: jQuery("#mapTerritoryFrm").serialize(),
				                success: function (data) 
				           		{
				           			hideLoadingBox();
					           		if(data == "success")
						           	{
					           			jQuery( "#mapSuccessDialog" ).dialog( "open" );
							        }
					           		else
						           	{
					           			jQuery( "#mapFailureDialog" ).dialog("open");
							           	
						           	}
				                }, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									//alert("Error while saving");
									hideLoadingBox();
									jQuery( "#mapFailureDialog" ).dialog("open");
								}
				            });
							
						}
					       
					    return false;
					});
						  		
			  		jQuery( "#mapSuccessDialog" ).dialog(
				 	{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: {
							OK: function() 
							{
								jQuery( "#mapSuccessDialog" ).dialog( "close" );
								window.location = "${baseurl}/opportunity/show/${opportunityInstance?.id}"
								return false;
							}
						}
					});

					jQuery( "#mapFailureDialog" ).dialog(
					{
						modal: true,
						autoOpen: false,
						resizable: false,
						buttons: {
							OK: function() {
								jQuery( "#mapFailureDialog" ).dialog( "close" );
								return false;
							}
						}
					});
			  });
			  
  		</script>
        
        
    </head>
    <body>
    	<div id="mapSuccessDialog" title="Success">
			Connectwise territory successfully mapped.
		</div>

		<div id="mapFailureDialog" title="Failure">
			Failed to map Connectwise territory.
		</div>
		
        <div class="nav">
            
        </div>
        <div class="body">
            <h2>Map territory of Connectwise opportunity : "${opportunityInstance?.name}"</h2><hr>
            
            <b>Note : Territory not defined in opportunity, so map it first.</b><br>
            
            <g:form action="saveTerritoryMapping" name="mapTerritoryFrm">
            	<g:hiddenField name="id" value="${opportunityInstance?.id}"/>
            	<g:hiddenField name="connectwiseTerritory" value="${connectwiseTerritory}"/>
            	<g:hiddenField name="mapValue" value="doMapping"/>
            	
                <div class="dialog list">
                    <table>
                    
                    	<thead>
	                        <tr>
	                        	<th>Unmatched Territory</th>
	                        
	                            <th>Mapped With Territory</th>
	                        
	                            <th>Do Mapping</th>
	                        
	                            <th>Create New</th>
	                        
	                        </tr>
	                    </thead>
	                    
                        <tbody>
                         
                            <tr class="prop">
                                
                                <td>${connectwiseTerritory}</td>
	                        
	                            <td><g:select name="territoryId" from="${territoryList?.sort {it.name}}" optionKey="id" value="${primaryTerritory?.id}" noSelection="['':'-Select Any One-']" class="required" /></td>
	                        
	                            <td><g:radio name="mapTerritory" class="doMapping" checked="true" value=""/></td>
	                        
	                            <td><g:radio name="mapTerritory" value="${connectwiseTerritory}" class="createNew"/></td>
                            </tr>
                        
                        </tbody>
	                 </table>
                </div>
                <div class="buttons">
                    <!-- <span class="button"><g:submitButton name="saveBtn" title="Save Territory Mapping" class="save" value="Save" /></span> -->
                    <span class="button"><button title="Save Territory Mapping" id="saveBtn" class="save"> Save </button></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
