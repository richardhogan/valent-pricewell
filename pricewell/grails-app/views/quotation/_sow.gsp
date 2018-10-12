<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ page import="com.valent.pricewell.CompanyInformation" %>
<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.Service" %>
<%@ page {
    size: 8.5in 11in;  /* width height */
    margin: 0.25in;
} %>
<%
	def companyInfo = CompanyInformation.list()[0];
%>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
		<style>
			#dvsowPreview table{
				border-collapse:collapse;
				border:1px solid #000000;
				}
				
			#dvsowPreview table td{
				border:1px solid #000000;
				}
				
			#dvsowPreview table th{
				border:1px solid #000000;
				}
				
				#summary {
				font-size: 110%
			}
		
		.heading1 {
			font-size: 120%
		}
		
		.heading2 {
			font-size: 110%
		}
			
		.indented-1
		   {
		   padding-left: 3em;
		   padding-right: 3em;
		   }
		   .definition {
		   	padding-top: 1em;
		   	padding-bottom: 1em;
		   }
		  .indented-2
		   {
		   padding-left: 2em;
		   padding-right: 2em;
		   }
		</style>
	</head>
    <body>        
        <div id="dvsowPreview" class="body yui-skin-sam">
        	<g:if test="${companyInfo != null}">
	        		<g:if test="${companyInfo?.logo?.id != null}">
	        			<g:if test="${pdfDisplay}">
	        				<div class="profile_picture" style="display:block;height:40px;"  />
	        			</g:if>
	        			<g:else>
							<img src="<g:createLink controller='logoImage' action='renderImage' id='${companyInfo?.logo?.id}' style='height: 40px'/>" />	        				
	        			</g:else>
	    			</g:if>
    			</g:if>
	        <center>
	        	<g:if test="${sowLabel != null}">
	        		<h1> ${sowLabel} </h1>
        		</g:if>
        		<g:else>
        			<h1>SOW</h1>
        		</g:else>
	         </center>
	        ${content}
	     </div>  
    </body>
</html>