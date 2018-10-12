<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="grails.plugins.nimble.core.*" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="grails.plugins.nimble.core.Role" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>

<%
	def baseurl = request.siteUrl
	def loginUser = User.get(new Long(SecurityUtils.subject.principal))
	def country = null 
	Role sManagerRole = Role.findByCode('SALES MANAGER')
	Role sPersonRole = Role.findByCode('SALES PERSON')
%>	
<head>
  	<style>
		.msg {
			color: red;
		}
		em { font-weight: bold; padding-right: 1em; vertical-align: top; }
	</style>
  
  	<title><g:message code="nimble.view.user.edit.title" /></title>
  	
  	<script>
	  jQuery(document).ready(function()
	  {		    
	  		jQuery("#userUpdate").validate();
	  		jQuery("#userUpdate input:text")[0].focus();
	  		
	  		jQuery.validator.addMethod("phone", function(value, element) 
			{ 
				return this.optional(element) || /^[+]?([0-9]*[\.\s\-\(\)]|[0-9]+){3,24}$/i.test(value); 
			}, "Please enter a valid number.");
				
			if("firstsetup" == "${source}")
				{var xdialogDiv = "#userDialog";}
			else
				{var xdialogDiv = "#userSetupDialog";}
			
			jQuery('#username').keyup(function(){
	  			jQuery("#usernameMsg").html('');
			});

	  		jQuery('#email').keyup(function(){
	  			jQuery("#emailMsg").html('');
			});

	  		jQuery('#phone').keyup(function(){
	  			jQuery("#phoneMsg").html('');
			});
			
			jQuery("#saveUser").click(function()
			{
				if(jQuery("#userUpdate").validate().form())
				{
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/userSetup/update",
						data:jQuery("#userUpdate").serialize(),
						success: function(data)
						{
							hideLoadingBox();
							if(data == "username_Available")
					      	{
					        	jQuery("#usernameMsg").html('Error: This username is already registered with an existing user account.');
					       	}
					       	else if(data == "email_Available")
					       	{
					        	jQuery("#emailMsg").html('Error: This email is already registered with an existing user account.');
					       	} 
					       	else if(data == "invalid_phone")
					       	{
					        	jQuery("#phoneMsg").html('Error: This phone number is not valid as per the selected country.');
					       	} 
							else if(data == "success")
							{
								jQuery( xdialogDiv ).dialog( "close" );    		                   		
		                   		jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
								jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
								jQuery(".resultDialog").html('User edited successfully.'); 
								
								if("firstsetup" == "${source}")
									{refreshGeoGroupList();}
							} else{
								jQuery( xdialogDiv ).dialog( "close" );
								jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
								jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
								jQuery(".resultDialog").html("Failed to edit user"); 
								
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							alert("Error while saving");
						}
					});
				}
				return false;
			}); 

			jQuery("#geoGroupId").change(function () 
	    	{
				if(this.value != "")
			    {
				    jQuery.ajax({type:'POST',data: {id: this.value, roleId: ${roleInstance?.id} },
						 url:'${baseurl}/userSetup/getGeosTerritories',
						 success:function(data,textStatus)
						 {
							 //jQuery("#primaryTerritoryList").html(data);
							 jQuery("#primaryTerritory").html(data['primary']);
							 if("SALES MANAGER" == '${roleInstance?.name}')
							 {
								 jQuery("#territoriesList").html(data['secondary']);
							 }
							 
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
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
		    		jQuery('.countryForTerritory').html("");
		    	}

		    	if("SALES MANAGER" == '${roleInstance?.name}')
		    	{
			    	 var secondaryOptions = '<option value selected="selected">Select Multiple</option>';
			    	 jQuery("#primaryTerritory option").each(function()
			    	 {
			    		 if(!jQuery(this).is(':selected') && jQuery(this).val() != '')
				    	 {
			    			 secondaryOptions = secondaryOptions + '<option value='+jQuery(this).val()+'>'+jQuery(this).text()+'</option>';
					     }
			    	 });
			    	 jQuery("#territoriesList").html(secondaryOptions);
			    	 //jQuery( "#territoriesList" ).hide();
			    }
	    		return false;
	    	});
	    	
			jQuery("#cancelUser").click(function()
			{
				showLoadingBox();
				jQuery.post( '${baseurl}/userSetup/listroles' , 
				  	{source: "firstsetup"},
			      	function( data ) 
			      	{
					  	hideLoadingBox();
			          	jQuery('#contents').html('').html(data);
			      	});
				return false;
			});

			jQuery( "#dvNewGeo" ).dialog(
			{
				maxHeight: 600,
				width: 'auto',
				modal: true,
				autoOpen: false,
				close: function( event, ui ) {
						jQuery(this).html('');
					}
				
			});

	  		jQuery( "#dvNewterritory" ).dialog(
			{
				maxHeight: 600,
				width: 'auto',
				modal: true,
				autoOpen: false,
				close: function( event, ui ) {
						jQuery(this).html('');
					}
				
			});
			
	  		jQuery( "#newGeo" ).click(function() 
			{
				jQuery("#dvNewGeo").dialog( "option", "title", 'Create New GEO' );
				jQuery('#dvNewGeo').html("Loading Data, Please Wait.....");
				jQuery("#dvNewGeo").dialog( "open" );
				jQuery.ajax({type:'POST',
					 url:'${baseurl}/geoGroup/createsetup',
					 data: {sourceFrom: "user", source: "${source}"},
					 success:function(data,textStatus)
					 {
						 jQuery('#dvNewGeo').html(data);
						 
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				return false;
			});
					
			jQuery( "#newPrimaryTerritory" ).click(function() 
			{
	  			createTerritory("primaryTerritory");
				return false;
			});	

	  		jQuery( "#newSecondaryTerritory" ).click(function() 
			{
	  			createTerritory("secondaryTerritory");
				return false;
			});
	  	});

	  	function createTerritory(territoryType)
	    {
	  		var givePermission = false;
			var geoId = "";
			if("GENERAL MANAGER" == '${roleInstance?.name}' && territoryType == "primaryTerritory")
			{
				if(jQuery("#geoGroupId").val() != "")
				{
					geoId = jQuery("#geoGroupId").val();
					givePermission = true;
				}
				else
				{
					alert("Please add GEO first.");	
				}
			}
			else
			{
				givePermission = true;
			}
			
			if(givePermission == true)
			{
		    	jQuery("#dvNewterritory").dialog( "option", "title", 'Create New Territory' );
				jQuery('#dvNewterritory').html("Loading Data, Please Wait.....");
				jQuery("#dvNewterritory").dialog( "open" );
				jQuery.ajax({type:'POST',
					 url:'${baseurl}/geo/createsetup',
					 data: {sourceFrom: "user", source: "${source}", territoryType: territoryType, geoId: geoId},
					 success:function(data,textStatus)
					 {
						 jQuery('#dvNewterritory').html(data);
						 
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			}
	    }
  </script>
	</head>

	<body>
		<div id="dvNewterritory"> </div>
    	<div id="dvNewGeo"> </div>
    	
		<g:if test="${source=='firstsetup'}">
			<div class="collapsibleContainer" >
				<div class="collapsibleContainerTitle ui-widget-header" >
					<div>Edit User :  ${user.profile?.fullName?.encodeAsHTML()}</div>
				</div>
		
				<div class="collapsibleContainerContent ui-widget-content" >
		</g:if>
  <!-- <h2><g:message code="nimble.view.user.edit.heading" args="[user.username]" /></h2>

  <p>
    <g:message code="nimble.view.user.edit.descriptive" />
  </p>
-->
  		<n:errors bean="${user}"/>

  		<g:form class="editaccount" name="userUpdate">
    		<input type="hidden" name="id" value="${user.id}"/>
    		<input type="hidden" name="roleId" value="${roleInstance.id}"/>
    		<input type="hidden" name="version" value="${user.version}"/>
			<g:hiddenField name="source" value="${source}"/>
			<g:hiddenField name="sourceFrom" value="${sourceFrom}" />
	
    		<table>
      			<tbody>

      				<tr>
        				<th><label for="username"><g:message code="nimble.label.username" /></label><em>*</em></th>
        				<td class="value">
          					<input type="text" id="username" name="username" minlength="4" value="${user.username?.encodeAsHTML()}" class="required easyinput"/>
        					<br/><div id="usernameMsg" class="msg"></div>
        				</td>
      				</tr>
      
	  				<tr>
        				<td class="name"><label for="fullName"><g:message code="nimble.label.fullname" /></label><em>*</em></td>
        				<td class="value">
          					<input type="text"  id="fullName" name="fullName" value="${user.profile?.fullName?.encodeAsHTML()}" class="required easyinput"/>
        				</td>
      				</tr>
      
      				<tr>
        				<td class="name"><label for="email"><g:message code="nimble.label.email" /></label><em>*</em></td>
       					<td class="value">
         	 				<input type="text"  id="email" name="email" value="${user.profile?.email?.encodeAsHTML()}" class="required email easyinput"/><!-- <span class="icon icon_bullet_green">&nbsp;</span> -->
        					<br/><div id="emailMsg" class="msg"></div>
        				</td>
      				</tr>
      
      				<tr>
        				<td class="name"><label for="phone"><g:message code="nimble.label.phone" default="Phone"/></label><em>*</em></td>
        				<td class="value">
          					<input type="text" size="30" id="phone" name="phone" value="${user.profile?.phone?.encodeAsHTML()}" class="required phone easyinput"/><!--  <span class="icon icon_bullet_green">&nbsp;</span>-->
        				</td>
        				<td>	
        					<g:countrySelect name="phoneCountry"
				                 from="['afg','alb','dza','asm','and','ago','aia','ata','atg','arg','arm','abw','aus','aut','aze'
										,'bhs','bhr','bgd','brb','blr','bel','blz','ben','bmu','btn','bol','bih','bwa','bra','iot'
										,'vgb','brn','bgr','bfa','bdi','khm','cmr','can','cpv','cym','caf','tcd','chl','chn'
										,'cxr','cck','col','com','cok','hrv','cub','cyp','cze','dnk','dji','dma','dom'
										,'ecu','egy','slv','gnq','eri','est','eth','flk','fro','fji','fin','fra','pyf','gab','gmb'
										,'geo','deu','gha','gib','grc','grl','grd','gum','gtm','gin','gnb','guy','hti','hnd'
										,'hkg','hun','ind','idn','irn','irq','irl','imn','isr','ita','jam','jpn','jor'
										,'kaz','ken','kir','kwt','kgz','lao','lva','lbn','lso','lbr','lby','lie','ltu','lux','mac'
										,'mdg','mwi','mys','mdv','mli','mlt','mhl','mrt','mus','myt','mex','fsm','mda','mco'
										,'mng','msr','mar','moz','mmr','nam','nru','npl','nld','ant','ncl','nzl','nic','ner','nga'
										,'niu','nfk','prk','mnp','nor','omn','pak','plw','pan','png','pry','per','phl','pcn','pol'
										,'prt','pri','qat','cog','rou','rus','rwa','shn','kna','lca','spm','vct','wsm'
										,'smr','stp','sau','sen','syc','sle','sgp','svk','svn','slb','som','zaf','kor','esp'
										,'lka','sdn','sur','sjm','swz','swe','che','syr','twn','tjk','tza','tha','tls','tgo','tkl'
										,'ton','tto','tun','tur','tkm','tca','tuv','uga','ukr','are','gbr','usa','ury','vir','uzb'
										,'vut','ven','vnm','wlf','esh','yem','zmb','zwe']" class="required"
				                 value="${user.profile?.country?.encodeAsHTML()}" noSelection="['':'-Select Country Please-']" class="required"/>
        					<br/><div id="phoneMsg" class="msg"></div>
        				</td>
      				</tr>
					
					<g:if test="${sourceFrom != 'geoGroup' && sourceFrom != 'geo' }">
					    <g:if test="${roleInstance?.name == 'GENERAL MANAGER'}"> <!-- && geoGroupList.size()>0}"> -->
							<tr>
								<td><label>GEO</label><em>*</em></td>
								<td>
									<g:select name="geoGroupId" from="${geoGroupList}" value="${user?.geoGroup?.id }" optionKey="id" noSelection="['': 'Select Any One']" class="required"/>
									<button id="newGeo" class="roundNewButton" title="Create New Geo">+</button>
								</td>
							</tr>
					  	</g:if>
				
		      			<g:if test="${roleInstance?.name == 'SALES PRESIDENT' || roleInstance?.name == 'GENERAL MANAGER' || roleInstance?.name == 'SALES MANAGER' || roleInstance?.name == 'SALES PERSON'}">
			 		
			 					 			
						 		<tr>
						    		<td><label>Primary Territory</label><em>*</em></td>
					  				
					  				<td>
					  					<div id="primaryTerritoryList">
					  						<g:if test="${roleInstance?.name == 'SALES MANAGER'}"> 
					  							<g:select name="primaryTerritory" from="${primaryTerritoriesList}" value="${user?.primaryTerritory?.id }" optionKey="id"  noSelection="['': 'Select Any One']" class="required"/>
				  							</g:if>
				  							<g:elseif test="${roleInstance?.name == 'SALES PERSON'}">
				  								<g:select name="primaryTerritory" from="${territoriesList}" value="${user?.territory?.id }" optionKey="id"  noSelection="['': 'Select Any One']" class="required"/>
				  							</g:elseif>
				  							<g:else>
				  								<g:select name="primaryTerritory" from="${territoriesList}" value="${user?.primaryTerritory?.id }" optionKey="id"  noSelection="['': 'Select Any One']" class="required"/>
				  							</g:else>
					  						<g:if test="${!SecurityUtils.subject.hasRole('SALES MANAGER')}">
					  							<g:if test="${roleInstance?.name != 'SALES MANAGER'}"> 
					  								<button id="newPrimaryTerritory" class="roundNewButton" title="Create New Territory">+</button>
				  								</g:if>
				  							</g:if>
				  						</div>
									</td>
						        </tr>
						           	
						        <tr class="countryForTerritory"></tr>
			 				
			 		
							<g:if test="${roleInstance?.name == 'SALES MANAGER'}"> 
								<tr>
									<td><label>Secondary Territories</label></td>
									<td>
										<div id="territoryList">
											<g:select name="territoriesList" from="${territoriesList}" value="${secondaryTerritories*.id}" optionKey="id" multiple="multiple" noSelection="['': 'Select Multiple']" />
										</div>
				      				</td>
				     			</tr>
				     			
				     			<tr>
									<td></td>
									<td>
										<button id="newSecondaryTerritory" class="roundNewButton" title="Create New erritory">New Territory</button>
				      				</td>
				     			</tr>
				   			</g:if>
						</g:if>
					</g:if>
					
      			</tbody>
    		</table>
    
			<div class="buttons">
       
       			<span class="button"><button title="Update User" id="saveUser"> Update </button></span>
       
		       	<g:if test="${source=='firstsetup' && sourceFrom != 'geoGroup' && sourceFrom != 'geo'}">
		       		<span class="button"><button id="cancelUser" title="Cancel"> Cancel </button></span>
		   		</g:if>
   		
			</div>
  		</g:form>
  
		<g:if test="${source=='firstsetup' && sourceFrom != 'geoGroup' && sourceFrom != 'geo'}">
				</div>
			</div>
		</g:if>
	</body>
