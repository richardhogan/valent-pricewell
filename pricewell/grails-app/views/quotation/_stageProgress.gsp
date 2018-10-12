<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Staging" %>
<!--  Pass quotationInstance, type -->
<%
	def stagingInstanceList = Quotation.quoteStagingList();
	def rejectedStageId = Staging.findByNameAndEntity('rejected', Staging.StagingObjectType.QUOTATION).id
	def acceptStageId = Staging.findByNameAndEntity('Accepted', Staging.StagingObjectType.QUOTATION).id
	int currentSequence = 1000;
	int lastStageId = -1
	def currentStage
	if(type == "contract"){
		currentStage = quotationInstance.contractStatus
	}
	else {
		currentStage = quotationInstance.status
	}
	
 %>
 <%
	def baseurl = request.siteUrl
%>
<script>

		 jQuery(document).ready(function()
		 {						
				jQuery('.postStage${type}').click(function(event) 
				{					
					var id = this.id;
					var check = false;
					var type = "${type}" + "-"
					var id = id.replace(type,"");
					
					
					if('${type}' == "contract" && id == ${acceptStageId})
					{
						if("Accepted" == '${quotationInstance.status.name}')
						{
							check = true;
						}
					}
					else
					{
						check = true;
					}	
					if(check == true)
					{
						
						jQuery.ajax({type:'POST',
							 url: "${baseurl}/quotation/changeStage",
							 data: {id: ${quotationInstance.id}, changeToId: id, type: "${type}", changeStage: 'change'} ,
							 success:function(data,textStatus)
							 {
								 jQuery('#dvQuote').html(data); refreshForecastValue(); 
							 },
							 error:function(XMLHttpRequest,textStatus,errorThrown){}});

						
					}
					else
					{
						jAlert('Quotation contract can not be accepted, first accept quote.', 'Quotation Contract Alert');
					}
					 return false
				});

				jQuery('.generate${type}').click(function(event)
				{
					if('${type}' == 'contract'){
						//Generate SOW
						//previewSOW(${quotationInstance.id});
						//generateSOW(${quotationInstance.id})
						addIntroductionAndMilestones(${quotationInstance.id});
						//alert(1);
					}else{
						//Generate Quotation
						previewQuotation(${quotationInstance.id});
					}
					
				});

				jQuery( "#generateSOWFailureDialog" ).dialog(
				{
					modal: true,
					autoOpen: false,
					resizable: false,
					buttons: {
						OK: function() {
							jQuery( "#generateSOWFailureDialog" ).dialog( "close" );
							location.reload();
							return false;
						}
					}
				}); 

				jQuery( "#sowIntroductionAndMilestonesDialog" ).dialog(
				{
					height: 'auto',
					width: 900,
					position: ['center',5],
					modal: true,
					autoOpen: false,
					close: function( event, ui ) {
							jQuery(this).html('');
						}
				}); 

		 });

		 function addIntroductionAndMilestones(id)
		 {
			 /*jQuery( "#sowIntroductionAndMilestonesDialog" ).html("Loading, Please wait...").dialog("open");
			 jQuery.ajax(
			 {
				 type:'POST',
				 url:"${baseurl}/quotation/addSOWIntroductionAndMilestones",
				 data: {id: id} ,
				 success:function(data,textStatus)
				 {
					 jQuery( "#sowIntroductionAndMilestonesDialog" ).html(data);
			 	 },
				 error:function(XMLHttpRequest,textStatus,errorThrown)
				 {
					 alert("Some error, please try again...");
					 jQuery( "#sowIntroductionAndMilestonesDialog" ).dialog("close");
				 }
			 });*/

			 showThrobberBox();
			 jQuery.ajax(
			 {
				 type:'POST',
				 url:"${baseurl}/quotation/checkSowTemplateAvailable",
				 data: {id: id} ,
				 success:function(data,textStatus)
				 {
					 if(data['result'] == "file_available")
					 {
						 window.location = "${baseurl}/quotation/generatesow/"+id;
					 }
					 else
					 {
						 hideThrobberBox();
						 jAlert("Failed to generate SOW for this quotation because there is no sample SOW file imported for territory ${quotationInstance?.geo?.name}.", 'Alert');
					 }
					 jQuery( "#sowIntroductionAndMilestonesDialog" ).html(data);
			 	 },
				 error:function(XMLHttpRequest,textStatus,errorThrown)
				 {
					 alert("Some error, please try again...");
					 jQuery( "#sowIntroductionAndMilestonesDialog" ).dialog("close");
				 }
			 });
			 
			 return false;
		 }
		 
		 function generateSOW(id)
		 {
			 var outputFilePath = '';
			 //showThrobberBox();
			 jQuery.ajax(
			 {
				 type:'POST',
				 url:"${baseurl}/quotation/generateDucumentOfSOW",
				 data: {id: id} ,
				 success:function(data,textStatus)
				 {
					 if(data == "noFile")
					 {
						 hideThrobberBox();
						 jAlert('Failed to generate SOW for this quotation because there is no sample SOW file imported for territory ${quotationInstance?.geo?.name}.', 'Alert');
						 return false;
					 }
					 else {
						 outputFilePath = data; //data coming from ajax is generated document full path
						 refreshSOW(id, outputFilePath)
					 }
					 
			 	 },
				 error:function(XMLHttpRequest,textStatus,errorThrown)
				 {
					 hideThrobberBox();
					 jQuery( "#generateSOWFailureDialog" ).dialog("open");
				 }
			 });

			 return false;
		 }

		 function refreshSOW(id, filePath)
		 {
			 jQuery.ajax({type:'POST',
				 url: "${baseurl}/quotation/showInfo",
				 data: {id: id } ,
				 success:function(data,textStatus)
				 {
					 	jQuery('#dvQuotationInfo').html(data); 
					 	refreshList();
					 	window.location = "${baseurl}/downloadFile/downloadDocumentFile?filePath="+filePath;
					 	hideThrobberBox();
						hideLoadingBox();
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown)
				 {
					 	hideThrobberBox();
					 	hideLoadingBox();
					 	jQuery( "#failureDialog" ).dialog("open");
				 }});
		 }
		 
		 function changeStage(id, type)
		 {
		 	var data = {id: ${quotationInstance.id}, changeToId: id, type: type}; 
			jQuery.ajax({type:'POST',
				 url:"${baseurl}/quotation/changeStage",
				 data: data ,
				 success:function(data,textStatus){jQuery('#dvQuotationInfo').html(data);},
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
		 }
</script>
			
		<div id="generateSOWFailureDialog" title="Failure">
			<p>Failed to generate SOW.</p>
		</div>
		
		<div id="sowIntroductionAndMilestonesDialog" title="Add SOW Introduction And Milestones">
			
		</div>

		
		<div class="stagesmall" style="float: left; ">
     		<ul>
     			<g:if test="${currentStage.name == 'Accepted'}">
     				<li> <a class="current" href="#"> ${currentStage.displayName} </a> </li>
     			</g:if>
     			<g:elseif test="${currentStage.name == 'rejected'}">
     				<li> <a class="endstage" href="#"> ${currentStage.displayName} </a> </li>
     			</g:elseif>
     			<g:else>
     				<div style="float: left; ">
	      				<g:each in="${stagingInstanceList}" status="i" var="stage">
	      					<% 
	      						if(currentStage.id == stage.id)
								  {
									  currentSequence = i;
								  }
	      					%>
	      						
	      					<!-- current stage definition -->	
				        	<g:if test="${currentSequence == i}">
				        		<g:if test="${!readOnly && lastStageId >= 0}"> 
				        			<li><a id="${type}-${lastStageId}" class="stageChange postStage${type}" href="#" > &lt;&lt; </a></li>
				        		</g:if>
			        			<li> <a class="current" href="#" title="${stage.displayName}">  ${i+1}. ${stage.displayName} </a> </li>
				        	</g:if>
				        	
				        	<g:elseif test="${(currentSequence + 1) == i}"><!-- next stage definition -->
				        		<g:if test="${!readOnly}"><!-- if not changeable then show change button -->
				        			<g:if test="${stage.name == 'generated'}">
										<li><a id="${type}-${stage.id}" class="stageChange generate${type}" href="#" > &gt;&gt; ${i+1}. ${stage.displayName} </a></li>											        		
					        		</g:if>
					        		<g:else>
					        			<li><a id="${type}-${stage.id}" class="postStage${type} stageChange" href="#" > &gt;&gt; ${i+1}. ${stage.displayName} </a></li>
					        		</g:else>
				        		</g:if>
				        		<g:else>
				        			<li> <a href="#" class="done">  ${i+1}. ${stage.displayName} </a> </li>
				        		</g:else>
				        	</g:elseif>
				        	
				        	<g:elseif test="${currentSequence > i}"><!-- finished stage definition -->
				        		<li> <a href="#" class="done">  ${i+1}. ${stage.displayName} </a> </li>
				        	</g:elseif>
				        	
				        	<g:else><!-- left stage definition -->
				        		<li> <a class="done" href="#" > ${i+1}. ${stage.displayName} </a> </li>
				        	</g:else>
				        	<% lastStageId = stage.id %>
	      				</g:each>
      				</div>
      				
      				<!-- reject stage definition -->
	     			<div style="float: right;  margin-left: 10px;">
	       				<li> <a id="${type}-${rejectedStageId}" class="endstage postStage${type}" href="#" > Reject </a> </li>
	       			</div>
     			</g:else>
     		</ul>
     <br style="clear: left">
</div>
        		
        			
