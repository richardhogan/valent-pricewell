<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>

    	<style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			
			.ui-autocomplete {
    			max-height: 100px;
    			overflow-y: auto;
    			/* prevent horizontal scrollbar */
    			overflow-x: hidden;
  			}
			
			/* IE 6 doesn't support max-height
   			* we use height instead, but this forces the menu to always be this tall
   			*/
   
			* html .ui-autocomplete {
    			height: 100px;
  			}
		</style>
		
		<g:setProvider library="prototype"/>
		<script>
			var activityTasks = [];
			var sequenceOrder = 1;
			
			jQuery(document).ready(function()
			{
				//jQuery.getScript("${baseurl}/js/jquery.validate.js", function() 
				//{
							jQuery.validator.messages.required = "Required field";
							jQuery.validator.messages.number = "Numbers only";
							jQuery.validator.setDefaults({
							    errorPlacement: function(error, element) {
							        if (element.hasClass("special-error")) {
							           error.insertBefore(element);
							        }else{
							        	error.insertAfter(element);
								       }
							    }
							});
							
							jQuery("#addActivity").validate();
							jQuery("#addActivity input:text")[0].focus();
							jQuery.validator.addMethod("uniquerole", function(value, element){
	
								
								var all =  jQuery("#childList select");
	
								var count = 0;
								for(var i=0; i<all.length; i++){
									
									if(jQuery(all[i]).val() == value){
											count++;
										}
								}
	
								return (count == 1);}, "This field is unique");
				//});
				jQuery( "#addActivity" ).submit(function( event )
				{
					if(jQuery('#addActivity').validate().form())
					{
						showLoadingBox();
				    	jQuery.ajax(
						{
							type: "POST",
							url: "${baseurl}/serviceActivity/saveFromDeliverable?activityTasks="+JSON.stringify(activityTasks),
							data: jQuery("#addActivity").serialize(),
							success: function(data)
							{
								hideLoadingBox();
								jQuery('#delActivity').html(data);
								hideUnhideNextBtn();
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								alert("Error while saving");
							}
						});
    				}
					return false
				});
				
				jQuery(".btnAddActivity").click(function()
				{
					//jQuery("#category").val(jQuery("#defaultCategory").val());
					jQuery( "#addActivity" ).submit();
					
						/*if(jQuery('#defaultCategory').val() == "" && jQuery('#costumeCategory').val() == "")
						{
							jAlert('Activity type not defined. Please select from default list or create custome one.', 'Type Not Define Alert');
							return false;
						}	
						
						else if(jQuery('#defaultCategory').val() != "" && jQuery('#costumeCategory').val() != "")
						{
							jConfirm('You have defined default type and costume both. Which type you want to keep? For default one press Yes, for costume one press No.', 'Please Confirm', function(r)
		    				{
							    if(r == true)
			    				{
			    					jQuery("#category").val(jQuery("#defaultCategory").val());
			    					jQuery( "#addActivity" ).submit();
			    				}
							    else
								{
							    	jQuery("#category").val(jQuery("#costumeCategory").val());
							    	jQuery( "#addActivity" ).submit();
								}
							});
						}
							
						else if(jQuery('#defaultCategory').val() != "")
						{
							jQuery("#category").val(jQuery("#defaultCategory").val());
							jQuery( "#addActivity" ).submit();
						}
							
						else if(jQuery("#costumeCategory").val() != "")
						{
							jQuery("#category").val(jQuery("#costumeCategory").val());
							jQuery( "#addActivity" ).submit();
						}*/
						
					return false;
				}); 
				
				jQuery("#btnCancel").click(function()
				{
					
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/serviceActivity/listDeliverableActivities",
						data: {id: ${serviceDeliverableId}},
						success: function(data)
						{
							
							jQuery("#delActivity").html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
					});
					
					return false;
				}); 
				

				jQuery(".changeTaskOrder").live( "click", function() 
				{
					jQuery( ".dvChangeOrderActivityTask" ).dialog( "open" );
					showLoadingBox();
					jQuery.ajax(
					{
						type:'POST',
					 	url:'${baseurl}/serviceActivityTask/changeOrders',
					 	data: {activityTasks: JSON.stringify(activityTasks)},
					 	success:function(data,textStatus)
					 	{
					 		hideLoadingBox();
					 		jQuery('.dvChangeOrderActivityTask').html(data);	
							
					 	},
					 	error:function(XMLHttpRequest,textStatus,errorThrown)
					 	{hideLoadingBox();}
					});
						
					return false;
				}); 

				jQuery( ".dvAddActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {
						if(jQuery(this).data('taskId') != "" && jQuery(this).data('taskId') != null)
						{
							addTaskToList(jQuery(this).data('taskId'));
							jQuery(this).data('taskId', "");
						}
						//myFunction();
						jQuery(this).html('');
						jQuery(this).empty();
					}
					
				});

				jQuery( ".dvEditActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {
						jQuery(this).html('');
						jQuery(this).empty();
						updateActivityTaskList();
					}
					
				});

				jQuery( ".dvChangeOrderActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {
						jQuery(this).html('');
						jQuery(this).empty();
						updateActivityTaskList();
					}
					
				});

				jQuery( ".dvDeleteActivityTask" ).dialog(
			 	{
					close: function( event, ui ) {

						if(jQuery(this).data('taskId') != "" && jQuery(this).data('taskId') != null)
						{
							//alert(jQuery(this).data('taskId'));
							deleteTaskToList(jQuery(this).data('taskId'));
							jQuery(this).data('taskId', "");
						}
						//jQuery(this).html('');
					}
					
				});

				var availableServiceActivityCategories = ${serviceActivityCategories as JSON};

		 		jQuery("#category").autocomplete({
			    	source: availableServiceActivityCategories
			    });
		 		
		 		jQuery("#category").keyup(function(){
				    this.value = this.value.toUpperCase();
				});
			});	  	  
				
			function addSequenceOrderToThisTask(id, sequenceOrder)
			{
				showLoadingBox();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceActivityTask/updateSequenceOrder",
					data: {id: id, sequenceOrder: sequenceOrder},
					success: function(data)
					{
						hideLoadingBox();
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
			
			function addTaskToList(id)
			{
				activityTasks.push(new Number(id));
				addSequenceOrderToThisTask(id, sequenceOrder);
				sequenceOrder++;
				updateActivityTaskList();
			}

			function deleteTaskToList(id)
			{
				var tempArray = [];
				for(j=0; j < activityTasks.length; j++)
				{
					tempArray.push(activityTasks[j]);
				}
				activityTasks = [];

				for (i = 0; i < tempArray.length; i++) { 
				    //text += cars[i] + "<br>";
				    if(tempArray[i] != id)
					    activityTasks.push(tempArray[i]);
				}

				//alert(activityTasks);
				//activityTasks.splice(activityTasks.indexOf(id), 1);
				//alert(activityTasks);
				updateActivityTaskList();
			}

			function updateActivityTaskList()
			{
				showLoadingBox();
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceActivityTask/listServiceActivityTasks",
					data: {taskList: JSON.stringify(activityTasks)},
					success: function(data)
					{
						jQuery("#dvServiceActivityTaskList").html(data);
						hideLoadingBox();
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
			
			function thisFn()
			{
				alert(1);
			}

			function serviceActivityList()
			{
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceActivity/listDeliverableActivities",
					data: {'id': ${serviceDeliverableId}},
					success: function(data){jQuery("#delActivity").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
				
				return false;
			}
  		</script>

<!--  <span style="font-size: 100%"> <b> Add Activity for ${deliverable} </b> </span> -->
<div class="nav">
    <span>
    	<!--<g:remoteLink class="buttons.button button" title="List Of Activity" id="${serviceDeliverableId}" action="listDeliverableActivities" controller="serviceActivity" update="[success:'delActivity',failure:'delActivity']">List Activities</g:remoteLink>-->
    	
    	<a id="idServiceActivityList" onclick="serviceActivityList();" class="buttons.button button" title="List Of Activity">List Activities</a>
    </span>
    	
</div>
<div class="body">
    
    <g:form action="save" name="addActivity">
        <div class="dialog">
        	<g:hiddenField name="serviceDeliverableId" value="${serviceDeliverableId}"></g:hiddenField>
        	<%--<g:hiddenField name="category" value=""></g:hiddenField>--%>
        	<g:render template="/serviceActivity/deliverableActivity" model="['serviceActivityInstance':serviceActivityInstance]"/>
            
            <div id="dvServiceActivityTaskList">
        		<g:render template="/serviceActivityTask/activityTaskList" model="['serviceActivityTaskList':serviceActivityInstance?.activityTasks]"/>
        	</div>
        </div>
        <div class="buttons">
        	<!-- <button id="btnAddActivity" class="btnAddActivity" title="Create Activity">Create</button>-->
        	
        	<button id="btnAddActivity" class="btnAddActivity" title="Create Activity">Save And Add Role</button>
        	<g:if test="${deliverable?.serviceActivities && deliverable?.serviceActivities.size() > 0}">
            	<button title="Cancel" id="btnCancel"> Cancel </button>
           	</g:if>
        </div>
    </g:form>
    
     <!--<g:render template='/serviceActivity/activityRoleTime' model="['activityRoleTimeInstance':null,'i':'_clone','hidden':true]"/>-->
    
</div>    