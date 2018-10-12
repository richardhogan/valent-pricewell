<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.ServiceProfileSOWDef"%>
<%
	def baseurl = request.siteUrl
%>
<style>
	/* Right Div */
		.RightDiv{
			  width: 15%;
			  padding: 0 0px;
			  float: right;
			  
			 } 
</style>

<g:setProvider library="prototype"/>
<script>
		jQuery(function() {
		  	jQuery( ".SOWDefinitionTabs" ).tabs();//.addClass( "ui-tabs-vertical ui-helper-clearfix" );
		  	//jQuery( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );
	
		  	jQuery(".btnSOWDefinitionDelete").click(function()
			{
		  		var id = this.id;
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceProfileSOWDef/deleteFromService",
					data: {id: id},
					success: function(data){jQuery("#mainSOWDefinitionTab").html(data);hideUnhideNextBtnForDefinition()}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
	
				return false;
			}); 
	
		  	jQuery(".btnSOWDefinitionEdit").click(function()
			{
		  		var id = this.id;
				jQuery.ajax({
					type: "POST",
					url: "${baseurl}/serviceProfileSOWDef/editFromService",
					data: {id: id},
					success: function(data){jQuery("#mainSOWDefinitionTab").html(data);}, 
					error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
				});
	
				return false;
			}); 

		});
	</script>
<div id="SOWDefinitionTabs" class="SOWDefinitionTabs">
	<ul>
		<g:each in="${sowDefinitionList?.sort {it.id}}" status="i" var="sowDefinition">
			<li>
				<a href="#tab-${sowDefinition?.id}">${sowDefinition?.part}</a>
				
			</li>
		</g:each>
	</ul>
	
	<g:each in="${sowDefinitionList?.sort {it.id}}" status="i" var="sowDefinitionProp">
		<div id="tab-${sowDefinitionProp?.id}">		
			<!-- <div class="RightDiv">
				<span class="button"><button title="Edit SOW Definition" class="btnSOWDefinitionEdit" id="${sowDefinitionProp?.id}"> Edit </button></span>
				<span class="button"><button title="Delete SOW Definition" class="btnSOWDefinitionDelete" id="${sowDefinitionProp?.id}"> Delete </button></span>
			</div>
			
			<br><br>${sowDefinitionProp?.definitionSetting?.value}
		</div>
		
		<div class="dialog">-->
            <table style="width: 100%">
                <tbody>
                	                          
                    <tr class="prop">
                        <td>
                            <g:textArea name="definition_${sowDefinitionProp?.id}" value="${sowDefinitionProp?.definitionSetting?.value}" rows="5" cols="60" class="required"/>
                        </td>
                        
                        <script>
	                        var toolbar = 	[];
	
	            	        var name = "definition_${sowDefinitionProp?.id}";
	            			var editor = CKEDITOR.instances[name];
	            			
	            	   		if (editor) { editor.destroy(true); }
	            	   			CKEDITOR.replace(name, {
            	   							 height: '90%',
            	   							 width: '98%', indentOffset: 30, toolbar: toolbar, readOnly: true});
                        </script>
                    </tr>
                	
                	
	                	<tr class="prop">
	                        <td>
	                            <div class="LeftDiv">
									<span class="button"><button title="Edit SOW Definition" class="btnSOWDefinitionEdit" id="${sowDefinitionProp?.id}"> Edit </button></span>
									<span class="button"><button title="Delete SOW Definition" class="btnSOWDefinitionDelete" id="${sowDefinitionProp?.id}"> Delete </button></span>
								</div>
	                        </td>
	                    </tr>   
                       
                </tbody>
            </table> 
        </div>
		
	</g:each>
</div>
