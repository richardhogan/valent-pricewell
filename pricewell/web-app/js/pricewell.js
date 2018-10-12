if(jQuery) (function($) {
	
	$.extend($.fn, {
		dropdown: function(method, data) {
			
			switch( method ) {
				case 'hide':
					hideDropdowns();
					return $(this);
				case 'attach':
					return $(this).attr('data-dropdown', data);
				case 'detach':
					hideDropdowns();
					return $(this).removeAttr('data-dropdown');
				case 'disable':
					return $(this).addClass('dropdown-disabled');
				case 'enable':
					hideDropdowns();
					return $(this).removeClass('dropdown-disabled');
				case 'reload':
					bindDropdowns();
					return;
			}
			
		}
	});
	
	function showMenu(event) {
		
		var trigger = $(this),
			dropdown = $( $(this).attr('data-dropdown') ),
			isOpen = trigger.hasClass('dropdown-open'),
			hOffset = parseInt($(this).attr('data-horizontal-offset') || 0),
			vOffset = parseInt($(this).attr('data-vertical-offset') || 0);
		
		if( trigger !== event.target && $(event.target).hasClass('dropdown-ignore') ) return;
		
		event.preventDefault();
		event.stopPropagation();
		
		hideDropdowns();
		
		if( isOpen || trigger.hasClass('dropdown-disabled') ) return;
		
		dropdown
			.css({
				left: dropdown.hasClass('anchor-right') ? 
					trigger.offset().left - (dropdown.outerWidth() - trigger.outerWidth()) + hOffset : trigger.offset().left + hOffset,
				top: trigger.offset().top + trigger.outerHeight() + vOffset
			})
			.show();
		
		trigger.addClass('dropdown-open');
		
	};
	
	function hideDropdowns(event) {
		
		var targetGroup = event ? $(event.target).parents().andSelf() : null;
		if( targetGroup && targetGroup.is('.dropdown-menu') && !targetGroup.is('A') ) return;
		
		$('BODY')
			.find('.dropdown-menu').hide().end()
			.find('[data-dropdown]').removeClass('dropdown-open');
	};
	
	function bindDropdowns(){
		$('.[data-dropdown]').unbind('click.dropdown').bind('click.dropdown', showMenu);
		//$('BODY').bind('click.dropdown', '[data-dropdown]', showMenu);
		$('HTML').unbind('click.dropdown').bind('click.dropdown', hideDropdowns);
		// Hide on resize (IE7/8 trigger this when any element is resized...)
		if( !$.browser.msie || ($.browser.msie && $.browser.version >= 9) ) {
			$(window).unbind('resize.dropdown').bind('resize.dropdown', hideDropdowns);
		}	
	}
	
	function showReport(id, reportActionUrl)
	{
		jQuery.ajax({
			type: "POST",
			url: reportActionUrl,
			data: {id: id, source: "firstsetup"},
			success: function(data){
				//jQuery("#contents").html(data);
				alert(data);
			}, 
			error:function(XMLHttpRequest,textStatus,errorThrown){}
		});return false;
		
	}
	
	$(function () {
		bindDropdowns();
	});
	
})(jQuery);

jQuery.fn.getParent = function(num) {
    var last = this[0];
    for (var i = 0; i < num; i++) {
        last = last.parentNode;
    }
    return jQuery(last);
};

