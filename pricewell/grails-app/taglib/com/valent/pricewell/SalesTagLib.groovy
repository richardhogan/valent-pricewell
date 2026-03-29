package com.valent.pricewell

import com.valent.pricewell.PricewellSecurity

/**
 * TagLib providing view helper methods previously called via "new SalesController()" in GSPs.
 *
 * MIGRATION (Grails 2 → 7): In Grails 2, controllers were sometimes instantiated directly in
 * GSPs (new SalesController()) to call utility methods.  In Grails 7 this fails because Spring
 * does not inject dependencies into objects created with 'new', and the 'g' tag delegate is not
 * available on a plain instance.  Moving these helpers into a TagLib gives them proper service
 * injection and access to the tag library infrastructure.
 *
 * Usage examples:
 *   <select name="assignToId">
 *       <option value="">Select Any One</option>
 *       <sales:assignedToOptions selectId="${loginUser.id}"/>
 *   </select>
 *
 *   <g:if test="${sales.isSalesPerson(userId: quotaInstance?.person?.id)}">
 *   ${sales.convertAmountToUserCurrency(userId: id, amount: amount)}
 */
class SalesTagLib {

    static namespace = 'sales'

    def salesCatalogService

    /**
     * Renders grouped <option> elements for the "assigned to" sales-user select box.
     * Users are grouped by role (Sales Presidents, General Managers, Sales Managers, Sales Persons).
     * The option matching selectId is pre-selected.
     *
     * Attrs:
     *   selectId - id of the currently selected User (may be null)
     *
     * Usage:
     *   <select name="assignToId" class="required">
     *       <option value="">Select Any One</option>
     *       <sales:assignedToOptions selectId="${loginUser.id}"/>
     *   </select>
     */
    def assignedToOptions = { attrs ->
        def selectId = attrs.selectId
        Map salesUsersMap = salesCatalogService.getMapOfAssignedToSalesUsers()
        out << g.render(template: "/sales/selectOptionOfAssignedToUsers",
                        model: [selectId    : selectId,
                                sPresidents : salesUsersMap['sPresidents'],
                                gManagers   : salesUsersMap['gManagers'],
                                sManagers   : salesUsersMap['sManagers'],
                                sPersons    : salesUsersMap['sPersons']])
    }

    /**
     * Same as assignedToOptions but pre-selects the currently authenticated user.
     *
     * Usage:
     *   <select name="assignToId" class="required">
     *       <option value="">Select Any One</option>
     *       <sales:assignedToOptionsForCurrentUser/>
     *   </select>
     */
    def assignedToOptionsForCurrentUser = { attrs ->
        def user = PricewellSecurity.currentUser
        Map salesUsersMap = salesCatalogService.getMapOfAssignedToSalesUsers()
        out << g.render(template: "/sales/selectOptionOfAssignedToUsers",
                        model: [selectId    : user?.id,
                                sPresidents : salesUsersMap['sPresidents'],
                                gManagers   : salesUsersMap['gManagers'],
                                sManagers   : salesUsersMap['sManagers'],
                                sPersons    : salesUsersMap['sPersons']])
    }

    /**
     * Renders grouped <option> elements for the quota person select box.
     * Uses the quota-specific user list from salesCatalogService.
     *
     * Usage:
     *   <select name="person.id" class="personId required">
     *       <option value="">Select Any One</option>
     *       <sales:assignedToOptionsForQuota/>
     *   </select>
     */
    def assignedToOptionsForQuota = { attrs ->
        Map salesUsersMap = salesCatalogService.getAssignedToSalesUserForQuota()
        out << g.render(template: "/sales/selectOptionOfAssignedToUsersForQuota",
                        model: [selectId    : null,
                                sPresidents : salesUsersMap['sPresidents'],
                                gManagers   : salesUsersMap['gManagers'],
                                sManagers   : salesUsersMap['sManagers'],
                                sPersons    : salesUsersMap['sPersons']])
    }

    /**
     * Returns true if the specified user has the SALES_PERSON role.
     *
     * Attrs:
     *   userId - id of the User to check
     *
     * Usage:
     *   <g:if test="${sales.isSalesPerson(userId: quotaInstance?.person?.id)}">
     */
    def isSalesPerson = { attrs ->
        def userId = attrs.userId
        User user = User.get(userId?.toLong())
        return salesCatalogService.checkUserRoleCode(user, RoleId.SALES_PERSON.code)
    }

    /**
     * Returns the amount converted to the user's territory currency.
     *
     * Attrs:
     *   userId - id of the User whose territory currency to convert to
     *   amount - BigDecimal amount in base currency
     *
     * Usage:
     *   ${sales.convertAmountToUserCurrency(userId: id, amount: quotaInstance?.amount)}
     */
    def convertAmountToUserCurrency = { attrs ->
        def userId = attrs.userId
        BigDecimal amount = attrs.amount as BigDecimal
        User user = User.get(userId?.toLong())
        if (user?.territory != null && user?.territory != "") {
            return amount.multiply(user?.territory?.convert_rate).setScale(0, BigDecimal.ROUND_HALF_EVEN)
        }
        return amount.setScale(0, BigDecimal.ROUND_HALF_EVEN)
    }

    /**
     * Returns true if Connectwise integration is available.
     * Usage: <g:if test="${sales.isConnectwiseIncluded()}">
     */
    def isConnectwiseIncluded = { attrs ->
        return SalesController.isConnectwiseIncluded()
    }

    /**
     * Returns true if the given quotation is for a Connectwise opportunity.
     * Attrs: id - quotation id
     * Usage: <g:if test="${sales.isQuoteForConnectwiseOpportunity(id: quotationInstance.id)}">
     */
    def isQuoteForConnectwiseOpportunity = { attrs ->
        def id = attrs.id
        Quotation quote = Quotation.get(id)
        if (quote?.contractStatus?.name == 'Accepted' &&
                quote?.opportunity?.externalId != '' &&
                quote?.opportunity?.externalId != null) {
            if (quote?.convertToTicket != 'yes') {
                return true
            }
        }
        return false
    }
}
