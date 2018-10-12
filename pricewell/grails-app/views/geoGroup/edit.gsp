
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'default.geoGroup.label', default: 'Geo')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <ckeditor:resources />
        
         <script>
		   	jQuery(function() 
		   	{
				jQuery("#geoGroupEdit").validate();
				jQuery("#geoGroupEdit input:text")[0].focus();
				
				jQuery('#name').keyup(function(){
				    this.value = this.value.toUpperCase();
				});

				jQuery( "#dvNewterritory" ).dialog(
				{
					height: 500,
					width: 960,
					modal: true,
					autoOpen: false,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
					
				});
				
				jQuery( "#newterritory" )
				.button()
				.click(function() 
				{
					jQuery( "#dvNewterritory" ).dialog( "option", "title", 'Create Territory' );
					jQuery('#dvNewterritory').html("Loading Data, Please Wait.....");
					jQuery( "#dvNewterritory" ).dialog( "open" );
					jQuery.ajax({type:'POST',
						 url:'${baseurl}/geo/createsetup',
						 data: {sourceFrom: "geoGroup", source: 'setup'},
						 success:function(data,textStatus)
						 {
							 jQuery('#dvNewterritory').html(data);
							 
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
			});
	   	</script>
        
    </head>
    <body>
        <div class="nav">
            <span><g:link class="buttons.button button" title="List Of GEOs" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <g:if test="${createPermission}">
            	<span><g:link class="buttons.button button" title="Create GEO" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
            </g:if>
        	<!-- <span><g:link class="buttons.button button" action="list" controller="deliveryRole">List of Delivery Roles</g:link></span>
            <span><g:link class="buttons.button button" action="list" controller="geo">List of Territories</g:link></span>-->
        </div>
        <div id="dvNewterritory"> </div>
        
        <div id="successDialog_1" title="Success">
			<p><g:message code="territory.create.message.success.dialog" default=""/></p>
		</div>

		<div id="failureDialog_1" title="Failure">
			<p><g:message code="territory.create.message.failure.dialog" default=""/></p>
		</div>
					
        <div class="body">
        
        	<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div><g:message code="default.edit.label" args="[entityName]" /></div>
				</div>
			
				<div class="collapsibleContainerContent">
				
					<g:form method="post" name="geoGroupEdit" >
		                <g:hiddenField name="id" value="${geoGroupInstance?.id}" />
		                <g:hiddenField name="version" value="${geoGroupInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="name"><g:message code="geoGroup.name.label" default="Name" /></label>
		                                  <em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: geoGroupInstance, field: 'name', 'errors')}">
		                                    <g:textField name="name" value="${geoGroupInstance?.name}" class="required" />
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
		                        
		                        	<g:if test="${generalManagerList.size() > 0}">
			                        	<tr>
								          <td valign="top" class="name"><label for="generalManager">Assign General Manager</label><em>*</em></td>
								          <td valign="top">
								          	<g:select name="generalManagerId" from="${generalManagerList?.sort {it.profile.fullName}}" optionKey="id" value="${generalManagerId}"  noSelection="['':'Select Any One...']" class="required" />
								          </td>
								        </tr>
							        </g:if>
		                        	
		                        	<tr>
							          <td valign="top" class="name"><label for="geo">Select Territories</label><em>*</em></td>
							          <td valign="top">
							          	<div id="territoriesList">
							          		<g:select name="geos" from="${territoriesList?.sort {it.name}}" optionKey="id" size="5" value="${geoGroupInstance?.geos*.id}"  noSelection="['':'Select Multiple...']" class="required" multiple="true"/>
						          		</div>	<button id="newterritory">Create Territory</button>
						          		
					          		  </td>
							        </tr>
							        
		                            
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
		                    <span class="button"><g:actionSubmit title="Update GEO" class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
		                    <span class="button"><g:actionSubmit title="Delete GEO" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
		                </div>
		            </g:form>
				
				</div>
				
			</div>
        
            
        </div>
    </body>
</html>
