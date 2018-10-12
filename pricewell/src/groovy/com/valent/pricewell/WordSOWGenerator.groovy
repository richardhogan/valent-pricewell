package com.valent.pricewell

import javax.xml.bind.JAXBElement
import org.docx4j.XmlUtils
import org.docx4j.dml.wordprocessingDrawing.Inline;
import org.docx4j.openpackaging.io.SaveToZipFile
import org.docx4j.openpackaging.packages.WordprocessingMLPackage
import org.docx4j.openpackaging.parts.WordprocessingML.FooterPart
import org.docx4j.openpackaging.parts.WordprocessingML.HeaderPart
import org.docx4j.openpackaging.parts.WordprocessingML.MainDocumentPart
import org.docx4j.openpackaging.parts.WordprocessingML.NumberingDefinitionsPart
import org.docx4j.openpackaging.parts.relationships.RelationshipsPart
import org.docx4j.openpackaging.parts.relationships.Namespaces;
import org.docx4j.relationships.Relationship
import org.docx4j.wml.CTLongHexNumber
import org.docx4j.wml.CTSdtCell
import org.docx4j.wml.Drawing
import org.docx4j.wml.Jc
import org.docx4j.wml.Lvl
import org.docx4j.wml.NumFmt
import org.docx4j.wml.Numbering
import org.docx4j.wml.ObjectFactory
import org.docx4j.wml.P
import org.docx4j.wml.PPr
import org.docx4j.wml.PPrBase
import org.docx4j.wml.R
import org.docx4j.wml.RFonts
import org.docx4j.wml.RPr
import org.docx4j.wml.Tbl
import org.docx4j.wml.Tc
import org.docx4j.wml.Tr
import org.docx4j.wml.PPrBase.Ind

class WordSOWGenerator implements SOWGenerator {

	//private String inputFilePath;
	private static WordprocessingMLPackage wordMLPackage;
	private String outputFilePath;
	//private WordSubstitutionMapGenerator mapGenerator;
	private SubstituionMapGenerator mapGenerator;
	
	
	public WordSOWGenerator(WordprocessingMLPackage wordMLPackage,//String inputFilePath,
	String outputFilePath,
	//WordSubstitutionMapGenerator mapGenerator){
	SubstituionMapGenerator mapGenerator){
		//this.inputFilePath = inputFilePath;
		this.wordMLPackage = wordMLPackage;
		this.outputFilePath = outputFilePath;
		this.mapGenerator = mapGenerator;
		
	}

	static String startOfList = """\
		<w:numbering 
			xmlns:ve=\"http://schemas.openxmlformats.org/markup-compatibility/2006\" 
			xmlns:o=\"urn:schemas-microsoft-com:office:office\" 
			xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" 
			xmlns:m=\"http://schemas.openxmlformats.org/officeDocument/2006/math\" 
			xmlns:v=\"urn:schemas-microsoft-com:vml\" 
			xmlns:wp=\"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing\" 
			xmlns:w10=\"urn:schemas-microsoft-com:office:word\" 
			xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\" 
			xmlns:wne=\"http://schemas.microsoft.com/office/word/2006/wordml\">
	""";
	
	static String endOfList = """\
		</w:numbering>
	""";
	
