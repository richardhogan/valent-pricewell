<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<r:script>

	var stepNumber
	jQuery(document).ready(function(){
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/setup/showStage?source=addUsers'  ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=currentStepNo - 1%>, labelFinish:'Add Delivery Roles', onFinish:onFinishCallback });
  		

    	function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            validateSteps(step_num); // return false to stay on step and true to continue navigation
            return reloadPage();
          }

		function reloadPage()
		{
			location.reload();
		}
		
        function showStepCallback(obj){
            
            	stepNumber = obj.attr('rel');
        		var elements = jQuery('.swMain ul.anchor li a:lt(' + <%=currentStepNo - 1%> + ')')
        		var step_num= obj.attr('rel');
        		for(var i=0; i<elements.length; i++){
					if(jQuery(elements[i]).hasClass('disabled')){
							jQuery(elements[i]).removeClass("disabled").addClass("done")
								.attr("isDone",1);
						}	
            	}
            	jQuery.ajax({
	                    url: '${baseurl}/setup/isUserDefined',
	                    type: 'POST', async: false, cache: false, timeout: 30000,
	                    error: function(){
	                        return false;
	                    },
	                    success: function(msg)
	                    { 
	                       if(msg == 'false')
		                   {
		                   		if(stepNumber != 9)
                        			{jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");}
                        			
                        		else if(stepNumber == 9)
                        			{jQuery('.swMain .buttonFinish').addClass("buttonDisabled").addClass("buttonHide");}
                        		
                        		
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
    		window.location.href = '${baseurl}/setup/changeStage';
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
				<g:each var="step" status="i" in="${ServiceStageFlow.setupSteps['addUsers']}">
					<li><a href="#step-${i+1}">
		                <span class="stepDesc">
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.setupSteps['addUsers']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

