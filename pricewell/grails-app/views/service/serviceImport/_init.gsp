<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function(){
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showServiceImportStages?source=init&id=' + ${serviceProfileInstance?.id}  ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  ${serviceProfileInstance?.currentStep - 1}, labelFinish:'Conceptulization >>', onFinish:onFinishCallback });
  		
		var stepNumber
    	function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
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
            		
        }

		
		
    	function validateSteps(stepnumber){
    	
            var isStepValid = true;
            return true;	 
        }

    	function onFinishCallback()
    	{
        	var stepnumber = stepNumber;

        	if(jQuery('#assignProductManager').validate().form()){
 	    	   jQuery("#assignProductManager").submit();
 	        }
   	    }
          
     
	});
</script>

<div id="wizard" class="swMain">
			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.importServiceStageSteps['init']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${currentIndex}${(char)65+i}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.importServiceStageSteps['init']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

