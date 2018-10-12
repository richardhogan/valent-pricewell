<%
	def baseurl = request.siteUrl
%>

<g:setProvider library="prototype"/>
<script>
	function hideUnhideNextBtn()
	{
		jQuery.ajax({
            url: '${baseurl}/service/hasActivityRoleDefine?id=' + <%=del?.serviceProfile?.id%>,
            type: 'POST', async: false, cache: false, timeout: 30000,
            error: function(){
                return false;
            },
            success: function(msg)
            { 
               var deliverableActivitySize = ${del?.serviceActivities?.size()};
               var isImported = ${isImported};
               if(msg == 'true')
               {
               		if(jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
            			/*if( isImported != true)
            				{jQuery('.swMain .buttonPrevious').removeClass("buttonDisabled").removeClass("buttonHide");}*/
        			}

               		//askForNew();
               }
               else
               {
               		if(!jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
               		{
            			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
						/*if(isImported != true)
            				{jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");}*/
        			}

               		//askForNew();
               }
                    
            }
        });
	}

	function askForNew()
	{
		var deliverableActivitySize = ${del?.serviceActivities?.size()};
		if(deliverableActivitySize > 0)
     	{
       		jConfirm('Do you want to add another Activity?', 'Please Confirm', function(r)
				{
				    if(r == true)
   				{
   					jQuery.ajax({type:'POST',
  	    					 url:'${baseurl}/service/addActivity?deliverableId='+<%=del.id%>,
							 success:function(data,textStatus){jQuery('#customerDeliverableActivitiesTab').html(data);},
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;
   				}
				});
     	}
	}
</script>
<div id="customerDeliverableActivitiesTab">

	<g:if test="${activitiesList && activitiesList.size() > 0}">
		<g:render template="/serviceActivity/listDeliverableActivities" model="['serviceDeliverableInstance': del, 'activitiesList': activitiesList]"/>
	</g:if>
	<g:else>
		<g:render template="/serviceActivity/createDeliverableActivity" model="['serviceDeliverableId': del.id, 'deliverable': del, 'serviceActivityCategories': serviceActivityCategories]"/>
	</g:else>
	
</div>