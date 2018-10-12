<%@ page import="com.valent.pricewell.SolutionBundle" %>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
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
        
			 jQuery(function() 
			 {			
			 	var xdialogDiv = "#solutionBundleDialog";
										
					jQuery("#savesolutionBundle").click(function()
						{
							if(jQuery("#solutionBundleUpdate").validate().form())
							{
								showLoadingBox();
								jQuery.ajax({
									type: "POST",
									url: "${baseurl}/solutionBundle/update",
									data:jQuery("#solutionBundleUpdate").serialize(),
									success: function(data)
									{
										hideLoadingBox();
										if(data == "SolutionBundle_Available")
							      		{
							        		jQuery("#nameMsg").html('Error: This Solution Bundle is already available.');
							       		}
										else if(data == "success"){
											jAlert("Solution Bundle edited successfully.", 'Confirmation Dialog', function(r)
						    				{
												window.location.href = "${baseurl}/solutionBundle/list";
											});
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
						
						jQuery("#cancelsolutionBundle").click(function()
						{
							jQuery( xdialogDiv ).dialog( "close" );
							jQuery("#solutionBundleDialog").hide();
							return false;
						});					  
			 });

  		</script>
    </head>
    <body>
        
        <div class="body">
        
			<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<div id="solutionBundleErrors" class="errors" style="display: none;">
            </div>
            
		            <g:form method="post" action="update" name="solutionBundleUpdate">
						<g:hiddenField name="id" value="${solutionBundleInstance?.id}" />
		                <g:hiddenField name="version" value="${solutionBundleInstance?.version}" />
		                <div class="dialog">
		                    <table>
		                        <tbody>
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                  <label for="name"><g:message code="solutionBundle.name.label" default="Name" /></label>
		                                	<em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: solutionBundleInstance, field: 'name', 'errors')}">
		                                	${solutionBundleInstance?.name}
		                                    <g:hiddenField name="name" value="${solutionBundleInstance?.name}" />
		                                    <br/><div id="nameMsg" class="msg"></div>
		                                </td>
		                            </tr>
		                            <tr class="prop">
		                                <td valign="top" class="name" style="vertical-align: top;padding-top: 10px;">
		                                  <label for="description"><g:message code="solutionBundle.description.label" default="Description" /></label>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: solutionBundleInstance, field: 'description', 'errors')}">
		                                    <g:textArea onKeyUp="limitText(this.form.description,this.form.countdown,255);" name="description" value="${solutionBundleInstance?.description}" rows="5" cols="75"/><br>
											<font size="1">(Maximum characters: 255)&nbsp;&nbsp;
											You have <input readonly type="text" name="countdown" size="3" value="${255-solutionBundleInstance.description.size()}"> characters left.</font>
		                                </td>
		                            </tr>	
		                            <tr>
			                            <td colspan="2">
			                            	<label for="Service List"><g:message code="solutionBundle.servicList.label" default="Service List" /></label>
			                            </td>
		                           </tr>
		                           <tr>
		                            	<td colspan="2" >
		                            		<g:if test="${solutionBundleInstance.solutionBundleServices.isEmpty()}">
		                            			No Services Added
		                            		</g:if>
		                            		<g:if test="${!solutionBundleInstance.solutionBundleServices.isEmpty()}">
			                            		<p style="word-wrap: break-word;">
							          				${solutionBundleInstance.solutionBundleServices}
							          			</p>
						          			</g:if>
                              		 	</td>
		                            </tr>	                         	
		                        </tbody>
		                    </table>
		                </div>
		                <div class="buttons">
                    		<span class="button"><button id="savesolutionBundle" title="Update Solution Bundle" > Update </button></span>
		                </div>
		            </g:form>
        </div>
        
    </body>
</html>
