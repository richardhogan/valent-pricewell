
<%@ page import="com.valent.pricewell.Geo" %>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.GeoGroup" %>
<%@ page import="com.valent.pricewell.ObjectType" %>
<%
	def baseurl = request.siteUrl
%>
<html>
	<g:setProvider library="prototype"/>
		<style>
			.milestoneContent {
			    height: 290px;
			    padding: 10px;
			    border: 1px solid #c3c3c3;
			    margin: 10px;
			}
			.milestoneButton {
			    height: 40px;
			    margin-right: 10px;
    			margin-left: 10px;
    			text-align:center;
			}
			
			.saveMilestoneBtn{
			    height:40px; 
			    width:30%; 
			    font-size: 30px;
			}
		</style>
		
        <script>
		   	jQuery(function() 
		   	{
				jQuery(".sowMilestoneFrm").validate();
				
				jQuery('#amount').val("")//(0);
				jQuery('#amount2').val("")//(0);
				jQuery('#amount3').val("")//(0);
				jQuery('#amount4').val("")//(0);
				jQuery('#amount5').val("")//(0);
				jQuery('#amount6').val("")//(0);

				jQuery(".addMilestoneBtn").click(function()
				{
					var id = this.id.substring(15);
					id = parseInt(id);
					if(id == 2)
					{
						if(jQuery("#amount").val() == ""){jAlert('Please select amount first.', 'Milestone Amount Alert');return false;}
						jQuery( "#amount" ).attr('disabled', true);
					}
					else
					{
						if(jQuery("#amount"+(id-1)).val() == ""){jAlert('Please select amount first.', 'Milestone Amount Alert');return false;}
						jQuery( "#amount"+(id-1) ).attr('disabled', true);	
					}	
							
					if(id > 2)
					{
						jQuery("#cancelMilestoneBtn"+(id-1)).hide();
					}
					
					jQuery('#milestone'+id).addClass('required');
					jQuery('#defaultMilestone'+id).addClass('required');
					jQuery('#amount'+id).addClass('required');
					addOptionsInSelection("amount"+id);
					jQuery( ".quotationMilestone"+id ).show();
					jQuery(this).hide();
								
					return false;
				});
				
				jQuery(".cancelMilestoneBtn").click(function()
				{
					var id = this.id.substring(18);
					doMilestoneOperation(id)
					jQuery('#milestone'+id).val("").removeClass('required');
					jQuery('#defaultMilestone'+id).val("").removeClass('required');
					jQuery('#amount'+id).val("").removeClass('required');
					removeOptionsFromSelection("amount"+id);
					jQuery( ".quotationMilestone"+id ).hide();
					
					id = parseInt(id);	
					if(id == 2)
					{
						jQuery( "#amount" ).attr('disabled', false);
					}
					else
					{
						jQuery( "#amount"+(id-1) ).attr('disabled', false);	
					}	
					jQuery("#addMilestoneBtn"+id).show();
					if(id > 2)
					{
						jQuery("#cancelMilestoneBtn"+(id-1)).show();
					}
					
					doCalculation();
					
					return false;
				});
				
				jQuery( ".quotationMilestone2" ).hide();
				jQuery( ".quotationMilestone3" ).hide();
				jQuery( ".quotationMilestone4" ).hide();
				jQuery( ".quotationMilestone5" ).hide();
				jQuery( ".quotationMilestone6" ).hide();

				jQuery('#amount, #amount2, #amount3, #amount4, #amount5, #amount6').change(function(){
					var oldValue = jQuery(this).val();
					doCalculation(oldValue);
				});
				
				/*jQuery('#amount, #amount2, #amount3, #amount4, #amount5, #amount6').bind("keyup", function(event){
					var value = jQuery(this).val();
					if(value.length == 0)
					{
						jQuery(this).val(0);
					}
					doCalculation();
					//alert(jQuery(this).val());
				});*/

				jQuery(".saveMilestoneBtn").click(function()
				{
					catchAllMilestone();
	    			if(jQuery(".sowMilestoneFrm").validate().form())
					{
						if(parseFloat(jQuery("#leftQuotedPrice").val()) < 0)
						{
							jAlert('${message(code:'addMilestoneWhileGeneratingSOW.exceedMessage.alert')}', 'Exceed Milestone Price'); return false;
						}
						else if(parseFloat(jQuery("#leftQuotedPrice").val()) > 0)
						{
							jAlert('${message(code:'addMilestoneWhileGeneratingSOW.lessMessage.alert')}', 'Less Milestone Price'); return false;
						}
						else if(jQuery(".sowMilestoneFrm").validate().form())
						{
							releaseDisableFromAllSelectionContent();
									
							//showLoadingBox();
							showThrobberBox();
							jQuery.ajax({
								type: "POST",
								url: "${baseurl}/quotation/saveSOWMilestone",
								data:jQuery(".sowMilestoneFrm").serialize(),
								success: function(data)
								{
									//hideLoadingBox();
									hideThrobberBox();
									if(data == 'success')
									{
										disableAllSelectionContent();
										jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
									}
									
									return false;
								}, 
								error:function(XMLHttpRequest,textStatus,errorThrown){
									//hideLoadingBox();
									return false;
								}
							});
							
							return false;
						}
					}
	            	else return false;
				});	
				
				jQuery(".sowMilestoneFrm").submit(function() 
				{
					alert(1);
					/*releaseDisableFromAllSelectionContent();
							
					showLoadingBox();
					jQuery.ajax({
						type: "POST",
						url: "${baseurl}/quotation/saveSOWMilestone",
						data:jQuery(".sowMilestoneFrm").serialize(),
						success: function(data)
						{
							hideLoadingBox();
							if(data == 'success')
							{
								//buildSOWForQuotation(${quotationInstance.id});
								//jQuery("#saveMilestoneBtn").hide();
								jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
							}
							
							return false;
						}, 
						error:function(XMLHttpRequest,textStatus,errorThrown){
							//hideLoadingBox();
							return false;
						}
					});*/
					
					return false;
				});	
				
				jQuery(".dvNewMilestone").each(function( index ) {
					jQuery(this).hide();
				});
				
				jQuery('.newMilestone').keyup(function(){
				    this.value = this.value.toUpperCase();
				});
				
				jQuery(".newMilestoneBtn").click(function() 
				{
					var id = this.id.substring(15);
					jQuery("#isNewMilestone"+id).val(${true});
					jQuery("#dvDefaultMilestone"+id).hide();
					jQuery("#dvNewMilestone"+id).show();
					jQuery("#defaultMilestone"+id).removeClass('required'); jQuery("#defaultMilestone"+id).val("");
					jQuery("#newMilestone"+id).addClass('required');
					jQuery("#newMilestone"+id).focus();
					return false;
				});
				
				jQuery(".defaultMilestoneBtn").click(function() 
				{
					var id = this.id.substring(19);
					
					jQuery("#isNewMilestone"+id).val(${false});
					jQuery("#dvNewMilestone"+id).hide();
					jQuery("#dvDefaultMilestone"+id).show();
					jQuery("#newMilestone"+id).removeClass('required'); jQuery("#newMilestone"+id).val("");
					jQuery("#defaultMilestone"+id).addClass('required');
					return false;
				});			
			});

			function catchAllMilestone()
		   	{
		   		jQuery(".dvDefaultMilestone").each(function( index ) 
				{
					var id = this.id.substring(18);
					if(jQuery("#isNewMilestone"+id).val() == true || jQuery("#isNewMilestone"+id).val() == "true")
					{
						jQuery("#milestone"+id).val(jQuery("#newMilestone"+id).val());	
					}
					else
					{
						jQuery("#milestone"+id).val(jQuery("#defaultMilestone"+id).val());
					}
					
				});
			}
			
		   	function doMilestoneOperation(id)
		   	{
		   		jQuery("#isNewMilestone"+id).val(${false});
				jQuery("#dvDefaultMilestone"+id).show();
				jQuery("#dvNewMilestone"+id).hide();
				jQuery("#milestone"+id).removeClass('required'); jQuery("#milestone"+id).val("");
				jQuery("#newMilestone"+id).removeClass('required'); jQuery("#newMilestone"+id).val("");
			}
				
			function releaseDisableFromAllSelectionContent()
			{
		   		jQuery( "#amount" ).attr('disabled', false);
		   		jQuery( "#amount2" ).attr('disabled', false);
		   		jQuery( "#amount3" ).attr('disabled', false);
		   		jQuery( "#amount4" ).attr('disabled', false);
		   		jQuery( "#amount5" ).attr('disabled', false);
		   		jQuery( "#amount6" ).attr('disabled', false);
		   	}

		   	function disableAllSelectionContent()
		   	{
		   		var ap1 = (jQuery("#amount").val() == "") ? 0 : parseInt(jQuery("#amount").val());
				var ap2 = (jQuery("#amount2").val() == "") ? 0 : parseInt(jQuery("#amount2").val());
				var ap3 = (jQuery("#amount3").val() == "") ? 0 : parseInt(jQuery("#amount3").val());
				var ap4 = (jQuery("#amount4").val() == "") ? 0 : parseInt(jQuery("#amount4").val());
				var ap5 = (jQuery("#amount5").val() == "") ? 0 : parseInt(jQuery("#amount5").val());
				var ap6 = (jQuery("#amount6").val() == "") ? 0 : parseInt(jQuery("#amount6").val());

				if(ap1 == 100){}
				else if(ap2 != 0 && ((ap1+ap2) == 100)){jQuery( "#amount" ).attr('disabled', true);}
				else if(ap3 != 0 && ((ap1+ap2+ap3) == 100))
				{
					jQuery( "#amount" ).attr('disabled', true);
					jQuery( "#amount2" ).attr('disabled', true);
				}
				else if(ap4 != 0 && ((ap1+ap2+ap3+ap4) == 100))
				{
					jQuery( "#amount" ).attr('disabled', true);
					jQuery( "#amount2" ).attr('disabled', true);
					jQuery( "#amount3" ).attr('disabled', true);
				}
				else if(ap5 != 0 && ((ap1+ap2+ap3+ap4+ap5) == 100))
				{
					jQuery( "#amount" ).attr('disabled', true);
					jQuery( "#amount2" ).attr('disabled', true);
					jQuery( "#amount3" ).attr('disabled', true);
					jQuery( "#amount4" ).attr('disabled', true);
				}
				else if(ap6 != 0 && ((ap1+ap2+ap3+ap4+ap5+ap6) == 100))
				{
					jQuery( "#amount" ).attr('disabled', true);
					jQuery( "#amount2" ).attr('disabled', true);
					jQuery( "#amount3" ).attr('disabled', true);
					jQuery( "#amount4" ).attr('disabled', true);
					jQuery( "#amount5" ).attr('disabled', true);
				}
			}
			   	
			function goToOpportunity(id)
			{
				window.location = "${baseurl}/quotation/goToOpportunity/id";
			}

		   	function addOptionsInSelection(id)
			{
				var totalAssignedAmount = getTotalAssignedAmountPercentage();
				var amountLeft = 100 - totalAssignedAmount;

				var options = new Array();
				for(i=10; i <= amountLeft; i=i+10)
				{
					options.push(""+i);
				}

				jQuery(options).each(function(i, v){
					jQuery("select[name="+id+"]").append(jQuery("<option>", { value: v, html: v }));
			    });
			}

			function removeOptionsFromSelection(id)
			{
				var selectBox = document.getElementById(id);
				
				while (selectBox.firstChild)
				    selectBox.removeChild(selectBox.firstChild);

				jQuery("select[name="+id+"]").append(jQuery("<option>", { value: "", html: "-Choose Amount In %-" }));
			}

			function getTotalAssignedAmountPercentage()
			{
				var ap1 = (jQuery("#amount").val() == "") ? 0 : parseFloat(jQuery("#amount").val());
				var ap2 = (jQuery("#amount2").val() == "") ? 0 : parseFloat(jQuery("#amount2").val());
				var ap3 = (jQuery("#amount3").val() == "") ? 0 : parseFloat(jQuery("#amount3").val());
				var ap4 = (jQuery("#amount4").val() == "") ? 0 : parseFloat(jQuery("#amount4").val());
				var ap5 = (jQuery("#amount5").val() == "") ? 0 : parseFloat(jQuery("#amount5").val());
				var ap6 = (jQuery("#amount6").val() == "") ? 0 : parseFloat(jQuery("#amount6").val());

				return ap1+ap2+ap3+ap4+ap5+ap6;
			}
			
			function getTotalAssignedAmount()
			{
				var ap1 = (jQuery("#amount").val() == "") ? 0 : parseInt(jQuery("#amount").val());//parseFloat(jQuery("#amount").val());
				var ap2 = (jQuery("#amount2").val() == "") ? 0 : parseInt(jQuery("#amount2").val());//parseFloat(jQuery("#amount2").val());
				var ap3 = (jQuery("#amount3").val() == "") ? 0 : parseInt(jQuery("#amount3").val());//parseFloat(jQuery("#amount3").val());
				var ap4 = (jQuery("#amount4").val() == "") ? 0 : parseInt(jQuery("#amount4").val());//parseFloat(jQuery("#amount4").val());
				var ap5 = (jQuery("#amount5").val() == "") ? 0 : parseInt(jQuery("#amount5").val());//parseFloat(jQuery("#amount5").val());
				var ap6 = (jQuery("#amount6").val() == "") ? 0 : parseInt(jQuery("#amount6").val());//parseFloat(jQuery("#amount6").val());

				return ap1+ap2+ap3+ap4+ap5+ap6;
			}
			
			function doCalculation(oldValue)
			{
				var ap1 = (jQuery("#amount").val() == "") ? 0 : parseFloat(jQuery("#amount").val());
				var ap2 = (jQuery("#amount2").val() == "") ? 0 : parseFloat(jQuery("#amount2").val());
				var ap3 = (jQuery("#amount3").val() == "") ? 0 : parseFloat(jQuery("#amount3").val());
				var ap4 = (jQuery("#amount4").val() == "") ? 0 : parseFloat(jQuery("#amount4").val());
				var ap5 = (jQuery("#amount5").val() == "") ? 0 : parseFloat(jQuery("#amount5").val());
				var ap6 = (jQuery("#amount6").val() == "") ? 0 : parseFloat(jQuery("#amount6").val());

				//alert(ap1+ " " +ap2+ " " +ap3+ " " +ap4+ " " +ap5+ " " +ap6);
				var leftPer = 100 - ap1;
				if(leftPer < 0)
				{
					showExceedMilestonePercentage();
					jQuery('#amount').val(oldValue);//(0);
				}
				else if (leftPer - ap2 < 0){
					showExceedMilestonePercentage();
					jQuery('#amount2').val(oldValue);//(0);
					
				}
				else if (leftPer - ap2 - ap3 < 0){
					showExceedMilestonePercentage();
					jQuery('#amount3').val(oldValue);//(0);
				
				}
				else if (leftPer - ap2 - ap3 - ap4 < 0){
					showExceedMilestonePercentage();
					jQuery('#amount4').val(oldValue);//(0);
				
				}
				else if (leftPer - ap2 - ap3 - ap4 - ap5 < 0){
					showExceedMilestonePercentage();
					jQuery('#amount5').val(oldValue);//(0);
				
				}
				else if (leftPer - ap2 - ap3 - ap4 - ap5 - ap6 < 0){
					showExceedMilestonePercentage();
					jQuery('#amount6').val(oldValue);//(0);
				
				}
				else {
					var total = ${quotationInstance?.finalPrice};
					var tenthOfTotal = total * 0.10;
					//var a1 = total*((ap1)/100), a2 = total*((ap2)/100), a3 = total*((ap3)/100);
					//var a4 = total*((ap4)/100), a5 = total*((ap5)/100), a6 = total*((ap6)/100);
					
					/*var a1 = (tenthOfTotal*ap1/10), a2 = (tenthOfTotal*ap2/10), a3 = (tenthOfTotal*ap3/10);
					var a4 = (tenthOfTotal*ap4/10), a5 = (tenthOfTotal*ap5/10), a6 = (tenthOfTotal*ap6/10);*/

					//alert(a1+ " " +a2+ " " +a3+ " " +a4+ " " +a5+ " " +a6+ " " +tenthOfTotal);

					var totalAssignedPercentage = ap1 + ap2 + ap3 + ap4 + ap5 + ap6;

					var totalLeftPercentage = 100 - totalAssignedPercentage;
					
					var leftValue = tenthOfTotal * (totalLeftPercentage / 10); //total - a1 - a2 - a3 - a4 - a5 - a6;

					if(retr_dec(leftValue.toString()) > 2)
					{
						leftValue = leftValue.toFixed();
					}

					jQuery("#leftQuotedPrice").val(parseFloat(leftValue));
					
					if(leftValue < 0)
					{
						jAlert('${message(code:'addMilestoneWhileGeneratingSOW.exceedMessage.alert')}', 'Exceed Milestone Price');
					}
				}				

				disableEnableAddMilestoneAndContinueButton(); //check that sum of all milestone value reach to 100% then enable submit (continue) button and disable all addMilestone button
			}

			function retr_dec(num)
			{
				return (num.split('.')[1] || []).length;
			}
			
			function isFractionalPartLenthGreaterThanTwo(number) 
			{
				var s = number.split('.');

				if (s[1].length > 2) 
				{
					return true;
				}

				return false;
			}
			
			function showExceedMilestonePercentage()
			{
				jAlert("${message(code:'addMilestoneWhileGeneratingSOW.exceedPercentageMessage.alert')}", "Exceed Milestone %");
			}

			function disableEnableAddMilestoneAndContinueButton()
    		{
        		if(getTotalAssignedAmountPercentage() == 100)
            	{
	    			if(jQuery(".saveMilestoneBtn").attr('disabled'))
	        		{
	    				jQuery(".saveMilestoneBtn").removeAttr("disabled");
	    				jQuery(".addMilestoneBtn").each(function()
   	                	{
   	        				  jQuery( this ).attr("disabled", "disabled");
   	        			});
	    			}
            	}
        		else
            	{
        			jQuery(".saveMilestoneBtn").attr("disabled", "disabled");
        			jQuery('.swMain .buttonNext').addClass("buttonDisabled").addClass("buttonHide");
        			jQuery(".addMilestoneBtn").each(function()
                	{
        				  jQuery( this ).removeAttr("disabled");
        			});
            	}
        	}
        	
	   	</script>
        
    <body>
    
    	<div class="body" id="dvMainSOWMilestone">
				
		            <g:form action="saveSOWMilestones" name="sowMilestoneFrm" class="sowMilestoneFrm" >
		            	<g:hiddenField name="id" value="${quotationInstance?.id}" />
		            	<g:hiddenField name="priceIn" value="percentage" />
		            	<g:hiddenField name="step_number" value="2" />
		            	<g:hiddenField name="source" value="generatesow" />
		            	<div class="dialog milestoneContent" >
	                        
	                        <table>
	                        	<tbody>
	                        		<tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="quotedPrice">Total Quoted Price</label>
		                                </td>
		                                <td valign="top">
		                                    <g:textField name="totalQuotedPrice" value="${quotationInstance?.finalPrice}" class="required" readOnly="true"/>
		                                </td>		                                
		                            	
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="leftPrice">Price left to add in milestone</label>
		                                </td>
		                                <td valign="top">
		                                    <g:textField name="leftQuotedPrice" value="${quotationInstance?.finalPrice}" class="required" readOnly="true"/>
		                                </td>
									</tr>
	                        	</tbody>
	                        </table>
	                        
	                        <g:set var="milestoneTypes" value="${ObjectType.getMilestoneTypes()}" />
	                        <g:set var="milestones" value="${quotationInstance?.milestones?.sort{it.id}}" />
	                        
	                        <table>
	                        	<tbody>
		                            <tr class="prop">
		                                <td valign="top" class="name">
		                                    <label for="milestone"><g:message code="quotationMilestone.milestone.label" default="Milestone" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
		                                    <!--<g:textArea name="milestone" value="" class="required" cols="40" rows="3"/>-->
		                                    
		                                    <g:hiddenField name="isNewMilestone1" value="${false}" />
		                                    <g:hiddenField name="milestone1" value="" class="required"/>
		                                    
		                                    <div id="dvDefaultMilestone1" class="dvDefaultMilestone">
	                                			<g:select name="defaultMilestone1" from="${milestoneTypes}" value="" noSelection="['':'-Select Default One-']" class="required"/>
	                                			
	                                			<button id="newMilestoneBtn1" class="roundNewButton newMilestoneBtn"  title="New Milestone">+</button>
	                                		</div>
	                                		<div id="dvNewMilestone1" class="dvNewMilestone">
	                                			<g:textField name="newMilestone1" value="" class="newMilestone" />
	                                			
	                                			<button id="defaultMilestoneBtn1" class="roundNewButton defaultMilestoneBtn"  title="List Default Milestone">-</button>
	                                			
	                                			<br/>
	                                			<p style="color: blue;">Write Milestone you want in above text field.</p>
	                                		</div>
                                		
		                                </td>
		                                
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Percentage" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
		                                    <!-- <g:textField name="amount" value="" class="required number"/> % -->
		                                    <g:select name="amount" from="${['10', '20', '30', '40', '50', '60', '70', '80', '90', '100']}" value="" noSelection="['':'-Choose Amount In %-']" class="required"/>
		                                </td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="addMilestoneBtn2" title="Add 2nd Milestone" class="addMilestoneBtn"> Add </button></span></td>
		                                
		                                <script>
		                                	if(${milestones?.size() > 0})
			                                {
				                                jQuery("#amount").val(${milestones?.toList()?.getAt(0)?.percentage});
				                                jQuery("#defaultMilestone1").val('${milestones?.toList()?.getAt(0)?.milestone}');
				                                jQuery("#milestone1").val('${milestones?.toList()?.getAt(0)?.milestone}');

				                                //jQuery("#addMilestoneBtn2").hide();
					                            
				                            }
											//alert(${quotationInstance?.milestones?.toList()?.getAt(0)?.percentage});
		                                </script>
		                            </tr>
		                            
		                            <tr class="prop quotationMilestone2">
		                                <td valign="top" class="name">
		                                    <label for="milestone2"><g:message code="quotationMilestone.milestone.label" default="2nd Milestone" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
		                                    <!--<g:textArea name="milestone2" value="" class="" cols="40" rows="3"/>-->
		                                    
		                                    <g:hiddenField name="isNewMilestone2" value="${false}" />
		                                    <g:hiddenField name="milestone2" value="" />
		                                    
		                                    <div id="dvDefaultMilestone2" class="dvDefaultMilestone">
	                                			<g:select name="defaultMilestone2" from="${milestoneTypes}" value="" noSelection="['':'-Select Default One-']" />
	                                			
	                                			<button id="newMilestoneBtn2" class="roundNewButton newMilestoneBtn"  title="New Milestone">+</button>
	                                		</div>
	                                		<div id="dvNewMilestone2" class="dvNewMilestone">
	                                			<g:textField name="newMilestone2" value="" class="newMilestone" />
	                                			
	                                			<button id="defaultMilestoneBtn2" class="roundNewButton defaultMilestoneBtn"  title="List Default Milestone">-</button>
	                                			
	                                			<br/>
	                                			<p style="color: blue;">Write Milestone you want in above text field.</p>
	                                		</div>
	                                		
		                                </td>
		                                
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Percentage" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
		                                    <!-- <g:textField name="amount2" value="" class="number"/> % -->
		                                    <g:select name="amount2" id="amount2" from="" class="" value="" noSelection="['':'-Choose Amount In %-']"/>
		                                </td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="addMilestoneBtn3" title="Add 3rd Milestone" class="addMilestoneBtn"> Add </button></span></td>
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="cancelMilestoneBtn2" title="Cancel 2nd Milestone" class="cancelMilestoneBtn"> Cancel </button></span></td>
		                                
		                                <script>
		                                	if(${milestones?.size() > 1})
			                                {
		                                		addOptionsInSelection("amount2");
				                                jQuery("#amount2").val(${milestones?.toList()?.getAt(1)?.percentage});
				                                jQuery("#defaultMilestone2").val('${milestones?.toList()?.getAt(1)?.milestone}');
				                                jQuery("#milestone2").val('${milestones?.toList()?.getAt(1)?.milestone}');
				                                jQuery(".quotationMilestone2").show();

				                                jQuery("#addMilestoneBtn2").hide();
				                                jQuery( "#amount" ).attr('disabled', true);
				                                //jQuery("#cancelMilestoneBtn2").hide();
				                            }
											
		                                </script>
		                            </tr>
		                            
		                            <tr class="prop quotationMilestone3">
		                                <td valign="top" class="name">
		                                    <label for="milestone3"><g:message code="quotationMilestone.milestone.label" default="3rd Milestone" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
		                                    <!--<g:textArea name="milestone3" value="" class="" cols="40" rows="3"/>-->
		                                    
		                                    <g:hiddenField name="isNewMilestone3" value="${false}" />
		                                    <g:hiddenField name="milestone3" value="" />
		                                    
		                                    <div id="dvDefaultMilestone3" class="dvDefaultMilestone">
	                                			<g:select name="defaultMilestone3" from="${milestoneTypes}" value="" noSelection="['':'-Select Default One-']"/>
	                                			
	                                			<button id="newMilestoneBtn3" class="roundNewButton newMilestoneBtn"  title="New Milestone">+</button>
	                                		</div>
	                                		<div id="dvNewMilestone3" class="dvNewMilestone">
	                                			<g:textField name="newMilestone3" value="" class="newMilestone" />
	                                			
	                                			<button id="defaultMilestoneBtn3" class="roundNewButton defaultMilestoneBtn"  title="List Default Milestone">-</button>
	                                			
	                                			<br/>
	                                			<p style="color: blue;">Write Milestone you want in above text field.</p>
	                                		</div>
	                                		
		                                </td>
		                                
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Percentage" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
		                                    <!-- <g:textField name="amount3" value="" class="number"/> % -->
		                                    <g:select name="amount3" id="amount3" from="" class="" value="" noSelection="['':'-Choose Amount In %-']"/>
		                                </td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="addMilestoneBtn4" title="Add 4th Milestone" class="addMilestoneBtn"> Add </button></span></td>
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="cancelMilestoneBtn3" title="Cancel 3rd Milestone" class="cancelMilestoneBtn"> Cancel </button></span></td>
		                                
		                                <script>
		                                	if(${milestones?.size() > 2})
			                                {
		                                		addOptionsInSelection("amount3");
				                                jQuery("#amount3").val(${milestones?.toList()?.getAt(2)?.percentage});
				                                jQuery("#defaultMilestone3").val('${milestones?.toList()?.getAt(2)?.milestone}');
				                                jQuery("#milestone3").val('${milestones?.toList()?.getAt(2)?.milestone}');
				                                jQuery(".quotationMilestone3").show();

				                                jQuery("#addMilestoneBtn3").hide();
				                                jQuery( "#amount2" ).attr('disabled', true);
				                                jQuery("#cancelMilestoneBtn2").hide();
				                            }
											
		                                </script>
		                            </tr>
		                            
		                            <tr class="prop quotationMilestone4">
		                                <td valign="top" class="name">
		                                    <label for="milestone4"><g:message code="quotationMilestone.milestone.label" default="4th Milestone" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
		                                    <!--<g:textArea name="milestone4" value="" class="" cols="40" rows="3"/>-->
		                                    
		                                    <g:hiddenField name="isNewMilestone4" value="${false}" />
		                                    <g:hiddenField name="milestone4" value="" />
		                                    
		                                    <div id="dvDefaultMilestone4" class="dvDefaultMilestone">
	                                			<g:select name="defaultMilestone4" from="${milestoneTypes}" value="" noSelection="['':'-Select Default One-']"/>
	                                			
	                                			<button id="newMilestoneBtn4" class="roundNewButton newMilestoneBtn"  title="New Milestone">+</button>
	                                		</div>
	                                		<div id="dvNewMilestone4" class="dvNewMilestone">
	                                			<g:textField name="newMilestone4" value="" class="newMilestone" />
	                                			
	                                			<button id="defaultMilestoneBtn4" class="roundNewButton defaultMilestoneBtn"  title="List Default Milestone">-</button>
	                                			
	                                			<br/>
	                                			<p style="color: blue;">Write Milestone you want in above text field.</p>
	                                		</div>
	                                		
		                                </td>
		                                
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Percentage" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
		                                    <!-- <g:textField name="amount4" value="" class="number"/> % -->
		                                    <g:select name="amount4" id="amount4" from="" class="" value="" noSelection="['':'-Choose Amount In %-']"/>
		                                </td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="addMilestoneBtn5" title="Add 5th Milestone" class="addMilestoneBtn"> Add </button></span></td>
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="cancelMilestoneBtn4" title="Cancel 4th Milestone" class="cancelMilestoneBtn"> Cancel </button></span></td>
		                                
		                                <script>
		                                	if(${milestones?.size() > 3})
			                                {
		                                		addOptionsInSelection("amount4");
				                                jQuery("#amount4").val(${milestones?.toList()?.getAt(3)?.percentage});
				                                jQuery("#defaultMilestone4").val('${milestones?.toList()?.getAt(3)?.milestone}');
				                                jQuery("#milestone4").val('${milestones?.toList()?.getAt(3)?.milestone}');
				                                jQuery(".quotationMilestone4").show();

				                                jQuery("#addMilestoneBtn4").hide();
				                                jQuery( "#amount3" ).attr('disabled', true);
				                                jQuery("#cancelMilestoneBtn3").hide();
				                            }
											
		                                </script>
		                                
		                            </tr>
		                            
		                            <tr class="prop quotationMilestone5">
		                                <td valign="top" class="name">
		                                    <label for="milestone5"><g:message code="quotationMilestone.milestone.label" default="5th Milestone" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
		                                    
		                                    <g:hiddenField name="isNewMilestone5" value="${false}" />
		                                    <g:hiddenField name="milestone5" value="" />
		                                    
		                                    <div id="dvDefaultMilestone5" class="dvDefaultMilestone">
	                                			<g:select name="defaultMilestone5" from="${milestoneTypes}" value="" noSelection="['':'-Select Default One-']" />
	                                			
	                                			<button id="newMilestoneBtn5" class="roundNewButton newMilestoneBtn"  title="New Milestone">+</button>
	                                		</div>
	                                		<div id="dvNewMilestone5" class="dvNewMilestone">
	                                			<g:textField name="newMilestone5" value="" class="newMilestone" />
	                                			
	                                			<button id="defaultMilestoneBtn5" class="roundNewButton defaultMilestoneBtn"  title="List Default Milestone">-</button>
	                                			
	                                			<br/>
	                                			<p style="color: blue;">Write Milestone you want in above text field.</p>
	                                		</div>
	                                		
		                                </td>
		                                
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Percentage" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
		                                    <g:select name="amount5" id="amount5" from="" class="" value="" noSelection="['':'-Choose Amount In %-']"/>
		                                </td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="addMilestoneBtn6" title="Add 6th Milestone" class="addMilestoneBtn"> Add </button></span></td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="cancelMilestoneBtn5" title="Cancel 5th Milestone" class="cancelMilestoneBtn"> Cancel </button></span></td>
		                                
		                                <script>
		                                	if(${milestones?.size() > 4})
			                                {
		                                		addOptionsInSelection("amount5");
				                                jQuery("#amount5").val(${milestones?.toList()?.getAt(4)?.percentage});
				                                jQuery("#defaultMilestone5").val('${milestones?.toList()?.getAt(4)?.milestone}');
				                                jQuery("#milestone5").val('${milestones?.toList()?.getAt(4)?.milestone}');
				                                jQuery(".quotationMilestone5").show();

				                                jQuery("#addMilestoneBtn5").hide();
				                                jQuery( "#amount4" ).attr('disabled', true);
				                                jQuery("#cancelMilestoneBtn4").hide();
				                            }
											
		                                </script>
		                            </tr>
		                            
		                            <tr class="prop quotationMilestone6">
		                                <td valign="top" class="name">
		                                    <label for="milestone6"><g:message code="quotationMilestone.milestone.label" default="6th Milestone" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'milestone', 'errors')}">
		                                    <!--<g:textArea name="milestone6" value="" class="" cols="40" rows="3"/>-->
		                                    
		                                    <g:hiddenField name="isNewMilestone6" value="${false}" />
		                                    <g:hiddenField name="milestone6" value="" />
		                                    
		                                    <div id="dvDefaultMilestone6" class="dvDefaultMilestone">
	                                			<g:select name="defaultMilestone6" from="${milestoneTypes}" value="" noSelection="['':'-Select Default One-']" />
	                                			
	                                			<button id="newMilestoneBtn6" class="roundNewButton newMilestoneBtn"  title="New Milestone">+</button>
	                                		</div>
	                                		<div id="dvNewMilestone6" class="dvNewMilestone">
	                                			<g:textField name="newMilestone6" value="" class="newMilestone" />
	                                			
	                                			<button id="defaultMilestoneBtn6" class="roundNewButton defaultMilestoneBtn"  title="List Default Milestone">-</button>
	                                			
	                                			<br/>
	                                			<p style="color: blue;">Write Milestone you want in above text field.</p>
	                                		</div>
	                                		
		                                </td>
		                                
		                            	<td>&nbsp;</td>
		                            	
		                                <td valign="top" class="name">
		                                    <label for="amount"><g:message code="quotationMilestone.amount.label" default="Percentage" /></label><em>*</em>
		                                </td>
		                                <td valign="top" class="value ${hasErrors(bean: quotationMilestoneInstance, field: 'amount', 'errors')}">
		                                    <!-- <g:textField name="amount6" value="" class="number"/> % -->
		                                    <g:select name="amount6" id="amount6" from="" class="" value="" noSelection="['':'-Choose Amount In %-']"/>
		                                </td>
		                                
		                                <td>&nbsp;</td>
		                                
		                                <td></td>
		                                
		                                <td>&nbsp;</td>
		                                <td><span class="button"><button id="cancelMilestoneBtn6" title="Cancel 6th Milestone" class="cancelMilestoneBtn"> Cancel </button></span></td>
		                                
		                                <script>
		                                	if(${milestones?.size() > 5})
			                                {
			                                	addOptionsInSelection("amount6");
				                                jQuery("#amount6").val(${milestones?.toList()?.getAt(5)?.percentage});
				                                jQuery("#defaultMilestone6").val('${milestones?.toList()?.getAt(5)?.milestone}');
				                                jQuery("#milestone6").val('${milestones?.toList()?.getAt(5)?.milestone}');
				                                jQuery(".quotationMilestone6").show();
				                                
				                                jQuery( "#amount5" ).attr('disabled', true);
				                                jQuery("#cancelMilestoneBtn5").hide();
				                            }
											
		                                </script>
		                            </tr>
				                        </tbody>
		                    </table>
		                </div>
		               	<div class="buttons milestoneButton">
		                	<span class="button"><button id="saveMilestoneBtn" class="saveMilestoneBtn" disabled="disabled" title="Save SOW Milestone"> Save </button></span>
		                	
		                	<script>
                               	if(${milestones?.size() > 0})
                                {
                                	disableEnableAddMilestoneAndContinueButton();
                                	jQuery("#leftQuotedPrice").val(0);
                                	jQuery('.swMain .buttonNext').removeClass("buttonDisabled").removeClass("buttonHide");
	                            }
								
                            </script>
		                </div>
		            </g:form>
			
        </div>
    </body>
</html>