	public void generateWord() {
		Map<String, List<Object>> substitutionMap = mapGenerator.generateSubstutionMap();
		Map<String, String> strSubstitutionMap = mapGenerator.generateStringSubstutionMap();
		
		//WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(new java.io.File(inputFilePath));
		
		MainDocumentPart documentPart = wordMLPackage.getMainDocumentPart();
		
		String xpath = "//w:p[w:r[w:t[contains(text(),'\${')]]]";
		
		//replacing tags by value of body part
			List<Object> bodyPartlist = documentPart.getJAXBNodesViaXPath(xpath, false);
			replaceSubstitutedValues(bodyPartlist, substitutionMap, documentPart)
			
		//replacing tags by value of header and footer part
			RelationshipsPart rp = documentPart.getRelationshipsPart()
			for (Relationship r : rp.getRelationships().getRelationship())
			{
				if (r.getType().equals(Namespaces.HEADER))
				{
					HeaderPart headerPart = (HeaderPart) rp.getPart(r)
					List<Object> hList = headerPart.getJAXBNodesViaXPath(xpath, false)
					replaceSubstitutedValues(hList, substitutionMap, documentPart)
					headerPart.variableReplace(strSubstitutionMap);
					
				}else if (r.getType().equals(Namespaces.FOOTER)) {
					FooterPart footerPart = (FooterPart) rp.getPart(r)
					List<Object> fList = footerPart.getJAXBNodesViaXPath(xpath, false)
					replaceSubstitutedValues(fList, substitutionMap, documentPart)
					footerPart.variableReplace(strSubstitutionMap);
				}
			}
		
		//TODO: if variable value is divided into multiple w:r then it would be hard to replace variables.
		//So in that replacement wouldn't work..
		//So it is better to validate template document when imported.
		documentPart.variableReplace(strSubstitutionMap);
		//println documentPart
		SaveToZipFile saver = new SaveToZipFile(wordMLPackage);
		saver.save(outputFilePath);
	}
	
	@Override
	public void generateReport() {
		Map<String, List<Object>> substitutionMap = mapGenerator.generateSubstutionMap();
		Map<String, String> strSubstitutionMap = mapGenerator.generateStringSubstutionMap();
		
		//WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(new java.io.File(inputFilePath));
		
		MainDocumentPart documentPart = wordMLPackage.getMainDocumentPart();
		
		NumberingDefinitionsPart ndp = documentPart.getNumberingDefinitionsPart();  
		
		Numbering.AbstractNum abstractNum = createAbstractNumbering()
		ndp.jaxbElement.getAbstractNum().add(abstractNum);
		
		Numbering.Num num = createNumberingNum()
		ndp.jaxbElement.getNum().add(num);
		
		documentPart.addTargetPart(ndp)
		
		//replacing tags by value of table body part
			String xpath = "//w:tbl[w:tr[w:tc[w:p[w:r[w:t[contains(text(), '\${')]]]]]]"
			List<Object> bodyPartlist = documentPart.getJAXBNodesViaXPath(xpath, false);
			replaceSubstitutedTableValues(bodyPartlist, substitutionMap, documentPart)
		
		
		//replacing tags by value of body part
			xpath = "//w:p[w:r[w:t[contains(text(),'\${')]]]";
			bodyPartlist = documentPart.getJAXBNodesViaXPath(xpath, false);
			replaceSubstitutedValues(bodyPartlist, substitutionMap, documentPart)
			
		//replacing tags by value of header and footer part
			RelationshipsPart rp = documentPart.getRelationshipsPart()
			for (Relationship r : rp.getRelationships().getRelationship())
			{
				if (r.getType().equals(Namespaces.HEADER))
				{
					HeaderPart headerPart = (HeaderPart) rp.getPart(r)
					List<Object> hList = headerPart.getJAXBNodesViaXPath(xpath, false)
					replaceSubstitutedValues(hList, substitutionMap, documentPart)
					headerPart.variableReplace(strSubstitutionMap);
					
				}else if (r.getType().equals(Namespaces.FOOTER)) {
					FooterPart footerPart = (FooterPart) rp.getPart(r)
					List<Object> fList = footerPart.getJAXBNodesViaXPath(xpath, false)
					replaceSubstitutedValues(fList, substitutionMap, documentPart)
					footerPart.variableReplace(strSubstitutionMap);
				}
			}
			
		
		
		//TODO: if variable value is divided into multiple w:r then it would be hard to replace variables.
		//So in that replacement wouldn't work..
		//So it is better to validate template document when imported.
		documentPart.variableReplace(strSubstitutionMap);
		//println documentPart   
		SaveToZipFile saver = new SaveToZipFile(wordMLPackage);
		saver.save(outputFilePath);
	}
	
