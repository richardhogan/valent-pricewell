	var activityTasks = [];
	var sequenceOrder = 1;
	
	jQuery(document).ready(function()
	{
		jQuery( ".dvAddActivityTask" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			height: 250,
			width: 500,
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
			modal: true,
			autoOpen: false,
			height: 250,
			width: 500,
			close: function( event, ui ) {
				jQuery(this).html('');
				jQuery(this).empty();
				updateActivityTaskList();
			}
			
		});

		jQuery( ".dvChangeOrderActivityTask" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			width: 600,
			close: function( event, ui ) {
				jQuery(this).html('');
				jQuery(this).empty();
				updateActivityTaskList();
			}
			
		});

		jQuery( ".dvDeleteActivityTask" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			buttons: {
		        Ok: function() {
		          jQuery( this ).dialog( "close" );
		        }
		    },
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
