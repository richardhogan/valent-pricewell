package com.clarizen.integration

import groovyx.net.http.HttpResponseException;

import java.util.Map;

import org.codehaus.groovy.grails.web.context.ServletContextHolder;
import org.omg.CORBA.portable.UnknownException;

import com.clarizen.integration.util.ClarizenConstants;
import com.clarizen.integration.util.ClarizenUtils;
import com.sun.java.util.jar.pack.Package.Class;

class ClarizenExportService {
	static transactional = true
	def serviceMethod() {
	
		}
	public Map isLogin(Map credentialsMap) {
		
		boolean result = false;
		String responseMessage = ""
		String username = credentialsMap["username"]//"ankit.jani@gmail.com";
		String password = credentialsMap["password"]//Anks@_4407;
		String instanceUri  = credentialsMap["instanceUri"]//"api.clarizen.com";
		ClarizenConstants.BASEURL="https://" + instanceUri;
		//String authEndPoint = "https://" + instanceUri + "/v2.0/services/authentication/";
		 
		def storagePath = getStoragePath("clarizenLogs")
		def body = [ userName:username, password:password ];
		ClarizenUtils.print(ClarizenConstants.GETSERVERDEFINITION)
		try
		{
		Object data=ClarizenUtils.getServerInfo(body,ClarizenConstants.GETSERVERDEFINITION)
		ClarizenUtils.print(data.serverLocation)
		Object canLogin=ClarizenUtils.login(data.serverLocation, body)
		//ClarizenUtils.print(canLogin)
		if(!canLogin.errorCode)
		{
			result=true
		
		}
		else
		{
			
			responseMessage=generateFailureMessage(canLogin.errorCode)
			result=false
		}
		}
		catch(HttpResponseException error)
		{
			error.printStackTrace(System.out)
			responseMessage = "Invalid Username or Password"
		}
		catch(Exception error)
		{
			error.printStackTrace(System.out)
			responseMessage = "Invalid Instance URI. Please correct it first"
		}
		//responseMessage = generateFailureMessage(ce.toString())
			//ce.printStackTrace();
			//println ce.toString()
			//println ce.getMessage()
		
		 
		
		return [result: result, responseMessage: responseMessage]
	}
	public String getStoragePath(def destinationDirectory)
	{
		
		
		String workingDir = getProjectPath(destinationDirectory)//System.getProperty("user.dir")
		//File workingFile = new File(workingDir)
		//String projectPath = workingFile.getParent()//= workingDir.substring(0, workingDir.lastIndexOf("\\")).replaceAll('\\\\', '/')
		
		def storagePath = workingDir + "/" + "logs" + "/" + destinationDirectory
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
	public String generateFailureMessage(String errorMessage)
	{
		if(errorMessage != null)
		{
			if(errorMessage.contains("LoginFailure"))
			{
				return  "Invalid username, password or user locked out."
			}
			else 
				{
					return "Something went wrong."
				}
			}
		}
	}

