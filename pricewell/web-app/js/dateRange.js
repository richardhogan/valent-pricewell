
function dateRange(id, defaultSelection, changeHandler){
	jQuery.each(selectOptions, function(key, value) {   
        if (key == defaultSelection) {
        	jQuery('#' + id).append(
        			jQuery('<option></option>').
                attr("value", value).
                attr("selected", "selected").
                text(key));
            }
        else {jQuery('#' + id).append(jQuery('<option></option>').attr("value", value).text(key));}
    });
	
	jQuery('#' + id).change(function(){
		changeHandler(jQuery(this).val());
	})
}
function dateRangeWithCustom(id, defaultSelection, changeHandler){
	jQuery.each(selectOptionswithCustom, function(key, value) {   
        if (key == defaultSelection) {
        	jQuery('#' + id).append(
        			jQuery('<option></option>').
                attr("value", value).
                attr("selected", "selected").
                text(key));
            }
        else {jQuery('#' + id).append(jQuery('<option></option>').attr("value", value).text(key));}
    });
	
	jQuery('#' + id).change(function(){
		changeHandler(jQuery(this).val());
	})
}
function setDateFormat(date)
{
	var datetoFormat=date.split("/");
	if(datetoFormat.size()>2)
{
	var formattedDate=datetoFormat[1]+"/"+datetoFormat[0]+"/"+datetoFormat[2];
	//alert(formattedDate)
	var convertDate=formattedDate.split("/").reverse().join("-")
	return convertDate;
}
	else
		{
		jAlert("Please Enter Valid date");
		return false;
		}
}

function getQuarterStartDate(month)
{
	if(month>=1 && month<=3)
	{
		return 1;
	}
	else if(month>=4 && month<=6)
	{
		return 4;
	}
	else if(month>=7 && month<=9)
	{
		return 7;
	}
	else if(month>=10 && month<=12)
	{
		return 10;
	}
	
}

function getLastQuater(month)
{
	if(month>=1 && month<=3)
	{
		return 4;
	}
	else if(month>=4 && month<=6)
	{
		return 1;
	}
	else if(month>=7 && month<=9)
	{
		return 2;
	}
	else if(month>=10 && month<=12)
	{
		return 3;
	}
}

	var today = Date.parse('today').add(1).days().toString('yyyy-MM-dd');
	var firstDayOfMonth = Date.today().moveToFirstDayOfMonth().toString('yyyy-MM-dd');
    var month = Date.parse('today').toString('MM');
    var year = Date.parse('today').toString('yyyy');
    var year1 = year-1;
    var quarterMonth = getQuarterStartDate(month);//(Math.floor(month/3));
    var quarter = (Math.abs(month/3))+1;
    var lastQuarter = getLastQuater(month);//(quarter > 1) ? quarter - 1 : lastQuarter = 4;
    var quarterStartDate = (quarterMonth < 10) ? year+'-0'+quarterMonth+'-01' : year+'-'+quarterMonth+'-01';
    var lastSevenDaysStart = Date.today().add(-6).days().toString('yyyy-MM-dd');
    var lastThirtyDaysStart = Date.today().add(-29).days().toString('yyyy-MM-dd');
    var lastYearDayStart = Date.today().add(-364).days().toString('yyyy-MM-dd');
    var lastFullWeekStart = Date.today().add(-7).days().last().monday().toString('yyyy-MM-dd');
    var lastFullWeekEnd = Date.today().add(-7).days().last().monday().add(6).days().toString('yyyy-MM-dd');
    var lastFullMonthStart = Date.today().add(-1).months().moveToFirstDayOfMonth().toString('yyyy-MM-dd');
    var lastFullMonthEnd = Date.today().add(-1).months().moveToLastDayOfMonth().toString('yyyy-MM-dd');
    var lastFullQuarterStart = ((((lastQuarter-1)*3)+1) < 10) ? year+'-0'+(((lastQuarter-1)*3)+1)+'-01' : year1+'-'+(((lastQuarter-1)*3)+1)+'-01';
    var lastFullQuarterEnd = Date.parse(lastFullQuarterStart).add(2).months().moveToLastDayOfMonth().toString('yyyy-MM-dd');
    var lastFullYearStart = Date.today().add(-1).years().toString('yyyy') + '-01-01';
    var lastFullYearEnd = Date.today().add(-1).years().toString('yyyy') + '-12-31'; 
    var allDateStart=Date.today().add(-10).years().toString('yyyy') + '-01-01';
    var selectOptions = {
            'This month to date':'{"start":"'+today+'","end":"'+firstDayOfMonth+'"}',
            'This quarter to date':'{"start":"'+today+'","end":"'+quarterStartDate+'"}',
            'Last 7 days':'{"start":"'+today+'","end":"'+lastSevenDaysStart+'"}',
            'Last 30 days':'{"start":"'+today+'","end":"'+lastThirtyDaysStart+'"}',
            'Last 365 days':'{"start":"'+today+'","end":"'+lastYearDayStart+'"}',
            'Last week (Mon to Sun)':'{"start":"'+lastFullWeekEnd+'","end":"'+lastFullWeekStart+'"}',
            'Last full month':'{"start":"'+lastFullMonthEnd+'","end":"'+lastFullMonthStart+'"}',
            'Last full quarter':'{"start":"'+lastFullQuarterEnd+'","end":"'+lastFullQuarterStart+'"}',
            'Last full year':'{"start":"'+lastFullYearEnd+'","end":"'+lastFullYearStart+'"}',
            'All': '{"start":"'+today+'","end":"'+null+'"}'
        }; 
    var selectOptionswithCustom = {
            'This month to date':'{"start":"'+today+'","end":"'+firstDayOfMonth+'"}',
            'This quarter to date':'{"start":"'+today+'","end":"'+quarterStartDate+'"}',
            'Last 7 days':'{"start":"'+today+'","end":"'+lastSevenDaysStart+'"}',
            'Last 30 days':'{"start":"'+today+'","end":"'+lastThirtyDaysStart+'"}',
            'Last 365 days':'{"start":"'+today+'","end":"'+lastYearDayStart+'"}',
            'Last week (Mon to Sun)':'{"start":"'+lastFullWeekEnd+'","end":"'+lastFullWeekStart+'"}',
            'Last full month':'{"start":"'+lastFullMonthEnd+'","end":"'+lastFullMonthStart+'"}',
            'Last full quarter':'{"start":"'+lastFullQuarterEnd+'","end":"'+lastFullQuarterStart+'"}',
            'Last full year':'{"start":"'+lastFullYearEnd+'","end":"'+lastFullYearStart+'"}',
            'All': '{"start":"'+today+'","end":"'+allDateStart+'"}',
            'Custom Date':'customDate'
        };