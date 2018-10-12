package com.valent.pricewell

import java.awt.image.BufferedImage
import java.io.File;

import org.springframework.web.multipart.MultipartFile
import org.codehaus.groovy.grails.web.context.ServletContextHolder

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageInputStream;
import javax.imageio.stream.ImageOutputStream;

class FileUploadService {

    static transactional = true

    def serviceMethod() {

    }
	
	def generateJsonFile(String filePath, String fileContent)
	{
		
		try {

			File newFile = new File(filePath)
			// if file doesnt exists, then create it
			
			if (!newFile.exists()) {
				newFile.createNewFile();
			}

			FileWriter fw = new FileWriter(newFile.getAbsoluteFile());
			BufferedWriter bw = new BufferedWriter(fw);
			bw.write(fileContent);
			bw.close();

			System.out.println("Done");

		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return filePath
	}
	
	public void checkFileAndDelete(File file)
	{
		if(file.exists())
		{
			//println "File already exist so now deleting it..."
			if(file.delete())
			{
				println file.getName() + " file is deleted successfully"
			}
			else
			{
				println file.getName() + " file is fail to delete"
			}
		}
	}
	
	def String uploadDocumentFile(Geo territory, MultipartFile importFile, String documentName, String destinationDirectory) 
	{
		  def result = "fail"
		  def storagePath = getStoragePath(destinationDirectory)
  
		  String fileName = territory?.name?.toString() + documentName
		  fileName = fileName?.toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
		  
		  File newFile = new File("${storagePath}/${fileName}")
		  checkFileAndDelete(newFile)
		  
		  // Store file
		  if (!importFile.isEmpty()) 
		  {
			  importFile.transferTo(new File("${storagePath}/${fileName}"))
			  
			  UploadFile sowFile = uploadNewFile(fileName, storagePath)	
			  if(sowFile != null)
			  {
				  DocumentTemplate sowDocumentTemplate = new DocumentTemplate(documentName: documentName, documentFile: sowFile, isDefault: new Boolean(false)).save() 
				
				  territory.addToSowDocumentTemplates(sowDocumentTemplate)
				  territory.save()
			  }
			  
			  
			  if(sowFile != null)
			  {
				  WordFixUtil util = new WordFixUtil();
				  util.fixBrokenTags("${storagePath}/${fileName}");
				  
				  println "Saved file: ${storagePath}/${fileName}"
			  }
			  result = "success"//"${storagePath}/${name}"
  
		  } else {
			  result = "fail"
		  }
		  return result
	}
	
	def String updateUploadedDocumentFile(DocumentTemplate sowDocumentTemplate, MultipartFile importFile, String documentName, String destinationDirectory)
	{
		  def result = "fail"
		  def storagePath = getStoragePath(destinationDirectory)
  
		  String fileName = sowDocumentTemplate?.territory?.name?.toString() + documentName
		  fileName = fileName?.toLowerCase().replaceAll(" ", "").replaceAll("[-+^,.!@#\$]*", "") + "SOW.docx"
		  
		  File newFile = new File("${storagePath}/${fileName}")
		  checkFileAndDelete(newFile)
		  
		  // Store file
		  if (!importFile.isEmpty())
		  {
			  importFile.transferTo(new File("${storagePath}/${fileName}"))
			  
			  UploadFile fileInstance = UploadFile.get(sowDocumentTemplate?.documentFile?.id)
			  fileInstance.name = fileName
			  fileInstance.filePath = storagePath
			  fileInstance.save()
			  
			  if(fileInstance != null)
			  {
				  WordFixUtil util = new WordFixUtil();
				  util.fixBrokenTags("${storagePath}/${fileName}");
				  
				  println "Saved file: ${storagePath}/${fileName}"
			  }
			  result = "success"//"${storagePath}/${name}"
  
		  } else {
			  result = "fail"
		  }
		  return result
	}
	
	def String uploadFile(Geo territory, MultipartFile importFile, String fileName, String destinationDirectory) 
	{
		  def result = "fail"
		  def storagePath = getStoragePath(destinationDirectory)
  
		  File newFile = new File("${storagePath}/${fileName}")
		  checkFileAndDelete(newFile)
		  
		  // Store file
		  if (!importFile.isEmpty()) 
		  {
			  importFile.transferTo(new File("${storagePath}/${fileName}"))
			  if(territory?.sowFile != null && territory?.sowFile != "")
			  {
				    territory.sowFile = updateUploadedFile(territory, fileName, storagePath)
					territory.save()
			  } 
			  else
			  {
			  		territory.sowFile = uploadNewFile(fileName, storagePath)
					territory.save()
			  }
			  
			  if(territory.sowFile != null)
			  {
				  WordFixUtil util = new WordFixUtil();
				  util.fixBrokenTags("${storagePath}/${fileName}");
				  
				  println "Saved file: ${storagePath}/${fileName}"
			  }
			  result = "success"//"${storagePath}/${name}"
  
		  } else {
			  result = "fail"
		  }
		  return result
	}
	
	public UploadFile uploadNewFile(String fileName, String filePath)
	{
		def fileInstance = new UploadFile()
		fileInstance.name = fileName
		fileInstance.filePath = filePath
		fileInstance.save()
		
		return fileInstance
	}
	
	public UploadFile updateUploadedFile(Geo geoInstance, String fileName, String filePath)
	{
		println geoInstance
		def fileInstance = UploadFile.get(geoInstance?.sowFile?.id)
		fileInstance.name = fileName
		fileInstance.filePath = filePath
		fileInstance.save()
		
		return fileInstance
	}
	
	public void getUploadFilePath(String instanceUrl, String destinationDirectory)
	{
		//instanceUrl = instanceUrl.replaceAll("//:/.", "")
		
		String workingDir = System.getProperty("user.dir")
		String projectPath = workingDir.substring(0, workingDir.lastIndexOf("\\")).replaceAll('\\\\', '/')
		
		def storagePath = projectPath + "/" + "uploadedFile" + "/" + destinationDirectory
		println storagePath
		//println workingDir.substring(0, workingDir.lastIndexOf("\\"))
	}
	
	public String getProjectPath(def destinationDir)
	{
		def servletContext = ServletContextHolder.servletContext
		
		def projectPath = servletContext.getRealPath(destinationDir)//return path of the folder inside project
		//println "folder inside project path : "+projectPath
		File workingDir = new File(projectPath)
		
		projectPath = workingDir.getParent()//return path to web-app inside project
		//println "project path : "+projectPath
		workingDir = new File(projectPath)
		
		projectPath = workingDir.getParent()//return path to project
		//println "tomcat web-app path : "+projectPath
		
		//workingDir = new File(projectPath)
		//projectPath = workingDir.getParent()//return path to parent dir of project
		
		return projectPath.replaceAll('\\\\', '/')
	}
	
	public String getStoragePath(def destinationDirectory)
	{
		
		
		String workingDir = getProjectPath(destinationDirectory)//System.getProperty("user.dir")
		//File workingFile = new File(workingDir)
		//String projectPath = workingFile.getParent()//= workingDir.substring(0, workingDir.lastIndexOf("\\")).replaceAll('\\\\', '/')
		
		def storagePath = workingDir + "/" + "uploadedFiles" + "/" + destinationDirectory
		storagePath = storagePath.replaceAll('\\\\', '/')
		
		def storagePathDirectory = new File(storagePath)
		if (!storagePathDirectory.exists())
		{
			print "CREATING DIRECTORY ${storagePath}: "
			if (storagePathDirectory.mkdirs())
			{
				println "SUCCESS"
			} else {
				println "FAILED"
			}
		}

		return "${storagePath}"
	}
	
	public boolean moveUploadedFile(String sourcePath, String destinationPath)
	{
		try
		{
			File sourceFile = new File(sourcePath);
			File destinationFile = new File(destinationPath + "/" + sourceFile.getName())
			println destinationPath + "/" + sourceFile.getName()
			
			if(sourceFile.renameTo(destinationFile))
			{
				println "File moved successful!"
				return true
			}
			else{
				println "File is failed to move!"
				return false
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public boolean isValidImage(File imageFile)
	{
		boolean isValid = false
		File outputFile = new File(System.getProperty("java.io.tmpdir") + System.getProperty("file.separator") +
								imageFile.getName());
		try{
			InputStream is = new FileInputStream(imageFile);
			ImageInputStream iis = ImageIO.createImageInputStream(is);
			BufferedImage image = ImageIO.read(iis);
			try {
				OutputStream os = new FileOutputStream(outputFile);
				ImageOutputStream ios = ImageIO.createImageOutputStream(os);
				ImageIO.write(image, getFileExtension(imageFile.getName()), ios);
				isValid = true
			} catch (Exception exp) {
				//exp.printStackTrace();
				System.out.println( "file is currepted");
			}
		} catch (Exception exp) {
			//exp.printStackTrace();
			System.out.println( "file is not valid");
		}
		return isValid;
	}
	
	public String getFileExtension(String fileName)
	{
		String extension = "";

		int i = fileName.lastIndexOf('.');
		if (i >= 0) {
			extension = fileName.substring(i+1);
		}
		return extension
	}
	
	public boolean isFileExist(String filePath)
	{
		boolean isThere = false
		File f = new File(filePath);
		
		 if(f.exists())
		 {
			 isThere = true
		 }
		 
		 return isThere
	}
	
	public boolean isFileContentCopied(String inputFilePath, String outputFilePath)
	{
		InputStream inStream = null;
		OutputStream outStream = null;
		boolean isCopied = false
		try
		{
			
		   File inputFile =new File(inputFilePath);
		   File outputFile =new File(outputFilePath);

		   inStream = new FileInputStream(inputFile);
		   outStream = new FileOutputStream(outputFile);

		   byte[] buffer = new byte[1024];

		   int length;
		   while ((length = inStream.read(buffer)) > 0){
			   outStream.write(buffer, 0, length);
		   }

		   if (inStream != null)inStream.close();
		   if (outStream != null)outStream.close();

		   System.out.println("File Copied..");
		   isCopied = true
	   }catch(IOException e){
		   e.printStackTrace();
	   }
	   
	   return isCopied
	}
}
