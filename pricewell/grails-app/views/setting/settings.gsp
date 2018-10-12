<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
    	<script type="text/javascript" src="../js/tiny_mce/tiny_mce.js"></script>
    	
		<link rel="stylesheet" href="${resource(dir:'js/dataTables/css',file:'demo_page.css')}" />
		<link rel="stylesheet" href="${resource(dir:'js/dataTables/css',file:'demo_table.css')}" />
		<ckeditor:resources />	
		<script type="text/javascript" language="javascript" src="../js/dataTables/js/jquery.dataTables.js"></script>
		
    	<script> 
        	tinyMCE.init({
        		// General options
        		mode : "textareas",
        		theme : "advanced",
        		skin : "o2k7",
        		plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advlink,iespell,insertdatetime,preview,searchreplace,print,directionality,fullscreen,noneditable,visualchars,nonbreaking,template,inlinepopups,autosave",

        		// Theme options
        		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,formatselect,fontselect,fontsizeselect,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,forecolor,backcolor,|,cite,abbr,acronym,del,ins,attribs,|,nonbreaking,pagebreak,|,fullscreen",
        		theme_advanced_buttons2 : "",
        	    theme_advanced_buttons3 : "",
        	
        		theme_advanced_toolbar_location : "top",
        		theme_advanced_toolbar_align : "left",
        		theme_advanced_statusbar_location : "bottom",
        		theme_advanced_resizing : true,
        		// Replace values for the template plugin
        		template_replace_values : {
        			username : "Some User",
        			staffid : "991234"
        		}
        	});
        	
        	jQuery(function() 
		   	{
				jQuery( "#tabsDiv" ).tabs();
			});
		</script>  
    </head>
    <body>
    
    	<div id="tabsDiv" class="body">
	 		<ul>
	 			<li><a href="#sowSetting">SOW Settings</a></li>
				
				<li><a href="#emailSetting">Email Settings</a></li>
	 			
	 			<li><a href="#companyInfo">Company Information</a></li>
	 			
	 			<li><a href="#workflowSetting">Workflow Settings</a></li>
			</ul>
			
			<div id="sowSetting">
				<div id="mainSowSettingTab">
					<g:render template="settings" model="['map': map]"/>
				</div>
			</div>
			
			<div id="companyInfo">
				<div id="mainInformationTab">
					<g:if test="${companyInformationInstance == null}">
						<g:render template="/companyInformation/create" />
					</g:if>
					<g:else>
						<g:render template="/companyInformation/show" model="['companyInformationInstance': companyInformationInstance]"/>
					</g:else>
				</div>
			</div>
			
			<div id="emailSetting">
				<div id="mainEmailSettingTab">
					<g:render template="../emailSetting/emailSettings" model="['emailSettings': emailSettings]"/>
				</div>
			</div>
			
			<div id="workflowSetting">
				<div id="mainWorkflowSettingTab">
					<g:render template="../staging/list" model="['stagingInstanceList': stagingInstanceList, 'title': title]"/>
				</div>
			</div>
		</div>
    	
	     
    </body>
    
</html>