<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="grails.plugins.nimble.core.*" %>
	
	<script type="text/javascript">
			jQuery.noConflict();
		</script>
  <script>
	  jQuery(document).ready(function()
	  {		    
	  		jQuery("#userCreate").validate();

	  		jQuery("#saveUser").click(function(){
				if(jQuery("#userCreate").validate().form()){
					jQuery.ajax({
						type: "POST",
						url: "/pricewell/user/save",
						data:jQuery("#userCreate").serialize(),
						success: function(data){
							if(data == "success"){
								jQuery( "#userDialog" ).dialog( "close" );
								jQuery("#resultDialog").html('Loading .....');
								jQuery("#resultDialog").dialog( "open" ); jQuery("#resultDialog").dialog( "option", "title", "Success To Add" );
								jQuery("#resultDialog").html('User added successfully into role.'); jQuery( "#resultDialog" ).dialog("open");
								//refreshGeoGroupList();
							} else{
								jQuery( "#userDialog" ).dialog( "close" );
								jQuery('#userErrors').html(data);
								jQuery("#resultDialog").html('Loading .....');
								jQuery("#resultDialog").dialog( "open" ); jQuery("#resultDialog").dialog( "option", "title", "Failed To Add" );
								jQuery("#resultDialog").html(data); jQuery( "#resultDialog" ).dialog("open");
								
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
				}
				return false;
			}); 
	  });
		    
  </script>

  <p>
    <g:message code="nimble.view.user.create.descriptive" />
  </p>
	
  

  <g:form action="save" name="userCreate">
  	<g:hiddenField name="roleId" value="${roleInstance?.id}" />
  	<g:hiddenField name="source" value="setup" />
    <table>
      <tbody>

      <tr>
        <td class="name"><label for="username"><g:message code="nimble.label.username" /></label></td>
        <td class="value">
		  <input type="text" size="30" id="username" name="username" value="${fieldValue(bean: user, field: 'username') }" required="true" class="easyinput"/>&nbsp;<span class="icon icon_bullet_green">&nbsp;</span>
		  <a href="#" id="usernamepolicybtn" rel="usernamepolicy" class="empty icon icon_help"></a>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="pass"><g:message code="nimble.label.password" /></label></td>
        <td class="value">
          <input type="password" size="30" id="pass" name="pass" value="${user.pass?.encodeAsHTML()}" class="password easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>  <a href="#" id="passwordpolicybtn" rel="passwordpolicy" class="empty icon icon_help">&nbsp;</a>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="passConfirm"><g:message code="nimble.label.password.confirmation" /></label></td>
        <td class="value">
          <input type="password" size="30" id="passConfirm" name="passConfirm" value="${user.passConfirm?.encodeAsHTML()}" class="easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="fullName"><g:message code="nimble.label.fullname" /></label></td>
        <td class="value">
          <input type="text" size="30" id="fullName" name="fullName" value="${user.profile?.fullName?.encodeAsHTML()}" class="easyinput"/>
        </td>
      </tr>

      <tr>
        <td class="name"><label for="email"><g:message code="nimble.label.email" /></label></td>
        <td class="value">
          <input type="text" size="30" id="email" name="email" value="${user.profile?.email?.encodeAsHTML()}" class="easyinput"/> <span class="icon icon_bullet_green">&nbsp;</span>
        </td>
      </tr>
      
      <tr>
		  	<td>
	        		<g:if test="${roleInstance.name=='SALES MANAGER'}"> 
		        			<label>Select Territories</label></td>
	        				<td>
	        					<g:select name="territoriesList" from="${Geo.list()}" value="" optionKey="id" multiple="multiple" noSelection="['': 'Select Multiple']"/>
	                    	
	        		</g:if>
	        		
	        		<g:if test="${roleInstance.name=='SALES PERSON'}">
	        			
	        			<label>Select Territory</label></td>
	        			<td>
	        				<g:select name="territoryId" from="${Geo.list()}" value="" optionKey="id" noSelection="['': 'Select any one']"/>
	        			
	        		</g:if>
	        		
	        		<g:if test="${roleInstance.name=='GENERAL MANAGER'}">
	        			<label>Select GEO</label></td>
	        			<td>
	        				<g:select name="geoGroupID" from="${GeoGroup.list()}" value="" optionKey="id" noSelection="['': 'Select any one']"/>
	        			
	        		</g:if>
	        	
		  	</td>
		  </tr>

      </tbody>
    </table>

    <div>
      <span class="button"><button id="saveUser"> Save </button></span>
    </div>

  </g:form>



</body>

</html>