/*@param entityName: -  name to be printed in dialogs, for example, "GEO"
* @param entity: - name of domain name, for example, "GeoGroup"
* @param baseUrl: - base URL of actions, for eg. /pricewell
* @param actionsuffix: - suffix to insert afer grails acitons like list, create, etc., for e.g. setup
* @param dialogWifth: - Width of dialogs to use when creating or updating domain.
* @param dialogHeight: - Height of dialogs to use when creaitng or updating domain.
* @param allowCreate: - Create allowed or not.
* @param allowEdit: - Edit allowed or not.
* @param allowDelete: - Delete allowed or not.
* @param allowShow: - Show allowed or not.
*/
function AjaxPricewellList(entityName, entity, baseUrl, actionSuffix, dialogWidth, dialogHeight, allowCreate, allowEdit, allowDelete, allowShow){
	this.actionSuffix = actionSuffix
	this.entity = entity
	this.entityName = entityName
	this.baseUrl = baseUrl
	this.dialogWidth = dialogWidth
	this.dialogHeight = dialogHeight
	this.allowCreate = allowCreate
	this.allowEdit = allowEdit
	this.allowDelete = allowDelete
	this.allowShow = allowShow
	
	var s_entity = entity.charAt(0).toLowerCase() + entity.slice(1);
	var entityUrl = baseUrl + "/" + s_entity + "/"
	var dialogDiv = s_entity + 'Dialog'
	var xdialogDiv = '#' + dialogDiv
	var listDiv = s_entity + 'sList'
	var xlistDiv = '#' + listDiv
	var createTitle = "Add " + entityName
	var editTitle = "Edit " + entityName
	var showTitle = "Show " + entityName
	var deleteTitle = "Remove " + entityName
	var deleteMsg = "<div>Are you sure you want to delete " + entityName + "?</div>"; 
	var createBtn = "create" + entity
	var editBtnClass = ".edit" + entity
	var deleteBtnClass = ".delete" + entity
	var showBtnClass = ".show" + entity
	var createActionUrl = entityUrl + "create" + actionSuffix
	var editActionUrl = entityUrl + "edit" + actionSuffix
	var listActionUrl = entityUrl + "list" + actionSuffix
	var deleteActionUrl = entityUrl + "delete" + actionSuffix
	var showActionUrl = entityUrl + "show" + actionSuffix
	var reportActionUrl = entityUrl + "report" + actionSuffix
	
	AjaxPricewellList.prototype.init = function(){
		jQuery(xdialogDiv).dialog({
		            autoOpen: false, position:[400,200],
		            modal: true,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
		            
		        });
		
		
		jQuery(xlistDiv).dataTable({
				"sPaginationType": "full_numbers",
				"sDom": 't<"F"ip>',
		        "bFilter": true,
		        "fnDrawCallback": function() {
	                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
	                        jQuery('.dataTables_paginate').css("display", "block"); 
	                        jQuery('.dataTables_length').css("display", "block");                    
	                } else {
	                		jQuery('.dataTables_paginate').css("display", "none");
	                		jQuery('.dataTables_length').css("display", "none");
	                }
	            }
			});
		
		
				
			jQuery(xdialogDiv).dialog("close");
			
			if(allowCreate){
				jQuery("#" + createBtn).click(function(){
					/*jQuery(xdialogDiv).html('Loading .....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", createTitle );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);*/
					jQuery("#contents").html("Loading, please wait...");
					jQuery.ajax({
						type: "POST",
						url: createActionUrl,
						data: {source: "firstsetup"},
						success: function(data){
							jQuery("#contents").html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});

				});
			} else{
				
			}
			
			if(allowDelete){
			
				jQuery(deleteBtnClass).live('click', function()
				{
					var myid = this.id; //alert(entityName);
					var objectName = "";
				
					if(entityName == "DeliveryRole")
					{
						jQuery.ajax({
							type: "POST",
							url: entityUrl + "getDeliveryRoleName",
							data: {id: this.id, source: "firstsetup"},
							success: function(data){
								objectName =  data;
								deleteMsg = "Are you sure you want to delete the " + objectName + " role?";
								
								jConfirm(deleteMsg, 'Confirmation Dialog', function(r)
			    				{
									
								    if(r == true)
				    				{
								    	jQuery.ajax({
											type: "POST",
											url: deleteActionUrl,
											data: {id: myid, source: "firstsetup"},
											success: function(data){
												if(data == "can_not_delete_delivery_role")
												{
													jRAlert('Cannot delete a role that is assigned to a service.', 'Delete Message', function(r)
													{
														if(r == true)
														{
															//showReport(myid, reportActionUrl);
															
															jQuery.ajax({
																type: "POST",
																url: reportActionUrl,
																data: {id: myid, source: "firstsetup"},
																success: function(data){
																	//jQuery("#contents").html(data);
																	jQuery("#reportDv").dialog( "open" ).html(data);
																	//alert(data);
																}, 
																error:function(XMLHttpRequest,textStatus,errorThrown){}
															});return false;
														}
														return false;
													});
												}else
												{
													refreshGeoGroupList("firstsetup");
												}
												
											}, 
											error:function(XMLHttpRequest,textStatus,errorThrown){}
										});
				    				}
								});
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});	
						
					}
					else
					{
						
						if(entityName == 'Territory'){
							deleteMsg = "<div>Are you sure you want to delete " + entityName + "? All associated opportunities will be deleted.</div>";
						}
						
						jConfirm(deleteMsg, 'Confirmation Dialog', function(r)
	    				{
							
						    if(r == true)
		    				{
						    	jQuery.ajax({
									type: "POST",
									url: deleteActionUrl,
									data: {id: myid, source: "firstsetup"},
									success: function(data){
										if(data == "can_not_delete_delivery_role")
										{
											jRAlert('Delivery Role is under use in service, so can not delete it.', 'Delete Message', function(r)
											{
												if(r == true)
												{
													//showReport(myid, reportActionUrl);
													
													jQuery.ajax({
														type: "POST",
														url: reportActionUrl,
														data: {id: myid, source: "firstsetup"},
														success: function(data){
															//jQuery("#contents").html(data);
															jQuery("#reportDv").dialog( "open" ).html(data);
															//alert(data);
														}, 
														error:function(XMLHttpRequest,textStatus,errorThrown){}
													});return false;
												}
												return false;
											});
										}
										else if( data == "success"){
											refreshGeoGroupList("firstsetup");
										}
										else
										{
											jAlert(data);
 											refreshGeoGroupList("firstsetup");
 										}
										
									}, 
									error:function(XMLHttpRequest,textStatus,errorThrown){}
								});
		    				}
						});
					}
					
				});
			} else {
				
			}
			
			if(allowEdit){
				jQuery(editBtnClass).live('click', function(){
					/*jQuery(xdialogDiv).html('Loading .....');
					jQuery( xdialogDiv ).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", editTitle );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);*/
					//jQuery( xdialogDiv ).dialog('option', 'position', 'center');
					jQuery("#contents").html("Loading, please wait...");
					jQuery.ajax({
						type: "POST",
						url: editActionUrl,
						data: {id: this.id, source: "firstsetup"},
						success: function(data){
							jQuery("#contents").html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
			} else{
				
			}
			
			if(allowShow){
				jQuery(showBtnClass).live('click', function(){
					/*jQuery(xdialogDiv).html('Loading .....');
					jQuery( xdialogDiv).dialog( "open" );
					jQuery( xdialogDiv ).dialog( "option", "title", showTitle );
					jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
					jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
					jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);*/
					//jQuery( xdialogDiv ).dialog('option', 'position', 'center');
					jQuery("#contents").html("Loading, please wait...");
					jQuery.ajax({
						type: "POST",
						url: showActionUrl,
						data: {id: this.id, source: "firstsetup"},
						success: function(data){
							jQuery("#contents").html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});
			} else{
				
			}
			
		}
}