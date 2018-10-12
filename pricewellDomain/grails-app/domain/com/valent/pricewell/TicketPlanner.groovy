package com.valent.pricewell

class TicketPlanner {

	Portfolio portfolio;
	String taskName;
	String taskDesc;
	TicketPlanner parentTask ;
	
	static constraints = {
		portfolio(nullable: true);
		taskName(nullable: true);
		taskDesc(nullable: true);
	}
}
