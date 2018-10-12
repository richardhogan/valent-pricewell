
<%@ page import="com.valent.pricewell.ProjectParameter" %>
<%@ page import="com.valent.pricewell.SowSupportParameter" %>
<%@ page import="com.valent.pricewell.Quotation" %>

<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>
	function hideUnhideNextBtn()
	{
		jQuery.ajax({
            url: '${baseurl}/quotation/hasProjectParameters',
            data: {id: ${quotationInstance?.id}},
            type: 'POST', async: false, cache: false, timeout: 30000,
            error: function(){
                return false;
            },
            success: function(msg)
            { 
               if(msg == 'true')
               {
               		if(jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
	       			}
               }
               else
               {
               		if(!jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
        			}
               }
                  
               return false;  
            }
        });
	}
</script>

<div id="mainSOWProjectParametersTab">

	<g:render template="/projectParameter/addProjectParameter" model="['quotationInstance': quotationInstance, 'projectParameterInstance': projectParameterInstance, 'isReadOnly': isReadOnly,'sowSupportParameterList':sowSupportParameterList]"/>

	<%-- 
		<g:if test="${quotationInstance?.projectParameters?.size() > 0}">
			<g:render template="/projectParameter/listProjectParameters" model="['quotationId': quotationInstance?.id, 'quotationInstance': quotationInstance, 'projectParameters': quotationInstance?.projectParameters, 'isReadOnly': isReadOnly,'sowSupportParameterList':sowSupportParameterList]"/>
		</g:if>
		<g:else>
			<g:render template="/projectParameter/createProjectParameter" model="['quotationId': quotationInstance?.id, 'projectParameters': quotationInstance?.projectParameters, 'projectParameterInstance': projectParameterInstance,'sowSupportParameterList':sowSupportParameterList]"/>
		</g:else>
	 --%>
	

</div>