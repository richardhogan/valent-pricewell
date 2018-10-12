
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%
	def baseurl = request.siteUrl
%>
<html>
		<script type="text/javascript" src="${baseurl}/js/jquery.tinymce.js"></script>
        <script>
		   	jQuery(function() 
		   	{
				jQuery("#sowIntroductionFrm").validate();

				jQuery('#sowIntroduction').tinymce({
				      script_url : '${baseurl}/js/tiny_mce/tiny_mce.js',
				      theme : "advanced",
				      	height: '100%',
				    	width: ''+Math.round(jQuery(window).width()*2/3)+'px',
		        		skin : "o2k7",
		        		plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,inlinepopups",
		        		// Theme options
		        		theme_advanced_buttons1 : "bold,italic,underline,|,bullist,numlist,|,outdent,indent,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect",
		        		theme_advanced_buttons2 : "",
		        		theme_advanced_buttons3 : "",
		        		theme_advanced_buttons4 : "",
		        		theme_advanced_toolbar_location : "top",
		        		theme_advanced_toolbar_align : "left",
		        		theme_advanced_statusbar_location : "bottom",
		        		theme_advanced_resizing : true,
		        		style_formats_merge: true,
		        		style_formats: [
		        		                {title: 'Red Title', block: 'h1', styles: {color: '#ff0000'}},
		        		                {title: 'Blue Title', block: 'h1', styles: {color: '#0000f'}},
		        		                { title : 'Marker: Yellow'	, inline : 'span', styles : { 'background-color' : 'Yellow' } },
		        		            	{ title : 'Marker: Green'	, inline : 'span', styles : { 'background-color' : 'Lime' } },
		        		            	{ title : 'Big'				, block : 'big' },
		        		            	{ title : 'Small'			, block : 'small' },
		        		            	{ title : 'Typewriter'		, block : 'tt' },
		        		            	{ title : 'Computer Code'	, inline : 'code' },
		        		            	{ title : 'Keyboard Phrase'	, inline : 'kbd' },
		        		            	{ title : 'Sample Text'		, inline : 'samp' },
		        		            	{ title : 'Variable'			, inline : 'var' },
		        		            	{ title : 'Deleted Text'		, inline : 'del' },
		        		            	{ title : 'Inserted Text'	, inline : 'ins' },
		        		            	{ title : 'Cited Work'		, inline : 'cite' },
		        		            	{ title : 'Inline Quotation'	, inline : 'q' }
		        		            ]
				   });

				jQuery(".buttonNext").click(function() {
					tinyMCE.triggerSave();
					//loadSOWIntroduction();
				});

				jQuery("#sowIntroductionSelection").change(function(){
					var selectedId = this.value;

					if(selectedId != '')
					{
						showThrobberBox();
						jQuery.ajax({
							type: "POST",
							url: "${baseurl}/sowIntroduction/getSowText",
							data:{id: selectedId},
							success: function(data)
							{
								hideThrobberBox();
								jQuery('#sowIntroduction').val(data.sow_text);
								
							}, 
							error:function(XMLHttpRequest,textStatus,errorThrown){
								hideThrobberBox();
							}
						});
					}
					else jQuery('#sowIntroduction').val("");
					
					return false;
					
				});
				
				
				
				jQuery("#sowIntroductionFrm").submit(function() 
				{
					showThrobberBox();
					//loadSOWIntroduction();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/quotation/saveGenerateSOWStages",
						data:jQuery("#sowIntroductionFrm").serialize(),
						success: function(data)
						{
							hideThrobberBox();
							return false;
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							return false;
						}
					});
					
					return false;
				});	
				
				jQuery( "#sowStartDate" ).datepicker({
		    		showOn: "button",
	    	        buttonImage: "${baseurl}/images/calendar.gif",
	    	        showWeek: true,
  					firstDay: 1,
	    	        minDate: 1,
	    	        buttonImageOnly: true,
	    	        numberOfMonths: 2,
			        onSelect: function (selected) {
			            var dt = new Date(selected);
			            dt.setDate(dt.getDate() + 1);
			            jQuery("#sowEndDate").datepicker("option", "minDate", dt);
			        }
			    });

				jQuery( "#sowEndDate" ).datepicker({
		    		showOn: "button",
	    	        buttonImage: "${baseurl}/images/calendar.gif",
	    	        showWeek: true,
  					firstDay: 1,
	    	        minDate: 1,
	    	        buttonImageOnly: true,
	    	        numberOfMonths: 2,
			        onSelect: function (selected) {
			            var dt = new Date(selected);
			            dt.setDate(dt.getDate() - 1);
			            jQuery("#sowStartDate").datepicker("option", "maxDate", dt);
			        }
			    });

				jQuery( "#sowStartDate" ).datepicker( "option", "dateFormat", '${dateFormat}' );
	 			jQuery( "#sowStartDate" ).datepicker( "setDate", '${sowStartDate}' );

	 			jQuery( "#sowEndDate" ).datepicker( "option", "dateFormat", '${dateFormat}' );
	 			jQuery( "#sowEndDate" ).datepicker( "setDate", '${sowEndDate}' );

	 			
			});

		   	function loadSOWIntroduction(){
    			var name = 'sowIntroduction';
    			jQuery('#sowIntroduction').val(jQuery('#sowIntroduction').tinymce().getContent());

    			if(isEditorContentSupported(jQuery('#sowIntroduction').val()) == "fail")
    			{
    				return false;
    			}
    			return true;
    		}
			
	   	</script>
    <body>
    
    	<div class="body">
				
		            <g:form action="saveSOWIntroduction" name="sowIntroductionFrm" class="sowIntroductionFrm" >
		            	<g:hiddenField name="id" value="${quotationInstance?.id}" />
		            	<div class="dialog">
		                    <table>
		                        <tbody>
		                        	<tr class="prop">    
		                                <td valign="top" class="name">
		                                    <label for="startDate"><g:message code="quotation.sowStartDate.label" default="SOW Start Date" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'sowStartDate', 'errors')}">
		                           			<g:textField name="sowStartDate" class="required"/>
		                                </td>
		                                
		                                <td>&nbsp;&nbsp;</td>
		                                
		                                <td valign="top" class="name">
		                                    <label for="startDate"><g:message code="quotation.sowEndDate.label" default="SOW End Date" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'sowEndDate', 'errors')}">
		                           			<g:textField name="sowEndDate"  class="required"/>
		                                </td>
		                            </tr>
		                    	</tbody>
	                    	</table>
	                    	
	                        <table>
		                        <tbody>	
		                        	
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="sowTemplateSelection">SOW Template</label><em>*</em>
		                                </td>
		                                <td valign="top" class="value">		
											<g:select style="width:700px" id="sowDocumentTemplateId" name="sowDocumentTemplateId" value="${defaultTemplate?.id}" from="${quotationInstance?.geo?.sowDocumentTemplates?.sort{it.documentName}}" optionKey="id" optionValue="documentName" class="required" noSelection="['':'Select Any One']"/>
		                                </td>
		                            </tr>
		                            
		                        	<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="sowIntroductionSelection">SOW Introduction List</label>
		                                </td>
		                                <td valign="top" class="value">		
											<g:select style="width:700px" id="sowIntroductionSelection" name="sowIntroductionSelection" from="${sowIntroList}" optionKey="id" optionValue="name" noSelection="['':'Select Any One']"/>
		                                </td>
		                            </tr>
											                        
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="sowIntroduction"><g:message code="quotation.sowIntroduction.label" default="SOW Introduction" /><em>*</em></label>
		                                </td>
		                                
		                                <td valign="top" class="value ${hasErrors(bean: quotationInstance, field: 'sowIntroduction', 'errors')}">		
											<g:textArea rows="15" cols="125" id="sowIntroduction"  name="sowIntroduction" value="${quotationInstance?.sowIntroductionSetting?.value}" class="required"/>
		                                </td>
		                            </tr>
	                            </tbody>
	                        </table>
	                        
		                </div>
		                <!-- <div class="buttons">
		                		<span class="button"><button id="continueBtn" title="Continue To Generate SOW"> Continue </button></span>
		                </div>-->
		            </g:form>
			
        </div>
    </body>
</html>
