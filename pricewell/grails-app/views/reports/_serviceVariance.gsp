<%@ page import="grails.converters.JSON"%>
<%
	def baseurl = request.siteUrl
%>
<html>

    <script>
		
       	var serviceVarianceChart; // globally available
       	jQuery(document).ready(function() 
       	{
	
			serviceVarianceChart = new Highcharts.Chart({
	
				chart: {
	
					renderTo: 'serviceVariance',
					type: 'bar',
					height: 300,
					width: Math.round(jQuery(window).width()*92/100)+10,//Math.round(jQuery(window).width()*45/100),
					backgroundColor:'transparent',
					marginTop: 50
	
				},
	
				title: {
	
					text: ''//"Product Manager vs Avg Estimates Variance"
	
				},
	
				xAxis: {
	
					categories: <%= serviceVarianceMap['categories'] as JSON%>,//	['Product Manager']
					labels: {
						enabled: true//,
							//x: 0
							//align: 'center'
					}
	
				},

				plotOptions: {
	            	bar: {
	            		//stacking: 'normal'
            			cursor: 'pointer',
            			point: {
							events: {
								click: function(){
									drilldownServiceVarianceFn(this.category);
								}
							}
		            	}
            		}
           		},
            		
				yAxis: {
	
					title: {
	
						text: ''//'<b>Avg Variance (%)</b>'
	
					}/*,
	                   stackLabels: {
							formatter: function(){
								return this.axis.chart.xAxis[0].categories[this.x];
							},
		               
		               		enabled: true,
		               		verticalAlign: 'top',
		               		align: 'left',
		               		y: -5,
		               		x: 25
	                   }*/
	
				},
				legend: {
					enable: true,
	                    /*backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
	                    borderColor: '#CCC',
	                    borderWidth: 1,
	                    shadow: false*/
				},
				tooltip: {
					formatter: function() {
						return '<b>Service : </b>'+this.x+'<br>'+
				               'Variance : '+ this.y +' %<br>Note : Click on bar to explore it.';
					}
				},

				series: [{
					name: 'Variance (%)',
					data: <%= serviceVarianceMap['data'] as JSON%>
				}]
	
			});
	
		});

       	function drilldownServiceVarianceFn(category)
       	{
       		serviceVarianceChart.showLoading();
       		jQuery.ajax({type:'POST',data: {serviceName: category, opportunityId: jQuery("#opportunityId").val()},
				 url:'${baseurl}/charts/drilldownServiceVariance',
				 success:function(data,textStatus)
				 {
					 jQuery('#dvServiceVariance').html(data);
					 serviceVarianceChart.hideLoading();
				 },
				 error:function(XMLHttpRequest,textStatus,errorThrown){}});
			 return false;
        }
          
  	</script>
	
 <div id="serviceVariance"></div>

</html>