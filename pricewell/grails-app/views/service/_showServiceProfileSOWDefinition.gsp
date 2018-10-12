<%@ page import="org.apache.shiro.SecurityUtils"%>
<script>
		jQuery(function() {
		  	jQuery( "#tabs" ).tabs();//.addClass( "ui-tabs-vertical ui-helper-clearfix" );
		  	//jQuery( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
		});
	</script>
<style>
  	.ui-tabs-vertical { width: 55em; }
  	.ui-tabs-vertical .ui-tabs-nav { padding: .2em .1em .2em .2em; float: left; }
  	.ui-tabs-vertical .ui-tabs-nav li { clear: left; width: 100%; border-bottom-width: 1px !important; border-right-width: 0 !important; margin: 0 -1px .2em 0; }
  	.ui-tabs-vertical .ui-tabs-nav li a { display:block; }
  	.ui-tabs-vertical .ui-tabs-nav li.ui-tabs-active { padding-bottom: 0; padding-right: .1em; border-right-width: 1px; border-right-width: 1px; }
  	.ui-tabs-vertical .ui-tabs-panel { padding: 1em; float: right; width: 40em;}
</style>


<div id="tabs">
	<ul>
		<g:each in="${serviceProfileInstance?.defs?.sort {it.id}}" status="i" var="sowDefinition">
			<li><a href="#tabs-${sowDefinition?.part}-${sowDefinition?.id}">${sowDefinition?.id} ${sowDefinition?.part}</a></li>
		</g:each>
	</ul>
	
	<g:each in="${serviceProfileInstance?.defs}" status="i" var="sowDefinitionProp">
		<div id="tabs-${sowDefinitionProp?.part}-${sowDefinitionProp?.id}">${sowDefinitionProp?.definition}</div>
	</g:each>
</div>
