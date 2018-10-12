

<%@ page import="com.valent.pricewell.ServiceQuotation" %>
<%
	def baseurl = request.siteUrl
%>
<html>
    <head>
    <script type="text/javascript" src="${baseurl}/js/jquery-1.6.2.min.js"></script>
    	<style>
	#feedback { font-size: 1.4em; }
	#portfolios .ui-selecting { background: #FECA40; }
	#portfolios  .ui-selected { background: #F39814; color: white; }
	#portfolios  { list-style-type: none; margin: 0; padding: 0; width: 60%; }
	#portfolios  li { padding: 0.2em; cursor: pointer;}
	
	#portfoliosSel .ui-selecting { background: #FECA40; }
	#portfoliosSel  .ui-selected { background: #F39814; color: white; }
	#portfoliosSel  { list-style-type: none; margin: 0; padding: 0; width: 60%; }
	#portfoliosSel  li { padding: 0.2em;  cursor: pointer;}
	
	.vertaligntop 	{ 	vertical-align:top; 
						margin-top:0; 
						height: 15em						
					}
	.panelBorder 	{
						border: 0.1em gray solid;
						 overflow: auto;					
					}
	
	</style>
	<script>

	
		(function (pricewell, $, undefined){		
			var urls = {getQuotesMap: "map",
							show: "../quotation/show"
				};			

			 pricewell.quote = function(id){

					var _id = id;


						this.getQuotesMap = function(elementId, loadSelectors){
							var _showElementId =  "#"+ elementId;
							$.getJSON(  
					                urls["getQuotesMap"],  
					                {"id": _id},  
					                function(json) {  
					                	$(_showElementId).val(JSON.stringify(json, null));
					                	loadSelectors(json);
					                }  
					            );							
						};
	
						this.show = function(elementId){
							var _showElementId =  "#"+ elementId;
							$.ajax({
								   type: "GET",
								   url: urls["show"],
								   data: "id=" + id,
								   success: function(html){									  
									   $(_showElementId).html(html);
								   }
								 })	
						};
					
				};

					
		}( window.pricewell = window.pricewell || {}, jQuery ));

		function Selectable(id){

			var data;

			var reloadData;

			this.reload = function (){
				
				if(typeof this.reloadData == 'function'){
					this.reloadData(this.data);
				}

				this.bindSelectEvents();
			}
			
			this.bindSelectEvents = function (){
				$('#' + id + ' li').bind("click", function (e){
					$(this).addClass("ui-selected");
					if ((e.shiftKey || e.ctrlKey || e.metaKey) === false) {
				 
				        $(this).siblings("li").removeClass("ui-selected");
				    } 			
					
				});
			}

			this.getSelectedIndexes = function (){
				var itemIndexes = [];
	    		var items = $('#' + id + ' .ui-selected');

	    		for(var i=0; i<items.length; i++)
	        	{
	    			itemIndexes.push($(items[i]).index());    
	            }

	    		return itemIndexes;
			}

			this.getSelectedItems = function (){
				return $('#' + id + ' .ui-selected');
			}
			
			
		}

		var q = new pricewell.quote(1);
		var count = 0;
		var json = null;
		var pSelector = null;
		var sSelector = null;

		$(function() {
			pSelector = new Selectable('portfolios');
			sSelector = new Selectable('services');
			
			pSelector.reloadData = reloadPortfolioData;
			sSelector.reloadData = reloadServiceData;
			
			q.getQuotesMap("jsonresult", loadSelectors);

			diffStr("The red brown fox jumped over the rolling log.", "The brown spotted fox leaped over the rolling log");
			//diffStr("The rose has thrones", "The new flower has thrones.");
				
			});


    	function loadSelectors(json1)
    	{	 
    
        	json = json1;
    		pSelector.data = json;
    		sSelector.data = json;
  
    		pSelector.reload();
    		sSelector.reload();

    		$('#portfolios').bind("click", function() {
        			sSelector.reload();
        		});	

    		$('#btnAdd').bind('click', function() {
				for(var i=0; i<1; i++)
				{
					json["portfolios"].push({id: i, portfolioName: "Portfolio" + i})
				}

				count++;	

				pSelector.reload();
			});

			$('#btnRemove').bind('click', function() {
				var itemIndexes = pSelector.getSelectedIndexes();
				itemIndexes = itemIndexes.sort(function(a,b){return b-a;} );
				
				for(var i=0; i<itemIndexes.length; i++)
				{
					json["portfolios"].splice(itemIndexes[i], 1);
				}
				pSelector.reload();
			});
    	}

    	function reloadPortfolioData(json){
            
    		$('#portfolios').html("");

			for(var p in json["portfolios"])
			{
				$('#portfolios').append("<li id="+ json["portfolios"][p].id +"> " + json["portfolios"][p].portfolioName + " </li>");
				
			}
        }

        function reloadServiceData(json){
			var items = pSelector.getSelectedItems();

			var services = json["services"];
			
			for(var i=0; i<items.length;i++){
				if(i == 0){
					services = [];
				}

				var addOnSevices = json["portfolioMap"][items[i].id];
				if(addOnSevices)
				{
					for(var k=0; k<addOnSevices.length; k++){
							services.push(addOnSevices[k]);			
						}
				}
				else
				{
					services = json["services"];
				}				
			}

			services = removeDuplicates(services, function(a,b){
					if(a.id > b.id)
						return 1;
					if(a.id < b.id)
						return -1;
					if(a.id == b.id)
						return 0;
				})

			$('#services').html("");

			for(var i=0; i<services.length; i++)
			{
				$('#services').append("<li> " + services[i].serviceName + " </li>");
				
			}
						
        }

        function removeDuplicates(arr, sortMethod){
				var sortedArray = arr.sort(sortMethod);
				var lastElement = null;
				var retArray = arr.slice(); 
				
				for(var i=0;i<arr.length;i++){
					if(sortedArray[i] === lastElement){
						retArray.splice(retArray.indexOf(sortedArray[i]),1);
					}
					else{
						lastElement = arr[i];
					}
						
				}

				return retArray;
					
           }

        function diffStr(o, n)
        {
			var os = o.split(/\s+/);
			var sn = n.split(/\s+/);
			var out = ""
			var map = {} 
			
			for(var i=0; i< sn.length; i++)
			{
				if(map[sn[i]] == undefined){
					map[sn[i]] = [];
				}

				map[sn[i]].push(i); 
						
			}

			var nIndex = 0;
			for(var i=0; i<os.length; ){

				if(map[os[i]] == undefined){
					out += "<del>" + os[i] + "</del>";
					
				}else{

					var tmpIndex = map[os[i]][0];
					for(; tmpIndex> nIndex;nIndex++){
						out += "<ins>" + sn[nIndex] + "</ins>";
						map[sn[nIndex]].pop();
					}

					map[os[i]].pop();

					out+= " " + os[i];
					nIndex++;
						
				}

				i++;
					
			}

			for(var val in map){
				if(sn[map[val]] !== undefined){
					out += "<ins>" + sn[map[val]] + "</ins>";
				}
			}

			alert(out);
				
			
        }
        
			
	 
	</script>
    </head>
    <body> 
        <div class="body">
        	<input id="btnHTML" type="button" value="HTML"/>
        	<input id="btnJSON" type="button" value="JSON"/>
        	<div id="htmlresult">
        		<legend> HTML Result </legend>
        	</div>
        	<div>
        		<legend> JSON Result </legend>
        			
				<textarea id="jsonresult"> </textarea>
				
				<div id="selectdiv">
					<ul id="portfolios">
					
					</ul>
					
					<ul id="services">
						
					</ul>
				</div>
				 
				 <input id="btnAdd" type="button" value="Add"/>
        		<input id="btnRemove" type="button" value="Remove"/>
        	</div>
        </div>
    </body>
</html>