	public void replaceSubstitutedTableValues(List jaxbPartList, Map substitutionMap, MainDocumentPart documentPart)
	{
		for(Object o : jaxbPartList)
		{
			Object oTbl = XmlUtils.unwrap(o);
			Tbl tbl = (Tbl) oTbl;
			
			List<Object> tblChildren = tbl.getContent()
			for(Object tr : tblChildren)
			{
				if(tr instanceof Tr)
				{
					List<Object> trChildren = tr.getContent()
					for(Object tc : trChildren)
					{
						if (tc instanceof JAXBElement && ((JAXBElement) tc).getDeclaredType().getName().equals("org.docx4j.wml.Tc"))
						{
							tc = (org.docx4j.wml.Tc) ((JAXBElement) tc).getValue();
							List<Object> tcChildren = tc.getContent()
							
							boolean doRelpacement = false
							Tc parentTc = null
							P paragraphToReplace = null
							List<Object> replacementObjects = new ArrayList<Object>()
							
							for(Object p : tcChildren)
							{
								if(p instanceof P)
								{
									Object o2 = XmlUtils.unwrap(p);
									p = (P) o2;
									
									String str = p.toString().trim();
									if(str.contains("\${"))
									{
										String variableStr = str.replaceAll('\\$\\{', "").replaceAll('}', "");
										
										if(substitutionMap.containsKey(variableStr))
										{
											replacementObjects = substitutionMap.get(variableStr);
											substitutionMap.remove(variableStr)
											parentTc = (Tc) p.getParent()
											doRelpacement = true
											paragraphToReplace = p
											break;
										}
									}
								}
							}
							
							if(doRelpacement && replacementObjects.size() > 0)
							{
								for(int i=0; i<replacementObjects.size(); i++)
								{
									Object replacementObject = replacementObjects.get(i);
									
									parentTc.getContent().add(replacementObject);
									
								}
								parentTc.getContent().remove(paragraphToReplace)
				
							}
							
						}
					}
				}
			}
		}
	}
	
	public void replaceSubstitutedValues(List jaxbPartList, Map substitutionMap, MainDocumentPart documentPart)
	{
		for (Object o : jaxbPartList)
		{
			Object o2 = XmlUtils.unwrap(o);
			P p = (P) o2;
			
			setParagraphContent(o, p, substitutionMap, documentPart)	
		}
	}
	
	public void setParagraphContent(Object o, P p, Map substitutionMap, MainDocumentPart documentPart)
	{
		String str = p.toString().trim();
		String variableStr = str.replaceAll('\\$\\{', "").replaceAll('}', "");
		
		println "variable string is : " + str
		RFonts rfonts = null/*new RFonts()
			rfonts.setAscii("Calibri")
			rfonts.setCs("Calibri")
			rfonts.setHAnsi("Calibri")*/
		
		List<Object> children = p.getContent();
		int cnt = 1
		for (Object ch : children )
		{
			if ( ch instanceof R) //R = org.docx4j.wml.R
			{
				R  run = (R)ch;
				RPr rpr = run.getRPr()
				//println cnt + " : " + rpr.getRFonts().getAscii()
				//rpr.setRFonts(null)
				if(rpr?.getRFonts() != null)//?.getAscii() != null)
				{
					println str + " : " + rpr?.getRFonts()?.getAscii()
					rfonts = rpr.getRFonts()
					break
				}
			}
		}
		
		if(substitutionMap.containsKey(variableStr))
		{
			List<Object> replacementObjects = substitutionMap.get(variableStr);
			int index = documentPart.getContent().indexOf(o);
			println "index of " + str + " is : " + index
			if(replacementObjects != null)
			{
				if(variableStr == "customer_logo")
				{
					PPr ppr = p.getPPr()
					Object imageObject = replacementObjects.get(0)
					P replacementParagraph = addAllignmentPropertiesToParagraph((P)imageObject, ppr)
					documentPart.getContent().add(index, replacementParagraph);
					documentPart.getContent().remove(o);
				}
				else
				{
					for(int i=0; i< replacementObjects.size(); i++){
						Object replacementObject = replacementObjects.get(i);
						
						if(rfonts != null)
						{
							if(replacementObject instanceof P)
								replacementObject = (Object) setParagraphReplacementObjectFonts((P)replacementObject, rfonts)
							else if(replacementObject instanceof Tbl)
								replacementObject = (Object) setTableReplacementObjectFonts((Tbl)replacementObject, rfonts)
						}
													
						if(i == 0){
							documentPart.getContent().add(index, replacementObject);
							documentPart.getContent().remove(o);
						}
						else{
							documentPart.getContent().add(index + i, replacementObject);
						}
					}
				}

			}
		}
	}
	
