<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<r:script>

	jQuery(document).ready(function(){
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/setup/showStage?source=portfolios'  ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=currentStepNo - 1%>, labelFinish:'Start', onFinish:onFinishCallback });
  		

    	function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
          }

        function showStepCallback(obj){
            
        		var elements = jQuery('.swMain ul.anchor li a:lt(' + <%=currentStepNo - 1%> + ')')
        		var step_num= obj.attr('rel');
        		for(var i=0; i<elements.length; i++){
					if(jQuery(elements[i]).hasClass('disabled')){
							jQuery(elements[i]).removeClass("disabled").addClass("done")
								.attr("isDone",1);
						}	
            	}
            	jQuery.ajax({
	                    url: '${baseurl}/portfolio/isPortfolioDefined',
	                    type: 'POST', async: false, cache: false, timeout: 30000,
	                    error: function(){
	                        return false;
	                    },
	                    success: function(msg)
	                    { 
	                       if(msg == 'false')
		                   {
                        		jQuery('.swMain .buttonFinish').addClass("buttonDisabled").addClass("buttonHide");
                        		
                           }
			                    
	                    }
	                });
            	
            	
        		
            }

		
		
    	function validateSteps(stepnumber){
    	
            var isStepValid = true;
            
        return true;
            	 
    }

    	function onFinishCallback()
    	{
    		window.location.href = '${baseurl}/home';
    		//return false;
    	}
          
     
		});
</r:script>

	<g:if test="${currentStepSequenceOrder != null}">
		<g:each in="${stagingInstanceList}" status="i" var="stage">
			<g:if test="${stage.sequenceOrder == currentStepSequenceOrder}">
				<g:set var="currentIndex" value="${i+1}"/>
			</g:if>
		</g:each>
	</g:if>
	
<div id="wizard" class="swMain">
			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.setupSteps['portfolios']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber"></label>
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.setupSteps['portfolios']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

