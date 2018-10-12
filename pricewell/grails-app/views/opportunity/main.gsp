<%@ page import="com.valent.pricewell.Opportunity"%>
<%@ page import="com.valent.pricewell.Staging"%>
<%
	def baseurl = request.siteUrl
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="layout" content="main" />
			
		<g:set var="entityName" value="${message(code: 'opportunity.label', default: 'Opportunity')}" />
		<title><g:message code="default.show.opportunity" args="[entityName]" />
		</title>
		
		<modalbox:modalIncludes />
		<ckeditor:resources/>
		
		<g:setProvider library="prototype"/>
		<style>
			p {
				font-size: 100%;
				margin: 0 0 0em;
			}
			
			.stageChange {
			   background-color: #18216B;
			   color: orange
			   text-align: center;
			}
						
			td.name {
				font-weight: bold;
				font-size: 85%
			}
			
			td.Value {
				font-weight: bold;
				font-size: 95%
			}
			
			td.reduced {
				font-size: 90%
			}
			
			label.error 
			{
				margin-left: 10px;
				width: auto;
				display: inline;
			}
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			
			.collapse p {padding:0 10px 1em}
			.top{font-size:.9em; text-align:right}
			#switch, .switch {margin-bottom:5px; text-align:right}
			
			/* --- Headings  --- */
			
			.expand{padding-bottom:.75em}
			
			/* --- Links  --- 
			a:link, a:visited {
			  border:1px dotted #ccc;
			  border-width:0 0 1px;
			  text-decoration:none;
			  color:blue
			}
			a:hover, a:active, a:focus {
			  border-style:solid;
			  background-color:#f0f0f0;
			  outline:0 none
			}
			a:active, a:focus {
			  color:red;
			} */
			.expand a {
			  display:block;
			  padding:3px 10px
			}
			.expand a:link, .expand a:visited {
			  border-width:1px;
			  background-image:url(${baseurl}/images/arrow-down.gif);
			  background-repeat:no-repeat;
			  background-position:98% 50%;
			}
			.expand a:hover, .expand a:active, .expand a:focus {
			  text-decoration:underline
			}
			.expand a.open:link, .expand a.open:visited {
			  border-style:solid;
			  background:#eee url(${baseurl}/images/arrow-up.gif) no-repeat 98% 50%
			}
		
		  	
		</style>
		
		<script>

			 jQuery(document).ready(function()
			 {
			
				 jQuery('.edit').attr("title", "Edit");
				 jQuery('.delete').attr("title", "Delete");

			 });
			 
	    </script>
	</head>
	<body>
  
	  	<div class="nav">
	        <!--span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span-->
	        <!--<span><A HREF="javascript:history.go(-1)" class="buttons.button button">Back</A></span>-->
	        <span><g:link action="list" title="List Of Opportunities" class="buttons.button button"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
	        <span><g:link action="create" title="Create Opportunity" class="buttons.button button"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
	    </div>
	          
		<g:set var="title" value="${opportunityInstance?.id != null?opportunityInstance.toString(): 'New Opportunity'}"/>
		
		<div class="body">
			<div class="collapsibleContainer">
				<div class="collapsibleContainerTitle ui-widget-header">
					<div style="font-size: 105%;">
						<g:form>
							<g:hiddenField name="id" value="${opportunityInstance?.id}" />
							
							<b>Opportunity: </b>${title}
							&nbsp;
							<g:if test="${opportunityInstance?.stagingStatus?.name != 'closedWon' && opportunityInstance?.stagingStatus?.name != 'closedLost'}">
								<span>	
				        			<g:remoteLink controller="opportunity" action="edit" class="edit" title="Edit Opportunity"
							 			update="[success:'dvopportunity',failure:'dvopportunity']" params="['id': opportunityInstance?.id]" >
										<r:img dir="images" file="edit-24.png"/>
									</g:remoteLink>
								</span>
								
								
								<span class="button">
			                    	<g:actionSubmitImage title="Delete Opportunity" class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" src="${resource(dir: 'images', file: 'delete-24.png')}"  onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" width="22px"/>
			                    </span>
			                    
		                    </g:if>
			            
						
						
							&nbsp;
							<b><g:message code="opportunity.account.label" default="Account: " /></b> ${fieldValue(bean: opportunityInstance, field: "account.accountName")}
							
							&nbsp;
							<b><g:message code="opportunity.primaryContact.label" default="Primary Contact: " /></b> ${opportunityInstance?.primaryContact?.firstname} ${opportunityInstance?.primaryContact?.lastname}
							
							&nbsp;
							<b><g:message code="default.geo.label" default="Territory:" /></b>: ${opportunityInstance?.geo}
							
							&nbsp;
							<b><g:message code="opportunity.amount.label" default="Amount: " /></b> ${opportunityInstance?.geo?.currencySymbol}${fieldValue(bean: opportunityInstance, field: "amount")}
							
							&nbsp;
							<b>Created: </b><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance?.dateCreated}" />
							
							&nbsp; 
							<b>Expires: </b><g:formatDate format="MMMMM d, yyyy" date="${opportunityInstance?.closeDate}" />
						</g:form>
					</div>
				</div>
				
				<div class="collapsibleContainerContent ui-widget-content">
					
				<g:render template="stageProgress" model="['opportunityInstance': opportunityInstance, 'stagingInstanceList': stagingInstanceList]"> </g:render>
					
				<g:if test="${opportunityInstance.id != null}">
					<g:render template="stage/show" model="['opportunityInstance': opportunityInstance, 'stagingInstanceList': stagingInstanceList, 'nextStage': nextStage]"/>
				</g:if>
				
			</div>
				
			<div id="dvQuotesMain">
		        <g:render template="/quotation/opportunity-quotes" model="['filePath': filePath, 'quoteAvailable': quoteAvailable, 'quotationInstance': quotationInstance, 'opportunityInstance': opportunityInstance]"></g:render>
		    </div>
		    <hr>
		    <div id="dvNotesMain">
		        <g:render template="notes" model="['opportunityInstance': opportunityInstance , 'loginUserId' : loginUserId]"></g:render>
		    </div>
		</div>
			
			
		<br />
		<br />
	</body>
</html>
