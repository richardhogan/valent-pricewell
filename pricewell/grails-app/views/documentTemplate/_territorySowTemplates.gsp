<%@ page import="com.valent.pricewell.SowIntroduction" %>
<%@ page import="com.valent.pricewell.SowSupportParameter" %>
<%
	def baseurl = request.siteUrl
%>		

	<style type="text/css">
		fieldset{
		  height: 0;
		  overflow: hidden;
		}
		fieldset.active {
		  height: auto;
		}
	</style>
	
<!-- <script src="${baseurl}/js/ckeditor/ckeditor.js"></script>-->
	<script> 
    	function refreshGeoGroupList(source)
		{
			if(source == "firstsetup")
				{refreshNavigation();}
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/sowIntroduction/listsetup",
				data: {source: "${source}",type: "${type}"},
				success: function(data){
					if(source == "firstsetup" || type == "PROJECTPARAMS")
					{jQuery('#contents').html(data);}
					else
					{jQuery('#dvsetting').html(data);}
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
		
    	function refreshGeoGroupListForSupportParameter(source)
		{
			if(source == "firstsetup")
				{refreshNavigation();}
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/sowSupportParameter/listsetup",
				data: {source: "${source}"},
				success: function(data){
					if(source == "firstsetup")
					{jQuery('#contents').html(data);}
					else
					{jQuery('#dvsetting').html(data);}
				}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}

    	function refreshTerritorySowTemplate(id)
    	{
    		jQuery.ajax({type:'POST',data: {territoryId: id},
				url:'${baseurl}/documentTemplate/sowDocumentTemplates',
				success:function(data,textStatus){jQuery('#contents').html('');jQuery('#contents').html(data);},
				error:function(XMLHttpRequest,textStatus,errorThrown){}});	
        }
		
		var ajaxList = new AjaxPricewellList("setting", "setting", "${baseurl}", "setup", 750, 600, true, true, true, true);
		
		jQuery(document).ready(function()
	 	{
			ajaxList.init();

			jQuery('legend.togvis').click(function() {
				//jQuery(this).closest("#mycontent").hide();
			    //return false;
			    var fieldset = jQuery(this).parent();
			    var isWrappedInDiv = jQuery(fieldset.children()[0]).is('div');
			
			    if (isWrappedInDiv) {
			        fieldset.find("div").slideToggle();
			    } else {
			        fieldset.wrapInner("<div>");
			        jQuery(this).appendTo(jQuery(this).parent().parent());
			        fieldset.find("div").slideToggle();
			    }
			});

			jQuery('legend.togvis').trigger('click');

			var deleteSetupMsg = "<div>Are you sure you want to delete Sow Introduction?</div>";

	 		var xdialogDiv = "#sowIntroductionDialog";
			jQuery('.createsowIntroductionSetup').click(function () 
			{
				 var dialogWidth = 800; var dialogHeight = 600;

				jQuery( xdialogDiv ).show();
				jQuery( "#resultDialog" ).hide();
				jQuery( xdialogDiv ).html('Loading, please wait.....');
				jQuery( xdialogDiv ).dialog( "open" );
				jQuery( xdialogDiv ).dialog( "option", "title", "Create SOW Introduction" );
				jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
				jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
				jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);
				jQuery.ajax({
					type: "POST", 
					url: "${baseurl}/sowIntroduction/createsetup",
					data: {source: 'setup',geoId: ${geoInstance?.id}},
					success: function(data){
						jQuery(xdialogDiv).html(data);
						
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
				return false;
					
			});
			
			jQuery(".editsowIntroductionSetup").click(function(){
				jQuery( xdialogDiv ).show();
				jQuery( "#resultDialog" ).hide();
				jQuery( xdialogDiv ).html('Loading, please wait.....');
				jQuery( xdialogDiv ).dialog( "open" );
				jQuery( xdialogDiv ).dialog( "option", "title", "Edit SOW Introduction" );
				jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
				jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowIntroduction/editsetup",
					data: {id: this.id, source: 'setup'},
					success: function(data){
						jQuery( xdialogDiv ).html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});
			
			jQuery(".showsowIntroductionSetup").click(function(){
				jQuery(xdialogDiv).html('Loading, please wait.....');
				jQuery(xdialogDiv).dialog( "open" );
				jQuery(xdialogDiv).dialog( "option", "title", "Show Sow Introduction" );
				jQuery(xdialogDiv).dialog( "option", "zIndex", 1500 ); jQuery(xdialogDiv).dialog( "option", "width", 800);
				jQuery(xdialogDiv).dialog( "option", "maxHeight", 600);
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowIntroduction/showsetup",
					data: {id: this.id, source: 'setup'},
					success: function(data){
						jQuery(xdialogDiv).html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});
			
			jQuery(".deletesowIntroductionSetup").click(function()
			{
				var myid = this.id;
				var btns = {};
				btns["Yes"] = function()
				{ 
					jQuery.ajax(
					{						
						type: "POST",
						url: "${baseurl}/sowIntroduction/deletesetup",
						data: {id: myid, source: 'setup'},
						success: function(data)
						{
							if(data == "success")
							{
								alert("SOW Introduction is removed successfully");
								
								refreshNavigation();
								jQuery('#definedTerritoryId').val(jQuery('#definedTerritoryId').val());
								jQuery('#definedTerritoryId').trigger('change');							    		         
								jQuery( xdialogDiv ).dialog( "close" );
							}
							else{
								jQuery('#definedTerritoryId').val(jQuery('#definedTerritoryId').val());
								jQuery('#definedTerritoryId').trigger('change');
								jQuery( xdialogDiv ).dialog( "close" );
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				    jQuery(this).dialog("close");
				};
				btns["No"] = function(){ 
					jQuery(this).dialog("close");
				};
				jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/sowIntroduction/getName",
						data: {id: myid, source: 'setup'},
						success: function(data){
							jQuery(deleteSetupMsg).dialog({
							    autoOpen: true,
							    title: "Delete Sow Introduction : " + data,
							    modal:true,
							    buttons:btns
							});
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				
					  
			});
			
			jQuery( "#reportDv" ).dialog(
			{
				maxHeight: 600,
				width: 800,
				modal: true,
				autoOpen: false,
				close: function( event, ui ) {
						jQuery(this).html('');
					}
				
			});
		
	 	});
		//Ankit Start
		
		jQuery(document).ready(function()
	 	{	
			//ajaxList.init();
				
	 		var deleteSetupMsg = "<div>Are you sure you want to delete Project Parameter?</div>";

	 		var xdialogDiv = "#sowSupportParameterDialog";
			jQuery('.createSowSupportParameterSetup').click(function () 
			{
				this.toggle();
				 var dialogWidth = 800; var dialogHeight = 600;
		 
				jQuery( xdialogDiv ).show();
				jQuery( "#resultDialog" ).hide();
				jQuery( xdialogDiv ).html('Loading, please wait.....');
				jQuery( xdialogDiv ).dialog( "open" );
				jQuery( xdialogDiv ).dialog( "option", "title", "Create Project Parameter" );
				jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
				jQuery( xdialogDiv ).dialog( "option", "width", dialogWidth);
				jQuery( xdialogDiv ).dialog( "option", "maxHeight", dialogHeight);
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowSupportParameter/createsetup",
					data: {source: 'setup',geoId: ${geoInstance?.id},type:'PROJECTPARAMS'},
					success: function(data){
						jQuery(xdialogDiv).html(data);
						
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
				return false;
					
			});
			
			jQuery(".editSowSupportParameterSetup").click(function(){
				jQuery( "#createSowSupportParameterSetup" ).hide();
				jQuery( xdialogDiv ).show();
				jQuery( "#resultDialog" ).hide();
				jQuery( xdialogDiv ).html('Loading, please wait.....');
				jQuery( xdialogDiv ).dialog( "open" );
				jQuery( xdialogDiv ).dialog( "option", "title", "Edit Project Parameter" );
				jQuery( xdialogDiv ).dialog( "option", "zIndex", 1500 );
				jQuery( xdialogDiv ).dialog( "option", "width", 800); jQuery( xdialogDiv ).dialog( "option", "maxHeight", 600);
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowSupportParameter/editsetup",
					data: {id: this.id, source: 'setup', type:'PROJECTPARAMS'},
					success: function(data){
						jQuery( xdialogDiv ).html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});
			
			jQuery(".showSowSupportParameterSetup").click(function(){
				jQuery( "#createSowSupportParameterSetup" ).show();
				jQuery(xdialogDiv).html('Loading, please wait.....');
				jQuery(xdialogDiv).dialog( "open" );
				jQuery(xdialogDiv).dialog( "option", "title", "Show Project Parameter" );
				jQuery(xdialogDiv).dialog( "option", "zIndex", 1500 ); jQuery(xdialogDiv).dialog( "option", "width", 800);
				jQuery(xdialogDiv).dialog( "option", "maxHeight", 600);
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/sowSupportParameter/showsetup",
					data: {id: this.id, source: 'setup', type:'PROJECTPARAMS'},
					success: function(data){
						jQuery(xdialogDiv).html(data);
					}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){}
				});
			});
			
			jQuery(".deleteSowSupportParameterSetup").click(function()
			{
				jQuery( "#createSowSupportParameterSetup" ).show();
				var myid = this.id;
				var btns = {};
				btns["Yes"] = function()
				{ 
					jQuery.ajax(
					{						
						type: "POST",
						url: "${baseurl}/sowSupportParameter/deletesetup",
						data: {id: myid, source: 'setup', type:'PROJECTPARAMS'},
						success: function(data)
						{
							if(data == "success")
							{
								alert("Project Parameter is removed successfully");
								
								refreshNavigation();
								jQuery('#definedTerritoryId').val(jQuery('#definedTerritoryId').val());
								jQuery('#definedTerritoryId').trigger('change');							    		               
								jQuery( xdialogDiv ).dialog( "close" );
							}
							else{
								jQuery('#definedTerritoryId').val(jQuery('#definedTerritoryId').val());
								jQuery('#definedTerritoryId').trigger('change');
								jQuery( xdialogDiv ).dialog( "close" );
							}
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				    jQuery(this).dialog("close");
				};
				btns["No"] = function(){ 
					jQuery(this).dialog("close");
				};
				jQuery.ajax(
					{
						type: "POST",
						url: "${baseurl}/sowSupportParameter/getName",
						data: {id: myid, source: 'setup', type:'PROJECTPARAMS'},
						success: function(data){
							jQuery(deleteSetupMsg).dialog({
							    autoOpen: true,
							    title: "Delete Project Parameter : " + data,
							    modal:true,
							    buttons:btns
							});
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				
			});
			
			jQuery( "#reportDv" ).dialog(
			{
				maxHeight: 600,
				width: 800,
				modal: true,
				autoOpen: false,
				close: function( event, ui ) {
						jQuery(this).html('');
					}
				
			});
	 	});
		//Ankit End
		
		jQuery(document).ready(function()
	 	{
				jQuery( "#importSOWSuccessDialog" ).dialog(
			 	{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() 
						{							 


							var territoryId = jQuery(this).data('id');
							jQuery.ajax({type:'POST',data: {territoryId: territoryId},
			   					url:'${baseurl}/documentTemplate/sowDocumentTemplates',
			   					success:function(data,textStatus){jQuery('#contents').html('');jQuery('#contents').html(data);},
			   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
			   		 			
							jQuery( "#importSOWSuccessDialog" ).dialog( "close" );
							//alert(id);
							return false;
						}
					}
				});
						
				jQuery( "#importSOWFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#importSOWFailureDialog" ).dialog( "close" );
							location.reload();
							return false;
						}
					}
				});
					    
				jQuery( ".importSOWBtn" ).click(function() 
				{
					jQuery.ajax({type:'POST',
	   					url:'${baseurl}/documentTemplate/importSowTemplate',
	   					data: {id: ${geoInstance?.id}},
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#importSOWDialog').html(data);
						 	jQuery("#importSOWDialog").dialog("open");
						},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});

					//url:'/setting/importSOWTemplate',
					return false;
				});

				jQuery( ".reimportSOWBtn" ).click(function() 
				{
					jQuery.ajax({type:'POST',
	   					url:'${baseurl}/documentTemplate/importSOWTemplate',
	   					data: {id: ${geoInstance?.id}},
	   					success:function(data,textStatus)
	   					{
		   					jQuery('#importSOWDialog').html(data);
						 	jQuery("#importSOWDialog").dialog("open");
						},
	   					error:function(XMLHttpRequest,textStatus,errorThrown){}});
					return false;
				});

				jQuery(".editSowDocumentTemplate").click(function(){
					jQuery("#sowDocumentTemplateDialog").html('Loading, please wait.....');
					jQuery("#sowDocumentTemplateDialog").dialog( "open" );
					jQuery("#sowDocumentTemplateDialog").dialog( "option", "zIndex", 1500 );

					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/documentTemplate/editsetup",
						data: {id: this.id, source: 'setup'},
						success: function(data){
							jQuery("#sowDocumentTemplateDialog").html(data);
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});

				jQuery(".deleteSowDocumentTemplate").click(function()
				{
					showLoadingBox();
					
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/documentTemplate/deletesetup",
						data: {id: this.id, source: 'setup'},
						success: function(data)
						{
							hideLoadingBox();
							if(data == "success")
							{
								refreshTerritorySowTemplate(${geoInstance?.id});
								refreshNavigation();
							}
							
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){}
					});
				});

							
				jQuery( ".previewSowDocumentTemplate" ).click(function() 
				{
					var id = this.id;
					window.location = "${baseurl}/documentTemplate/downloadSowPreview/"+id;
					return false;
				});

				jQuery("#selectDefaultDiv").hide();
				jQuery( "#setDefaultSowBtn" ).click(function() 
				{
					jQuery("#setDefaultSowBtn").hide();
					jQuery("#selectDefaultDiv").show();
					return false;
				});

				jQuery( "#cancelDefaultBtn" ).click(function() 
				{
					jQuery("#setDefaultSowBtn").show();
					jQuery("#selectDefaultDiv").hide();
					return false;
				});

				jQuery( "#saveDefaultBtn" ).click(function() 
				{
					var selectedId = jQuery("#selectDefault").val();
					if(selectedId != "")
					{
						showLoadingBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/geo/saveDefaultDocumentTemplate",
							data: {id: ${geoInstance?.id}, selectedId: selectedId},
							success: function(data)
							{
								if(data == "success")
								{
									hideLoadingBox();
									refreshTerritorySowTemplate(${geoInstance?.id});
									refreshNavigation();
								}
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){}
						});
					}
									
					return false;
				});
				
				jQuery( ".previewSOWBtn" ).click(function() 
				{
					window.location = "${baseurl}/setting/downloadSOWPreview/${geoInstance?.id}"
					return false;
				});

				jQuery( ".helpBtn" ).click(function() 
				{
					jQuery("#helpDialog").dialog("open");
					return false;
				});

				jQuery( "#importSOWDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					height: 300,
					width: 600,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});

				jQuery( "#sowDocumentTemplateDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					height: 300,
					width: 600,
					close: function( event, ui ) {
						jQuery(this).html('');
					}
				});

				jQuery( "#helpDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					height: 500,
					width: 1000
				});
				
  			});
			
		</script>  


		<div id="importSOWSuccessDialog" title="Success">
			<p>File imported successfully.</p>
		</div>

		<div id="importSOWFailureDialog" title="Failure">
			<p>Failed to import file.</p>
		</div>
		
		<div id="helpDialog" title="SOW Template Help">
			<g:render template="../setting/help"/>
		</div>
		
		<div id="importSOWDialog" title="Import SOW File">
			
		</div>
		
		<h4> <b>  SOW Template for ${geoInstance}  </b> </h4>
    		
		<div>
			<g:if test="${!isFile}">
    			<button id="importSOWBtn" class="importSOWBtn buttons.button button" title="Import SOW">Import SOW</button>
    			
    			<button id="helpBtn" class="helpBtn buttons.button button" title="Help">SOW Tags</button>
    			
    			<g:if test="${geoInstance?.sowDocumentTemplates?.size() > 0}">
    				<button id="setDefaultSowBtn" class="setDefaultSowBtn buttons.button button" title="Set Default SOW">Set Default</button>
    			</g:if>
    			
   			</g:if>
   			<g:else>
   				<button id="reimportSOWBtn" class="reimportSOWBtn buttons.button button" title="Reimport SOW">Reimport SOW</button>
   				
   				<button id="previewSOWBtn" class="previewSOWBtn buttons.button button" title="Download Preview">Download</button>
   				
   				<button id="helpBtn" class="helpBtn buttons.button button" title="Help">SOW Tags</button>
   				
   			</g:else>
	    </div>	
	    <br/>
	    
	    <div id="selectDefaultDiv">
	    	<p>
	    		Select your default SOW :  &nbsp; 
	    		<g:select name="selectDefault" from="${geoInstance?.sowDocumentTemplates?.sort{it?.documentName}}" optionKey="id" optionValue="documentName" value="" noSelection="['': 'Select Any One']" class="required"/> &nbsp;
	    		<button id="saveDefaultBtn" class="saveDefaultBtn buttons.button button" title="Save Default">Save Default</button>
	    		<button id="cancelDefaultBtn" class="cancelDefaultBtn buttons.button button" title="Cancel">Cancel</button>
    		</p>
	    </div>
	    
	    <div class="list">
	    	<div id="sowDocumentTemplateDialog" title="Edit SOW Document Template">
			</div>
	    	
	    	<table cellpadding="0" cellspacing="0" border="0" class="display" id="sowDocumentTemplateList">
				<thead>
					<tr>
						<th>#</th>
                    	<th>Name</th>
                        <th>Action</th>
                    </tr>
                  	</thead>
                  	
                  	<tbody>
                  
                    <g:each in="${geoInstance?.sowDocumentTemplates?.sort{it?.documentName}}" status="i" var="sowDocumentTemplateInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        	<td>${i+1}</td>
                            <td>${sowDocumentTemplateInstance?.documentName}</td>
                        
	                        <td > 
	                        	<a id="${sowDocumentTemplateInstance.id}" href="#" class="editSowDocumentTemplate hyperlink"> Edit </a> &nbsp; | &nbsp;
	                        	<a id="${sowDocumentTemplateInstance.id}" href="#" class="previewSowDocumentTemplate hyperlink"> Preview </a> &nbsp;|&nbsp; 
	                        	<a id="${sowDocumentTemplateInstance.id}" href="#" class="deleteSowDocumentTemplate hyperlink"> Delete </a>
	                        	
	                        	<g:if test="${sowDocumentTemplateInstance.isDefault == true}">
	                        		&nbsp;|&nbsp; Default
	                        	</g:if>
	                        </td>
                        </tr>
                    </g:each>
				</tbody>
			</table>
	    </div>    			
					
		<br>
					
		<div class="reportDv" id="reportDv" title="Delete Report Of Sow Introduction"></div>
        
        <g:if test="${geoInstance?.sowDocumentTemplates?.size()}">
        	<div id="resultDialog" title="">
			</div>
        
        	<fieldset class="active">
        		<legend class="togvis"> SOW Introduction (${sowIntroductionInstanceTotal})</legend>
        		<div id="mycontent">	 

		        	<div id="sowIntroductionDialog" title="">
					</div>
		        
		        	<div class="body">                	
		        		<button id="createsowIntroductionSetup" class="createsowIntroductionSetup buttons.button button" title="Add SOW Introduction">Add SOW Introduction</button>
		    		</div>
	    	
	    			<br/>
					<%-- 	Append the List of SOW Introduction According To Territory Name		--%>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="sowIntroductionsList">
						<thead>
							<tr>
								<th>#</th>
		                    	<th>Name</th>
		                        <th>Action</th>
		                    </tr>
                    	</thead>
                    	
                    	<tbody>
                    
		                    <g:each in="${sowIntroductionInstanceList?.sort{it?.name}}" status="i" var="sowIntroductionInstance">
		                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		                        	<td>${i+1}</td>
		                            <td>${fieldValue(bean: sowIntroductionInstance, field: "name")}</td>
		                        
			                        	<td > <a id="${sowIntroductionInstance.id}" href="#" class="editsowIntroductionSetup hyperlink"> Edit </a> &nbsp;|&nbsp; <a id="${sowIntroductionInstance.id}" href="#" class="deletesowIntroductionSetup hyperlink"> Delete </a></td>
		                        </tr>
		                    </g:each>
	                    </tbody>
                   </table>
		 		</div>
          	</fieldset>
         	   
          	<div id="resultDialog" title="">
			</div>

			<fieldset class="active">
				<legend class="togvis">Project Parameter (${sowSupportParameterInstanceTotal})</legend>
				<div id="mycontent">
					<div id="sowSupportParameterDialog" title="">
					</div>
					<div class="body">
				        <button id="createSowSupportParameterSetup" class="createSowSupportParameterSetup" buttons.button button" title="Add Project Parameter">Add Project Parameter</button>
	  					</div>
	  				
	   				<br/>
					<%-- 	Append the List of Project Parameter According To Territory Name		--%>
				
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="sowSupportParameterList">
						<thead>
							<tr>
								<th>#</th>
		                    	<th>Name</th>
		                        <th>Action</th>
		                    </tr>
	                   	</thead>
	                  	
	                   	<tbody>
		                    <g:each in="${sowSupportParameterInstanceList?.sort{it?.name}}" status="i" var="sowSupportParameterInstance">
		                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
		                        	<td>${i+1}</td>
		                            <td>${fieldValue(bean: sowSupportParameterInstance, field: "name")}</td>
		                        
			                        <td > <a id="${sowSupportParameterInstance.id}" href="#" class="editSowSupportParameterSetup hyperlink"> Edit </a> &nbsp;|&nbsp; <a id="${sowSupportParameterInstance.id}" href="#" class="deleteSowSupportParameterSetup hyperlink"> Delete </a></td>
		                        </tr>
		                    </g:each>
		            
	                    </tbody>
	                   
	              	</table>
	           	</div>
			</fieldset>
                 
			<p><b>NOTE</b>: Click on respective header of "SOW Introduction" or "Project Parameter" to get details.</p>
		</g:if>
				