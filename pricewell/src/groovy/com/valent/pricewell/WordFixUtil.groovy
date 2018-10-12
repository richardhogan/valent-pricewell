package com.valent.pricewell

import javax.xml.bind.JAXBElement

import org.docx4j.XmlUtils
import org.docx4j.openpackaging.io.SaveToZipFile
import org.docx4j.openpackaging.packages.WordprocessingMLPackage
import org.docx4j.openpackaging.parts.WordprocessingML.FooterPart
import org.docx4j.openpackaging.parts.WordprocessingML.HeaderPart
import org.docx4j.openpackaging.parts.WordprocessingML.MainDocumentPart
import org.docx4j.openpackaging.parts.relationships.RelationshipsPart
import org.docx4j.openpackaging.parts.relationships.Namespaces;
import org.docx4j.relationships.Relationship
import org.docx4j.wml.*

class WordFixUtil {
	
	public void fixBrokenTags(String filePath){
		fixBrokenTags(filePath, true);
	}
	
	public void fixBrokenTags(String filePath, boolean isFirstTime)//inputFilePath, String outputFilePath)
	{
		boolean failed = false
		WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(new java.io.File(filePath));
		MainDocumentPart documentPart = wordMLPackage.getMainDocumentPart();
		String xpath = "//w:p[w:r[w:t[contains(text(),'\$')]]]";
		
		try{
			//fix for body part
			List<Object> list = documentPart.getJAXBNodesViaXPath(xpath, false);
			doFixForJaxbXmlPartList(list)
			
			//fix for header and footer
			RelationshipsPart rp = documentPart.getRelationshipsPart()
			for (Relationship r : rp.getRelationships().getRelationship())
			{
				if (r.getType().equals(Namespaces.HEADER))
				{
					HeaderPart hp = (HeaderPart) rp.getPart(r)
					List<Object> hList = hp.getJAXBNodesViaXPath(xpath, false)
					doFixForJaxbXmlPartList(hList)
				}else if (r.getType().equals(Namespaces.FOOTER)) {
					FooterPart fp = (FooterPart) rp.getPart(r)
					List<Object> fList = fp.getJAXBNodesViaXPath(xpath, false)
					doFixForJaxbXmlPartList(fList)
				}
			}
			
		} catch(Exception e){
			println "Error while fixing tags for file " +  filePath
			e.printStackTrace()
			failed = true;
		}
		
		SaveToZipFile saver = new SaveToZipFile(wordMLPackage);
		saver.save(filePath);
		//Word around in case, if it fails first time it can retry again to fix tags.
		if(failed && isFirstTime){
			fixBrokenTags(filePath, false);
		}
	}
	

	public void doFixForJaxbXmlPartList(List jaxbPartList)
	{
		for (Object o : jaxbPartList)
		{
			Object o2 = XmlUtils.unwrap(o);
			P p = (P) o2;
			String str = p.toString().trim();
	
			if(str.matches('.*\\$\\{\\S+\\}.*')) //check if string is between '${' and '}'
			{
				println str
				fixBrokenTagsInP(p)
			} else {
				println "Something wrong in " + str
			}
		}
		
	}
	
	public void fixBrokenTagsInP(P p)
	{
		StringBuilder result = new StringBuilder();

		List<Object> children = p.getContent();

		int brokenTagState = 0;
		def mergeLists = [];
		def lastMergeList = [];

		for (Object o : children ) 
		{
			//			System.out.println("  " + o.getClass().getName() );
			if ( o instanceof R) //R = org.docx4j.wml.R
			{
				R  run = (R)o;
				
				String tmpVal = rToString(run);

				if(tmpVal.contains("DOCPROPERTY"))
				{
					println tmpVal
					//p.getContent().remove(run);
					continue;
				}
				if(tmpVal.isEmpty()){
					continue;
				}

				String compareVal = tmpVal;

				//Then find next tags until we find '}'
				//if (Is this t has broken tag?)
				if(brokenTagState > 0){
					if(brokenTagState == 1)
					{
						if(compareVal.startsWith("{"))
						{
							brokenTagState = 2;
							compareVal = compareVal.substring(compareVal.indexOf("{")+1);
						} else {
							brokenTagState = 0;
							lastMergeList = [];
						}
					}

					if(brokenTagState == 2)
					{
						if(compareVal.matches('[_\\w]*\\}.*'))//For example, 'sds} sdsd' or 'sdsd}${sd}..${d'
						{
							//Then merge here..
							lastMergeList.add(run);
							mergeLists.add(lastMergeList);
							brokenTagState = 0;
							lastMergeList = [];
							compareVal = compareVal.substring(compareVal.indexOf("}")+1);
						} else if(compareVal.matches('[_\\w]+')){
							lastMergeList.add(run);
						} else {
							brokenTagState = 0;
							lastMergeList = [];
						}
					}
				}

				//${sds} has ${
				if(compareVal.equals('$')){
					brokenTagState = 1;
					lastMergeList.add(run);
				} else if(compareVal.matches('.*\\$\\{[^\\}]*')) //For example, 'sdsd ${' or 'sds ${sds' or '${abs'
				{
					brokenTagState = 2;
					lastMergeList.add(run);
				}
			}
		}

		mergeRs(p, mergeLists);
	}

	//'${' 'sdsd' '}'
	private void mergeRs(P p, def mergeLists){
		println mergeLists
		if(mergeLists.isEmpty()){
			return;
		}
		mergeLists = mergeLists.reverse();
		for(def list: mergeLists){
			if(list.size() > 0){
				StringBuffer sb = new StringBuffer();
				for(org.docx4j.wml.R r: list){
					sb.append(rToString(r));
				}
				boolean first = true;
				for(org.docx4j.wml.R r: list){
					if(first){
						setRContent(r, sb.toString());
						first = false;
					} else {
						p.getContent().remove(r);
					}
				}
			}
		}
	}

	private void setRContent(org.docx4j.wml.R run, String content){
		List runContent = run.getContent();
		for (Object o2 : runContent ) {
			if ( o2 instanceof javax.xml.bind.JAXBElement) {
				if ( ((JAXBElement)o2).getDeclaredType().getName().equals("org.docx4j.wml.Text") ) 
				{
					Text t = (Text)((JAXBElement)o2).getValue();
					t.setValue(content);
				}
			} else {
			}
		}
	}

	private String rToString(R run){
		List runContent = run.getContent();
		String tmpVal = "";
		for (Object o2 : runContent ) 
		{
			if ( o2 instanceof javax.xml.bind.JAXBElement) 
			{
				if ( ((JAXBElement)o2).getDeclaredType().getName().equals("org.docx4j.wml.Text") ) {
					Text t = (Text)((JAXBElement)o2).getValue();
					tmpVal = t.getValue();
				}
			} else {
			}
		}
		return tmpVal;
	}

	public static void main(String[] args){
		String inputFile = "C:/Users/user/Downloads/varrow-SOW-template-v325.docx"//"G:/my/x1.docx";
		String outputFile = "G:/my/x1.docx";
		WordFixUtil util = new WordFixUtil();
		util.fixBrokenTags(inputFile);//, outputFile);
	}

}
