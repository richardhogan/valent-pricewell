package com.valent.pricewell

import javax.servlet.http.HttpSessionEvent
import javax.servlet.http.HttpSessionListener

public class MyHttpSessionListener implements HttpSessionListener
{
	public void sessionCreated(HttpSessionEvent event)
	{
		event.getSession().setMaxInactiveInterval(2*60); //in seconds
	}
	public void sessionDestroyed(HttpSessionEvent event){}
}