<%
	def baseurl = request.siteUrl
%><script>

	var pSelect = null;
	
	jQuery(function() {

		var icons = {
				header: "ui-icon-circle-arrow-e",
				headerSelected: "ui-icon-circle-arrow-s"
			};
		
		
		jQuery( ".deliverableActivityAccordion" ).accordion({ 
        	change: function(event, ui){
        			refreshAccordionData();
                },
            icons: icons,
   			autoHeight: false,
   			navigation: true
		   
		});
				
		function refreshAccordionData(){
			var a =	jQuery('.deliverableActivityAccordion .ui-state-active').find('a');
            loadContents(a.attr('id'), a.attr("href"));
		}

		function loadContents(id, href){
			jQuery('#del-'+ id).html('');
			jQuery('#del-'+ id).append('<div class="list" id="delActivity" style="border: 0.1em #CDCDCD solid;">  </div>');
			jQuery('#del-'+ id).find('#delActivity').load(href);
			if(pSelect != null && pSelect != jQuery('#del-'+ id)){
				pSelect.html('');
			}

			pSelect = jQuery('#del-'+ id);
		}

		
		refreshAccordionData();
		
		jQuery( ".accordionContent" ).height(260);

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
		
	});
	</script>
	
<style>
		
	.deliverableActivityAccordion {
		width: 100% auto;
	}

</style>

	
<div id="accordion" class="deliverableActivityAccordion">
	<g:each in="${serviceProfileInstance?.listCustomerDeliverables(params)}" status="i" var="del">
		<h2><a id="${del.id}" href="${baseurl}/serviceActivity/listDeliverableActivities?id=${del.id}">Deliverable: ${del.name} [type: ${del.type}]</a></h2>
		<div class="accordionContent" id="del-${del.id}">
			
		</div>
	</g:each>
</div>

<div id="dvAddActivityTask" title="Add Service Activity Task" class="dvAddActivityTask"></div>
<div id="dvEditActivityTask" title="Edit Service Activity Task" class="dvEditActivityTask"></div>
<div id="dvDeleteActivityTask" title="Success" class="dvDeleteActivityTask">
	<p>Service Activity Task deleted successfully.</p>
</div>

<div id="dvChangeOrderActivityTask" title="Service Activity Task Change Order" class="dvChangeOrderActivityTask">
	
</div>
</div>

