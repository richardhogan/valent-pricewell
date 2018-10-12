package com.valent.pricewell

import com.ibm.icu.text.DateFormat
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import com.ibm.icu.text.SimpleDateFormat
import com.valent.pricewell.util.PricewellUtils;

import java.util.Date;
import java.util.GregorianCalendar;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

class DateService {

	static transactional = true

	def serviceMethod() {
	}

	public Date removeTime(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}

	public Date setDate(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}

	/*
	 * Converts java.util.Date to javax.xml.datatype.XMLGregorianCalendar
	 */
	public XMLGregorianCalendar toXMLGregorianCalendar(Date date) {
		GregorianCalendar gCalendar = new GregorianCalendar();
		gCalendar.setTime(date);
		XMLGregorianCalendar xmlCalendar = null;
		try {
			xmlCalendar = DatatypeFactory.newInstance().newXMLGregorianCalendar(gCalendar);
		} catch (DatatypeConfigurationException ex) {
			log(Level.SEVERE, null, ex);
		}
		return xmlCalendar;
	}


	// Converts a java.util.Date into an instance of XMLGregorianCalendar
	public XMLGregorianCalendar asXMLGregorianCalendar(java.util.Date date)
	{
		// DatatypeFactory creates new javax.xml.datatype Objects that map XML to/from Java Objects.
		DatatypeFactory df = null;
		try {
			df = DatatypeFactory.newInstance();
		} catch(DatatypeConfigurationException e) {
			throw new IllegalStateException("Error while trying to obtain a new instance of DatatypeFactory", e);
		}


		if(date == null) {
			return null;
		} else {
			GregorianCalendar gc = new GregorianCalendar();
			gc.setTimeInMillis(date.getTime());
			return df.newXMLGregorianCalendar(gc);
		}
	}

	public Date convertFromXMLToGregorianCalendar(XMLGregorianCalendar xgcal)//convert from xmlGregorianCalendar to GregorianCalendar
	{
		GregorianCalendar gCal = xgcal.toGregorianCalendar();
		Date calDate = gCal.getTime();
		return calDate
	}

	public Long convertDateToMillisecond(Date date)
	{
		return date.getTime()
	}

	// Converts an XMLGregorianCalendar to an instance of java.util.Date
	public Date asDate(XMLGregorianCalendar xmlGC)
	{
		if(xmlGC == null) {
			return null;
		} else {
			return xmlGC.toGregorianCalendar().getTime();
		}
	}

	public int compareXmlGregorianCalendars(XMLGregorianCalendar calendar1, XMLGregorianCalendar calendar2)
	{
		//println calendar1.compare(calendar2)
		switch (calendar1.compare(calendar2))
		{
			case -1:  return -1;  break;
			case 0:   return 0;  break;
			case 1:   return 1;  break;
			default: return 2; break;
		}
	}

	public void mainfun()
	{
		Date currentDate = new Date(); // Current date

		// java.util.Date to XMLGregorianCalendar
		XMLGregorianCalendar xmlGC = asXMLGregorianCalendar(currentDate);
		println "Current date in XMLGregorianCalendar format: " + xmlGC//.toString()

		// XMLGregorianCalendar to java.util.Date
		println "Current date in java.util.Date format: " + asDate(xmlGC).toString()
	}


	public def compareQuotasTwoDates(Date date1, Date date2)
	{
		//clear time from date before comparing two dates only for quota
		return compareDates(removeTime(date1), removeTime(date2))
	}

	public def compareDates(Date date1, Date date2)
	{
		switch (date1.compareTo(date2))
		{
			case -1:  return -1;  break;
			case 0:   return 0;  break;
			case 1:   return 1;  break;
		}
	}
	public Map getTimespanForQuotaWithDate(String startDate,String endDate)
	{
		
		
		

		Date fromDate = null, toDate = null
		//def quarter = getQuarter(month)
		//PricewellUtils.Println('start Date :',""+getDate('yyyy-MM-dd',startDate))
		toDate=getDate('yyyy-MM-dd',startDate)
		if(endDate!=null)
		{
		fromDate=getDate('yyyy-MM-dd',endDate)
		}
		PricewellUtils.Println("StartDate"+fromDate.toString()+"endDate"+toDate)   
		return ["fromDate": fromDate, "toDate": toDate]

		
		

	}
public int getDifferenceBetweenDays(Date toDate,Date startDate)
{
	//find out difference between two date in days
	final long DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
	
	int diffInDays = (int) ((toDate.getTime()  - startDate.getTime())/ DAY_IN_MILLIS );
	return diffInDays
}
public int getDifferenceBetweenMonths(Date toDate,Date startDate)
{
	//find out difference between two date in days
	Calendar startCalendar = new GregorianCalendar();
	startCalendar.setTime(startDate);
	Calendar endCalendar = new GregorianCalendar();
	endCalendar.setTime(toDate);

	int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
	int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
	return diffMonth
	}
public int getDifferenceBetweenYears(Date toDate,Date startDate)
{
	Calendar startCalendar = new GregorianCalendar();
	startCalendar.setTime(startDate);
	Calendar endCalendar = new GregorianCalendar();
	endCalendar.setTime(toDate);

	int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);

