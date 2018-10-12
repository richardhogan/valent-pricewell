package com.clarizen.integration.util

public class ClarizenConstants {
	public static  String BASEURL  = "";//"https://api.clarizen.com";
	
	public static final String USERNAME = "ankit.jani@gmail.com";//"snehal@valent-software.com";
	public static final String PASSWORD = "Anks@_4407";//"valent123";

	public static final String BASICSERVICESURL = "/v2.0/services";
	
	/* Actual PATH URLs of various request*/
	public static final String AUTHENTICATION = BASICSERVICESURL + "/authentication/";
	public static final String DATASERVICE =BASICSERVICESURL+"/data/"
	
	//Get Server Information - https://api.clarizen.com/V2.0/services/authentication/GetServerDefinition
	public static String GETSERVERDEFINITION = AUTHENTICATION + "getServerDefinition";
	
	//Login https://api.clarizen.com/V2.0/services/authentication/Login
	public static String LOGIN               = AUTHENTICATION + "login";
	
	//Logout - https://api.clarizen.com/V2.0/services/authentication/Logout
	public static String LOGOUT              = AUTHENTICATION + "logout";
	//
	public static String GETTASK=DATASERVICE+"objects"
	
	//USER SessionID
	private static String SESSION_UID=""
	
	//URL PATH FOR CREATEANDRETRIVE ENTITY
	private static String CREATEANDRETRIVEENTITY=DATASERVICE+"createAndRetrieve"
	
	//URL path to create objects(task,milestone)
	private static String CREATEOBJECTS=DATASERVICE+"objects/"
		}
