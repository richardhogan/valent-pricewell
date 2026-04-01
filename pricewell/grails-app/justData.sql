
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

LOCK TABLES `_user` WRITE;
/*!40000 ALTER TABLE `_user` DISABLE KEYS */;
INSERT INTO `_user` VALUES (1,1,'admin','{bcrypt}$2a$10$m0CVZs.bN.rt.yczMmCiVuXpdPgdP8bjq4Hzvs49rMMqef5cGtBN2',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0','SYSTEM ADMINISTRATOR',NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.057000',NULL),(2,0,'superadmin','{bcrypt}$2a$10$VfTlnvUVYKSSKXUcnvoY8utmbAjvyfbdxWXR7vDU7ftoqgTXTztYi',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.228000',NULL),(3,0,'nobody','{bcrypt}$2a$10$/3THb6nHQtOiQe1S5iYNButhp3/ZGgqVf5j03ltDXVeFCv71I029S',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.343000',NULL),(4,1,'gm.amer','{bcrypt}$2a$10$BYJ5WlfIwiTx9nWdNVbeWe79EkWimCuQyXNUJUPyLDUMiSvnIAYQG',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,1,NULL,'2026-03-31 20:22:16.469000',NULL),(5,1,'gm.emea','{bcrypt}$2a$10$GThdiIDgtbsOCynv46aCjurotRwCfaAQk3uFZLAQ1yzIjYQiI.qfe',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,2,NULL,'2026-03-31 20:22:16.633000',NULL),(6,1,'gm.apac','{bcrypt}$2a$10$P5ILWO1Xn5se9ARliagtVeHM.cWfSXCIchpBUpDEoJ/k1GzFJ5Vve',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,3,NULL,'2026-03-31 20:22:16.730000',NULL);
/*!40000 ALTER TABLE `_user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `activity_role_time` WRITE;
/*!40000 ALTER TABLE `activity_role_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_role_time` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `billing_address` WRITE;
/*!40000 ALTER TABLE `billing_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_address` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `clarizen_credentials` WRITE;
/*!40000 ALTER TABLE `clarizen_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `clarizen_credentials` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `company_information` WRITE;
/*!40000 ALTER TABLE `company_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_information` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `connectwise_credentials` WRITE;
/*!40000 ALTER TABLE `connectwise_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `connectwise_credentials` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `contact_billing_address` WRITE;
/*!40000 ALTER TABLE `contact_billing_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_billing_address` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `contact_quotation` WRITE;
/*!40000 ALTER TABLE `contact_quotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_quotation` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `correction_in_activity_role_time` WRITE;
/*!40000 ALTER TABLE `correction_in_activity_role_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `correction_in_activity_role_time` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `delivery_role` WRITE;
/*!40000 ALTER TABLE `delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `description` WRITE;
/*!40000 ALTER TABLE `description` DISABLE KEYS */;
/*!40000 ALTER TABLE `description` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `document_template` WRITE;
/*!40000 ALTER TABLE `document_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_template` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `email_setting` WRITE;
/*!40000 ALTER TABLE `email_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_setting` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `extra_unit` WRITE;
/*!40000 ALTER TABLE `extra_unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `extra_unit` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `field_mapping` WRITE;
/*!40000 ALTER TABLE `field_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `field_mapping` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `general_staging_log` WRITE;
/*!40000 ALTER TABLE `general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `geo` WRITE;
/*!40000 ALTER TABLE `geo` DISABLE KEYS */;
/*!40000 ALTER TABLE `geo` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `geo_group` WRITE;
/*!40000 ALTER TABLE `geo_group` DISABLE KEYS */;
INSERT INTO `geo_group` VALUES (1,0,'AMER',NULL),(2,0,'EMEA',NULL),(3,0,'APAC',NULL);
/*!40000 ALTER TABLE `geo_group` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `geo_sow_discounts` WRITE;
/*!40000 ALTER TABLE `geo_sow_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `geo_sow_discounts` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `internal_map` WRITE;
/*!40000 ALTER TABLE `internal_map` DISABLE KEYS */;
INSERT INTO `internal_map` VALUES (1,0,'bootstrap','revision','1');
/*!40000 ALTER TABLE `internal_map` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `lead` WRITE;
/*!40000 ALTER TABLE `lead` DISABLE KEYS */;
/*!40000 ALTER TABLE `lead` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `lead_general_staging_log` WRITE;
/*!40000 ALTER TABLE `lead_general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `lead_general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `login_record` WRITE;
/*!40000 ALTER TABLE `login_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_record` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `logo_image` WRITE;
/*!40000 ALTER TABLE `logo_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `logo_image` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `note` WRITE;
/*!40000 ALTER TABLE `note` DISABLE KEYS */;
/*!40000 ALTER TABLE `note` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `notification__user` WRITE;
/*!40000 ALTER TABLE `notification__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification__user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `notification_receiver_groups` WRITE;
/*!40000 ALTER TABLE `notification_receiver_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_receiver_groups` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `object_type` WRITE;
/*!40000 ALTER TABLE `object_type` DISABLE KEYS */;
INSERT INTO `object_type` VALUES (1,1,'INSTALL','SERVICE_DELIVERABLE',NULL,0),(2,1,'TRAINING','SERVICE_DELIVERABLE',NULL,0),(3,1,'INSTALL','SERVICE_ACTIVITY',NULL,0),(4,1,'TRAINING','SERVICE_ACTIVITY',NULL,0),(5,0,'INITIAL PAYMENT','SOW_MILESTONE',NULL,0),(6,0,'SECOND MILESTONE','SOW_MILESTONE',NULL,0),(7,0,'THIRD PAYMENT','SOW_MILESTONE',NULL,0),(8,0,'NEXT PAYABLE AMOUNT','SOW_MILESTONE',NULL,0),(9,0,'LAST PAYMENT AMOUNT','SOW_MILESTONE',NULL,0),(10,0,'FINAL MILESTONE','SOW_MILESTONE',NULL,0),(11,1,'DEFAULT STARTUP PHASE','DELIVERABLE_PHASE','This is default startup phase created for already existing published services to continue the process.',1);
/*!40000 ALTER TABLE `object_type` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `opportunity` WRITE;
/*!40000 ALTER TABLE `opportunity` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `opportunity_general_staging_log` WRITE;
/*!40000 ALTER TABLE `opportunity_general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity_general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `pending_mail` WRITE;
/*!40000 ALTER TABLE `pending_mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `pending_mail` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `portfolio` WRITE;
/*!40000 ALTER TABLE `portfolio` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `portfolio__user` WRITE;
/*!40000 ALTER TABLE `portfolio__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio__user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `pricelist` WRITE;
/*!40000 ALTER TABLE `pricelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `pricelist` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `product_pricelist` WRITE;
/*!40000 ALTER TABLE `product_pricelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_pricelist` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (1,0,'Administrator',NULL,'rlsar.valent2010@gmail.com',NULL,NULL,'2026-03-31 20:22:16.062000','2026-03-31 20:22:16.062000',1),(2,0,'Super Administrator',NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.229000','2026-03-31 20:22:16.229000',2),(3,0,'No Body',NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.344000','2026-03-31 20:22:16.344000',3),(4,0,'GM Americas',NULL,'gm.amer@example.com',NULL,NULL,'2026-03-31 20:22:16.470000','2026-03-31 20:22:16.470000',4),(5,0,'GM Europe',NULL,'gm.emea@example.com',NULL,NULL,'2026-03-31 20:22:16.633000','2026-03-31 20:22:16.633000',5),(6,0,'GM Asia Pacific',NULL,'gm.apac@example.com',NULL,NULL,'2026-03-31 20:22:16.731000','2026-03-31 20:22:16.731000',6);
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `project_parameter` WRITE;
/*!40000 ALTER TABLE `project_parameter` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_parameter` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `quota` WRITE;
/*!40000 ALTER TABLE `quota` DISABLE KEYS */;
/*!40000 ALTER TABLE `quota` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `quotation` WRITE;
/*!40000 ALTER TABLE `quotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `quotation_general_staging_log` WRITE;
/*!40000 ALTER TABLE `quotation_general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `quotation_milestone` WRITE;
/*!40000 ALTER TABLE `quotation_milestone` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_milestone` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `quotation_sow_discounts` WRITE;
/*!40000 ALTER TABLE `quotation_sow_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_sow_discounts` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `relation_delivery_geo` WRITE;
/*!40000 ALTER TABLE `relation_delivery_geo` DISABLE KEYS */;
/*!40000 ALTER TABLE `relation_delivery_geo` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `review_comment` WRITE;
/*!40000 ALTER TABLE `review_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_comment` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `review_request` WRITE;
/*!40000 ALTER TABLE `review_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_request` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `review_request__user` WRITE;
/*!40000 ALTER TABLE `review_request__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_request__user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,0,'ROLE_SYSTEM_ADMINISTRATOR','System Administrator','SYSTEM ADMINISTRATOR',_binary '\0','2026-03-31 20:22:15.923000','2026-03-31 20:22:15.923000'),(2,0,'ROLE_PORTFOLIO_MANAGER','Portfolio Manager','PORTFOLIO MANAGER',_binary '\0','2026-03-31 20:22:15.934000','2026-03-31 20:22:15.934000'),(3,0,'ROLE_PRODUCT_MANAGER','Product Manager','PRODUCT MANAGER',_binary '\0','2026-03-31 20:22:15.936000','2026-03-31 20:22:15.936000'),(4,0,'ROLE_SERVICE_DESIGNER','Service Designer','SERVICE DESIGNER',_binary '\0','2026-03-31 20:22:15.938000','2026-03-31 20:22:15.938000'),(5,0,'ROLE_SALES_PRESIDENT','Sales President','SALES PRESIDENT',_binary '\0','2026-03-31 20:22:15.940000','2026-03-31 20:22:15.940000'),(6,0,'ROLE_SALES_MANAGER','Sales Manager','SALES MANAGER',_binary '\0','2026-03-31 20:22:15.941000','2026-03-31 20:22:15.941000'),(7,0,'ROLE_SALES_PERSON','Sales Person','SALES PERSON',_binary '\0','2026-03-31 20:22:15.943000','2026-03-31 20:22:15.943000'),(8,0,'ROLE_DELIVERY_ROLE_MANAGER','Delivery Role Manager','DELIVERY ROLE MANAGER',_binary '\0','2026-03-31 20:22:15.945000','2026-03-31 20:22:15.945000'),(9,0,'ROLE_GENERAL_MANAGER','General Manager','GENERAL MANAGER',_binary '\0','2026-03-31 20:22:15.947000','2026-03-31 20:22:15.947000');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `salesforce_credentials` WRITE;
/*!40000 ALTER TABLE `salesforce_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `salesforce_credentials` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service__user` WRITE;
/*!40000 ALTER TABLE `service__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `service__user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_activity` WRITE;
/*!40000 ALTER TABLE `service_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_activity` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_activity_delivery_role` WRITE;
/*!40000 ALTER TABLE `service_activity_delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_activity_delivery_role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_activity_task` WRITE;
/*!40000 ALTER TABLE `service_activity_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_activity_task` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_deliverable` WRITE;
/*!40000 ALTER TABLE `service_deliverable` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_deliverable` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_portfolio` WRITE;
/*!40000 ALTER TABLE `service_portfolio` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_portfolio` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_product_item` WRITE;
/*!40000 ALTER TABLE `service_product_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_product_item` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_profile` WRITE;
/*!40000 ALTER TABLE `service_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_profile__user` WRITE;
/*!40000 ALTER TABLE `service_profile__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile__user` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_profile_delivery_role` WRITE;
/*!40000 ALTER TABLE `service_profile_delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile_delivery_role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_profile_metaphors` WRITE;
/*!40000 ALTER TABLE `service_profile_metaphors` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile_metaphors` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_profilesowdef` WRITE;
/*!40000 ALTER TABLE `service_profilesowdef` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profilesowdef` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_quotation` WRITE;
/*!40000 ALTER TABLE `service_quotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_quotation` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `service_quotation_ticket` WRITE;
/*!40000 ALTER TABLE `service_quotation_ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_quotation_ticket` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `setting` WRITE;
/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
INSERT INTO `setting` VALUES (1,0,'sowLabel',''),(2,0,'sowTemplate','<p> Use following tags to put place holder for dynamically generated contents. </p><ul><li> [@@sow_introduction_input@@] a placeholder where sales person can add introduction </li><li> [@@services@@] for print services details </li><li> [@@terms@@] for terms and conditions for given GEO </li><li> [@@billing_terms@@] for billing terms for given GEO </li><li> [@@signature_block@@] </li></ul>'),(3,0,'services','Currently This is disable.'),(4,0,'terms',''),(5,0,'billing_terms',''),(6,0,'signature_block','');
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `shipping_address` WRITE;
/*!40000 ALTER TABLE `shipping_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipping_address` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `solution_bundle` WRITE;
/*!40000 ALTER TABLE `solution_bundle` DISABLE KEYS */;
/*!40000 ALTER TABLE `solution_bundle` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `solution_bundle_service` WRITE;
/*!40000 ALTER TABLE `solution_bundle_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `solution_bundle_service` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sow_discount` WRITE;
/*!40000 ALTER TABLE `sow_discount` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_discount` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sow_introduction` WRITE;
/*!40000 ALTER TABLE `sow_introduction` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_introduction` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sow_support_parameter` WRITE;
/*!40000 ALTER TABLE `sow_support_parameter` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_support_parameter` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sow_tag` WRITE;
/*!40000 ALTER TABLE `sow_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_tag` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `staging` WRITE;
/*!40000 ALTER TABLE `staging` DISABLE KEYS */;
INSERT INTO `staging` VALUES (1,1,'SERVICE',1,'init','Initialization','Create service and assign product manager to define core requirements of service','NA',_binary ''),(2,2,'SERVICE',10,'concept','Conceptualization','<ul> <li> Add requirement data for service </li> <li> Then send request to review requirements for concept </li> </ul>','NA',_binary ''),(3,2,'SERVICE',11,'conceptreview','Concept Review','Review requirement data and approve if valid','SERVICE',_binary ''),(4,2,'SERVICE',12,'conceptapproved','Concept Approved','Concept is Approved, now assign service designer to define detailed activities and estimate time required','ADMIN',_binary ''),(5,2,'SERVICE',20,'design','Design','<ul> <li>Define detailed service activities and roles required for each activity </li> <li> Define estimate time and role required for each activity </li> <li> After design is done, send it for review request to product manager </li> </ul>','NA',_binary ''),(6,2,'SERVICE',21,'designreview','Design Review','Review design and approve if valid','SERVICE',_binary ''),(7,2,'SERVICE',22,'designapproved','Design Approved','Design is approved, now send Sale approval request','SERVICE',_binary ''),(8,2,'SERVICE',31,'salesreview','Sales Review','Review Sales related concern and approve if valid','SERVICE',_binary ''),(9,2,'SERVICE',32,'salesapproval','Sales Approval','Sales is approved so GEO admins will be notified to request to publish','LEGAL',_binary ''),(10,2,'SERVICE',41,'requestforpublished','Request to Publish','Request to Publish','SERVICE',_binary ''),(11,1,'SERVICE',42,'published','Published','Published','PORTFOLIO',_binary ''),(12,1,'SERVICE',43,'requesttoremove','Request to remove','Request to remove','SERVICE',_binary ''),(13,1,'SERVICE',100,'removed','Removed','Removed','PORTFOLIO',_binary ''),(14,1,'SERVICE',23,'inActive','Not Active','New Version of service is being upgraded','NA',_binary ''),(15,1,'SETUP',111,'welcome','Welcome','Welcome','NA',_binary ''),(16,1,'SETUP',112,'companyInfo','Company Information','Company Information','NA',_binary ''),(17,1,'SETUP',114,'addUsers','Add Users','Add Users','NA',_binary ''),(18,1,'SETUP',113,'geos','Create GEOs','Create GEOs','NA',_binary ''),(19,1,'SETUP',115,'deliveryRoles','Create DeliveryRoles','Create DeliveryRoles','NA',_binary ''),(20,1,'SETUP',116,'portfolios','Create Portfolios','Create Portfolios','NA',_binary ''),(21,1,'QUOTATION',1,'development','Development','In Development','NA',_binary ''),(22,1,'QUOTATION',2,'generated','Click to Generate','Click to Generate','NA',_binary ''),(23,1,'QUOTATION',3,'sent','Sent','Document Sent','NA',_binary ''),(24,1,'QUOTATION',4,'received','Customer Received','Customer Received','NA',_binary ''),(25,1,'QUOTATION',-1,'rejected','Rejected','Document Rejected','NA',_binary ''),(26,1,'QUOTATION',0,'closedAndNewOne','Closed And Created New One','Closed And Created New One','NA',_binary ''),(27,1,'QUOTATION',5,'Accepted','Accepted','Document Accepted','NA',_binary ''),(28,1,'LEAD',50,'uncontacted','Uncontacted','Create new Lead and add requirement fields.','NA',_binary ''),(29,1,'LEAD',51,'contactinprogress','Contact In Progress','Lead is contacted and in progress.','NA',_binary ''),(30,1,'LEAD',52,'converttoopportunity','Convert To Opportunity','Lead is converting to opportunity.','NA',_binary ''),(31,1,'LEAD',53,'converted','Converted','Lead is converted to opportunity.','NA',_binary ''),(32,1,'LEAD',54,'dead','Dead','Lead is dead.','NA',_binary ''),(33,1,'OPPORTUNITY',60,'prospecting','Prospecting','Prospecting Stage.','NA',_binary ''),(34,1,'OPPORTUNITY',61,'qualification','Qualification','Qualification Stage.','NA',_binary ''),(35,1,'OPPORTUNITY',62,'needAnalysis','Need Analysis','Need Analysis Stage.','NA',_binary ''),(36,6,'OPPORTUNITY',63,'valueProposition','Value Proposition','Value Proposition Stage.','NA',_binary '\0'),(37,6,'OPPORTUNITY',64,'decisionMakers','Decision Makers','Decision Makers Stage.','NA',_binary '\0'),(38,6,'OPPORTUNITY',65,'perceptionAnalysis','Perception Analysis','Perception Analysis Stage.','NA',_binary '\0'),(39,1,'OPPORTUNITY',66,'proposalPriceQuote','Proposal/Price Quote','Proposal/Price Quote Stage.','NA',_binary ''),(40,1,'OPPORTUNITY',67,'negotiationReview','Negotiation/Review','Negotiation/Review Stage.','NA',_binary ''),(41,1,'OPPORTUNITY',68,'closedWon','Closed Won','Closed Won Stage.','NA',_binary ''),(42,1,'OPPORTUNITY',69,'closedLost','Closed Lost','<ul> <li>Closed Lost Stage.</li> <li>Click To Break Opportunity.</li><ul>','NA',_binary ''),(43,1,'SERVICEQUOTATION',121,'new','New','New ServiceQuotation','NA',_binary ''),(44,1,'SERVICEQUOTATION',122,'active','Active','Active ServiceQuotation','NA',_binary ''),(45,1,'SERVICEQUOTATION',123,'edit','Edit','Edit ServiceQuotation','NA',_binary ''),(46,1,'SERVICEQUOTATION',124,'delete','Delete','Delete ServiceQuotation','NA',_binary '');
/*!40000 ALTER TABLE `staging` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `staging_authorized_role` WRITE;
/*!40000 ALTER TABLE `staging_authorized_role` DISABLE KEYS */;
INSERT INTO `staging_authorized_role` VALUES (1,2),(2,3),(3,2),(4,3),(5,4),(6,3),(7,3),(8,2),(9,2),(12,3),(13,2);
/*!40000 ALTER TABLE `staging_authorized_role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `staging_log` WRITE;
/*!40000 ALTER TABLE `staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `staging_log` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `staging_reviewer_role` WRITE;
/*!40000 ALTER TABLE `staging_reviewer_role` DISABLE KEYS */;
INSERT INTO `staging_reviewer_role` VALUES (6,4);
/*!40000 ALTER TABLE `staging_reviewer_role` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `staging_types` WRITE;
/*!40000 ALTER TABLE `staging_types` DISABLE KEYS */;
INSERT INTO `staging_types` VALUES (1,'BEGIN_NEW'),(1,'NEW_STAGE'),(2,'NEW_STAGE'),(3,'NEW_STAGE'),(3,'REVIEW_REQUEST'),(4,'NEW_STAGE'),(4,'APPROVAL'),(5,'NEW_STAGE'),(5,'BEGIN_EDIT'),(5,'EDIT_STAGE'),(6,'NEW_STAGE'),(6,'EDIT_STAGE'),(6,'REVIEW_REQUEST'),(7,'NEW_STAGE'),(7,'EDIT_STAGE'),(7,'APPROVAL'),(8,'REVIEW_REQUEST'),(8,'NEW_STAGE'),(8,'EDIT_STAGE'),(9,'NEW_STAGE'),(9,'EDIT_STAGE'),(9,'APPROVAL'),(10,'NEW_STAGE'),(10,'EDIT_STAGE'),(10,'REVIEW_REQUEST'),(11,'NEW_STAGE'),(11,'EDIT_STAGE'),(11,'END_NEW'),(11,'END_EDIT'),(12,'REMOVE_STAGE'),(12,'BEGIN_REMOVE'),(12,'REVIEW_REQUEST'),(13,'REMOVE_STAGE'),(13,'END_REMOVE'),(13,'APPROVAL'),(14,'INACTIVE'),(15,'NEW_STAGE'),(15,'BEGIN_NEW'),(16,'NEW_STAGE'),(16,'BEGIN_EDIT'),(16,'EDIT_STAGE'),(17,'NEW_STAGE'),(17,'BEGIN_EDIT'),(17,'EDIT_STAGE'),(18,'NEW_STAGE'),(18,'BEGIN_EDIT'),(18,'EDIT_STAGE'),(19,'NEW_STAGE'),(19,'BEGIN_EDIT'),(19,'EDIT_STAGE'),(20,'NEW_STAGE'),(20,'BEGIN_EDIT'),(20,'EDIT_STAGE'),(21,'EDIT_STAGE'),(21,'BEGIN_NEW'),(22,'EDIT_STAGE'),(23,'EDIT_STAGE'),(24,'EDIT_STAGE'),(25,'END_REMOVE'),(25,'REMOVE_STAGE'),(25,'EDIT_STAGE'),(26,'END_REMOVE'),(26,'REMOVE_STAGE'),(26,'EDIT_STAGE'),(27,'END_EDIT'),(27,'EDIT_STAGE'),(28,'NEW_STAGE'),(28,'BEGIN_NEW'),(29,'NEW_STAGE'),(29,'BEGIN_EDIT'),(29,'EDIT_STAGE'),(30,'NEW_STAGE'),(30,'BEGIN_EDIT'),(30,'EDIT_STAGE'),(31,'NEW_STAGE'),(31,'BEGIN_EDIT'),(31,'EDIT_STAGE'),(32,'NEW_STAGE'),(32,'REMOVE_STAGE'),(32,'END_REMOVE'),(33,'NEW_STAGE'),(33,'BEGIN_NEW'),(34,'NEW_STAGE'),(34,'BEGIN_EDIT'),(34,'EDIT_STAGE'),(35,'NEW_STAGE'),(35,'BEGIN_EDIT'),(35,'EDIT_STAGE'),(36,'NEW_STAGE'),(36,'BEGIN_EDIT'),(36,'EDIT_STAGE'),(37,'NEW_STAGE'),(37,'BEGIN_EDIT'),(37,'EDIT_STAGE'),(38,'NEW_STAGE'),(38,'BEGIN_EDIT'),(38,'EDIT_STAGE'),(39,'NEW_STAGE'),(39,'BEGIN_EDIT'),(39,'EDIT_STAGE'),(40,'NEW_STAGE'),(40,'BEGIN_EDIT'),(40,'EDIT_STAGE'),(41,'NEW_STAGE'),(41,'REMOVE_STAGE'),(41,'END_REMOVE'),(42,'NEW_STAGE'),(42,'REMOVE_STAGE'),(42,'END_REMOVE'),(43,'NEW_STAGE'),(43,'BEGIN_NEW'),(44,'NEW_STAGE'),(44,'BEGIN_EDIT'),(44,'EDIT_STAGE'),(45,'NEW_STAGE'),(45,'BEGIN_EDIT'),(45,'EDIT_STAGE'),(46,'NEW_STAGE'),(46,'END_REMOVE'),(46,'REMOVE_STAGE'),(46,'EDIT_STAGE');
/*!40000 ALTER TABLE `staging_types` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `sub_stages` WRITE;
/*!40000 ALTER TABLE `sub_stages` DISABLE KEYS */;
INSERT INTO `sub_stages` VALUES (1,0,1,'Review Service Info','showDetailedInfo',10),(2,0,2,'Approve publishing','approveRequest',10),(3,0,1,'Request Publish','request',9),(4,0,2,'Approve/Reject Sale','approveRequest',8),(5,0,1,'Review Service Info','showDetailedInfo',8),(6,0,1,'Request Sales Review','request',7),(7,0,3,'Approve/Reject Design','approveRequest',6),(8,0,2,'Edit SOW Language','editDefinition',6),(9,0,1,'Review Design','showDetailedInfo',6),(10,0,3,'Define Products','addProducts',5),(11,0,4,'Add Pre-requisites','addPrerequisites',5),(12,0,1,'Review Requirements','showInfo',5),(13,0,2,'Add Activities and Roles','addActivities',5),(14,0,7,'Request Design Review','request',5),(15,0,5,'Add Out of Scope','addOutOfScope',5),(16,0,6,'Preview','showDetailedInfo',5),(17,0,1,'Assign Designer','assignDesigner',4),(18,0,2,'Approve/Reject Concept','approveRequest',3),(19,0,1,'Review Requirements','showInfo',3),(20,0,2,'Add Service Deliverables','editDeliverables',2),(21,0,3,'Add SOW Language','editDefinition',2),(22,0,4,'Preview','showInfo',2),(23,0,1,'Add requirement data','edit',2),(24,0,5,'Request concept review','request',2);
/*!40000 ALTER TABLE `sub_stages` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `text_template` WRITE;
/*!40000 ALTER TABLE `text_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `text_template` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `ticket_planner` WRITE;
/*!40000 ALTER TABLE `ticket_planner` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_planner` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `time_stamp_saver_object` WRITE;
/*!40000 ALTER TABLE `time_stamp_saver_object` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_stamp_saver_object` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `update_record` WRITE;
/*!40000 ALTER TABLE `update_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `update_record` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `upload_file` WRITE;
/*!40000 ALTER TABLE `upload_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `upload_file` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,1),(2,1),(3,1),(1,2),(2,2),(3,2),(1,3),(2,3),(3,3),(1,4),(2,4),(3,4),(1,5),(2,5),(3,5),(1,6),(2,6),(3,6),(1,7),(2,7),(3,7),(1,8),(2,8),(3,8),(1,9),(2,9),(3,9),(4,9),(5,9),(6,9);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

