
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="org.apache.shiro.SecurityUtils"%>

<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
        
		<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
		</style>
		
		<script>
			 			 
			 jQuery(document).ready(function()
			 {
			 	
			    jQuery("#serviceTicketConfigurationFrm").validate();

			    jQuery( "#continueBtn" ).button().click(function() 
				{
					if(jQuery('#serviceTicketConfigurationFrm').validate().form())
					{
						showLoadingBox();
    	   				jQuery.post( '${baseurl}/quotation/createServiceTicket', 
               				  jQuery("#serviceTicketConfigurationFrm").serialize(),
						      function( data ) 
						      {
    	   						  hideLoadingBox();	
    	   						  if(data['result'] == "success")
        	   					  {
    	   								jQuery( "#serviceTicketConfigurationDialog" ).dialog("close");
    	   								jQuery( "#responseDialog" ).dialog( "option", "title", "Success" );
    	   								jQuery( "#responseDialog" ).html(data['msg']).dialog("open");
                	   			  }					          
						      });
                		
               		}
					return false;
				});

			    jQuery( "#responseDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#responseDialog" ).dialog( "close" );
							location.reload();
							return false;
						}
					}
				});

			    jQuery("#board").change(function () 
		    	{
			    	showLoadingBox();
		    		jQuery.ajax({type:'POST',data: {board: this.value },
						 url:'${baseurl}/quotation/getRelatedConfiguration',
						 success:function(data,textStatus)
						 {
							 hideLoadingBox();	
							 jQuery('#statusNameDv').html(data['statusNameContent']);
							 jQuery('#servicetypeDv').html(data['serviceTypeContent']);
						 },
						 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
		    	});
			    	
			 });
  		</script>
        
    </head>
    
    <body>
        
        <div class="body">
            
            <div id="responseDialog">
				
			</div>
            <g:form action="createServiceTicket" name="serviceTicketConfigurationFrm">
            	<g:hiddenField name="quotationId" value="${quotationInstance.id}" />
                
                <div class="dialog">
                    <table>
                        <tbody>
							<tr class="prop">
                                <td valign="top" class="name">
                                    <label for="serviceBoard"><g:message code="ticket.serviceBoard.label" default="Service Board" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top">
                                    <g:select name="board" from="${serviceBoard}" value="" class="required"/>
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
                                    <label for="source"><g:message code="ticket.source.label" default="Source" /></label><em>*</em>
                                </td>
                                <td valign="top">
                                    <g:select name="source" from="${serviceSource}" value="" class="required"/>
                                </td>
                                
                            </tr>
                            
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status"><g:message code="ticket.status.label" default="Status" /></label>
                                    <em>*</em>
                                </td>
                                <td valign="top">
                                	<div id="statusNameDv">
                                		<g:select name="statusName" from="${serviceStatus}" value="" class="required"/>
                                	</div>
                                    
                                </td>
                                
                                <td>&nbsp;&nbsp;</td>
								
								<td valign="top" class="name">
                                    <label for="priority"><g:message code="ticket.priority.label" default="Priority" /></label><em>*</em>
                                </td>
                                <td valign="top">
                                    <g:select name="priority" from="${priority}" value="" class="required"/>
                                </td>
                                
                            </tr>
                            
                            <tr>
                            	<td valign="top" class="name">
                                    <label for="serviceType"><g:message code="ticket.serviceType.label" default="Service Type" /></label><em>*</em>
                                </td>
                                <td valign="top">
                                	<div id="servicetypeDv">
                                		<g:select name="serviceType" from="${serviceType}" value="" class="required"/>
                                	</div>
                                    
                                </td>
                            </tr>
                           
                        </tbody>
                    </table>
                    
                </div>
                <div class="buttons">
                    <span class="button"><button title="Create Service Ticket" id="continueBtn">Continue</button></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
