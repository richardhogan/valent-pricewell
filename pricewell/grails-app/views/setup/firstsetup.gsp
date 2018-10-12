<%@ page import="com.valent.pricewell.Service"%>
<%
	def baseurl = request.siteUrl
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />

<ckeditor:resources />
<style>
/* LIST #4 */
#list4 { width:300px; font-family:Georgia, Times, serif; font-size:15px; }
#list4 ol { list-style: none; }
#list4 ol li { }
#list4 ol li .sideNavLink { display:block; text-decoration:none; color:#000000; background-image:url(${resource(dir: 'images', file: 'bg_hdr.png')}); background-repeat:repeat-x; line-height:30px;
  border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:#CCCCCC; padding-left:0px; cursor:pointer; }
#list4 ol li .sideNavLink:hover, .sideNavLink:active { color:#FFFFFF; background-image:url(${resource(dir: 'images', file: 'hover.png')}); background-repeat:repeat-x; }
#list4 ol li a strong { margin-right:10px; }

</style>
<script>
	
	function bindNavigation(){
		jQuery(document).ready(function()
	 	{
			jQuery('.setup').click(function()
			{	
				showLoadingBox();
				jQuery.post( '${baseurl}/setup/process' , 
				  {id: this.id},
			      function( data ) 
			      {
					  hideLoadingBox();
			          jQuery('#contents').html('').html(data);
			      });
				return false;
			});
		});
	}
	
	bindNavigation();
	
	var baseImage = "${resource(dir: 'images', file: '')}"
	function refreshNavigation(){
		jQuery.post( '${baseurl}/setup/firstsetup',
		 	{isajax: true},
			function (data){
				//var j = 1;
				var buf = ["<ol>"];
				for (var i=1; i<=data.size(); i++){
					var arr = data[i-1];
					
					if(arr['isVisible'] == true)
					 {
					 	var li = "<li><a href='#tbUsers' id='" + arr['link'] + "'class='setup sideNavLink'> <img src='" +  baseImage + "/" + arr['image'] + "'/>  <strong>" +  arr['title']+ " </strong> " + arr['counts'] + "</a></li>"
						//j=j+1;
					 	buf.push(li);
					 }
								
				}
				buf.push("</ol>");
				
				var lis = buf.join(' ');
				jQuery('#list4').html('').html(lis);
				bindNavigation();
			});
	}
	
	
</script>
</head>
<body>
	<div class="body">
		<table>
			<tr>
				<td style="vertical-align: top">
						<div id="list4">
							<ol>
								<g:each in="${viewMap}" status="i" var="arr">
									<g:if test="${arr['isVisible']}">
										<li><a href="#tbUsers" id="${arr['link']}" class="setup sideNavLink"> <img src="${resource(dir: 'images', file: arr['image'])}"/>  <strong>${arr['title']}</strong> ${arr['counts']}</a></li>
										
									</g:if>
								</g:each>
							</ol>
						</div>
				</td>
				<!-- <td><div style="width:1px;height:900px;background-color:black;float:left;"></div></td>
				<td>&nbsp;&nbsp;</td>-->
				<td style="vertical-align: top; width: 100%;">
					<div id="contents">
						
					</div>
				</td>
			</tr>
		</table>
	
	
	</div>
	
</body>
</html>
