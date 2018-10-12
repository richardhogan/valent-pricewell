package com.valent.pricewell

import java.math.BigDecimal;
import org.apache.shiro.SecurityUtils
import java.util.List;
import java.util.Map;

class QuotaService {

    static transactional = true
	def dateService
	
    def serviceMethod() {

    }
	
	List getUserQuotaList()
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		def territoryInstance = null, currency = ""
		def quotaList = []
		Set territoryList = new HashSet()
		
		
		if(SecurityUtils.subject.hasRole("SALES PERSON"))
		{
			quotaList = Quota.findAll("FROM Quota quota WHERE quota.person.id=:uid", [uid: user.id])
		}
		else //if(SecurityUtils.subject.hasRole("SALES MANAGER"))
		{
			quotaList = Quota.findAll("FROM Quota quota WHERE quota.createdBy.id=:uid OR quota.person.id=:pid", [uid: user.id, pid: user.id])
		}
		
		
		return quotaList//['quotaList': quotaList]//, 'territory': territoryInstance, 'territories': territoryList.toList()]
	}
	public List getQuotasPersonList(List quotaList)
	{
		def user = User.get(new Long(SecurityUtils.subject.principal))
		Set personSet = new HashSet()
		for(Quota qu : quotaList)
		{
			if(!SecurityUtils.subject.hasRole("SALES PERSON"))
			{
				if(qu.person.id != user.id)
					personSet.add(qu?.person)
			}
			else personSet.add(qu?.person)
		}
		
		return personSet.toList()
	}
	
	public List filterQuotaByDate(Map dateMap, List quotaList)
	{
		List filteredList = new ArrayList()
		for(Quota qu : quotaList)
		{
			if(dateService.compareDates(qu.fromDate, dateMap['fromDate']) >= 0 && dateService.compareDates(qu.toDate, dateMap['toDate']) <= 0)
			{
				filteredList.add(qu)
			}
		}
		
		return filteredList
	}
	
	public BigDecimal calculateQuotaAmount(List quotaList, User user)//calculate total assigned amount
	{
		BigDecimal assignedAmount = new BigDecimal(0), submitedAmount = new BigDecimal(0)
		//User user = User.get(new Long(SecurityUtils.subject.principal))
		
		for(Quota qu : quotaList)
		{
			if(SecurityUtils.subject.hasRole("SALES PERSON"))
			{
				if(qu.person?.id == user?.id)
				{
					 assignedAmount = assignedAmount + qu.amount.multiply(qu.person?.territory?.convert_rate)
				}
			}
			else //for sales president, sales manager and general manager
			{
				if(qu?.person?.id == user?.id && qu?.createdBy?.id != user?.id)
				{
					assignedAmount = assignedAmount + qu.amount
				}
				else if(qu?.createdBy?.id == user?.id)
				{
					submitedAmount = submitedAmount + qu.amount
				}
			}
		}
		
		if(submitedAmount > assignedAmount)
		{
			return submitedAmount
		}
			
		return assignedAmount
	}
}
