<html>
    <head>
    	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
    	<ckeditor:resources />
    	<script> 
        	
        	jQuery(document).ready(function()
     		{
     			var name = 'sowTemplate'
    				var editor = CKEDITOR.instances[name];
    				if (editor) { editor.destroy(true); }
    				CKEDITOR.replace(name, {
    					height: '90%',
    				   	width: '700px',
    				   	toolbar: 'Basic'});
 				    	
    			var name = 'services'
   					var editor = CKEDITOR.instances[name];
   				    if (editor) { editor.destroy(true); }
   				    CKEDITOR.replace(name, {
   				    	height: '90%',
   				    	width: '700px',
   				    	toolbar: 'Basic'});

     			var name = 'terms'
  					var editor = CKEDITOR.instances[name];
  				    if (editor) { editor.destroy(true); }
  				    CKEDITOR.replace(name, {
  				    	height: '90%',
  				    	width: '700px',
  				    	toolbar: 'Basic'});
     				    	
     		 	var name = 'billing_terms'
   					var editor = CKEDITOR.instances[name];
   				    if (editor) { editor.destroy(true); }
   				    CKEDITOR.replace(name, {
   				    	height: '90%',
   				    	width: '700px',
   				    	toolbar: 'Basic'});
     				
     			var name = 'signature_block'
   					var editor = CKEDITOR.instances[name];
   				    if (editor) { editor.destroy(true); }
   				    CKEDITOR.replace(name, {
   				    	height: '90%',
   				    	width: '700px',
   				    	toolbar: 'Basic'});    	 
     		});
		</script>  
    </head>
    <body>
    
    	<div class="nav">
       		<span><g:link class="buttons.button button" title="Territory Settings" action="territorySettings">Territory Settings</g:link></span>
            
       	</div>
	        	
    	<div class="collapsibleContainer">
			<div class="collapsibleContainerTitle ui-widget-header">
				<div>SOW Settings</div><hr />
			</div>
		
			<div class="collapsibleContainerContent">
			
				<div id="sowSetting">
					<div id="mainSowSettingTab">
						<g:render template="settings" model="['map': map]"/>
					</div>
				</div>
			
			</div>
			
		</div>
			
			
			
    </body>
    
</html>