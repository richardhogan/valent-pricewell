<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<r:script>

	var prevCalled = false;
    jQuery(document).ready(function(){
    	jQuery.getScript("${baseurl}/js/jquery.smartWizard-2.0.min.js", function() {
        	
  			jQuery('#wizard').smartWizard({contentURL:'${baseurl}/opportunity/showStage?source=valueProposition&id=' + <%=opportunityInstance?.id%> ,contentCache:false, transitionEffect:'slide', onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=opportunityInstance?.currentStep - 1%>});
  		});

    	function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
          }

        function showStepCallback(obj)
        {
        	var elements = jQuery('.swMain ul.anchor li a:lt(' + <%=opportunityInstance?.currentStep - 1%> + ')')
        		
    		for(var i=0; i<elements.length; i++)
    		{
				if(jQuery(elements[i]).hasClass('disabled'))
				{
					jQuery(elements[i]).removeClass("disabled").addClass("done")
						.attr("isDone",1);
				}	
        	}
        		
        }

    	
        
     
		});
</r:script>

<div id="wizard" class="swMain">
  			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.opportunityStageSteps['valueProposition']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${i+1}</label>
		                <span class="stepDesc">
		                   
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.opportunityStageSteps['valueProposition']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

