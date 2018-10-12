<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function(){
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showImportStages?source=concept&id=' + ${serviceProfileInstance?.id}  ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  ${serviceProfileInstance?.currentStep - 1}, labelFinish:'Design >>', onFinish:onFinishCallback });
  		
		var stepNumber
		
		function leaveAStepCallback(from, to){
    		var fromStepIdx = from.attr( "rel" );
    	    var toStepIdx = to.attr( "rel" );

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

       		if(step_num == 2  || step_num == 3)
        	{	
            	var url = "";
            	if(step_num == 2)
                {
                    url = '${baseurl}/service/hasDeliverables?id=' + <%=serviceProfileInstance?.id%>;
                }
            	else
                {
            		url = '${baseurl}/service/hasSOWDefinition?id=' + <%=serviceProfileInstance?.id%>;
                }
        		jQuery.ajax({
                    url: url,
                    type: 'POST', async: false, cache: false, timeout: 30000,
                    error: function(){
                        return false;
                    },
                    success: function(msg)
                    { 
	                   if(msg == 'false')
	                   {
		                    if(step_num == 2)
			                {
		                    	jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
			                }
		                    else
			                {
		                    	jQuery('.swMain .buttonFinish').addClass("buttonDisabled").addClass("buttonHide");
		                    }
	                	   	
                    		
	                   		//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
	                   }
		                    
                    }
                });
            
        	}	
        }

		
		
    	function validateSteps(stepnumber, toStepIdx)
    	{
        	if(toStepIdx < stepnumber)
            {
                return true;
            }
    	
            var isStepValid = true;

            if(stepnumber == 1)
            {
            	
            	if(jQuery('#serviceEdit').validate().form())
            	{	
           
            			jQuery('<input />').attr('type', 'hidden')
    	        		.attr('name', 'step_number')
    	        		.attr('value', stepnumber + '')
    	        		.appendTo('#serviceEdit');
    	            	jQuery('<input />').attr('type', 'hidden')
                   		.attr('name', 'source')
                   		.attr('value', 'concept')
                   		.appendTo('#serviceEdit');
    					jQuery('#serviceEdit').submit();
            			
                } 
            	else 
            	{
            		return false;
                }
            	
					
            }

            else if(stepnumber == 2)
            {
            	var val = true;
            	jQuery.ajax({
                    url: '${baseurl}/service/hasDeliverables?id=' + ${serviceProfileInstance?.id},
                    type: 'GET',
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
                        		jQuery('#step-2 div:first').prepend("<div class='errors'> Service Deliverables can not be empty </div>");
                        		
		                   }
		                    
                    }
                });

                return val;
            }

            else if(stepnumber == 3)
            {
            	
    					
            }
            return true;	 
        }

    	function onFinishCallback()
    	{
        	var stepnumber = stepNumber;

		   /* if(jQuery('#serviceEditDef').validate().form())
            {
            	if(CKEDITOR.instances['definition'].getData())
                {
                   	jQuery('<input />').attr('type', 'hidden')
   	        		.attr('name', 'step_number')
   	        		.attr('value', stepnumber + '')
   	        		.appendTo('#serviceEditDef');

   	        		jQuery('<input />').attr('type', 'hidden')
                  		.attr('name', 'source')
                  		.attr('value', 'concept')
                  		.appendTo('#serviceEditDef');
          		
                   	jQuery('#serviceEditDef').submit();
                   	
                }
                else
                {
                   	jAlert('Please add Scope Definition Language.', 'Alert Message');
					return false;
                }
                   
   	        }*/

   	     if(${serviceProfileInstance.workflowMode == 'customized' && serviceProfileInstance?.stagingStatus.name == 'concept'})
			{
				window.location.href = '${baseurl}/service/changeCustomizeServiceStage?id='+${serviceProfileInstance?.id};
			}
   	    }
          
     
	});
</script>

<div id="wizard" class="swMain">
			<ul>
				<g:each var="step" status="i" in="${importServiceStageSteps['concept']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${i+1}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${importServiceStageSteps['concept']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

