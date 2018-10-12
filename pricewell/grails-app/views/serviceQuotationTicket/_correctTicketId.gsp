

<%@ page import="com.valent.pricewell.ServiceQuotationTicket" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <script>
	   	jQuery(function() 
	   	{
	   		jQuery("#correctTicketIdFrm").validate();
	   	});
   	</script>
        <div class="body">
            
            <g:form method="post" action="update" name="correctTicketIdFrm">
                <g:hiddenField name="id" value="${serviceQuotationTicketInstance?.id}" />
                <g:hiddenField name="version" value="${serviceQuotationTicketInstance?.version}" />
                <div class="dialog">
                    <g:textField name="ticketId" value="${serviceQuotationTicketInstance?.ticketId}" class="required"/>
                    
                    <span class="button"><g:actionSubmit class="save buttons.button button" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
