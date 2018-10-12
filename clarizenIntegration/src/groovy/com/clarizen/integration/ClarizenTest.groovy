package com.clarizen.integration

/**
 * Created by snehal.shah on 04/08/15
 */


import com.clarizen.integration.util.ClarizenConstants;
import com.clarizen.integration.util.ClarizenUtils;

import groovyx.net.http.*;
import groovy.json.*;
import org.codehaus.groovy.grails.web.json.JSONObject

/**
 * This class contains demo methods to communicate with Clarizen System
 * @author snehal
 *
 */
public class ClarizenTest {

	public static String projectId=""
	private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

	public static void main(String[] args) {
		ClarizenTest samples = new ClarizenTest();

		//Step 1 - Get Server Info first to get the actual server URL where our access is given
		Object serverInfoResponse = ClarizenUtils.getServerInfo();

		System.out.println("serverInfoResponse "+serverInfoResponse);

		//def jsonSlurper = new JsonSlurper();
		// def serverDetails = jsonSlurper.parseText(serverInfoResponse);

		System.out.println(" appLocation "+serverInfoResponse.appLocation);
		System.out.println(" serverLocation "+serverInfoResponse.serverLocation);

		//By default Server Location looks like this - https://api2.clarizen.com/v2.0/services
		//We need to remove '/v2.0/services' to get the actual domain URL only
		String serverLocation = serverInfoResponse.serverLocation;
		serverLocation = serverLocation.substring(0, serverLocation.indexOf("/v2.0"));

		//Below will be actual domain URL which needs to be set for RESTClient
		System.out.println(" Calling URL "+serverLocation);

		//Step 2 - Login to system in order to get the sessionId to move further
		samples.login(serverLocation);
		JSONObject mainjsonObject=new JSONObject();
		JSONObject subjsonObject=new JSONObject();
		subjsonObject.put("Id","/Project" )
		subjsonObject.put("Name", "Sub Project")
		subjsonObject.put("StartDate", "2015-10-08")
		mainjsonObject.put("entity",subjsonObject )
		//def body = [ entity:[Id:"/Project",Name:"First Project(pricewell)",StartDate:"2015-11-01"]];
		System.out.println(mainjsonObject.toString());
		//	   samples.createProject(mainjsonObject,serverLocation)
		JSONObject mainjsonObjectMileStone=new JSONObject();
		//	   mainjsonObjectMileStone.put("Parent",projectId)
		//	  	mainjsonObjectMileStone.put("Name", "New MileStone In second project")
		//	   mainjsonObjectMileStone.put("StartDate", "2015-10-08")
		//   samples.createObject(mainjsonObjectMileStone, serverLocation, "Milestone")
		mainjsonObjectMileStone.put("Parent","/Task/3rscetn8d84nsjh7toki5n8c02")
		mainjsonObjectMileStone.put("Name", "New Task In second project")
		mainjsonObjectMileStone.put("StartDate", "2015-10-08")
		samples.createObject(mainjsonObjectMileStone, serverLocation, "Milestone")
		//	mainjsonObjectMileStone.put("Parent",projectId)
		//	mainjsonObjectMileStone.put("Name", "New Project In second project")
		// mainjsonObjectMileStone.put("StartDate", "2015-10-08")
		// samples.createObject(mainjsonObjectMileStone, serverLocation, "Project")
	}

	/**
	 * @param url
	 * @return
	 */
	private boolean login(String url) {
		boolean success = false;

		def body = [ userName:ClarizenConstants.USERNAME, password:ClarizenConstants.PASSWORD ];
		HttpResponseDecorator decorator = ClarizenUtils.postRequest(url, ClarizenConstants.LOGIN, body);
		System.out.println("Login Response Received "+decorator.responseData.sessionId);
		ClarizenConstants.SESSION_UID=decorator.responseData.sessionId

		return success;
	}
	/**
	 * @param url
	 * @param data
	 * @return
	 */
	private boolean createProject(JSONObject data,String url) {
		HttpResponseDecorator decorator =ClarizenUtils.postRequest(url, ClarizenConstants.CREATEANDRETRIVEENTITY,data,ClarizenConstants.SESSION_UID);
		projectId=decorator.responseData.entity.id;
		System.out.println(decorator.responseData.entity.id);
	}
	/**
	 * @param url
	 * @param data
	 * @return
	 */
	private boolean createObject(JSONObject data,String url,String Object) {

		HttpResponseDecorator decorator =ClarizenUtils.putRequest(url, ClarizenConstants.CREATEOBJECTS+Object,data,ClarizenConstants.SESSION_UID);
		System.out.println(decorator.responseData);
	}
	/**
	 * @param url
	 * @return
	 */
	private boolean logout(String url) {
		boolean success = false;

		def body = [ userName:ClarizenConstants.USERNAME, password:ClarizenConstants.PASSWORD ];
		HttpResponseDecorator decorator = ClarizenUtils.postRequest(url, ClarizenConstants.LOGOUT, body);
		System.out.println(" Response Received "+decorator.responseData);
		return success;
	}
}
