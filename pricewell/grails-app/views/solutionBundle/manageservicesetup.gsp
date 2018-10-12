<%@ page import="com.valent.pricewell.SolutionBundle" %>

<%@ page import="com.valent.pricewell.Service" %>
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
		 jQuery(function() 
		 {			
			 	if("firstsetup" == "${source}")
					{var xdialogDiv = "#solutionBundleDialog";}
				else
					{var xdialogDiv = "#solutionBundleSetupDialog";}
			    jQuery("#solutionBundleManage").validate();
			    //jQuery("#solutionBundleManage input:text")[0].focus();
			    jQuery("#savesolutionBundleSetup").click(function()
			    {
					if(jQuery("#solutionBundleManage").validate().form())
					{
						showLoadingBox();
						jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/solutionBundle/saveservices",
							data:jQuery("#solutionBundleManageService").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "SolutionBundle_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Service is already available.');
					       		}
								else if(data == "success"){
									jQuery(xdialogDiv).html('Loading, please wait.....'); 
									jQuery(xdialogDiv).dialog( "open" ); jQuery(xdialogDiv).dialog( "option", "title", "Success" );
									jQuery(xdialogDiv).html('Solution Bundle services saved successfully.'); 
									
									window.location.href = "${baseurl}/solutionBundle/list";
								} else{
									jQuery( xdialogDiv ).dialog( "close" );
									jQuery("#resultDialog").html('Loading .....');
									jQuery("#resultDialog").dialog( "open" ); jQuery(".resultDialog").dialog( "option", "title", "Failure" );
									jQuery("#resultDialog").html("Failed to manage service."); jQuery( ".resultDialog" ).dialog("open");
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
			  
			    jQuery("#saveandmanageservicesolutionBundle").click(function()
				{
			    	jQuery("#solutionBundleServices option").prop('selected', true);
					if(jQuery("#solutionBundleManageService").validate().form())
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/solutionBundle/saveservices",
							data:jQuery("#solutionBundleManageService").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								if(data == "manageService_Available")
					      		{
					        		jQuery("#nameMsg").html('Error: This Service is already available.');
					       		}
								else if(data == "success"){
									jQuery(xdialogDiv).html('Loading, please wait.....'); 
									jQuery(xdialogDiv).dialog( "open" ); jQuery(xdialogDiv).dialog( "option", "title", "Success" );
									jQuery(xdialogDiv).html('Solution Bundle services saved successfully.'); 
									
									window.location.href = "${baseurl}/solutionBundle/list";
								} 
								else{
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

	    		jQuery("#cancelsolutionBundle").click(function()
				{
					jQuery( xdialogDiv ).dialog( "close" );
					jQuery("#solutionBundleDialog").hide();
					return false;
				});	
				
	    		jQuery('#btn-add').click(function(){
	    	        jQuery('#serviceAll option:selected').each( function() {
	    	                jQuery('#solutionBundleServices').append("<option selected=selected value='"+jQuery(this).val()+"'>"+jQuery(this).text()+"</option>");
	    	            jQuery(this).remove();
	    	        });
	    	    });	
	    		jQuery('#btn-addAll').click(function(){
	    	        jQuery('#serviceAll option').each( function() {
    	                jQuery('#solutionBundleServices').append("<option selected=selected value='"+jQuery(this).val()+"'>"+jQuery(this).text()+"</option>");
    	            	jQuery(this).remove();
	    	        });
	    	    });	
	    		jQuery('#btn-remove').click(function(){
	    	        jQuery('#solutionBundleServices option:selected').each( function() {
	    	            jQuery('#serviceAll').append("<option value='"+jQuery(this).val()+"'>"+jQuery(this).text()+"</option>");
	    	            jQuery(this).remove();
	    	        });
	    	    });
	    		jQuery('#btn-removeAll').click(function(){
	    	        jQuery('#solutionBundleServices option').each( function() {
	    	            jQuery('#serviceAll').append("<option value='"+jQuery(this).val()+"'>"+jQuery(this).text()+"</option>");
	    	            jQuery(this).remove();
	    	        });
	    	    });
	    		jQuery('#btn-up').click(function(){
	    	        jQuery('#solutionBundleServices Option:selected').each( function() {
	    	            var newPos = jQuery('#solutionBundleServices option').index(this) - 1;
	    	            if (newPos > -1) {
	    	                jQuery('#solutionBundleServices option').eq(newPos).before("<option value='"+jQuery(this).val()+"' selected='selected'>"+jQuery(this).text()+"</option>");
	    	                jQuery(this).remove();
	    	            }
	    	        });
	    	    });
	    	    jQuery('#btn-down').click(function(){
	    	        var countOptions = jQuery('#solutionBundleServices option').size();
	    	        jQuery('#solutionBundleServices option:selected').each( function() {
	    	            var newPos = jQuery('#solutionBundleServices option').index(this) + 1;
	    	            if (newPos < countOptions) {
	    	                jQuery('#solutionBundleServices option').eq(newPos).after("<option value='"+jQuery(this).val()+"' selected='selected'>"+jQuery(this).text()+"</option>");
	    	                jQuery(this).remove();
	    	            }
	    	        });
	    	    });
	    	    jQuery("#cancelSolutionBundleServices").click(function()
   			    {
	   			 	jQuery("#solutionBundleDialog").dialog( "close" );
					return false;
   			    });
		 	});
		 
  		</script>
    </head>
    <body>
        
        <div class="body">
					<!--<g:if test="${flash.message}">
		            <div class="message">${flash.message}</div>
		            </g:if>
					<div id="solutionBundleErrors" class="errors" style="display: none;">
		            </div>-->
		    <g:if test="${source=='firstsetup'}">        
	            <div class="collapsibleContainer" >
					<div class="collapsibleContainerTitle ui-widget-header" >
						<div>Add New Solution Bundle</div>
					</div>
				
					<div class="collapsibleContainerContent ui-widget-content" >
			</g:if>
	            <g:form action="saveservices" name="solutionBundleManage">
	                <div class="dialog">
	                <g:hiddenField name="id" value="${solutionBundleServiceInstance?.id}"/>
	                <g:hiddenField name="solution_bundle_id" value="${solutionBundleInstance?.id}" optionKey="name"/>
	                <%--<g:hiddenField name="sequence_no" value="${solutionBundleInstance?.sequence_no}"/>
	                    --%><table>
	                        <tbody>
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                  <label for="name"><g:message code="solutionBundle.name.label" default="Name" /></label>
	                                	:&nbsp;<label>${solutionBundleInstance?.name}</label>
	                                </td>
	                            </tr>
                              		 <tr class="prop">
                              		 	<th>List Of Services</th>
                              		 	<th></th>
                              		 	<th>Selected Services</th>
                              		 </tr>
                              		 <tr>
                              		 	<td>
                              		 		<g:select id="serviceAll" name="serviceAll" from="${serviceListInstance}" optionValue="serviceName"
										          optionKey="id" size="10" style="width: 25em"/>
                              		 	</td>
                              		 	<td>
                              		 		<input type="button" value="&nbsp;&nbsp;>&nbsp;&nbsp;" id="btn-add"/></br></br>
                              		 		<input type="button" value="&nbsp;>>&nbsp;" id="btn-addAll"/></br></br>
                              		 		<input type="button" value="&nbsp;&nbsp;<&nbsp;&nbsp;" id="btn-remove"/></br></br>                           		 		
                              		 		<input type="button" value="&nbsp;<<&nbsp;" id="btn-removeAll"/>
                              		 	</td>
                              		 	<td>
                              		 		<g:select id="solutionBundleServices" name="solutionBundleServices" optionValue="serviceName"
										          optionKey="id" from="${solutionBundleInstance?.solutionBundleServices}" class="required" selected="true" multiple="true" value="${solutionBundleServiceInstance?.solutionBundleServices*.id}" size="10" style="width: 25em"/>
                              		 	</td>
                              		 	<td><input type="button" value="&nbsp;Up&nbsp;&nbsp;" class="btn-up" id="btn-up"/></br></br>
                              		 		<input type="button" value="Down" id="btn-down"/></td>
									</tr>
	                        </tbody>
	                    </table>
	                </div>
	                <div class="buttons">
	                	<g:if test="${source=='firstsetup'}">
	                		<span class="button"><button id="saveandmanageservicesolutionBundle" title="Save Solution Bundle"> Save Services </button></span>
	                		<span class="button"><button id="cancelSolutionBundleServices" title="Cancel"> Cancel </button></span>
	                	</g:if>
	                	<g:else>
	                    	<span class="button"><button title="Save Solution Bundle" id="saveandmanageservicesolutionBundle"> Save Services </button></span>
	                    	<span class="button"><button type="button" id="cancelSolutionBundleServices" title="Cancel"> Cancel </button></span>
                    	</g:else>
	                </div>
	            </g:form>
	            <g:if test="${source=='firstsetup'}">
						</div>
					</div>
				</g:if>
        </div>
         <div id="solutionBundleDialog" title="">
			
		</div>
    </body>
</html>