	private static P setParagraphReplacementObjectFonts(P paragraph, RFonts rfonts)
	{
		List<Object> children = paragraph.getContent();
		
		for (Object ch : children )
		{
			if ( ch instanceof R) //R = org.docx4j.wml.R
			{
				R  run = (R)ch;
				RPr rpr = run.getRPr()
				
				rpr.setRFonts(rfonts)
			}
		}
		return paragraph
	}
	
	private static P printParagraphReplacementObjectFonts(P paragraph)
	{
		List<Object> children = paragraph.getContent();
		
		for (Object ch : children )
		{
			if ( ch instanceof R) //R = org.docx4j.wml.R
			{
				R  run = (R)ch;
				RPr rpr = run.getRPr()
				//println rpr?.getRFonts()?.getAscii()
			}
		}
		return paragraph
	}
	
	private static Tbl setTableReplacementObjectFonts(Tbl tbl, RFonts rfonts)
	{
		//println "coming to set table content font"
		List<Object> tblChildren = tbl.getContent();
		
		for (Object tblCh : tblChildren )
		{
			if ( tblCh instanceof Tr) //R = org.docx4j.wml.R
			{
				//println "instance of tr"
				List<Object> trChildren = tblCh.getContent()
				
				for(Object trCh : trChildren)
				{
					//println trCh.toString()
					
					if (trCh instanceof Tc) {
						//tc = (org.docx4j.wml.Tc) o2;
						trCh = (Object) setTcReplacementObjectFonts((Tc)trCh, rfonts)
					} 
					else if (trCh instanceof JAXBElement 
						&& ((JAXBElement) trCh).getDeclaredType().getName().equals("org.docx4j.wml.Tc")) 
					{
						trCh = (org.docx4j.wml.Tc) ((JAXBElement) trCh).getValue();
						trCh = (Object) setTcReplacementObjectFonts(trCh, rfonts)
					} 
					else if (trCh instanceof JAXBElement
							&& ((JAXBElement) trCh).getDeclaredType().getName().equals("org.docx4j.wml.CTSdtCell")) 
					{
						CTSdtCell sdtCell = (org.docx4j.wml.CTSdtCell) ((JAXBElement) trCh).getValue();
						Object o3 = sdtCell.getSdtContent().getContent().get(0);
						if (o3 instanceof JAXBElement && ((JAXBElement) o3).getDeclaredType().getName().equals("org.docx4j.wml.Tc")) 
						{
							trCh = (org.docx4j.wml.Tc) ((JAXBElement) o3).getValue();
							trCh = (Object) setTcReplacementObjectFonts(trCh, rfonts)
						} 
						
					} 
					
				}
				
			}
		}
		return tbl
	}

	private static Tc setTcReplacementObjectFonts(Tc tc, RFonts rfonts)
	{
		//println "instance of tc"
		List<Object> tcChildren = tc.getContent()
		
		for(Object tcCh : tcChildren)
		{
			if(tcCh instanceof P)
			{
				//println "coming to set fot for table content"
				tcCh = setParagraphReplacementObjectFonts(tcCh, rfonts)
				printParagraphReplacementObjectFonts(tcCh)
			}
		}
		return tc
	}
	
