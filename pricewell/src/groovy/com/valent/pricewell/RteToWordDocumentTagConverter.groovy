package com.valent.pricewell

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern

import org.jsoup.Jsoup
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
class RteToWordDocumentTagConverter {
	
	private final RteToWordDocumentTagConverterService rteToWordDocumentTagConverterService
	
	@Autowired
	public RteToWordDocumentTagConverter(RteToWordDocumentTagConverterService rteToWordDocumentTagConverterService)
	{
		this.rteToWordDocumentTagConverterService = rteToWordDocumentTagConverterService
	}
	
	private void printStatement()
	{
		println "coming to rteToWordDocumentConverter"
	}

	public List convertRteToWordDocumentFormat(String str)
	{
		return rteToWordDocumentTagConverterService.convertRteToWordDocumentFormat(str)
	}
	
}
