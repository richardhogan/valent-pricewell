
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
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
		   	jQuery(function() 
		   	{
				jQuery(".geoGroupCreate").validate();
				jQuery(".geoGroupCreate input:text")[0].focus();
				
				jQuery('#name').keyup(function(){
				    this.value = this.value.toUpperCase();
				});
				
				jQuery("#saveGeoGroupSetup").click(function(){
					if(jQuery(".geoGroupCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/geoGroup/save",
							data:jQuery(".geoGroupCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "GEO_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This GEO is already available.');
					       		}
								else if(data['result'] == "success")//from initial setup
								{
									if("user" != "${sourceFrom}" && "territory" != "${sourceFrom}")
									{
										jQuery( xdialogDiv ).dialog( "close" );
										jQuery(".resultDialog").html('Loading .....');
										jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Success" );
										jQuery(".resultDialog").html('GEO is created successfully.'); jQuery( ".resultDialog" ).dialog("open");
										hideUnhideNextBtn();
									}
									if("user" == "${sourceFrom}" || "territory" == "${sourceFrom}")
									{
										jQuery("#dvNewGeo").dialog( "close" );
										var id = data['geoId']; var name = data['geoName'];

										if("user" == "${sourceFrom}")
											jQuery("#geoGroupId").append('<option value='+id+' selected="selected">'+name+'</option>');
										else
											jQuery("#geoGroup").append('<option value='+id+' selected="selected">'+name+'</option>');
									}
									       
									
								} else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery(".resultDialog").html('Loading .....');
									jQuery(".resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery(".resultDialog").html("Failed to create GEO"); jQuery( ".resultDialog" ).dialog("open");
									
								}						
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){hideLoadingBox();}
						});
					}
					return false;
				});
				
				jQuery('#name').keyup(function(){
	  				jQuery("#nameMsg").html('');
				});
				
				jQuery("#saveGeoGroup").click(function()
				{
					if(jQuery(".geoGroupCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/geoGroup/save",
							data:jQuery(".geoGroupCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "GEO_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This GEO is already available.');
					       		}
								else if(data['result'] == "success")//data == "success") //from setup tab
								{
									if("user" != "${sourceFrom}")
									{
										refreshGeoGroupList();
									}
									if("user" == "${sourceFrom}")
									{
										jQuery("#dvNewGeo").dialog( "close" );
										var id = data['geoId']; var name = data['geoName'];
										
										jQuery("#geoGroupId").append('<option value='+id+' selected="selected">'+name+'</option>');
									}
									
								} else{
									jQuery('#geoGroupErrors').html(data);
									jQuery('#geoGroupErrors').show();
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
						 data: {sourceFrom: "geoGroup", source: "${source}"},
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
					if("user" == "${sourceFrom}")
					{
						jQuery("#dvNewGeo").dialog( "close" );
					}
					else
					{
						showLoadingBox();
						jQuery.post( '${baseurl}/geoGroup/listsetup' , 
						  	{source: "firstsetup"},
					      	function( data ) 
					      	{
							  	hideLoadingBox();
					          	jQuery('#contents').html('').html(data);
					      	});
					}
					
					return false;
				});	
				
			});

			function goToGeoList()
			{
				showLoadingBox();
				jQuery.post( '${baseurl}/geoGroup/listsetup' , 
				  	{source: "firstsetup"},
			      	function( data ) 
			      	{
					  	hideLoadingBox();
			          	jQuery('#contents').html('').html(data);
			      	});
			}
			
	   	</script>
        
    <body>
    
    	<div id="dvNewterritory"> </div>
    	<div id="userDialog"> </div>
        <div class="body">
				
					<!--<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
		            
		            <div id="geoGroupErrors" class="errors" style="display: none;">
		            </div>-->
		            
		            <div id="successDialog_1" title="Success">
						<p><g:message code="territory.create.message.success.dialog" default=""/></p>
					</div>
			
					<div id="failureDialog_1" title="Failure">
						<p><g:message code="territory.create.message.failure.dialog" default=""/></p>
					</div>
		
					<g:if test="${source=='firstsetup' && sourceFrom != 'user' && sourceFrom != 'territory'}">
						<div class="collapsibleContainer" >
							<div class="collapsibleContainerTitle ui-widget-header" >
								<div>Add New GEO</div>
							</div>
						
							<div class="collapsibleContainerContent ui-widget-content" >
					</g:if>
			
				            <g:form action="save" name="geoGroupCreate" class="geoGroupCreate" >
				            	<g:hiddenField name="source"  value="${source}"/>
				            	<g:hiddenField name="sourceFrom" value="${sourceFrom}"/>
				                <div class="dialog">
				                    <table>
				                        <tbody>
				                        
				                            <tr class="prop">
				                                <td valign="top" class="name">
				                                    <label for="name"><g:message code="geoGroup.name.label" default="Name" /></label>
				                                    <em>*</em>
				                                </td>
				                                
				                                <td valign="top" class="value ${hasErrors(bean: geoGroupInstance, field: 'name', 'errors')}">		
													
				                                    <g:textField id="name" name="name" value="${geoGroupInstance?.name}" size="38" class="required" />
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
				                        
				                        	<g:if test="${source!='setup' && sourceFrom != 'user' && sourceFrom != 'territory'}">
						                        <tr>
											        <td valign="top" class="name"><label for="generalManager">Assign General Manager</label></td>
										          	<td valign="top">
											          	
											          	<g:select name="generalManagerId" from="${generalManagerList?.sort {it.profile.fullName}}" optionKey="id" value=""  noSelection="['':'Select Any One...']" />
										          		
										          		<button id="newGManager" class="roundNewButton"  title="Create New General Manager">+</button>
										          	</td>
											    </tr>
										    </g:if>
									        
				                        	<g:if test="${sourceFrom != 'user' && sourceFrom != 'territory'}">
				                        		<tr>
									          		<td valign="top" class="name"><label for="geo">Select Territories</label></td>
									          		<td valign="top">
											          	<div id="territoriesList">
											          		<g:select name="geos" from="${territoriesList?.sort {it.name}}" optionKey="id" value=""  noSelection="['':'Select Multiple...']" multiple="true"/>
											          		<button id="newterritory" class="roundNewButton" style="vertical-align: top; margin: 30px 0px 0px 0px" title="Create New Territory">Create Territory</button>
										          		</div>	
								          			</td>
									        	</tr>
									        </g:if>
				                        </tbody>
				                    </table>
				                </div>
				                <div class="buttons">
				                	<g:if test="${source=='firstsetup' && sourceFrom != 'user' && sourceFrom != 'territory'}">
				                		<span class="button"><button id="saveGeoGroup" title="Save GEO"> Save </button></span>
				                		<span class="button"><button id="cancelGeoGroup" title="Cancel"> Cancel </button></span>
				                	</g:if>
				                	<g:else>
				                		<span class="button"><button id="saveGeoGroupSetup" title="Save GEO"> Save </button></span>
				                	</g:else>
				                    
				                </div>
				            </g:form>
			           	<g:if test="${source=='firstsetup' && sourceFrom != 'user'}">
					            </div>
				            </div>
			            </g:if>
			
        </div>
    </body>
</html>
