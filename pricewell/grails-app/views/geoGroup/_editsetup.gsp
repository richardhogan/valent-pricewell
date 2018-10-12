
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="grails.plugins.nimble.core.Role" %>
<%
	def baseurl = request.siteUrl
	Role gManagerRole = Role.findByCode('GENERAL MANAGER')
%>
<html>
		<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
        
         <script>
         	jQuery(document).ready(function()
     		{
				jQuery("#geoGroupEdit").validate();
				jQuery("#geoGroupEdit input:text")[0].focus();
				
				jQuery('#name').keyup(function(){
				    this.value = this.value.toUpperCase();
				});
				
				jQuery("#updateGeoGroupSetup").click(function(){
					if(jQuery("#geoGroupEdit").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/geoGroup/update",
							data:jQuery("#geoGroupEdit").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "GEO_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This GEO is already available.');
					       		}
								else if(data == "success")
								{								    		         
									jQuery(".resultDialog").html('Loading, please wait.....'); 
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
									jQuery(".resultDialog").html('GEO edited successfully.'); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
								else{
									jQuery(".resultDialog").html('Loading, please wait.....'); jQuery( ".resultDialog" ).dialog("open");
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to edit GEO"); 
									jQuery( xdialogDiv ).dialog( "close" );
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){hideLoadingBox();}
						});
					}
					return false;
				});

				jQuery("#saveGeoGroup").click(function(){
					if(jQuery("#geoGroupEdit").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/geoGroup/update",
							data:jQuery("#geoGroupEdit").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "GEO_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This GEO is already available.');
					       		}
								else if(data == "success"){
									refreshGeoGroupList();
								} else{
									jQuery('#territoryErrors').html(data);
									jQuery('#territoryErrors').show();
								}
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								hideLoadingBox();
								alert("Error while saving");
							}
						});
					}
					return false;
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

				jQuery( "#userDialog" ).dialog(
				{
					maxHeight: 600,
					width: 'auto',
					modal: true,
					autoOpen: false,
					close: function( event, ui ) {
							jQuery(this).html('');
						}
					
				});
				
				jQuery( "#newterritory" ).click(function() 
				{
					jQuery( "#dvNewterritory" ).dialog( "option", "title", 'Create Territory' );
					jQuery('#dvNewterritory').html("Loading Data, Please Wait.....");
					jQuery( "#dvNewterritory" ).dialog( "open" );
					jQuery.ajax({type:'POST',
						 url:'${baseurl}/geo/createsetup',
						 data: {sourceFrom: "geoGroup", source: '${source}'},
						 success:function(data,textStatus)
						 {
							 jQuery('#dvNewterritory').html(data);
							 
						},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					return false;
				});

				jQuery( "#newGManager" ).click(function() 
				{
					jQuery( "#userDialog" ).dialog( "option", "title", 'Create General Manager' );
					jQuery('#userDialog').html("Loading Data, Please Wait.....");
					jQuery( "#userDialog" ).dialog( "open" );
					jQuery.ajax({type:'POST',
						 url:'${baseurl}/userSetup/createsetup',
						 data: {sourceFrom: "geoGroup", roleId: ${gManagerRole?.id}, source: "${source}"},
						 success:function(data,textStatus)
						 {
							 jQuery('#userDialog').html(data);
							 
						},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
					return false;
				});
				
				jQuery( "#successDialog_1" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: 
					{
						OK: function() 
						{
							jQuery( "#successDialog_1" ).dialog( "close" );
							return false;
						}
					}
				});
						
				jQuery( "#failureDialog_1" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#failureDialog_1" ).dialog( "close" );
							return false;
						}
					}
				});

				jQuery("#cancelGeoGroup").click(function()
				{
					showLoadingBox();
					jQuery.post( '${baseurl}/geoGroup/listsetup' , 
					  	{source: "firstsetup"},
				      	function( data ) 
				      	{
						  	hideLoadingBox();
				          	jQuery('#contents').html('').html(data);
				      	});
					return false;
				});	
			});
	   	</script>
        
    <body>
     
     	<div id="dvNewterritory"> </div>
     	<div id="userDialog"> </div>
     	<div id="successDialog_1" title="Success">
			<p><g:message code="territory.create.message.success.dialog" default=""/></p>
		</div>

		<div id="failureDialog_1" title="Failure">
			<p><g:message code="territory.create.message.failure.dialog" default=""/></p>
		</div>
        <div class="body">
        	<g:if test="${source=='firstsetup'}">
	        	<div class="collapsibleContainer">
					<div class="collapsibleContainerTitle ui-widget-header">
						<div>Edit GEO</div>
					</div>
			
					<div class="collapsibleContainerContent ui-widget-content">
			</g:if>
					<g:form method="post" name="geoGroupEdit" >
		                <g:hiddenField name="id" value="${geoGroupInstance?.id}" />
		                <g:hiddenField name="version" value="${geoGroupInstance?.version}" />
		                <g:hiddenField name="source" value="${source}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="name"><g:message code="geoGroup.name.label" default="Name" /></label>
		                                  <em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoGroupInstance, field: 'name', 'errors')}">
											<g:textField name="name" value="${geoGroupInstance?.name}" size="38" class="required" />
											<br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="description"><g:message code="geoGroup.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoGroupInstance, field: 'description', 'errors')}">
		                                     <g:textArea name="description" value="${geoGroupInstance?.description}" rows="5" cols="40" />
		                                </td>
		                            </tr>
		                        
		                            <g:if test="${source!='setup'}">
			                            <tr>
								          	<td valign="top" class="name"><label for="generalManager">Assign General Manager</label></td>
								          	<td valign="top">
								          		<g:if test="${SecurityUtils.subject.hasRole('GENERAL MANAGER')}">
								          			<g:hiddenField name="generalManagerId" value="${generalManagerId}" />
								          			<g:textField name="gemeralManager" value="${User.get(generalManagerId)}" readOnly="true" />
								          		</g:if>
								          		<g:else>
								          			<g:select name="generalManagerId" from="${generalManagerList?.sort {it.profile.fullName}}" optionKey="id" value="${generalManagerId}"  noSelection="['':'Select Any One...']"  />
								          			<button id="newGManager" class="roundNewButton" title="Create New General Manager">+</button>
							          			</g:else>
								          	</td>
								        </tr>
							        </g:if>
							        
		                        	
		                        	<tr>
							          	<td valign="top" class="name"><label for="geo">Select Territories</label></td>
							          	<td valign="top">
							          		<div id="territoriesList">
							          			<g:select name="geos" from="${territoriesList?.sort {it.name}}" optionKey="id" size="5" value="${geoGroupInstance?.geos*.id}"  noSelection="['':'Select Multiple...']" multiple="true"/>
							          			<button id="newterritory" class="roundNewButton" style="vertical-align: top; margin: 30px 0px 0px 0px" title="Create New Territory">Create Territory</button>
						          			</div>	
						          		
					          		  	</td>
							        </tr>
		                        
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <span class="button">
		                    	<g:if test="${source == 'firstsetup'}">
		                    		<button id="saveGeoGroup" title="Update GEO"> Update </button>
		                    		<span class="button"><button id="cancelGeoGroup" title="Cancel"> Cancel </button></span>
		                    	</g:if>
		                    	<g:else>
		                    		<button id="updateGeoGroupSetup" title="Update GEO"> Update </button>
	                    		</g:else>
		                    </span>
		                </div>
		            </g:form>
		            
            <g:if test="${source=='firstsetup'}">
		            </div>
	            </div>
            </g:if>
			
        </div>
    </body>
</html>
