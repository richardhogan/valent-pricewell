<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function(){
		var username = '${serviceProfileInstance?.serviceDesignerLead?.username}';
		
  		if(username == 'designer')
		{
    		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showServiceImportStages?source=design&id=' + ${serviceProfileInstance?.id }  ,contentCache:false, previousStageEnabled: true, onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  ${serviceProfileInstance?.currentStep }, labelFinish:'Publish >>', onFinish: onFinishCallback, onPreviousStage: onPreviousStageCallback });
		}
		else
		{
			jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showServiceImportStages?source=design&id=' + ${serviceProfileInstance?.id }  ,contentCache:false, previousStageEnabled: true, onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  ${serviceProfileInstance?.currentStep - 1}, labelFinish:'Publish >>', onFinish: onFinishCallback, onPreviousStage: onPreviousStageCallback });
		}

  		var stepNumber
    	/*function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
        }*/

		function leaveAStepCallback(from, to){
    		var fromStepIdx = from.attr( "rel" );
    	    var toStepIdx = to.attr( "rel" );

    	    stepNumber = toStepIdx;
    	    //alert(fromStepIdx + " " + toStepIdx);
    	    //var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(fromStepIdx, toStepIdx); // return false to stay on step and true to continue navigation 
          }

        function showStepCallback(obj){
            
       		var elements = jQuery('.swMain ul.anchor li a:lt(' + ${serviceProfileInstance?.currentStep - 1} + ')')
       		var step_num= obj.attr('rel');
       		stepNumber = obj.attr('rel');
       		for(var i=0; i<elements.length; i++){
				if(jQuery(elements[i]).hasClass('disabled')){
						jQuery(elements[i]).removeClass("disabled").addClass("done")
							.attr("isDone",1);
					}	
           	}
           	
           	if(step_num == 1)
            {
           		jQuery('.swMain .buttonPreviousStage').removeClass("buttonDisabled").removeClass("buttonHide");
            }
           	

       		if(step_num == 2)
        	{	
        		jQuery.ajax({
                    url: '${baseurl}/service/hasActivityRoleDefine?id=' + <%=serviceProfileInstance?.id%>,
                    type: 'POST', async: false, cache: false, timeout: 30000,
                    error: function(){
                        return false;
                    },
                    success: function(msg)
                    { 
                    	if(username == 'designer')
                		{
                			jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
                			jQuery('.swMain .buttonPreviousStage').removeClass("buttonDisabled").removeClass("buttonHide");
                		}
                		
                        if(msg == 'false')
	                    {
                    		jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
                    		//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
	                    }
		                    
                    }
                });
            
        	}

       		if(username == 'designer' && step_num != 1 && step_num != 2)
            {
           		jQuery('.swMain .buttonPreviousStage').addClass("buttonDisabled").addClass("buttonHide");
           		jQuery('.swMain .buttonPrevious').removeClass("buttonDisabled").removeClass("buttonHide");
            }

            if(username != 'designer' && step_num != 1)
            {
           		jQuery('.swMain .buttonPreviousStage').addClass("buttonDisabled").addClass("buttonHide");
           		jQuery('.swMain .buttonPrevious').removeClass("buttonDisabled").removeClass("buttonHide");
            }

            
        }

		
		
    	function validateSteps(stepnumber, toStepIdx){
    	
            var isStepValid = true;

            if(stepnumber == 1)
            {
            	if(jQuery('#assignDesigner').validate().form())
            	{	

            			jQuery('<input />').attr('type', 'hidden')
    	        		.attr('name', 'step_number')
    	        		.attr('value', parseInt(stepnumber) + 1)
    	        		.appendTo('#assignDesigner');
    	            	jQuery('<input />').attr('type', 'hidden')
                   		.attr('name', 'source')
                   		.attr('value', 'design')
                   		.appendTo('#assignDesigner');
    					jQuery('#assignDesigner').submit();
            			
                } 
            	else 
            	{
            		return false;
                }
            }
            
            if(stepnumber == 2)
            {
            	var val = true;
                if(toStepIdx > stepnumber)
                {
                	jQuery.ajax({
                        url: '${baseurl}/service/hasActivityRoleDefine?id=' + <%=serviceProfileInstance?.id%>,
                        type: 'POST',
                        async: false,
                        cache: false,
                        timeout: 30000,
                        error: function(){
                            return false;
                        },
                        success: function(msg){ 
    	                    if(msg == 'false')
    		                   {
                            		val = false;
                            		jQuery('#step-2 div:first').prepend("<div class='errors'> Service Activity or Activity Role can not be empty </div>");
                            		
    		                   }
    		                    
                        }
                    });
                }

                return val;
            }

            return true;	 
        }

    	function onFinishCallback()
    	{
	   		var isImported = '${serviceProfileInstance.isImported}';
    		var workflowMode = '${serviceProfileInstance.workflowMode}'; //"customized"
    		if(isImported){
        		if( workflowMode == "" || workflowMode != "customized"){
	    			showLoadingBox();
	    			jQuery.post( '${baseurl}/service/publishImportService', 
	    				{id: ${serviceProfileInstance?.id}},
	    			      function( data ) 
	    			      {
	    			 		  hideLoadingBox();
	    			          if(data == 'success')
	    			          {		                   		                   		
	    	                   		jQuery( "#successDialog" ).dialog("open");
	    				      }
	    				      else
	    				      {
	    	                  		jQuery( "#failureDialog" ).dialog("open");
	    				      }
	    				      
	    			      });
	            	
	    		    return;
        		}
        	}

			window.location.href = '${baseurl}/service/changeImportServiceStage?id='+${serviceProfileInstance?.id};
		    //
		    //return false;
   	    }
          
    	function onPreviousStageCallback()
   	    {
    		window.location.href = '${baseurl}/service/changeBackImportServiceStage?id='+${serviceProfileInstance?.id};
   	   	    //return false;
   	   	}
   	   	
    	jQuery( "#successDialog" ).dialog(
	 	{
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: {
				OK: function() {
					jQuery( "#successDialog" ).dialog( "close" );
					window.location.href = '${baseurl}/service/catalog';
					return false;
				}
			}
		});
		
		jQuery( "#failureDialog" ).dialog(
		{
			modal: true,
			autoOpen: false,
			resizable: false,
			buttons: {
				OK: function() {
					jQuery( "#failureDialog" ).dialog( "close" );
					return false;
				}
			}
		});
	});
</script>


<div id="successDialog" title="Success">
	<p>Service published successfully.</p>
</div>

<div id="failureDialog" title="Failure">
	<p><g:message code="service.import.message.failure.dialog" default=""/></p>
</div>

<div id="wizard" class="swMain">
			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.importServiceStageSteps['design']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${currentIndex}${(char)65+i}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.importServiceStageSteps['design']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>
