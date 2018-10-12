<g:set var="tmpDeliverablesList"
	value="${deliverablesList? deliverablesList: serviceProfileInstance.listCustomerDeliverables()}" />
<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>
	function hideUnhideNextBtn()
	{
		jQuery.ajax({
            url: '${baseurl}/service/hasDeliverables?id=' + <%=serviceProfileInstance?.id%>,
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
            			//jQuery('.swMain .buttonPrevious').removeClass("buttonDisabled").removeClass("buttonHide");
        				
        				
        			}
    				
    				jConfirm('Do you want to add another Deliverable?', 'Please Confirm', function(r)
    				{
					    if(r == true)
	    				{
	    					jQuery.ajax({type:'POST',data: {id: <%=serviceProfileInstance.id %> },
								 url:'${baseurl}/service/addDeliverable',
								 success:function(data,textStatus){jQuery('#mainCustomerDeliverablesTab').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
	    				}
					});
               }
               else
               {
               		if(!jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
            			//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
        			}
        			    				
    				jConfirm('Do you want to add Deliverable now?', 'Please Confirm', function(r)
    				{
					    if(r == true)
	    				{
	    					jQuery.ajax({type:'POST',data: {id: <%=serviceProfileInstance.id %> },
								 url:'${baseurl}/service/addDeliverable',
								 success:function(data,textStatus){jQuery('#mainCustomerDeliverablesTab').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
	    				}
					});
               }
                  
               return false;  
            }
        });
	}
</script>
<div id="mainCustomerDeliverablesTab">

	<g:if test="${deliverablesList && deliverablesList.size() > 0}">
		<g:render template="/serviceDeliverable/listCustomerDeliverables" model="['serviceProfileInstance': serviceProfileInstance, 'deliverablesList': deliverablesList]"/>
	</g:if>
	<g:else>
		<g:render template="/serviceDeliverable/newCustomerDeliverable" model="['serviceProfileId': serviceProfileInstance.id, 'deliverablesList': deliverablesList, 'deliverableTypes':deliverableTypes]"/>
	</g:else>
	

</div>