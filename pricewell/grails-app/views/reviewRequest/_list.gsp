
<%@ page import="com.valent.pricewell.ReviewRequest" %>
<%
	def baseurl = request.siteUrl
%>
	<style type="text/css" title="currentStyle">
		@import "${baseurl}/js/dataTables/css/demo_page.css";
		@import "${baseurl}/js/dataTables/css/demo_table.css";
	</style>
		
	<style>
			/* Left Div */
			.LeftDiv{
				  width: 50%;
				  padding: 0 0px;
				  float:left;
				  
				 }
			
			/* Right Div */
			.RightDiv{
				  width: 40%;
				  padding: 0 0px;
				  float: right;
				  
				 } 
	</style>
		
	<g:setProvider library="prototype"/>
	<script type="text/javascript" language="javascript" src="${baseurl}/js/dataTables/js/jquery.dataTables.js"></script>	
	<script>
		jQuery(document).ready(function()
		{
			
			jQuery('.buttonSmall').each(function()
					   {
					      jQuery(this).qtip({
					         content: jQuery(this).attr('tooltip'), // Use the tooltip attribute of the element for the content
					         style: 'dark', // Give it a crea mstyle to make it stand out
					        	 
					               position: {
					                  corner: {
					                      // Use the corner...
					                     target: 'bottomLeft' // ...and opposite corner
					                  }
					               }
					      });
			
			});
			
			var oTable = jQuery('#reviewRequestList').dataTable({
					"sPaginationType": "full_numbers",
					"sDom": '<"H"f>t<"F"ip>',
				    "aaSorting": [[ 3, "desc" ]],
			        "fnDrawCallback": function() {
		                if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
		                        jQuery('.dataTables_paginate').css("display", "block"); 
		                        jQuery('.dataTables_length').css("display", "block");                 
		                } else {
		                		jQuery('.dataTables_paginate').css("display", "none");
		                		jQuery('.dataTables_length').css("display", "none");
		                }
		            }
			    } );

		});

		function createReviewRequest()
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/reviewRequest/create",
				data: {'serviceProfileId': '${serviceProfileInstance?.id}' , 'userId': '${userInstance?.id}', 'category': '${category}', 'type': '${type}'},
				success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}

		function reviewRequestList(type)
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/reviewRequest/list",
				data: {'category': '${category}', 'type': type},
				success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}

		function showRequest(id)
		{
			jQuery.ajax({
				type: "POST",
				url: "${baseurl}/reviewRequest/show",
				data: {'category': '${category}', 'type': '${type}', 'id': id},
				success: function(data){jQuery("#mainReviewBoardTab").html(data);}, 
				error:function(XMLHttpRequest,textStatus,errorThrown){alert("Error while saving");}
			});
			
			return false;
		}
	</script>
			
    <g:set var="entityName" value="${message(code: 'reviewRequest.label', default: 'Review Request')}" />
   
   	<div class="body">
    
    	<div class="nav">
	            <span>
	            	<a id="idCreateReviewRequest" onclick="createReviewRequest();" class="buttons.button button" title="Create Review Request">Create Review Request</a>

	            </span>
        </div>
        	
    	<div class="leftNavSmall">      		
    		<g:render template="nevigation"/>
    	</div>	
        
        <div id="columnRight" class="body rightContent column">
        	
            <div>
            	<div class="LeftDiv"><h1>${title} - ${type}</h1></br>
            	
            		
            		<span class="menuButton">
            			<!--<g:remoteLink class="list" controller="reviewRequest" action="list" params="['category': category, 'type': 'Pending']" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']" title="Pending Review Requests">Pending Request</g:remoteLink>-->
            			
            			<a id="idPendingReviewRequest" onclick="reviewRequestList('Pending');" class="list" title="Pending Review Request">Pending Request</a>
            		</span>
            		&nbsp;&nbsp;
            		<span class="menuButton">
            			<!--<g:remoteLink class="list" controller="reviewRequest" action="list" params="['category': category, 'type': 'Archive']" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']" title="Archive Review Requests">Archive Request</g:remoteLink>-->
            			
            			<a id="idArchiveReviewRequest" onclick="reviewRequestList('Archive');" class="list" title="Archive Review Requests">Archive Request</a>
            		</span></br></br>
					         		
            	</div>
            	
            </div>
            
            <div class="list">
            
                <table cellpadding="0" cellspacing="0" border="0" class="display" id="reviewRequestList">
                    <thead>
                        <tr>
                        
                            <th><g:message property="subject" code="reviewRequest.subject.label" default="Subject" /></th>
                        
                            <th><g:message property="status" code="reviewRequest.status.label" default="Status" /></th>
                            
                            <th><g:message property="description" code="reviewRequest.description.label" default="Description" /></th>
                            
                            <th><g:message property="dateModified" code="reviewRequest.dateModified.label" default="DateModified" /></th>
                            
                            <th><g:message code="reviewRequest.submitter.label" default="Submitter" /></th>
                        	
                        	<th><g:message code="reviewRequest.assignees.label" default="Reviewer" /></th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${reviewRequestInstanceList}" status="i" var="reviewRequestInstance">
                        <tr>
                        
                            <td>
                            	<a id="idShowReviewRequest-${reviewRequestInstance.id}" onclick="showRequest(${reviewRequestInstance.id});" class="hyperlink" title="Show Review Request">${fieldValue(bean: reviewRequestInstance, field: "subject")}</a>
                            	<!-- <g:remoteLink controller="reviewRequest" title="Show Review Request" class="hyperlink" action="show" id="${reviewRequestInstance.id}"  params="['category': category, 'type': type]" update="[success:'mainReviewBoardTab',failure:'mainReviewBoardTab']">${fieldValue(bean: reviewRequestInstance, field: "subject")} </g:remoteLink> -->
                            </td>
                        
                            <td>${fieldValue(bean: reviewRequestInstance, field: "status")}</td>
                        
                            <td>${fieldValue(bean: reviewRequestInstance, field: "description")}</td>
                                                
                            <td><g:formatDate format="MMMMM d, yyyy" date="${reviewRequestInstance.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: reviewRequestInstance, field: "submitter")}</td>
                        
                        	<td>
                        		<g:each in="${reviewRequestInstance.assignees}" var="a" status="k">
		                        	
		                        		<g:if test="${k>0}">
		                        			;
		                        		</g:if>
		                            	<span> ${a?.encodeAsHTML()} </span>
		                            
		                        </g:each>
                        	</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            
        </div>
  </div> 

