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
		// Changed from hard-coded Windows absolute path "G:/SOWFiles/my-territory.docx" to a
		// relative path so the application works on any OS and deployment environment.
		// The path resolves relative to the working directory from which the app is launched
		// (project root in development; configure the launch directory for production deployments).
		def path = "SOWFiles/my-territory.docx"//"SOWFiles/"+territory?.name.toLowerCase().toString()+"-territory.docx"
		getCopiesOfMasterFile("my-territory")
	}

	public void returnTemplate()
	{

	}

	public void getCopiesOfMasterFile(String fileName)
	{
		// Changed from hard-coded Windows absolute path "G:/SOWFiles/" to a relative path.
		// See comment in getTemplate() above for details.
		def path = "SOWFiles/"
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
