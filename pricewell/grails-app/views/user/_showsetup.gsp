<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="grails.plugins.nimble.core.*" %>

<head>
  <script type="text/javascript">
  	
	jQuery(document).ready(function()
	{	
		jQuery( "#dvUserServices" ).dialog(
		{
			modal: true,
			autoOpen: false,
			height: 200,
			width: 300
		});
		
		jQuery('#changeTerritory').click(function() 
		{
			jQuery( "#dvUserServices" ).html('Loading .....');
			jQuery( "#dvUserServices" ).dialog( "open" );
			jQuery( "#dvUserServices" ).dialog( "option", "title", "Change Territory" );
			jQuery( "#dvUserServices" ).dialog( "option", "zIndex", 2000 );
			jQuery.ajax(
			{
				type: "POST",
				url: '/pricewell/user/changeProperties?id=' + <%=user?.id%> + '&userRole=' + 'salesPerson',
				success: function(data){
					jQuery( "#dvUserServices" ).html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
			return false;
		});
		
		jQuery('#changeTerritories').click(function() 
		{
			jQuery( "#dvUserServices" ).html('Loading .....');
			jQuery( "#dvUserServices" ).dialog( "open" );
			jQuery( "#dvUserServices" ).dialog( "option", "title", "Change Territories" );
			jQuery( "#dvUserServices" ).dialog( "option", "zIndex", 2000 );
			jQuery.ajax(
			{
				type: "POST",
				url: '/pricewell/user/changeProperties?id=' + <%=user?.id%> + '&userRole=' + 'salesManager',
				success: function(data){
					jQuery( "#dvUserServices" ).html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
			return false;
		});
		
		jQuery('#changeGeo').click(function() 
		{
			jQuery( "#dvUserServices" ).html('Loading .....');
			jQuery( "#dvUserServices" ).dialog( "open" );
			jQuery( "#dvUserServices" ).dialog( "option", "title", "Change GEO" );
			jQuery( "#dvUserServices" ).dialog( "option", "zIndex", 2000 );
			jQuery.ajax(
			{
				type: "POST",
				url: '/pricewell/user/changeProperties?id=' + <%=user?.id%> + '&userRole=' + 'generalManager',
				success: function(data){
					jQuery( "#dvUserServices" ).html(data);
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
			return false;
		});
		
	});
  </script>
</head>

<body>

  <span><h2><g:message code="nimble.view.user.show.heading" args="[user.username?.encodeAsHTML()]" /></h2></span>

	
			
  <div id="dvUserServices">
  
  </div>
  
  <div>
    
    <table class="datatable">
      <tbody>

      <tr>
        <td><label><g:message code="nimble.label.username" /></label></td>
		<td>${user.username?.encodeAsHTML()}</td>
      </tr>

	  <tr>
	    	<td><label><g:message code="nimble.label.fullname" /></label></td>
			<td>${user.profile?.fullName?.encodeAsHTML()}</td>
		
			<td>&nbsp;&nbsp;</td>
			
	    	<td><label><g:message code="nimble.label.email" /></label></td>
			<td>${user.profile?.email?.encodeAsHTML()}</td>
		</tr>
		
      <tr>
        <td><label><g:message code="nimble.label.created" /></label></td>
        <td><g:formatDate format="MMMMM d, yyyy" date="${user.dateCreated}"/></td>
        
        <td>&nbsp;&nbsp;</td>
        
        <td><label><g:message code="nimble.label.lastupdated" /></label></td>
        <td><g:formatDate format="MMMMM d, yyyy" date="${user.lastUpdated}"/></td>
      </tr>

      <tr>
        <td><label><g:message code="nimble.label.type" /></label></td>
        <g:if test="${user.external}">
          <td class="value"><g:message code="nimble.label.external.managment" /></td>
        </g:if>
        <g:else>
          <td class="value"><g:message code="nimble.label.local.managment" /></td>
        </g:else>
        
        <td>&nbsp;&nbsp;</td>
        
        <td><label><g:message code="nimble.label.state" /></label></td>
        <td class="value">

          <div id="disableduser">
            <span class="icon icon_tick">&nbsp;</span><g:message code="nimble.label.enabled" />
          </div>
          <div id="enableduser">
            <span class="icon icon_cross">&nbsp;</span><g:message code="nimble.label.disabled" />
          </div>

        </td>
      </tr>

      <tr>
        <td><label><g:message code="nimble.label.remoteapi" /></label></td>
        <td class="value">

          <div id="enabledapi">
            <span class="icon icon_tick">&nbsp;</span>Enabled
          </div>
          <div id="disabledapi">
            <span class="icon icon_cross">&nbsp;</span>Disabled
          </div>

        </td>
      </tr>


	   
		  <tr>
		  	<td>
		  		<g:each in="${user.roles}" status="j" var="role">
	        		
	        		
	        		<g:if test="${role.name=='SALES MANAGER'}"> 
		        			
		                    	
                    		<b>Territories</b></td>
	        				<td>
	        					<g:each in="${user.territories}" var="mb">
		                        	<li>${mb}</li>
		                    	</g:each>
		                    	<input id="changeTerritories" type="button" value="Change" class="button"/></td>
	        		</g:if>
	        		
	        		<g:if test="${role.name=='SALES PERSON'}">
	        			
	        			
	        			<b>Territory</b></td>
	        			<td>${user?.territory?.name}<input id="changeTerritory" type="button" value="Change" class="button"/>
	        			
	        		</g:if>
	        		
	        		<g:if test="${role.name=='GENERAL MANAGER'}">
	        			<b>GEO</b></td>
	        			<td>${user?.geoGroup?.name}<input id="changeGeo" type="button" value="Change" class="button"/>
	        			
	        		</g:if>
	        	</g:each>
		  	</td>
		  </tr>
	    
      </tbody>
    </table>
  </div>

</body>
