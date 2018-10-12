package com.valent.pricewell

import org.docx4j.model.datastorage.migration.VariablePrepare
import org.docx4j.openpackaging.io.SaveToZipFile
import org.docx4j.openpackaging.packages.WordprocessingMLPackage
import org.docx4j.wml.ContentAccessor
import org.springframework.context.ApplicationContext
import org.springframework.context.ApplicationContextAware

import javax.xml.bind.JAXBElement
import java.util.regex.Matcher
import java.util.regex.Pattern

class TestWord {
	
	public static String main(Quotation quotation, String outputFilePath)
	{
		
		def territoryInstance = Geo.get(quotation?.geo?.id)
		String inputFile = getQuotationSowFilePath(quotation)//getFilePath(territoryInstance)//"G:/my/sample.docx";
		String outputFile = outputFilePath //"G:/my/x2.docx";
		
		WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(new java.io.File(inputFile));
		
		//WordSubstitutionMapGenerator substitutionGenerator = new WordSubstitutionMapGenerator(quotation, g, context, wordMLPackage);
		SubstituionMapGenerator substitutionGenerator = new WordSubstitutionMapGenerator(quotation, wordMLPackage);

		WordSOWGenerator sowGenerator = new WordSOWGenerator(wordMLPackage, //inputFile,
				outputFile,
				substitutionGenerator);
		sowGenerator.generateReport();
		
		return outputFile
	}

	public static String implementAfterTemplater(Quotation quotation, String outputFilePath)
	{
		String inputFile = outputFilePath//"G:/my/sample.docx";
		String outputFile = outputFilePath //"G:/my/x2.docx";
		
		WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(new java.io.File(inputFile));
		
		//WordSubstitutionMapGenerator substitutionGenerator = new WordSubstitutionMapGenerator(quotation, g, context, wordMLPackage);
		SubstituionMapGenerator substitutionGenerator = new WordSubstitutionMapGenerator(quotation, wordMLPackage);

		WordSOWGenerator sowGenerator = new WordSOWGenerator(wordMLPackage,
				outputFile,
				substitutionGenerator);
		sowGenerator.generateReport();
		
		return outputFile
	}

	
	public static String getFilePath(Geo territoryInstance)
	{
		def filePath = territoryInstance?.sowFile?.filePath + "\\" + territoryInstance?.sowFile?.name
		filePath = filePath.replaceAll('\\\\', '/')
		return filePath
	}
	
	public static String getQuotationSowFilePath(Quotation quotationInstance)
	{
		def filePath = quotationInstance?.sowDocumentTemplate?.documentFile?.filePath + "\\" + quotationInstance?.sowDocumentTemplate?.documentFile?.name
		filePath = filePath.replaceAll('\\\\', '/')
		return filePath
	}
	
	public static String main(ServiceProfile serviceProfile, String territoryID, Object g, ApplicationContext context, String outputFilePath)
	{
		def fileUploadService=new FileUploadService();
		def territoryInstance = Geo.get(territoryID)  
		def storagePath =  fileUploadService.getStoragePath("SOWFiles")
		//def outputFilePath = storagePath+"/"+"GenerateSowPdfViewer.docx"
		//String inputFile = getFilePath(territoryInstance)//"G:/my/sample.docx";
		String inputFile=storagePath+"/"+"GenerateSowPdfViewer.docx"
		String outputFile = outputFilePath //"G:/my/x2.docx";
		
		File file=new File(inputFile)
		
		// if file doesnt exists, then create it
		if (!file.exists()) {
			def content='${quotationOfferingServices}';
			WordprocessingMLPackage wordMLPackage_create = WordprocessingMLPackage.createPackage();
			wordMLPackage_create.getMainDocumentPart().addParagraphOfText(content);
			wordMLPackage_create.save(new java.io.File(inputFile));
							}
				
		WordprocessingMLPackage wordMLPackage = WordprocessingMLPackage.load(new java.io.File(inputFile));

		SubstituionMapGenerator substitutionGenerator = new ServiceWordSubstitutionMapGenerator(serviceProfile, g, context, wordMLPackage);

		WordSOWGenerator sowGenerator = new WordSOWGenerator(wordMLPackage, //inputFile,
				outputFile,
				substitutionGenerator);
		sowGenerator.generateWord();

		return outputFile
	}

    //Pattern paramPatern = Pattern.compile('(\\[\\[\\w+\\]:?\\w*\\])')
    //TestWord.findTexts(templatePath,'\\[\\[[\\w,\\.]+\\]\\]')
    public static List<String> findTexts(String filePath, final String pattern)  throws Exception{
        WordprocessingMLPackage mlp = WordprocessingMLPackage.load(new File(filePath));
        ContentAccessor c = mlp.getMainDocumentPart();
        StringBuffer buffer = new StringBuffer()
        findAllTexts(c).each {
            buffer.append(it.getValue())
        }
        String contents = buffer.toString()
        println contents
        Pattern paramPatern = Pattern.compile(pattern)
        Matcher m = paramPatern.matcher(contents);
        def matches = []
        while(m.find()){
            matches.add(m.group())
        }
        return matches
    }

    public static void removeText(InputStream is, String pattern, String outputPath){
        WordprocessingMLPackage mlp = WordprocessingMLPackage.load(is);
        ContentAccessor c = mlp.getMainDocumentPart();
        findAllTexts(c).each {
            if (it.getValue().contains(pattern)) it.setValue("")
        }
        SaveToZipFile saveToZipFile = new SaveToZipFile(mlp)
        saveToZipFile.save(new File(outputPath) )
    }

    static List<org.docx4j.wml.Text> findAllTexts(ContentAccessor c)  throws Exception
    {
        def textsList = [];
        for (Object p: c.getContent())
        {
            if (p instanceof ContentAccessor)
                textsList.addAll(findAllTexts((ContentAccessor) p));

            else if (p instanceof JAXBElement)
            {
                Object v = ((JAXBElement) p).getValue();

                if (v instanceof ContentAccessor)
                    textsList.addAll(findAllTexts((ContentAccessor) v));

                else if (v instanceof org.docx4j.wml.Text)
                {
                    org.docx4j.wml.Text t = (org.docx4j.wml.Text) v;
                    String text = t.getValue();


                    if (text != null)
                    {
                        textsList.add(t)
                    }
                }
            }
        }
        return textsList
    }
}
