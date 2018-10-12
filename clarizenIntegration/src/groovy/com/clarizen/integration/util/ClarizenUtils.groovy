package com.clarizen.integration.util

import groovyx.net.http.HttpResponseDecorator;
import groovyx.net.http.RESTClient;

import org.codehaus.groovy.grails.web.json.JSONObject;

class ClarizenUtils {
	/**
	 * @param url
	 * @return
	 */
	private static Object login(String url,Object body) {
		//def body = [ userName:ClarizenConstants.USERNAME, password:ClarizenConstants.PASSWORD ];
		ClarizenUtils.print(url+ClarizenConstants.LOGIN)
		HttpResponseDecorator decorator = ClarizenUtils.postRequest(url, ClarizenConstants.LOGIN, body);
		ClarizenUtils.print(decorator.responseData)
		return decorator.responseData; 
	}
	/**
	 * @param url
	 * @param data
	 * @return
	 */
	private static boolean createProject(JSONObject data,String url) {
		HttpResponseDecorator decorator =ClarizenUtils.postRequest(url, ClarizenConstants.CREATEANDRETRIVEENTITY,data,ClarizenConstants.SESSION_UID);
		//projectId=decorator.responseData.entity.id;
		System.out.println(decorator.responseData.entity.id);
	}
	/**
	 * @param url
	 * @param data
	 * @return
	 */
	private static boolean createObject(JSONObject data,String url,String Object) {

		HttpResponseDecorator decorator =ClarizenUtils.putRequest(url, ClarizenConstants.CREATEOBJECTS+Object,data,ClarizenConstants.SESSION_UID);
		System.out.println(decorator.responseData);
	}
	/**
	 * @param url
	 * @return
	 */
	private static boolean logout(String url) {
		boolean success = false;

		def body = [ userName:ClarizenConstants.USERNAME, password:ClarizenConstants.PASSWORD ];
		HttpResponseDecorator decorator = ClarizenUtils.postRequest(url, ClarizenConstants.LOGOUT, body);
		System.out.println(" Response Received "+decorator.responseData);
		return success;
	}
	/**
	 * @return
	 */
	public static Object getServerInfo(Object body,String url) {
		//def body = [ userName:ClarizenConstants.USERNAME, password:ClarizenConstants.PASSWORD ];
		HttpResponseDecorator decorator = postRequest(url, body);
		System.out.println(" Response Received "+decorator.responseData);
		
		return decorator.responseData;
	}

	/**
	 * @return
	 */
	public static RESTClient getRestClient(){
		return getRestClient(ClarizenConstants.BASEURL);
	}
	
	/**
	 * @param url
	 * @return
	 */
	public static RESTClient getRestClient(String url){
		RESTClient client = new RESTClient(url);
		client.setContentType("application/json");
		
		return client;
	}
	
	/**
	 * @param baseURL
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator postRequest(String baseURL, String path, Object body){
		System.out.println("URL is "+baseURL);
		
		return postRequest(getRestClient(baseURL), path, body);
	}
	
	/**
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator postRequest(String path, Object body){
		return postRequest(getRestClient(), path, body);
	}
	
	/**
	 * @param client
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator postRequest(RESTClient client, String path, Object body){
		def responseObj = client.post( path: path,body : body );
		
		client.shutdown();
		return responseObj;
	}
	/**
	 * @param baseURL
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator postRequest(String baseURL, String path, JSONObject body,String sessionId){
		System.out.println("URL is "+baseURL);
		
		return postRequest(getRestClient(baseURL), path, body,sessionId);
	}
	
	/**
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator postRequest(String path, JSONObject body,String sessionId){
		return postRequest(getRestClient(), path, body);
	}
	/**
	 * @param client
	 * @param sessionId
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator postRequest(RESTClient client, String path, JSONObject body,String sessionId){
		client.setHeaders("Authorization":"Session "+sessionId);
		def responseObj = client.post( path: path,body : body );
		
		client.shutdown();
		return responseObj;
	}
//	/**
//	 * @param baseURL
//	 * @param path
//	 * @param body
//	 * @return
//	 */
//	public static HttpResponseDecorator getRequest(String baseURL, String path){
//		System.out.println("URL is "+baseURL);
//		
//		return getRequest(getRestClient(baseURL), path);
//	}
//	
//	/**
//	 * @param path
//	 * @param body
//	 * @return
//	 */
//	public static HttpResponseDecorator getRequest(String path, Object body){
//		return getRequest(getRestClient(), path, body);
//	}
//	
//	/**
//	 * @param client
//	 * @param path
//	 * @param body
//	 * @return
//	 */
//	public static HttpResponseDecorator getRequest(RESTClient client, String path){
//		
//		//client.setHeaders("Cookie":	"USID=" + ClarizenConstants.SESSION_UID);
//		//client.setHeaders(null)
//		client.get(path:path)
//		client.shutdown();
//		return responseObj;
//	}
	
	/**
	 * @param baseURL
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator putRequest(String baseURL, String path, JSONObject body,String sessionId){
		System.out.println("URL is "+baseURL);
		
		return putRequest(getRestClient(baseURL), path, body,sessionId);
	}
	
	/**
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator putRequest(String path, JSONObject body,String sessionId){
		return putRequest(getRestClient(), path, body);
	}
	/**
	 * @param client
	 * @param sessionId
	 * @param path
	 * @param body
	 * @return
	 */
	public static HttpResponseDecorator putRequest(RESTClient client, String path, JSONObject body,String sessionId){
		client.setHeaders("Authorization":"Session "+sessionId);
		def responseObj = client.put( path: path,body : body );
		
		client.shutdown();
		return responseObj;
	}
	/**
	 * print on console
	 */
	public static void print(String print)
	{
		boolean flag=true;
		if(flag==true)
		{
			System.out.println(print);
		}
	}
}