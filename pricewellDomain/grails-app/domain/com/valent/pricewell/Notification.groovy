package com.valent.pricewell

import java.util.Date;

class Notification {

	String message
	String comment
	boolean active = true
	Date dateCreated
	ReviewRequest reviewRequest
	String objectType = "ServiceProfile"
	long objectId = 0
	User createdBy
	
    static constraints = {
		comment(nullable: true)
		message(nullable: false)
		dateCreated(nullable: false)
		reviewRequest(nullable: true)
		objectType(nullable: true)
		receiverGroups(nullable: true)
		receiverUsers(nullable: true)
		createdBy(nullable: true)
    }
	
	static hasMany = [ receiverGroups: RoleId, receiverUsers: User]
	
	static List  listUserNotifications(User user, def page)
	{
		def list1 = null;
		
		if(page == "active")
		{
			list1 = Notification.findAll("FROM Notification noti WHERE noti.active=true order by noti.dateCreated desc")
		}
		else
		{
			list1 = Notification.findAll("FROM Notification noti order by noti.dateCreated desc")
		}
		
		//println list1
		Set set = new HashSet()
		
		def userRoles = user.roles.code
		
		for(Object n in list1)
		{
			
			if(user in (n.receiverUsers))
			{
				//if(isNotificationCurrent(n)){
					set.add(n)
				//}
			}
			else
			{
				for(roleString in userRoles)
				{
					if(n.receiverGroups?.code.contains(roleString))
					{
						//if(isNotificationCurrent(n)){
							set.add(n)
						//}
						
						break;
					}
				}
				
			}
		}
		def list = new ArrayList(set)
		return list.sort{x,y -> y.dateCreated <=> x.dateCreated}
	}
	
	//Check if notification came from review request then check if it is same as current request in service profile
	static boolean isNotificationCurrent(Notification n){
		try{
			if(n.reviewRequest && n.reviewRequest?.serviceProfile && n?.reviewRequest?.id !=  n.reviewRequest?.serviceProfile?.currentReviewRequest?.id ){
				return false;
			}
			else
			{
				return true;
			}
		} catch(Exception e){
			return false;
		}
	}
}
