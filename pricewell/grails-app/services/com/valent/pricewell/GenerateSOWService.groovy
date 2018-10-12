package com.valent.pricewell

class GenerateSOWService {

    static transactional = true

    def serviceMethod() {

    }
	
	public void myFunc()
	{
		println "Hi Abhi"
	}
	
	public File getTemplate(Geo territory)
	{
		def path = "G:/SOWFiles/my-territory.docx"//"G:/SOWFiles/"+territory?.name.toLowerCase().toString()+"-territory.docx"
		getCopiesOfMasterFile("my-territory")
	}
	
	public void returnTemplate()
	{
		
	}
	
	public void getCopiesOfMasterFile(String fileName)
	{
		def path = "G:/SOWFiles/"
		File parentFolder = new File(path+fileName+".docx").getParentFile()
		//println parentFolder.listFiles()
		def availableFiles = getCopies(parentFolder, fileName)
		println availableFiles
	}
	
	public List<File> getCopies(File parentFolder, String fileName)
	{
		List availableFiles = []
		for(File file : parentFolder.listFiles())
		{
			if(file.isFile())
			{
				def name = file.getName().toString()
				if(name.contains(fileName))
				{
					//println name
					//pool.isAvailable(file) then put in availableList
					availableFiles.add(file)
				}
			}
		}
		
		//if availableList.isEmpty() //then create new
		return availableFiles
	}
}
