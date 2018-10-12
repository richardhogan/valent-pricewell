<%@ page import="com.valent.pricewell.DeliveryRole" %>
<%
	def baseurl = request.siteUrl
%>
	<head>
    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		<g:setProvider library="prototype"/>
		
		<script>
			jQuery.getScript("${baseurl}/js/jquery.validate.js", function() {
						jQuery("#activityRoleTimeEditFrm").validate(
					    {
		  					rules: 
		  					{
		    					estimatedTimeInHoursFlat: 
		    					{
		      						number: true	
		    					},
		    					estimatedTimeInHoursPerBaseUnits:
		    					{
		    						number: true
		    					}
		  					}
						});
						
				  });
			jQuery("#activityRoleTimeEditFrm input:text")[0].focus();
		</script>
	</head>   

<g:form method="post" name="activityRoleTimeEditFrm">
    
    <div class="dialog">
    <g:hiddenField name="activityRoleId" value="${activityRoleTimeInstance?.id}" />
    <g:hiddenField name="serviceActivityId" value="${activityRoleTimeInstance?.serviceActivity?.id}" />
    <g:hiddenField name="activityRoleVersion" value="${activityRoleTimeInstance?.version}" />
        <table>
            <tbody>
               <tr class="prop">
                    <td valign="top" class="name">
                      <label for="role"><g:message code="activityRoleTime.role.label" default="Role" /></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: activityRoleTimeInstance, field: 'role', 'errors')}">
                       ${fieldValue(bean: activityRoleTimeInstance, field: "role")}
                    </td>
                </tr>
            	 
                <tr class="prop">
                    <td valign="top" class="name">
                      <label for="estimatedTimeInHoursFlat"><g:message code="activityRoleTime.estimatedTimeInHoursFlat.label" default="Estimated Time In Hours (Flat)" /></label>
                    	<em>*</em>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursFlat', 'errors')}">
                        <g:textField name="estimatedTimeInHoursFlat" id="estimatedTimeInHoursFlat" value="${fieldValue(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursFlat')}" class="required"/>
                    </td>
                </tr>
            	
				<tr class="prop">
					<td valign="top" class="name">
                      <label for="estimatedTimeInHoursPerBaseUnits"><g:message code="activityRoleTime.estimatedTimeInHoursPerBaseUnits.label" default="Additional Time In Hours (Per Unit)" /></label>
                    	<em>*</em> 
                    </td>

                 	<td valign="top" class="value ${hasErrors(bean: activityRoleTimeInstance, field: 'estimatedTimeInHours', 'errors')}">
                        <g:textField name="estimatedTimeInHoursPerBaseUnits" id="estimatedTimeInHoursPerBaseUnits" value="${fieldValue(bean: activityRoleTimeInstance, field: 'estimatedTimeInHoursPerBaseUnits')}" class="required" />
                    </td>
               </tr>

            </tbody>
        </table>
    </div>
    
</g:form>
        
