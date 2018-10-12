<%@ page import="com.valent.pricewell.Quotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <script>
    jQuery(document).ready(function()
    		{
				jQuery('#btnCreateQuote').click(function()
				{
					showLoadingBox();	
					jQuery.ajax({type:'POST',data: jQuery('#quotationCreate').serialize(),
						 url:'${baseurl}/quotation/save',
						 success:function(data,textStatus){
							 	hideLoadingBox();
							 	jQuery('#dvQuote').html(data);
							 	
							 	jQuery( "#dvNewQuote" ).dialog("close");
							   	jQuery( "#dvQuote" ).dialog( "option", "title", 'SOW <%=quotationInstance?.id%>' );
								jQuery( "#dvQuote" ).dialog( "open" );
								refreshList();
							 	},
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});
				});

				/*jQuery("input[name=versionType]:radio").change(function () {
					var versionType = jQuery("input[name=versionType]:checked").val();
					if(versionType == "full")
					{
						jQuery("#isLight").val(${false});
					}
					else
					{
						jQuery("#isLight").val(${true});
					}
				});*/

    		});

	
    </script>
    <body>
        
        <div class="body">
            
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${quotationInstance}">
            <div class="errors">
                <g:renderErrors bean="${quotationInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form name="quotationCreate">
            	<g:hiddenField name="opportunity.id" value="${quotationInstance?.opportunity?.id}"  />
            	<g:hiddenField name="account.id" value="${quotationInstance?.account?.id}"  />
            	<g:hiddenField name="geo.id" value="${quotationInstance?.geo?.id}"/>
            	<!--<g:hiddenField name="isLight" value="${false}"/>-->
            	
                <div class="dialog">
                    <table>
                        <tbody>
                              
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="validityInDays"><g:message code="quotation.validityInDays.label" default="Validity in days : " /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'status', 'errors')}">
                                    <g:select name="validityInDays" from="${0..validityDays}" value=""  noSelection="['':'-Choose Days-']"/>
                                    
                                </td>
                            </tr>
                            
                            <!-- <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="versionType">Version Type : </label>
                                </td>
                                <td valign="top">
                                    <g:radioGroup name="versionType" labels="['Full Version','Light Version']" values="['full', 'light']" value="full">
										<p>${it.radio} ${it.label} </p>
									</g:radioGroup>

                                </td>
                            </tr> -->
                                                
                        </tbody>
                    </table>
                </div>
                <!--<div class="buttons">
                    <span class="button"><input type="button" name="create" class="save" id="btnCreateQuote" value="Create"/> </span>
                </div>-->
            </g:form>
        </d	iv>
    </body>
</html>