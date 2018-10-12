

<%@ page import="com.valent.pricewell.CorrectionInActivityRoleTime" %>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function()
	{
		var activityId = ${activityRoleTime?.serviceActivity?.id };
		jQuery(".createRoleTimeCorrectionFrm").validate();
		jQuery("#createRoleTimeCorrectionFrm input:text")[0].focus();
		
		jQuery("input:text").keypress(function(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                jQuery( ".createArtcBtn" ).click();
                return false;
            }
        });
        
		jQuery('.createArtcBtn').click( function()
		{
			if(jQuery(".createRoleTimeCorrectionFrm").validate().form())
			{	
				showLoadingBox();		
				jQuery.ajax({type:'POST',data: jQuery(".createRoleTimeCorrectionFrm").serialize(),
					 url:'${baseurl}/correctionInActivityRoleTime/save',
					 success:function(data,textStatus){
						 //jQuery('#accordionContent-'+activityId).html(data);
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
            <g:form action="save" name="createRoleTimeCorrectionFrm" class="createRoleTimeCorrectionFrm">
            
                	<g:hiddenField name="sqId" value="${serviceQuotation?.id}"/>
	                <g:hiddenField name="roleTimeId" value="${activityRoleTime?.id}"/>
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
                                    ${activityRoleTime?.role?.name }
                                </td>
                                
                                <td valign="top" class="value">
                                    <g:textField name="totalHours" value="${activityRoleTime.countTotalHoursForServiceQuotationUnits(serviceQuotation.totalUnits) }" class="required number"/>
                                </td>
                                
                                <td valign="top" class="buttons">
                                	<input id="createArtcBtn" class="createArtcBtn" type="button" title="Update" value="Update"/>
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                
            </g:form>
        </div>
    
