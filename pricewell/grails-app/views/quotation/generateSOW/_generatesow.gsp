<%@ page import="com.valent.pricewell.ServiceStageFlow"%>
<%
	def baseurl = request.siteUrl
%>
<script>

	jQuery(document).ready(function(){
    		
  		jQuery('#wizard').smartWizard({contentURL:'${baseurl}/quotation/showGenerateSOWStages?source=generatesow&id=' + ${quotationInstance?.id}  ,contentCache:false,  onLeaveStep:leaveAStepCallback, onShowStep: showStepCallback, selected:  ${currentStep}-1, labelFinish:'Generate SOW', onFinish:onFinishCallback});//,  approveEnabled: true, labelApprove: 'Generate SOW', labelReject:'Opportunity >>', onApprove: onApprove, onReject: onReject });
  		
		var stepNumber

		function leaveAStepCallback(from, to){
    		var fromStepIdx = from.attr( "rel" );
    	    var toStepIdx = to.attr( "rel" );

    	    //alert(fromStepIdx + " " + toStepIdx);
    	    //var step_num= obj.attr('rel'); // get the current step number
            return validateSteps(fromStepIdx, toStepIdx); // return false to stay on step and true to continue navigation 
        }

        function showStepCallback(obj){
            
       		var elements = jQuery('.swMain ul.anchor li a:lt(' + ${currentStep - 1} + ')')
       		var step_num= obj.attr('rel');
       		stepNumber = obj.attr('rel');
       		for(var i=0; i<elements.length; i++){
				if(jQuery(elements[i]).hasClass('disabled')){
						jQuery(elements[i]).removeClass("disabled").addClass("done")
							.attr("isDone",1);
					}	
           	}
       		//jQuery('.swMain .buttonPrevious').addClass("buttonDisabled").addClass("buttonHide");

       		if(step_num == 3)
            {
                if(${quotationInstance?.milestones?.size() == 0})
       			{
           			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
       			}
            }

       		/*if(step_num == 2)
            {
       			jQuery.ajax({
       	            url: '${baseurl}/quotation/hasProjectParameters',
       	            data: {id: ${quotationInstance?.id}},
       	            type: 'POST', async: false, cache: false, timeout: 30000,
       	            error: function(){
       	                return false;
       	            },
       	            success: function(msg)
       	            { 
       	               if(msg == 'true')
       	               {
       	               		if(jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
       	               		{
       	            			jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
       		       			}
       	               }
       	               else
       	               {
       	               		if(!jQuery('.swMain .buttonNext').hasClass('buttonDisabled'))
       	               		{
       	            			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
       	        			}
       	               }
       	                  
       	               return false;  
       	            }
       	        });
            }*/

       		/*if(step_num == 4)
            {
       			jQuery('.swMain .buttonReject').addClass("buttonDisabled").addClass("buttonHide");
            }*/
       		
        }

		
		
    	function validateSteps(stepnumber, toStepIdx)
    	{
    		if(stepnumber == 1)
            {
    			if(loadSOWIntroduction())
        		{
    				if(jQuery('#sowIntroductionFrm').validate().form())
                	{	
               
               			jQuery('<input />').attr('type', 'hidden')
    	   	        		.attr('name', 'step_number')
    	   	        		.attr('value', stepnumber + '')
    	   	        		.appendTo('#sowIntroductionFrm');
       	            	jQuery('<input />').attr('type', 'hidden')
                      		.attr('name', 'source')
                      		.attr('value', 'generatesow')
                      		.appendTo('#sowIntroductionFrm');
       					jQuery('#sowIntroductionFrm').submit();
                			
                    } 
                	else return false;
            	}
    			else return false;
            					
            }

    		if(stepnumber == 2)
            {
    			if(loadProjectParameters())
        		{
    				if(jQuery('#createProjectParameterFrm').validate().form())
                	{	
               
               			jQuery('<input />').attr('type', 'hidden')
    	   	        		.attr('name', 'step_number')
    	   	        		.attr('value', stepnumber + '')
    	   	        		.appendTo('#createProjectParameterFrm');
       	            	jQuery('<input />').attr('type', 'hidden')
                      		.attr('name', 'source')
                      		.attr('value', 'generatesow')
                      		.appendTo('#createProjectParameterFrm');
       					jQuery('#createProjectParameterFrm').submit();
                			
                    } 
                	else return false;
            	}
    			else return false;				
            }
            
    		
            return true;	 
        }
		
		
    	function onFinishCallback()
    	{
    		//buildJSONDataForQuotationProperties(${quotationInstance?.id})

    		if(${isSampleSowOfTemplaterType} == true)
        	{
    			jQuery( "#reviewSOWJsonDataFrm" ).submit();
            }
    		else
        	{
    			buildSOWForQuotation(${quotationInstance?.id});
            }
		   	return true;
   	    }

    	function onApprove()
        {
    		buildSOWForQuotation(${quotationInstance?.id});
			return false;
        }
        
        function onReject()
        {
        	goToOpportunity(${quotationInstance?.id});
			return false;
        }

	});

	function downloadSOW(id, filePath)
	{
		jQuery.ajax({type:'POST',
			url: "${baseurl}/quotation/showInfo",
			data: {id: id } ,
			success:function(data,textStatus)
			{
				hideThrobberBox();
	    		jQuery("#filePath").val(filePath);
	    		goToOpportunity(id);
			},
			error:function(XMLHttpRequest,textStatus,errorThrown)
			{
				 //hideLoadingBox();
				 hideThrobberBox();
				 jQuery( "#failureDialog" ).dialog("open");
			}
		});
	}

</script>

<div id="wizard" class="swMain">
			<ul>
				<g:each var="step" status="i" in="${ServiceStageFlow.sowGenerateStageSteps['generatesow']}">
				
					<g:if test="${i < 4}">
						<li>
							<a href="#step-${i+1}">
				                <label class="stepNumber">${i+1}</label>
				                <span class="stepDesc">
				                   <small>${step[1]}</small>
				                </span>
				            </a>
			            </li>
					</g:if>
					<g:elseif test="${isSampleSowOfTemplaterType == true || isSampleSowOfTemplaterType == 'true'}">
						<li>
							<a href="#step-${i+1}">
				                <label class="stepNumber">${i+1}</label>
				                <span class="stepDesc">
				                   <small>${step[1]}</small>
				                </span>
				            </a>
			            </li>
					</g:elseif>
					
				</g:each>
  			</ul>
  			
  			<g:each var="step" status="i" in="${ServiceStageFlow.sowGenerateStageSteps['generatesow']}">
  			
  				<g:if test="${i < 4}">
					<div id="step-${i+1}">	
                    
        			</div>
				</g:if>
				<g:elseif test="${isSampleSowOfTemplaterType == true || isSampleSowOfTemplaterType == 'true'}">
					<div id="step-${i+1}">	
                    
        			</div>
				</g:elseif>
  				
  			</g:each>
 </div>

