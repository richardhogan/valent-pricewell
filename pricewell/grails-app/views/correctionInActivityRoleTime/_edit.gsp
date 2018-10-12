

<%@ page import="com.valent.pricewell.CorrectionInActivityRoleTime" %>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function()
	{
		var activityId = ${correctionInActivityRoleTimeInstance?.serviceActivity?.id };
		jQuery(".editRoleTimeCorrectionFrm").validate();
		jQuery("#editRoleTimeCorrectionFrm input:text")[0].focus();
		
		jQuery("input:text").keypress(function(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                jQuery( ".editArtcBtn" ).click();
                return false;
            }
        });
		
		jQuery('.editArtcBtn').click( function()
		{
			if(jQuery(".editRoleTimeCorrectionFrm").validate().form())
			{			
				//var extraUnit=jQuery("#extraUnits").val();
				//jQuery("#totalextraUnit").val(extraUnit);
				showLoadingBox();
				jQuery.ajax({type:'POST',data: jQuery(".editRoleTimeCorrectionFrm").serialize(),
					 url:'${baseurl}/correctionInActivityRoleTime/update',
					 success:function(data,textStatus){
						 	//jQuery('#accordionContent-'+activityId).html("").html(data);
						 	jQuery("#dvQutationServices").html(data);
						 	jQuery("#dvRoleTimeEdit").dialog( "close" );
						 	hideLoadingBox();
					 },
					 error:function(XMLHttpRequest,textStatus,errorThrown){alert(errorThrown)}});
				return false;

			}
			return false;
				      
		});

	});
			      
			 
 
</script>
			
        <div class="body list">
            <g:form name="editRoleTimeCorrectionFrm" class="editRoleTimeCorrectionFrm">
            
                	<g:hiddenField name="sqId" value="${serviceQuotation?.id}"/>
	                <g:hiddenField name="id" value="${correctionInActivityRoleTimeInstance?.id}" />
                	<g:hiddenField name="version" value="${correctionInActivityRoleTimeInstance?.version}" />
	                <g:hiddenField id="extraUnits" name="extraUnits" value="${extraUnits}"/>
                    <table>
                    	<thead>
                    		<th>Role</th>
                    		<th>Total Hours</th>
                    		<th> </th>
                    	</thead>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="value">
                                    ${correctionInActivityRoleTimeInstance?.role?.name }
                                </td>
                                
                                <g:set var="totalHours" value="${correctionInActivityRoleTimeInstance?.originalHours + correctionInActivityRoleTimeInstance?.extraHours}" />
                                
                                <td valign="top" class="value">
                                    <g:textField name="totalHours" value="${totalHours }" class="required number"/>
                                </td>
                                
                                
                                <td valign="top" class="buttons">
                                	<input id="editArtcBtn" class="editArtcBtn" type="button" title="Update" value="Update"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                
            </g:form>
        </div>
    
