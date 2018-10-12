<%@ page import="org.apache.shiro.SecurityUtils"%>
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
	jQuery(document).ready(function()
	{
		var toolbar = [];

        var name = 'defaultDefinition';
		var editor = CKEDITOR.instances[name];
		
   		if (editor) { editor.destroy(true); }
   			CKEDITOR.replace(name, {
   							 height: '90%',
   							 width: '98%', toolbar: toolbar, readOnly: true});
					    	            
	  	jQuery( ".SOWDefinitionTabs" ).tabs();//.addClass( "ui-tabs-vertical ui-helper-clearfix" );
	  	//jQuery( "#tabs li" ).removeClass( "ui-corner-top" ).addClass( "ui-corner-left" );

	  	jQuery(".btnSOWDefinitionEdit").click(function()
		{
	  		var id = this.id;
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/serviceProfileSOWDef/editDefaultSOWDefinition",
				data: {id: id},
				success: function(data){jQuery("#mainSOWDefinitionTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});

			return false;
		});
	  	jQuery(".btnSOWViewPDF").click(function()
	  			{
		  			
	  		  		var id = this.id;
					var geoID = jQuery("#viewPDFGeoId").val();
	  		  		if(geoID == ''){
		  		  		jAlert('Please select Territory');
		  		  		return false;
		  		  	}
	  		  		else{
	  		  		showThrobberBox();
	  		  		jQuery.ajax(
	  						 {
	  							 type:'POST',
	  							 url:"${baseurl}/service/generatePdfSOW",
	  							 data: {geoId: geoID,id: id} ,
	  							 success:function(data,textStatus)
	  							 {
	  								 if(data == "noFile")
	  								 {
	  									hideThrobberBox();
	  									 jAlert('Failed to generate SOW Preview for this service because there is no sample SOW file imported for selected territory.', 'Alert');
	  									 return false;
	  								 }
	  								 else {
	  									hideThrobberBox();
	  									 outputFilePath = data.outputfilePath; //data coming from ajax is generated document full path
	  									jQuery("#dialog").dialog({
	  					                    modal: true,
	  					                    title: data.fileName,
	  					                    width: 780,
	  					                    height: 600,
	  					                    buttons: {
	  					                        Close: function () {
	  					                            jQuery(this).dialog('close');
	  					                        }
	  					                    },
	  					                    open: function () {
	  					                    	var finalURL = "${baseurl}/downloadFile/downloadDocumentFile?filePath="+outputFilePath;
		  					                    
												//this is sample how pdf view with live urls
												//for live url we have to change just path here
		  					                       var object='<iframe src="https://docs.google.com/gview?embedded=true&url='+finalURL+'" style="height:580px;width:760px"></iframe>'
	  					                        //alert(object)
	  					                        jQuery("#dialog").html(object);
	  					                    }
	  					                });

		  									 //downloadSOW(id, outputFilePath)
	  									 //For local testing use below line
	  									//window.location = "${baseurl}/downloadFile/downloadDocumentFile?filePath="+outputFilePath;
	  									
	  									//Use below line for live URLs
	  									
	  									//window.open("https://docs.google.com/viewer?embedded=true&url="+finalURL,"_blank");
	  									
	  								 }
	  								 
	  						 	 },
	  							 error:function(XMLHttpRequest,textStatus,errorThrown)
	  							 {
	  								 //hideLoadingBox();
	  								 hideThrobberBox();
	  								 jQuery( "#generateSOWFailureDialog" ).dialog("open");
	  							 }
	  						 });
		  		  	}
	  				return false;
	  			}); 
		});
		  	
	  	
	  		
	function downloadSOW(id, filePath)
	{
		jQuery.ajax({type:'POST',
			url: "${baseurl}/quotation/showInfo",
			data: {id: id } ,
			success:function(data,textStatus)
			{
				window.location = "${baseurl}/downloadFile/downloadDocumentFile?filePath="+filePath;
			},
			error:function(XMLHttpRequest,textStatus,errorThrown)
			{
				 jAlert("error has occured");
			}
		});
	}
</script>
 <div id="dialog" style="display: none">
    </div>	
<div id="SOWDefinitionTabs" class="SOWDefinitionTabs">
	<ul>
		
			<li>
				<a href="#tab-${defaultSOWDefinition?.id}">${defaultSOWDefinition?.part}</a>
				
			</li>
		
	</ul>
	
	
		<div id="tab-${defaultSOWDefinition?.id}">
			<!-- <g:if test="${!readOnly}">
				<div class="RightDiv">
					<span class="button"><button title="Edit SOW Definition" class="btnSOWDefinitionEdit" id="${defaultSOWDefinition?.id}"> Edit </button></span>
				</div>
			</g:if>	-->	
				
			<div class="dialog">
	            <table style="width: 100%">
	                <tbody>
	                	                     	                	     
	                    <tr class="prop">
	                        <td>
	                            <g:textArea name="defaultDefinition" value="${defaultSOWDefinition?.definitionSetting?.value}" rows="5" cols="120" readOnly="true" class="required"/>
	                        </td>
	                        
	                    </tr>
	                	
	                	<g:if test="${readOnly}"> 
		                	<tr class="prop">
		                        <td>
		                        	<b>Select Territory </b>&nbsp;&nbsp; <g:select id="viewPDFGeoId" name="viewPDFGeoId" from="${com.valent.pricewell.Geo.list()}" optionKey="id" value="${geoInstance?.id}" noSelection="['': 'Select Any One']" />
			                        <button title="View PDF" class="btnSOWViewPDF buttons.button button" id="${serviceProfileInstance?.id}" ><g:message code="service.viewServicePdf.label" default="View PDF" /></button>
		                        </td>
		                    </tr>
	                	</g:if>

	                	<g:if test="${!readOnly}"> 
		                	<tr class="prop">
		                        <td>
		                            <div class="LeftDiv">
										<span class="button"><button title="Edit SOW Definition" id="${defaultSOWDefinition?.id}" class="btnSOWDefinitionEdit" > Edit </button></span>
									</div>
		                        </td>
		                    </tr>   
                        </g:if> 
                        
	                </tbody>
	            </table> 
	        </div>
			
		</div>
		
		
	
</div>

<!-- 

<g:if test="${writable}">
	
</g:if>
<div>
	<g:if test="${SecurityUtils.subject.hasRole('SYSTEM ADMINISTRATOR')}">
		<div class="RightDiv">
			<span class="button">
				<g:remoteLink action="editDefinition" controller="service" update="[success:'tbDef',failure:'tbDef']"
								class="hyperlink" title="Edit Definition"
								id="${serviceProfileInstance?.id}" >
								Edit Definition
								</g:remoteLink>
			</span>
		</div>
		<br />
		<p style="font-size: 100%">${serviceProfileInstance?.definition}</p>
		
	</g:if>
	<g:else>
		<p style="font-size: 100%">${serviceProfileInstance?.definition}</p>
	</g:else>
</div>

-->