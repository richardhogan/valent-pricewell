<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.ServiceProfileSOWDef"%>

<%
	def baseurl = request.siteUrl
%>
<g:setProvider library="prototype"/>
<script>
		jQuery(function() {
		  	jQuery( ".SOWDefinitionTabs" ).tabs();//.addClass( "ui-tabs-vertical ui-helper-clearfix" );
		  	//jQuery( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
		  	
		});
	</script>
<div id="SOWDefinitionTabsReadOnly" class="SOWDefinitionTabs">
	<ul>
		<g:each in="${sowDefinitionList?.sort {it.id}}" status="i" var="sowDefinition">
			<li>
				<a href="#tabReadOnly-${sowDefinition?.id}">${sowDefinition?.part}</a>
			</li>
		</g:each>
	</ul>
	
	<g:each in="${sowDefinitionList?.sort {it.id}}" status="i" var="sowDefinitionProp">
		<div id="tabReadOnly-${sowDefinitionProp?.id}">
			
			<table style="width: 100%">
                <tbody>
                	                          
                    <tr class="prop">
                        <td>
                            <g:textArea name="definition_${sowDefinitionProp?.id}" value="${sowDefinitionProp?.definitionSetting?.value}" rows="5" cols="60" class="definitionEditor required"/>
                            
                            <script type="text/javascript">
	                            var toolbar = 	[];
	
	                	        var name = "definition_${sowDefinitionProp?.id}";
	                			var editor = CKEDITOR.instances[name];
	                			
	                	   		if (editor) { editor.destroy(true); }

                	   			CKEDITOR.replace(name, {
                	   							 height: '90%',
                	   							 width: '98%', indentOffset: 30, toolbar: toolbar, readOnly: true});
                            </script>
                        </td>
                    </tr>

                </tbody>
            </table> 
            
		</div>
	</g:each>
</div>