	private static P addAllignmentPropertiesToParagraph(P paragraph, PPr ppr)
	{
		paragraph.setPPr(ppr)
		return paragraph
	}
	
	private static Numbering.AbstractNum createAbstractNumbering()
	{
		org.docx4j.wml.ObjectFactory wmlObjectFactory = new org.docx4j.wml.ObjectFactory();
		
		//Numbering numbering = wmlObjectFactory.createNumbering();
		
		Numbering.AbstractNum numberingabstractnum = wmlObjectFactory.createNumberingAbstractNum();
		numberingabstractnum.setAbstractNumId( BigInteger.valueOf(2010) );
	
		CTLongHexNumber longhexnumber = wmlObjectFactory.createCTLongHexNumber();
		numberingabstractnum.setNsid(longhexnumber);
			longhexnumber.setVal( "6ECB300A");
			
		Numbering.AbstractNum.MultiLevelType numberingabstractnummultileveltype = wmlObjectFactory.createNumberingAbstractNumMultiLevelType();
		numberingabstractnum.setMultiLevelType(numberingabstractnummultileveltype);
			numberingabstractnummultileveltype.setVal( "hybridMultilevel");
			
		CTLongHexNumber longhexnumber2 = wmlObjectFactory.createCTLongHexNumber();
		numberingabstractnum.setTmpl(longhexnumber2);
			longhexnumber2.setVal( "54F22A3A");
			
		Lvl lvl = wmlObjectFactory.createLvl();
		numberingabstractnum.getLvl().add(lvl);
		
		lvl.setIlvl( BigInteger.valueOf(3) );		
		lvl.setTplc( "04090001");
		
			Lvl.Start lvlstart = wmlObjectFactory.createLvlStart();
			lvl.setStart(lvlstart);
				lvlstart.setVal( BigInteger.valueOf( 1) );
				
			NumFmt numfmt = wmlObjectFactory.createNumFmt();
			lvl.setNumFmt(numfmt);
				numfmt.setVal(org.docx4j.wml.NumberFormat.BULLET);
					
			Lvl.LvlText lvllvltext = wmlObjectFactory.createLvlLvlText();
			lvl.setLvlText(lvllvltext);
				lvllvltext.setVal( "");
				
			Jc jc = wmlObjectFactory.createJc();
			lvl.setLvlJc(jc);
				jc.setVal(org.docx4j.wml.JcEnumeration.LEFT);
				
			PPr ppr = wmlObjectFactory.createPPr();
			lvl.setPPr(ppr);
				PPrBase.Ind pprbaseind = wmlObjectFactory.createPPrBaseInd();
				ppr.setInd(pprbaseind);
					pprbaseind.setLeft( BigInteger.valueOf( 720) );
					pprbaseind.setHanging( BigInteger.valueOf( 360) );
						
			RPr rpr = wmlObjectFactory.createRPr();
			lvl.setRPr(rpr);
				RFonts rfonts = wmlObjectFactory.createRFonts();
				rpr.setRFonts(rfonts);
					rfonts.setAscii( "Symbol");
					rfonts.setHint(org.docx4j.wml.STHint.DEFAULT);
					rfonts.setHAnsi( "Symbol");
					
			return numberingabstractnum;
	}
	
	private static Numbering.Num createNumberingNum()
	{
		org.docx4j.wml.ObjectFactory wmlObjectFactory = new org.docx4j.wml.ObjectFactory();
		Numbering.Num numberingnum = wmlObjectFactory.createNumberingNum();
		 
			Numbering.Num.AbstractNumId numberingnumabstractnumid = wmlObjectFactory.createNumberingNumAbstractNumId();
			numberingnum.setAbstractNumId(numberingnumabstractnumid);
				numberingnumabstractnumid.setVal( BigInteger.valueOf( 2010) );
			numberingnum.setNumId( BigInteger.valueOf( 2010) );
			
		return numberingnum;
	}
}
