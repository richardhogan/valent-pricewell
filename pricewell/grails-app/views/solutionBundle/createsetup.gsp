<%@ page import="com.valent.pricewell.SolutionBundle" %>
<g:set var="entityName" value="${message(code: 'SolutionBundle.label', default: 'Solution Bundle')}" />
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        <g:set var="entityName" value="${message(code: 'SolutionBundle.label', default: 'Solution Bundle')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    
    	<style>
			.msg {
				color: red;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<script>
		function limitText(limitField, limitCount, limitNum) {
        	if (limitField.value.length > limitNum) {
        		limitField.value = limitField.value.substring(0, limitNum);
        	} else {
        		limitCount.value = limitNum - limitField.value.length;
        	}
        }
        
		function refreshGeoGroupList(source)
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/solutionBundle/listsetup",
				data: {source: "${source}"},
				success: function(data){
					if(source == "firstsetup")
					{jQuery('#contents').html(data);}
					else
					{jQuery('#dvsolutionBundle').html(data);}
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		 jQuery(function()
		 {
			 	jQuery("#name").focus();
			 	
			    jQuery("#savesolutionBundleSetup").click(function()
			    {
					if(jQuery("#solutionBundleCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/solutionBundle/save",
							data:jQuery("#solutionBundleCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();	
								if(data == "SolutionBundle_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Solution Bundle is already available.');
					       		}
								else if(data == "success"){
									jAlert("Solution Bundle created successfully.", 'Confirmation Dialog', function(r)
				    				{
										window.location.href = "${baseurl}/solutionBundle/list";
									});
								} 
								else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery("#resultDialog").html('Loading .....');
									jQuery("#resultDialog").dialog( "open" ); 
									jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery("#resultDialog").html("Failed to create Solution Bundle."); 
									jQuery( ".resultDialog" ).dialog("open");
								}		
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving ");
								hideLoadingBox();
							}
						});
					}
					return false;
				}); 
			    
			    jQuery("#savesolutionBundle").click(function()
				{
					if(jQuery("#solutionBundleCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/solutionBundle/save",
							data:jQuery("#solutionBundleCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "SolutionBundle_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Solution Bundle is already available.');
					       		}
								else if(data == "success"){
									refreshGeoGroupList("${source}");
								} else{
									jQuery('#solutionBundleErrors').html(data);
									jQuery('#solutionBundleErrors').show();
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
			    jQuery("#saveandmanageservicesolutionBundle").click(function()
				{
			    	if(jQuery("#solutionBundleCreate").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/solutionBundle/manageservicesetup2",
							data:jQuery("#solutionBundleCreate").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "SolutionBundle_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Solution Bundle is already available.');
					       		}
								else if(data.result == "success"){
									jQuery( xdialogDiv ).html('Loading, please wait.....');
									jQuery( xdialogDiv ).dialog( "open" );
									jQuery( xdialogDiv ).dialog( "option", "title", "Manage Services for Solution Bundle" );
									jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
									jQuery( xdialogDiv ).dialog( "option", "width", 800); 
									jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
									jQuery.ajax({
										type: "POST",
										url: "${baseurl}/solutionBundle/manageservicesetup",
										data: {id: data.sbInstance, source: 'setup'},
										success: function(data){
											jQuery( xdialogDiv ).html(data);
										}, 
										error:function(XMLHttpRequest,textStatus,errorThrown){}
									});
								} else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery(xdialogDiv).html('Loading .....');
									jQuery(xdialogDiv).dialog( "open" ); 
									jQuery(xdialogDiv).dialog( "option", "title", "Failure" );
									jQuery(xdialogDiv).html("Failed to create Solution Bundle."); 
									jQuery(xdialogDiv).dialog("open");
								}		
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving ");
								hideLoadingBox();
							}
						});
					}
					return false;
		 		});
		 });
  		</script>
    </head>
    <body>
        
        <div class="body">
		            <g:form action="manageservicesetup2" name="solutionBundleCreate">
		            	<g:hiddenField name="source" value="${source}"/>
		                
		                <div class="dialog">
		                    <table>
		                        <tbody>		                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="name"><g:message code="solutionBundle.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td>

		                                	<g:textField name="name" class="required" size="105%"  maxlength="75" />
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                           	 </tr>
		                            <tr class="prop">
		                                <td valign="top" class="name" style="vertical-align: top;padding-top: 10px;">
		                                    <label for="description"><g:message code="solutionBundle.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: solutionBundleInstance, field: 'description', 'errors')}">
		                                    <g:textArea onKeyUp="limitText(this.form.description,this.form.countdown,255);" name="description" rows="5" cols="80"  />
		                                    <font size="1">(Maximum characters: 255)&nbsp;&nbsp;
											You have <input readonly type="text" name="countdown" size="3" value="255" tabindex="-1"> characters left.</font>
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
	                    	<span class="button"><button title="Save Solution Bundle" id="savesolutionBundleSetup"> Save </button></span>
	                    	<span class="button"><button id="saveandmanageservicesolutionBundle" title="Save and Manage Services"> Save and Manage Services </button></span>
		                </div>
		            </g:form>
        </div>
         <div id="solutionBundleDialog" title="">
			
		</div>
    </body>
</html>
