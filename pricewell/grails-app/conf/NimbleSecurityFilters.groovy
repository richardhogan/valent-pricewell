/*
 *  Nimble, an extensive application base for Grails
 *  Copyright (C) 2010 Bradley Beddoes
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
import grails.plugins.nimble.core.AdminsService

/**
 * Filter that works with Nimble security model to protect controllers, actions, views
 *
 * @author Bradley Beddoes
 */
public class NimbleSecurityFilters extends grails.plugins.nimble.security.NimbleFilterBase {

    def filters = {

        // Content requiring users to be authenticated
        secure(controller: "account|activityRoleTime|companyInformation|contact|deliveryRole|emailSetting|geo|geoGroup|home|lead|navigation|notification|opportunity|pendingMail|portfolio|preferences|quotation|relationDeliveryGeo|reports|reviewComment|reviewRequest|serviceActivity|service|serviceDeliverable|serviceProductItem|serviceProfile|serviceQuotation|setting|staging|stagingLog|setup|quota|product|productPricelist|serviceQuotationTicket|timeStampSaverObject|QuotationMilestone|serviceProfileSOWDef|error|cw|correctionInActivityRoleTime|connectwiseCredentials") {
            before = {
                accessControl {
                    true
                }
            }
        }

        // Account management requiring authentication
        accountsecure(controller: "account", action: "(changepassword|updatepassword|changedpassword)") {
            before = {
                accessControl {
                    true
                }
            }
        }

        // This should be extended as the application adds more administrative functionality
        administration(controller: "(admins|user|group|role)") {
            before = {
                accessControl {
                    role(AdminsService.ADMIN_ROLE)
                }
            }
        }

        serviceManage(controller: "service", action: "(create|delete)") {
            before = {
                accessControl {
                    permission("service:create") || permission("portfolio:update")
                }
            }
        }

        portfolioManage(controller: "portfolio", action: "(create|delete)") {
            before = {
                accessControl {
                    permission("portfolio:create")
                }
            }
        }
		
		deliveryRoleManage(controller: "deliveryRole|geo|relationDeliveryGeo", action: "(create|save|edit|update|delete|deleteMultiple|editMultiple|updateMultiple|saveMultiple|addGeosForDeliveryRole)")
		{
			before = {
				accessControl {
					permission("deliveryRole:create")
				}
			}
		}
		
		reportsView(controller: "reports") {
			before = {
				accessControl {
					permission("reports:show")
				}
			}
		}
		
		quotation(controller: "quotation"){
			before = {
				accessControl {
					permission("quotation:create")
				}
			}
		}
		
	
    }

}

