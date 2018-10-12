<%@ page import="com.valent.pricewell.Quotation" %>
<%@ page import="com.valent.pricewell.QuotationService" %> 
<%@ page import="com.valent.pricewell.SalesController"%>
<%
	def baseurl = request.siteUrl
	def salesController = new SalesController()
%>
	<style>
		.editableIcon {
			   color: black;
			   font-size:20px;
			}
		.editableIcon:hover {
			   color: blue;
			   font-size:20px;
			}
	</style>
 <script>

 </script>
 
<%
 	def listComments = opportunityInstance.listNotes()	 
%>                
	<h4 style="padding: 0px 0px 0px 0px"><br><br> &nbsp;Recent Notes </h4>	
                
	<table>                    
    	<tbody>
        	<g:each in="${listComments}" status="i" var="noteInstance">                   
                            
	            <hr style="margin: 5px" width="35%" align="left">
	            
	            <div>    
	            	&nbsp; <B>${noteInstance.modifiedBy}</B> <br>
	            	&nbsp; <textarea <g:if test="${noteInstance.createdBy != loginUserId}"> readonly= "readonly" </g:if>  id="textArea${noteInstance.id}" cols="55" rows="3" style="resize : none">${fieldValue(bean: noteInstance, field: "notes")}</textarea>
	                             
	                <br>&nbsp; <font size="2" color="#cccccc"><g:formatDate type="datetime" style="MEDIUM" date="${noteInstance.modifiedDate}" /></font> &nbsp;
	                          
	                <g:if test="${noteInstance.createdBy == loginUserId}">
	                           
						<input id="editNote" type="button" onclick="editClick(${noteInstance.id})" style="font-size:2; color: #cccccc ; cursor:pointer; padding: 0;border: none;background: none;" value="Edit" />
						<input id="deleteNote"  type="button" onclick="deleteClick(${noteInstance.id})" style="font-size:1;color: #cccccc; cursor:pointer; padding: 0;border: none;background: none;" value="Delete" />
	                </g:if> 
	                <br><br>
				</div>                        
                       
			</g:each>
		</tbody>
	</table>
 