<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<script>

	var prevCalled = false;
    jQuery(document).ready(function(){
    	jQuery('#wizard').smartWizard({contentURL:'${baseurl}/lead/showStage?source=converttoopportunity&id=' + <%=leadInstance?.id%> ,contentCache:false, transitionEffect:'slide', onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  <%=leadInstance?.currentStep - 1%>, labelFinish:'Create Opportunity', enableFinishButton: true, onFinish:onFinishCallback});

    	function leaveAStepCallback(obj){
            var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(step_num); // return false to stay on step and true to continue navigation 
          }

        function showStepCallback(obj)
        {
        	var elements = jQuery('.swMain ul.anchor li a:lt(' + <%=leadInstance?.currentStep - 1%> + ')')
        	var step_num = obj.attr('rel');
    		for(var i=0; i<elements.length; i++)
    		{
				if(jQuery(elements[i]).hasClass('disabled'))
				{
					jQuery(elements[i]).removeClass("disabled").addClass("done")
						.attr("isDone",1);
				}	
        	}

        	if(step_num == 1 )
        	{	if(${leadInstance?.contact == null})
        		jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
        	}
        		
        	jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");
        }

    	
        function validateSteps(stepnumber)
        {    	
        	if(stepnumber == 1 )
        	{
            		jQuery('<input />').attr('type', 'hidden')
	        		.attr('name', 'step_number')
	        		.attr('value', stepnumber + '')
	        		.appendTo('#leadConverter');
	        		
	            	jQuery('<input />').attr('type', 'hidden')
	           		.attr('name', 'source')
	           		.attr('value', 'converttoopportunity')
	           		.appendTo('#leadConverter');
	           		
					//jQuery('#leadConverter').submit();
					return true;
				
            }

        }
        
        function onFinishCallback(){
    	       if(jQuery("#opportunityCreate").validate().form()){
    	    	   jQuery("#opportunityCreate").submit();
    	       }
    	      }
     
		});
</script>

<div id="wizard" class="swMain">
  			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.leadStageSteps['converttoopportunity']}">
					<li><a href="#step-${i+1}">
		                <label class="stepNumber">${i+1}</label>
		                <span class="stepDesc">
		                   
		                   <small>${step[1]}</small>
		                </span>
		            </a></li>
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.leadStageSteps['converttoopportunity']}">
  				<div id="step-${i+1}">	
                    
        		</div>
  			</g:each>
 </div>

