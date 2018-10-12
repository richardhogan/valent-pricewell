
<%@ page import="org.apache.shiro.SecurityUtils"%>
<%@ page import="com.valent.pricewell.User" %>
<%@ page import="com.valent.pricewell.Geo" %>

<html>
<%
	def baseurl = request.siteUrl
%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Add Country</title>
        
        <style type="text/css">
			.submit { margin-left: 12em; }
			em { font-weight: bold; padding-right: 1em; vertical-align: top; }
			.ui-dialog .ui-state-error { padding: .3em; }
		</style>
		
		<script>
			 
			jQuery(document).ready(function()
		 	{
				jQuery("#addTerritory").validate();
				
				jQuery( "#save" ).click(function() 
					{
						if(jQuery('#addTerritory').validate().form())
						{
							showLoadingBox();
	    	   				jQuery.post( '${baseurl }/userSetup/savePrimaryTerritory', 
                				  jQuery("#addTerritory").serialize(),
							      function( data ) 
							      {
	    	   						  hideLoadingBox();
							          if(data == 'success')
							          {		  
							          		window.location.href = '${baseurl }/${controller}/create';
								      }

							      });
	                		
                		}
						return false;
					});
				  
			});
  		</script>
  		
  		
    </head>
    <body>
        <div class="body">
            <h2>First add your <!-- default country and --> primary territory</h2><hr>
            
            <g:form action="save"  name="addTerritory">
            
                <div class="dialog">
                	
                    <table>
                    	<tbody>
                        	<!-- <tr class="prop">
								<td valign="top" class="name">
                                    <label for="country">Select Country</label><em>*</em>
                                </td>
                                <td valign="top" >
                                    <g:countrySelect name="country"
						                 from="['afg','alb','dza','asm','and','ago','aia','ata','atg','arg','arm','abw','aus','aut','aze'
												,'bhs','bhr','bgd','brb','blr','bel','blz','ben','bmu','btn','bol','bih','bwa','bra','iot'
												,'vgb','brn','bgr','bfa','bdi','khm','cmr','can','cpv','cym','caf','tcd','chl','chn'
												,'cxr','cck','col','com','cok','hrv','cub','cyp','cze','dnk','dji','dma','dom'
												,'ecu','egy','slv','gnq','eri','est','eth','flk','fro','fji','fin','fra','pyf','gab','gmb'
												,'geo','deu','gha','gib','grc','grl','grd','gum','gtm','gin','gnb','guy','hti','hnd'
												,'hkg','hun','ind','idn','irn','irq','irl','imn','isr','ita','jam','jpn','jor'
												,'kaz','ken','kir','kwt','kgz','lao','lva','lbn','lso','lbr','lby','lie','ltu','lux','mac'
												,'mdg','mwi','mys','mdv','mli','mlt','mhl','mrt','mus','myt','mex','fsm','mda','mco'
												,'mng','msr','mar','moz','mmr','nam','nru','npl','nld','ant','ncl','nzl','nic','ner','nga'
												,'niu','nfk','prk','mnp','nor','omn','pak','plw','pan','png','pry','per','phl','pcn','pol'
												,'prt','pri','qat','cog','rou','rus','rwa','shn','kna','lca','spm','vct','wsm'
												,'smr','stp','sau','sen','syc','sle','sgp','svk','svn','slb','som','zaf','kor','esp'
												,'lka','sdn','sur','sjm','swz','swe','che','syr','twn','tjk','tza','tha','tls','tgo','tkl'
												,'ton','tto','tun','tur','tkm','tca','tuv','uga','ukr','are','gbr','usa','ury','vir','uzb'
												,'vut','ven','vnm','wlf','esh','yem','zmb','zwe']" class="required"
						                 value="${userInstance?.country }" noSelection="['':'-Choose your country-']" />
                                
                                </td>
                        	</tr>-->
                        	
                        	<tr>
				    			<td><label>Primary Territory</label><em>*</em></td>
				  				<td>
				  					
			  						<g:select name="primaryTerritory" from="${Geo?.list()?.sort {it.name}}" value="" optionKey="id"  noSelection="['': 'Select Any One']" class="required"/>
			 						
				            	</td>
				           	</tr>
                        	
                    	</tbody>
                    </table>
                </div>
                <div class="buttons">
                     <span class="button"><button id="save" title="Save">Save</button></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
