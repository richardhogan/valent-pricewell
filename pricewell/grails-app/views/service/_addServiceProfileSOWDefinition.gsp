<g:set var="tmpDefinitionList" value="${definitionList? definitionList: serviceProfileInstance?.defs}" />
<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>

<script>
	function hideUnhideNextBtnForDefinition()
	{
		jQuery.ajax({
            url: '${baseurl}/service/hasSOWDefinition?id=' + <%=serviceProfileInstance?.id%>,
            type: 'POST', async: false, cache: false, timeout: 30000,
            error: function(){
                return false;
            },
            success: function(msg)
            { 
               if(msg == 'true')
               {
               		//jQuery('.swMain .buttonPrevious').removeClass("buttonDisabled").removeClass("buttonHide");
           			if('${serviceProfileInstance?.isImported}' != "true" && '${serviceProfileInstance?.workflowMode}' != "customized")
               		{
           				if(jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
                   		{
                       		jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
                   		}
                    } 
           			else
               		{
           				if(jQuery('.swMain .buttonFinish').hasClass('buttonDisabled'))
                   		{
                       		jQuery('.swMain .buttonFinish').removeClass("buttonDisabled").removeClass("buttonHide");
                   		}
                   	}       				
        				
        			
    				
    				/*jConfirm('Do you want to add another Deliverable?', 'Please Confirm', function(r)
    				{
					    if(r == true)
	    				{
	    					jQuery.ajax({type:'POST',data: {id: <%=serviceProfileInstance.id %> },
								 url:'${baseurl}/service/addDeliverable',
								 success:function(data,textStatus){jQuery('#mainCustomerDeliverablesTab').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
	    				}
					});*/
               }
               else
               {
               		
              			//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
           			if('${serviceProfileInstance?.isImported}' != "true" && '${serviceProfileInstance?.workflowMode}' != "customized")
               		{
           				if(!jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
                   		{
                       		jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
                   		}
                    }
           			else
               		{
           				if(!jQuery('.swMain .buttonFinish').hasClass('buttonDisabled'))
                   		{
                       		jQuery('.swMain .buttonFinish').addClass("buttonDisabled").addClass("buttonHide");
                   		}
                   	}
        			
        			    				
    				/*jConfirm('Do you want to add Deliverable now?', 'Please Confirm', function(r)
    				{
					    if(r == true)
	    				{
	    					jQuery.ajax({type:'POST',data: {id: <%=serviceProfileInstance.id %> },
								 url:'${baseurl}/service/addDeliverable',
								 success:function(data,textStatus){jQuery('#mainCustomerDeliverablesTab').html(data);},
								 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
	    				}
					});*/
               }
                  
               return false;  
            }
        });
	}
</script>
<div id="mainSOWDefinitionTab">

	<g:if test="${!hasDefaultSOWDefinition }">
		<g:render template="/serviceProfileSOWDef/addDefaultSOWDefinition" model="['serviceProfileId': serviceProfileInstance.id, 'defaultSowLanguageTemplate': defaultSowLanguageTemplate]"/>
	</g:if>
	<g:else>
		<g:if test="${definitionList && definitionList.size() > 0}">
			<g:render template="/serviceProfileSOWDef/listServiceProfileSOWDefinition" model="['serviceProfileInstance': serviceProfileInstance, 'territoryList': territoryList, 'hasDefaultSOWDefinition': hasDefaultSOWDefinition, 'defaultSowDef': defaultSowDef, 'readOnly': readOnly]"/>
		</g:if>
		<g:else>
			<g:render template="/serviceProfileSOWDef/newServiceProfileSOWDefinition" model="['serviceProfileId': serviceProfileInstance.id, 'definitionList': definitionList, 'defaultSowLanguageTemplate': defaultSowLanguageTemplate]"/>
		</g:else>
	</g:else>
	

</div>