	return diffYear
}
	public Map getTimespanForQuota(def string)
	{
		Map dates = [:], dates2 = [:]
		Date today = new Date()
		Integer year = today.year + 1900
		Integer month = today.month + 1

		Date fromDate = null, toDate = null
		def quarter = getQuarter(month)
		switch(string)
		{
			case "First to this quarter": 		dates = getDatesOfGivenQuarter(1,year)
				dates2 = getDatesOfGivenQuarter(quarter,year)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

			case "Previous to this quarter": 	def newQuarter = quarter - 1
				def newYear = year
				if(quarter == 1)
				{
					newQuarter = 4
					newYear = year - 1
				}
				dates = getDatesOfGivenQuarter(newQuarter,newYear)
				dates2 = getDatesOfGivenQuarter(quarter,year)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

			case "First quarter": 				dates = getDatesOfGivenQuarter(1,year)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates['to'])]
				break;

			case "Previous quarter":			def newQuarter = quarter - 1
				def newYear = year
				if(quarter == 1)
				{
					newQuarter = 4
					newYear = year - 1
				}
				dates = getDatesOfGivenQuarter(newQuarter,newYear)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates['to'])]
				break;

			case "This quarter": 				dates = getDatesOfGivenQuarter(quarter,year)
				PricewellUtils.Println("start"+ getDate(dates['from']).toString()+getDate(dates['to']).toString())  
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates['to'])]
				break;

			case "Next quarter": 				def newQuarter = quarter + 1
				def newYear = year
				if(quarter == 4)
				{
					newQuarter = 1
					newYear = year + 1
				}
				dates = getDatesOfGivenQuarter(newQuarter,newYear)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates['to'])]
				break;

			case "Last quarter": 				dates = getDatesOfGivenQuarter(4,year)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates['to'])]
				break;

			case "This to next quarter": 		dates = getDatesOfGivenQuarter(quarter,year)
				def newQuarter = quarter + 1
				def newYear = year
				if(quarter == 4)
				{
					newQuarter = 1
					newYear = year + 1
				}
				dates2 = getDatesOfGivenQuarter(newQuarter,newYear)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

			case "This to last quarter": 		dates = getDatesOfGivenQuarter(quarter,year)
				dates2 = getDatesOfGivenQuarter(4,year)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

			case "Previous year": 				dates = getDatesOfGivenQuarter(1,year-1)
				dates2 = getDatesOfGivenQuarter(4,year-1)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

			case "This year": 					dates = getDatesOfGivenQuarter(1,year)
				dates2 = getDatesOfGivenQuarter(4,year)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

			case "Next year": 					dates = getDatesOfGivenQuarter(1,year+1)
				dates2 = getDatesOfGivenQuarter(4,year+1)
				return ["fromDate": getDate(dates['from']), "toDate": getDate(dates2['to'])]
				break;

		}
	}

	public Date getDate(String dateFormat, String dateString)
	{
		DateFormat df = new SimpleDateFormat(dateFormat);
		return df.parse(dateString);
	}
	public Date getDate (String date, String initDateFormat, String endDateFormat)
	 {
		
			Date initDate = new SimpleDateFormat(initDateFormat).parse(date);
			SimpleDateFormat formatter = new SimpleDateFormat(endDateFormat);
			String parsedDate = formatter.format(initDate);
			
			return formatter.parse(parsedDate);
		}
	public Date getDate(def dateString)
	{
		DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		return df.parse(dateString);
	}

	public def getQuarter(def month)
	{
		if(month >=1 && month <=3)
			return 1
		else if(month >=4 && month <=6)
			return 2
		else if(month >=7 && month <=9)
			return 3
		else if(month >=10 && month <=12)
			return 4
	}

	public Map getDatesOfGivenQuarter(def q, def year)
	{
		switch(q)
		{
			case 1: return ['from': '01-01-'+year, 'to': '31-03-'+year];
				break;
			case 2: return ['from': '01-04-'+year, 'to': '30-06-'+year];
				break;
			case 3: return ['from': '01-07-'+year, 'to': '30-09-'+year];
				break;
			case 4: return ['from': '01-10-'+year, 'to': '31-12-'+year];
				break;
		}
	}
}
