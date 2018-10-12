package com.valent.pricewell

import javax.servlet.http.HttpServletRequest

class HttpRequestMetaClassEnhancer{
	public static void enhanceRequest(){
		HttpServletRequest.metaClass {
			getRemoteIPAddress = {
				delegate.getHeader("x-forwarded-for") ?: delegate.remoteAddr
			}
			isAjax = {
				delegate.getHeader("X-Requested-With") == "XMLHttpRequest"
			}
			getSiteUrl = {
				delegate.scheme + "://" + delegate.serverName + ":" + delegate.serverPort + delegate.getContextPath()
			}
			getUserAgent = { delegate.getHeader("User-Agent") }
			isMobileBrowser = {
				delegate.getHeader("User-Agent").matches("(?i).*(android|iphone|ipad).*")
			}
			/*
			 Keep adding methods that are common to projects as comment to blog.
			 I will update this blog with your helper methods
			 */
		}
	}
}