<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>

<script type="text/javascript">
   
    jQuery(document).ready(function(){
    	jQuery.getScript("${baseurl}/js/jquery.smartWizard-2.0.min.js", function() {
        	
  					jQuery('#wizard').smartWizard({contentURL:'${baseurl}/service/showStage?source=conceptreview&id=' + <%=serviceProfileInstance?.id%> ,contentCache:false, transitionEffect:'slide', onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=serviceProfileInstance?.currentStep - 1%>, labelFinish:'Approve', onFinish:onFinishCallback });
  		});

    	function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
          }

        function showStepCallback(obj){
        		var elements = jQuery('.swMain ul.anchor li a:lt(' + <%=serviceProfileInstance?.currentStep - 1%> + ')')
        		
        		for(var i=0; i<elements.length; i++){
					if(jQuery(elements[i]).hasClass('disabled')){
							jQuery(elements[i]).removeClass("disabled").addClass("done")
								.attr("isDone",1);
						}	
            	}
        		
            }

    	function validateSteps(stepnumber){
            	return true;
            	 
            }

    	function onFinishCallback(){
    			jQuery('#approveForm').submit();
    	      }
          
     
		});
</script>

<div id="wizard" class="swMain">
  			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['conceptreview']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${i+1}</label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.stageSteps['conceptreview']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

