
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
DROP TABLE IF EXISTS `_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `enabled` bit(1) NOT NULL,
  `account_expired` bit(1) NOT NULL,
  `account_locked` bit(1) NOT NULL,
  `password_expired` bit(1) NOT NULL,
  `action_hash` varchar(255) DEFAULT NULL,
  `expiration` datetime(6) DEFAULT NULL,
  `remoteapi` bit(1) NOT NULL,
  `last_login_role` varchar(255) DEFAULT NULL,
  `primary_territory_id` bigint DEFAULT NULL,
  `territory_id` bigint DEFAULT NULL,
  `geo_group_id` bigint DEFAULT NULL,
  `supervisor_id` bigint DEFAULT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `date_modified` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_nlcolwbx8ujaen5h0u2kr2bn2` (`username`),
  KEY `FKdsd1rsjcm7w8tqr8agfd6n4u0` (`primary_territory_id`),
  KEY `FKgme6fr9hve1jkysjdcqqfplq0` (`territory_id`),
  KEY `FKo4owm5lx4ul0snm66fhc4tirg` (`geo_group_id`),
  KEY `FKf4p55d7bxhmoqleikl3t1wlpf` (`supervisor_id`),
  CONSTRAINT `FKdsd1rsjcm7w8tqr8agfd6n4u0` FOREIGN KEY (`primary_territory_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FKf4p55d7bxhmoqleikl3t1wlpf` FOREIGN KEY (`supervisor_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKgme6fr9hve1jkysjdcqqfplq0` FOREIGN KEY (`territory_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FKo4owm5lx4ul0snm66fhc4tirg` FOREIGN KEY (`geo_group_id`) REFERENCES `geo_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `_user` WRITE;
/*!40000 ALTER TABLE `_user` DISABLE KEYS */;
INSERT INTO `_user` VALUES (1,1,'admin','{bcrypt}$2a$10$m0CVZs.bN.rt.yczMmCiVuXpdPgdP8bjq4Hzvs49rMMqef5cGtBN2',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0','SYSTEM ADMINISTRATOR',NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.057000',NULL),(2,0,'superadmin','{bcrypt}$2a$10$VfTlnvUVYKSSKXUcnvoY8utmbAjvyfbdxWXR7vDU7ftoqgTXTztYi',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.228000',NULL),(3,0,'nobody','{bcrypt}$2a$10$/3THb6nHQtOiQe1S5iYNButhp3/ZGgqVf5j03ltDXVeFCv71I029S',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.343000',NULL),(4,1,'gm.amer','{bcrypt}$2a$10$BYJ5WlfIwiTx9nWdNVbeWe79EkWimCuQyXNUJUPyLDUMiSvnIAYQG',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,1,NULL,'2026-03-31 20:22:16.469000',NULL),(5,1,'gm.emea','{bcrypt}$2a$10$GThdiIDgtbsOCynv46aCjurotRwCfaAQk3uFZLAQ1yzIjYQiI.qfe',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,2,NULL,'2026-03-31 20:22:16.633000',NULL),(6,1,'gm.apac','{bcrypt}$2a$10$P5ILWO1Xn5se9ARliagtVeHM.cWfSXCIchpBUpDEoJ/k1GzFJ5Vve',_binary '',_binary '\0',_binary '\0',_binary '\0',NULL,NULL,_binary '\0',NULL,NULL,NULL,3,NULL,'2026-03-31 20:22:16.730000',NULL);
/*!40000 ALTER TABLE `_user` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `assign_to_id` bigint DEFAULT NULL,
  `logo_id` bigint DEFAULT NULL,
  `image_file_id` bigint DEFAULT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `billing_address_id` bigint DEFAULT NULL,
  `shipping_address_id` bigint DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `external_source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_jfarbv64d68y4tm9c9ms5fh7b` (`account_name`),
  KEY `FKt7h2s8dugj9q2bu9gpbam7v48` (`assign_to_id`),
  KEY `FKgq9jtubst5stfhsugs1jlel2h` (`logo_id`),
  KEY `FKc3c2ajggplpvm5at3ag0jbn14` (`image_file_id`),
  KEY `FK1c0ktrk0l62qnoehvrl7i6uys` (`created_by_id`),
  KEY `FKibve7gcre5dqxbhyr4mwtgia6` (`modified_by_id`),
  KEY `FKaddb3t7rd5iwkc2w5r5p1twpr` (`billing_address_id`),
  KEY `FK4c36gw4g8pj95ifeurb30egkd` (`shipping_address_id`),
  CONSTRAINT `FK1c0ktrk0l62qnoehvrl7i6uys` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK4c36gw4g8pj95ifeurb30egkd` FOREIGN KEY (`shipping_address_id`) REFERENCES `shipping_address` (`id`),
  CONSTRAINT `FKaddb3t7rd5iwkc2w5r5p1twpr` FOREIGN KEY (`billing_address_id`) REFERENCES `billing_address` (`id`),
  CONSTRAINT `FKc3c2ajggplpvm5at3ag0jbn14` FOREIGN KEY (`image_file_id`) REFERENCES `upload_file` (`id`),
  CONSTRAINT `FKgq9jtubst5stfhsugs1jlel2h` FOREIGN KEY (`logo_id`) REFERENCES `logo_image` (`id`),
  CONSTRAINT `FKibve7gcre5dqxbhyr4mwtgia6` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKt7h2s8dugj9q2bu9gpbam7v48` FOREIGN KEY (`assign_to_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `activity_role_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_role_time` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  `estimated_time_in_hours_per_base_units` decimal(19,2) NOT NULL,
  `estimated_time_in_hours_flat` decimal(19,2) NOT NULL,
  `service_activity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1h8x7fd3vhlhvv3brgprww9bp` (`role_id`),
  KEY `FKmpprwkw0t3qoli1w7o861fiht` (`service_activity_id`),
  CONSTRAINT `FK1h8x7fd3vhlhvv3brgprww9bp` FOREIGN KEY (`role_id`) REFERENCES `delivery_role` (`id`),
  CONSTRAINT `FKmpprwkw0t3qoli1w7o861fiht` FOREIGN KEY (`service_activity_id`) REFERENCES `service_activity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `activity_role_time` WRITE;
/*!40000 ALTER TABLE `activity_role_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_role_time` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `billing_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_address` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `bill_address_line1` varchar(255) DEFAULT NULL,
  `bill_address_line2` varchar(255) DEFAULT NULL,
  `bill_city` varchar(255) DEFAULT NULL,
  `bill_state` varchar(255) DEFAULT NULL,
  `bill_postalcode` varchar(255) DEFAULT NULL,
  `bill_country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `billing_address` WRITE;
/*!40000 ALTER TABLE `billing_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing_address` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `clarizen_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clarizen_credentials` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `instance_uri` varchar(255) DEFAULT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcnyjop0ra77dkqokblyjtx7v6` (`created_by_id`),
  KEY `FKhereowll7icax26oxdrn7lg43` (`modified_by_id`),
  CONSTRAINT `FKcnyjop0ra77dkqokblyjtx7v6` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKhereowll7icax26oxdrn7lg43` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `clarizen_credentials` WRITE;
/*!40000 ALTER TABLE `clarizen_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `clarizen_credentials` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `company_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_information` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `logo_id` bigint DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `smtpserver` varchar(255) DEFAULT NULL,
  `from_email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `date_modified` datetime(6) DEFAULT NULL,
  `shipping_address_id` bigint DEFAULT NULL,
  `base_currency` varchar(255) NOT NULL,
  `base_currency_symbol` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKe38madjxofc0li1ceoxhj9gb5` (`logo_id`),
  KEY `FKo3vm6x4lv4nfwf0aovpu5mx2m` (`shipping_address_id`),
  CONSTRAINT `FKe38madjxofc0li1ceoxhj9gb5` FOREIGN KEY (`logo_id`) REFERENCES `logo_image` (`id`),
  CONSTRAINT `FKo3vm6x4lv4nfwf0aovpu5mx2m` FOREIGN KEY (`shipping_address_id`) REFERENCES `shipping_address` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `company_information` WRITE;
/*!40000 ALTER TABLE `company_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_information` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `connectwise_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `connectwise_credentials` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `site_url` varchar(255) NOT NULL,
  `company_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  `update_hours` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8hudr275yfrah41rgjsi09kke` (`created_by_id`),
  KEY `FKpjx4tlxqyi4svwh6128bdnspl` (`modified_by_id`),
  CONSTRAINT `FK8hudr275yfrah41rgjsi09kke` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKpjx4tlxqyi4svwh6128bdnspl` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `connectwise_credentials` WRITE;
/*!40000 ALTER TABLE `connectwise_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `connectwise_credentials` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `assign_to_id` bigint DEFAULT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `department` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `alt_email` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `created_by_id` bigint NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `billing_address_id` bigint DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `iso` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `external_id` varchar(255) DEFAULT NULL,
  `external_source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5q36f7trp9gxgyfefb4pjd0wm` (`assign_to_id`),
  KEY `FKjnowqyoxcuc461tey50dm4i4t` (`created_by_id`),
  KEY `FK64vqfmlg216vj0tw2pgr5cwb8` (`modified_by_id`),
  KEY `FK5sbq1ovd3iqpiwymsswagdxv7` (`billing_address_id`),
  KEY `FK3ctagodg5h629t8ltnam39l5w` (`account_id`),
  CONSTRAINT `FK3ctagodg5h629t8ltnam39l5w` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`),
  CONSTRAINT `FK5q36f7trp9gxgyfefb4pjd0wm` FOREIGN KEY (`assign_to_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK5sbq1ovd3iqpiwymsswagdxv7` FOREIGN KEY (`billing_address_id`) REFERENCES `billing_address` (`id`),
  CONSTRAINT `FK64vqfmlg216vj0tw2pgr5cwb8` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKjnowqyoxcuc461tey50dm4i4t` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `contact_billing_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_billing_address` (
  `contact_address_id` bigint NOT NULL,
  `billing_address_id` bigint DEFAULT NULL,
  KEY `FKhj8c4sc077o2i2hb6vt6yg43d` (`billing_address_id`),
  KEY `FKob2a8wojatb3r3o51xrofbk1r` (`contact_address_id`),
  CONSTRAINT `FKhj8c4sc077o2i2hb6vt6yg43d` FOREIGN KEY (`billing_address_id`) REFERENCES `billing_address` (`id`),
  CONSTRAINT `FKob2a8wojatb3r3o51xrofbk1r` FOREIGN KEY (`contact_address_id`) REFERENCES `contact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `contact_billing_address` WRITE;
/*!40000 ALTER TABLE `contact_billing_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_billing_address` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `contact_quotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_quotation` (
  `contact_quotation_id` bigint NOT NULL,
  `quotation_id` bigint DEFAULT NULL,
  KEY `FKk56i0qcx8dktd6kqkgy0u8jpr` (`quotation_id`),
  KEY `FKed0ayje5uegn6tjb6wklgn20d` (`contact_quotation_id`),
  CONSTRAINT `FKed0ayje5uegn6tjb6wklgn20d` FOREIGN KEY (`contact_quotation_id`) REFERENCES `contact` (`id`),
  CONSTRAINT `FKk56i0qcx8dktd6kqkgy0u8jpr` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `contact_quotation` WRITE;
/*!40000 ALTER TABLE `contact_quotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_quotation` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `correction_in_activity_role_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `correction_in_activity_role_time` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  `extra_hours` decimal(19,2) DEFAULT NULL,
  `original_hours` decimal(19,2) DEFAULT NULL,
  `service_activity_id` bigint DEFAULT NULL,
  `service_quotation_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2ijg5w1lbq6x623dsj5jrmdik` (`role_id`),
  KEY `FKkbt8kpd0kmjb2dnrw88gtqkp7` (`service_activity_id`),
  KEY `FKj35dffm0dclr507almxgbfupa` (`service_quotation_id`),
  CONSTRAINT `FK2ijg5w1lbq6x623dsj5jrmdik` FOREIGN KEY (`role_id`) REFERENCES `delivery_role` (`id`),
  CONSTRAINT `FKj35dffm0dclr507almxgbfupa` FOREIGN KEY (`service_quotation_id`) REFERENCES `service_quotation` (`id`),
  CONSTRAINT `FKkbt8kpd0kmjb2dnrw88gtqkp7` FOREIGN KEY (`service_activity_id`) REFERENCES `service_activity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `correction_in_activity_role_time` WRITE;
/*!40000 ALTER TABLE `correction_in_activity_role_time` DISABLE KEYS */;
/*!40000 ALTER TABLE `correction_in_activity_role_time` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `delivery_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `delivery_role` WRITE;
/*!40000 ALTER TABLE `delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_role` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `description` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `description` WRITE;
/*!40000 ALTER TABLE `description` DISABLE KEYS */;
/*!40000 ALTER TABLE `description` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `document_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_template` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `document_name` varchar(255) DEFAULT NULL,
  `document_file_id` bigint DEFAULT NULL,
  `is_default` bit(1) DEFAULT NULL,
  `territory_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKajqg32ugosenhxk1daqc5obfx` (`document_file_id`),
  KEY `FK8jv32o0kpwbvmqmvenev7iqgw` (`territory_id`),
  CONSTRAINT `FK8jv32o0kpwbvmqmvenev7iqgw` FOREIGN KEY (`territory_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FKajqg32ugosenhxk1daqc5obfx` FOREIGN KEY (`document_file_id`) REFERENCES `upload_file` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `document_template` WRITE;
/*!40000 ALTER TABLE `document_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `document_template` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `email_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_setting` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `secret` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `email_setting` WRITE;
/*!40000 ALTER TABLE `email_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_setting` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `extra_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `extra_unit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `unit_of_sale` varchar(255) NOT NULL,
  `extra_unit` int NOT NULL,
  `short_name` varchar(255) DEFAULT NULL,
  `service_profile_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKc5iwt5yqh0p045caaf6xl9ndc` (`service_profile_id`),
  CONSTRAINT `FKc5iwt5yqh0p045caaf6xl9ndc` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `extra_unit` WRITE;
/*!40000 ALTER TABLE `extra_unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `extra_unit` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `field_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `field_mapping` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `field_mapping` WRITE;
/*!40000 ALTER TABLE `field_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `field_mapping` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `general_staging_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_staging_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `action` varchar(255) NOT NULL,
  `from_stage_id` bigint DEFAULT NULL,
  `to_stage_id` bigint DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `modified_by` varchar(255) NOT NULL,
  `revision` int NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKbjmga27kajqj91xlq60lhm09c` (`from_stage_id`),
  KEY `FK6vhci2p0058fp92n8l0e77sk` (`to_stage_id`),
  CONSTRAINT `FK6vhci2p0058fp92n8l0e77sk` FOREIGN KEY (`to_stage_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKbjmga27kajqj91xlq60lhm09c` FOREIGN KEY (`from_stage_id`) REFERENCES `staging` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `general_staging_log` WRITE;
/*!40000 ALTER TABLE `general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `geo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date_format` varchar(255) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `currency_symbol` varchar(255) DEFAULT NULL,
  `tax_percent` decimal(19,2) NOT NULL,
  `terms` longtext,
  `billing_terms` longtext,
  `signature_block` longtext,
  `sow_template` longtext,
  `sow_label` varchar(255) DEFAULT NULL,
  `sales_manager_id` bigint DEFAULT NULL,
  `sow_file_id` bigint DEFAULT NULL,
  `country` longtext,
  `is_external` varchar(255) DEFAULT NULL,
  `convert_rate` decimal(19,2) NOT NULL,
  `geo_group_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6old14e6dp1q8jklvx3bb3c9q` (`sales_manager_id`),
  KEY `FKolxt95xya0r2yg40pregvfifo` (`sow_file_id`),
  KEY `FK7moy960lk33c6wfxny660bcr8` (`geo_group_id`),
  CONSTRAINT `FK6old14e6dp1q8jklvx3bb3c9q` FOREIGN KEY (`sales_manager_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK7moy960lk33c6wfxny660bcr8` FOREIGN KEY (`geo_group_id`) REFERENCES `geo_group` (`id`),
  CONSTRAINT `FKolxt95xya0r2yg40pregvfifo` FOREIGN KEY (`sow_file_id`) REFERENCES `upload_file` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `geo` WRITE;
/*!40000 ALTER TABLE `geo` DISABLE KEYS */;
/*!40000 ALTER TABLE `geo` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `geo_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_group` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `geo_group` WRITE;
/*!40000 ALTER TABLE `geo_group` DISABLE KEYS */;
INSERT INTO `geo_group` VALUES (1,0,'AMER',NULL),(2,0,'EMEA',NULL),(3,0,'APAC',NULL);
/*!40000 ALTER TABLE `geo_group` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `geo_sow_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_sow_discounts` (
  `geo_id` bigint NOT NULL,
  `sow_discount_id` bigint NOT NULL,
  PRIMARY KEY (`geo_id`,`sow_discount_id`),
  KEY `FKatqq9woidsh234ew1m7mx8rye` (`sow_discount_id`),
  CONSTRAINT `FKatqq9woidsh234ew1m7mx8rye` FOREIGN KEY (`sow_discount_id`) REFERENCES `sow_discount` (`id`),
  CONSTRAINT `FKllib5kx02ix4o9jnicwpapldm` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `geo_sow_discounts` WRITE;
/*!40000 ALTER TABLE `geo_sow_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `geo_sow_discounts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `internal_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internal_map` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `type` varchar(255) NOT NULL,
  `internal_key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `internal_map` WRITE;
/*!40000 ALTER TABLE `internal_map` DISABLE KEYS */;
INSERT INTO `internal_map` VALUES (1,0,'bootstrap','revision','1');
/*!40000 ALTER TABLE `internal_map` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `lead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `assign_to_id` bigint DEFAULT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `alt_email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) NOT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `iso` varchar(255) DEFAULT NULL,
  `format` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `created_by_id` bigint NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `billing_address_id` bigint DEFAULT NULL,
  `contact_id` bigint DEFAULT NULL,
  `staging_status_id` bigint DEFAULT NULL,
  `current_step` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKg6etcyn4tpwquaorx7sm2qlhk` (`assign_to_id`),
  KEY `FKfxjdnlirnosw736erapgp6wql` (`created_by_id`),
  KEY `FK35tm4t3at8vgi56x44iq00xnj` (`modified_by_id`),
  KEY `FKp13p3tbjuqw1y5v4qlkyjl4po` (`billing_address_id`),
  KEY `FK2j9aik1br9klt17cmgbubp9e1` (`contact_id`),
  KEY `FK4go68big4c4idbdok0iwecg4c` (`staging_status_id`),
  CONSTRAINT `FK2j9aik1br9klt17cmgbubp9e1` FOREIGN KEY (`contact_id`) REFERENCES `contact` (`id`),
  CONSTRAINT `FK35tm4t3at8vgi56x44iq00xnj` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK4go68big4c4idbdok0iwecg4c` FOREIGN KEY (`staging_status_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKfxjdnlirnosw736erapgp6wql` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKg6etcyn4tpwquaorx7sm2qlhk` FOREIGN KEY (`assign_to_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKp13p3tbjuqw1y5v4qlkyjl4po` FOREIGN KEY (`billing_address_id`) REFERENCES `billing_address` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `lead` WRITE;
/*!40000 ALTER TABLE `lead` DISABLE KEYS */;
/*!40000 ALTER TABLE `lead` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `lead_general_staging_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lead_general_staging_log` (
  `lead_general_staging_logs_id` bigint NOT NULL,
  `general_staging_log_id` bigint DEFAULT NULL,
  KEY `FKelo2aw8wmmdl84ke1klfr856w` (`general_staging_log_id`),
  KEY `FKrntheu6rqul2wsd3lmx8nvxyi` (`lead_general_staging_logs_id`),
  CONSTRAINT `FKelo2aw8wmmdl84ke1klfr856w` FOREIGN KEY (`general_staging_log_id`) REFERENCES `general_staging_log` (`id`),
  CONSTRAINT `FKrntheu6rqul2wsd3lmx8nvxyi` FOREIGN KEY (`lead_general_staging_logs_id`) REFERENCES `lead` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `lead_general_staging_log` WRITE;
/*!40000 ALTER TABLE `lead_general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `lead_general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `login_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `remote_addr` varchar(255) NOT NULL,
  `remote_host` varchar(255) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `last_updated` datetime(6) DEFAULT NULL,
  `owner_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjj0fb4t24xipdbndx05j80lti` (`owner_id`),
  CONSTRAINT `FKjj0fb4t24xipdbndx05j80lti` FOREIGN KEY (`owner_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `login_record` WRITE;
/*!40000 ALTER TABLE `login_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_record` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `logo_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logo_image` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `image` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `logo_image` WRITE;
/*!40000 ALTER TABLE `logo_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `logo_image` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `note` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_by_id` bigint NOT NULL,
  `modified_by_id` bigint NOT NULL,
  `created_date` datetime(6) NOT NULL,
  `modified_date` datetime(6) NOT NULL,
  `opportunity_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK2t1lq0t6hnukun5v5r5fcehfr` (`created_by_id`),
  KEY `FK3fja7gdchsslkp03nsq1d4jd9` (`modified_by_id`),
  KEY `FKdtgeoagm5wnw5am4diwilnvgy` (`opportunity_id`),
  CONSTRAINT `FK2t1lq0t6hnukun5v5r5fcehfr` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK3fja7gdchsslkp03nsq1d4jd9` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKdtgeoagm5wnw5am4diwilnvgy` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `note` WRITE;
/*!40000 ALTER TABLE `note` DISABLE KEYS */;
/*!40000 ALTER TABLE `note` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `message` varchar(255) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `active` bit(1) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `review_request_id` bigint DEFAULT NULL,
  `object_type` varchar(255) DEFAULT NULL,
  `object_id` bigint NOT NULL,
  `created_by_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKifwukkimmgdrt2qjvpmsmci9n` (`review_request_id`),
  KEY `FK5of19hh0xu63hajx0kre6jr0m` (`created_by_id`),
  CONSTRAINT `FK5of19hh0xu63hajx0kre6jr0m` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKifwukkimmgdrt2qjvpmsmci9n` FOREIGN KEY (`review_request_id`) REFERENCES `review_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `notification__user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification__user` (
  `notification_receiver_users_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  KEY `FKdtjom4019xwkb1juwfsef0e49` (`user_id`),
  KEY `FKg9ry0tiwb8qaj3n8ugxk689fo` (`notification_receiver_users_id`),
  CONSTRAINT `FKdtjom4019xwkb1juwfsef0e49` FOREIGN KEY (`user_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKg9ry0tiwb8qaj3n8ugxk689fo` FOREIGN KEY (`notification_receiver_users_id`) REFERENCES `notification` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notification__user` WRITE;
/*!40000 ALTER TABLE `notification__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification__user` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `notification_receiver_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_receiver_groups` (
  `notification_id` bigint NOT NULL,
  `role_id` varchar(255) DEFAULT NULL,
  KEY `FKcqp1fv4p9o16y6o3rivlhip64` (`notification_id`),
  CONSTRAINT `FKcqp1fv4p9o16y6o3rivlhip64` FOREIGN KEY (`notification_id`) REFERENCES `notification` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notification_receiver_groups` WRITE;
/*!40000 ALTER TABLE `notification_receiver_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_receiver_groups` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `object_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `object_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` longtext NOT NULL,
  `type` varchar(255) NOT NULL,
  `description` longtext,
  `sequence_order` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `object_type` WRITE;
/*!40000 ALTER TABLE `object_type` DISABLE KEYS */;
INSERT INTO `object_type` VALUES (1,1,'INSTALL','SERVICE_DELIVERABLE',NULL,0),(2,1,'TRAINING','SERVICE_DELIVERABLE',NULL,0),(3,1,'INSTALL','SERVICE_ACTIVITY',NULL,0),(4,1,'TRAINING','SERVICE_ACTIVITY',NULL,0),(5,0,'INITIAL PAYMENT','SOW_MILESTONE',NULL,0),(6,0,'SECOND MILESTONE','SOW_MILESTONE',NULL,0),(7,0,'THIRD PAYMENT','SOW_MILESTONE',NULL,0),(8,0,'NEXT PAYABLE AMOUNT','SOW_MILESTONE',NULL,0),(9,0,'LAST PAYMENT AMOUNT','SOW_MILESTONE',NULL,0),(10,0,'FINAL MILESTONE','SOW_MILESTONE',NULL,0),(11,1,'DEFAULT STARTUP PHASE','DELIVERABLE_PHASE','This is default startup phase created for already existing published services to continue the process.',1);
/*!40000 ALTER TABLE `object_type` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `opportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opportunity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `assign_to_id` bigint DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `probability` int DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `discount` int DEFAULT NULL,
  `close_date` datetime(6) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `created_by_id` bigint NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `account_id` bigint DEFAULT NULL,
  `geo_id` bigint DEFAULT NULL,
  `staging_status_id` bigint DEFAULT NULL,
  `current_step` int NOT NULL,
  `primary_contact_id` bigint DEFAULT NULL,
  `notes` longtext,
  `external_id` varchar(255) DEFAULT NULL,
  `external_source` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpdq320jxpewu7tauictjf5fb` (`assign_to_id`),
  KEY `FKal1qby3346qp0bulq18giuo11` (`created_by_id`),
  KEY `FKo7f2asw75xn6bsuggyfq0ywmn` (`modified_by_id`),
  KEY `FK9mvhqgny93la8u8k2gd531nex` (`account_id`),
  KEY `FKtfarx5px9ddoidqctpnx4a9c3` (`geo_id`),
  KEY `FKabofe6exhw4b976scsysgjgng` (`staging_status_id`),
  KEY `FK97fqxdmpfnjyhex00q15e0uyu` (`primary_contact_id`),
  CONSTRAINT `FK97fqxdmpfnjyhex00q15e0uyu` FOREIGN KEY (`primary_contact_id`) REFERENCES `contact` (`id`),
  CONSTRAINT `FK9mvhqgny93la8u8k2gd531nex` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`),
  CONSTRAINT `FKabofe6exhw4b976scsysgjgng` FOREIGN KEY (`staging_status_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKal1qby3346qp0bulq18giuo11` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKo7f2asw75xn6bsuggyfq0ywmn` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKpdq320jxpewu7tauictjf5fb` FOREIGN KEY (`assign_to_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKtfarx5px9ddoidqctpnx4a9c3` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `opportunity` WRITE;
/*!40000 ALTER TABLE `opportunity` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `opportunity_general_staging_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opportunity_general_staging_log` (
  `opportunity_general_staging_logs_id` bigint NOT NULL,
  `general_staging_log_id` bigint DEFAULT NULL,
  KEY `FK8ht1qqtvbt2vvw4ryho2fm7jh` (`general_staging_log_id`),
  KEY `FKbjspdfmutxhxckcdbt90qcpub` (`opportunity_general_staging_logs_id`),
  CONSTRAINT `FK8ht1qqtvbt2vvw4ryho2fm7jh` FOREIGN KEY (`general_staging_log_id`) REFERENCES `general_staging_log` (`id`),
  CONSTRAINT `FKbjspdfmutxhxckcdbt90qcpub` FOREIGN KEY (`opportunity_general_staging_logs_id`) REFERENCES `opportunity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `opportunity_general_staging_log` WRITE;
/*!40000 ALTER TABLE `opportunity_general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity_general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `pending_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pending_mail` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `email_id` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `create_date` datetime(6) NOT NULL,
  `active` bit(1) NOT NULL,
  `active_bit` int NOT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pending_mail` WRITE;
/*!40000 ALTER TABLE `pending_mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `pending_mail` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `portfolio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `portfolio_name` varchar(255) NOT NULL,
  `description` longtext,
  `date_modified` datetime(6) NOT NULL,
  `staging_status` varchar(255) NOT NULL,
  `portfolio_manager_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKgpisrcbl3pquinxo5qbifs45l` (`portfolio_manager_id`),
  CONSTRAINT `FKgpisrcbl3pquinxo5qbifs45l` FOREIGN KEY (`portfolio_manager_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `portfolio` WRITE;
/*!40000 ALTER TABLE `portfolio` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `portfolio__user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portfolio__user` (
  `portfolio_designers_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `portfolio_other_portfolio_managers_id` bigint NOT NULL,
  KEY `FK9gc4y7j918voswqiile3gg33g` (`user_id`),
  KEY `FK3unue48xaopt9xjjch0w7b8bp` (`portfolio_designers_id`),
  KEY `FKbbv402t1wej0g7l4xqyymdh0u` (`portfolio_other_portfolio_managers_id`),
  CONSTRAINT `FK3unue48xaopt9xjjch0w7b8bp` FOREIGN KEY (`portfolio_designers_id`) REFERENCES `portfolio` (`id`),
  CONSTRAINT `FK9gc4y7j918voswqiile3gg33g` FOREIGN KEY (`user_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKbbv402t1wej0g7l4xqyymdh0u` FOREIGN KEY (`portfolio_other_portfolio_managers_id`) REFERENCES `portfolio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `portfolio__user` WRITE;
/*!40000 ALTER TABLE `portfolio__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio__user` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `pricelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pricelist` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `service_profile_id` bigint NOT NULL,
  `geo_id` bigint NOT NULL,
  `base_price` decimal(19,2) NOT NULL,
  `additional_price` decimal(19,2) NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `is_temporary` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKhnl8vdej27gd5ot5xxjeqiv8h` (`service_profile_id`),
  KEY `FK63uxk7f1ubqtl3lu9glbiwqu3` (`geo_id`),
  KEY `FK9ghw3yuyd4vmh75qum7c7d2ms` (`modified_by_id`),
  CONSTRAINT `FK63uxk7f1ubqtl3lu9glbiwqu3` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FK9ghw3yuyd4vmh75qum7c7d2ms` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKhnl8vdej27gd5ot5xxjeqiv8h` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pricelist` WRITE;
/*!40000 ALTER TABLE `pricelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `pricelist` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `product_id` varchar(255) DEFAULT NULL,
  `unit_of_sale` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `date_published` datetime(6) DEFAULT NULL,
  `date_modified` datetime(6) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `product_pricelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_pricelist` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `geo_id` bigint NOT NULL,
  `unit_price` decimal(19,2) NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKq8mp6rd7faepexeqvcld2csj0` (`geo_id`),
  KEY `FKcfjuf9u0l0bpqbdwu08vtgxoe` (`modified_by_id`),
  KEY `FKg1qcb4h72yk6vnrojaiuhmkxv` (`product_id`),
  CONSTRAINT `FKcfjuf9u0l0bpqbdwu08vtgxoe` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKg1qcb4h72yk6vnrojaiuhmkxv` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKq8mp6rd7faepexeqvcld2csj0` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `product_pricelist` WRITE;
/*!40000 ALTER TABLE `product_pricelist` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_pricelist` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `nick_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `last_updated` datetime(6) DEFAULT NULL,
  `owner_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_9d5dpsf2ufa6rjbi3y0elkdcd` (`email`),
  KEY `FKana1hy6piii6uawnrm7nqy8va` (`owner_id`),
  CONSTRAINT `FKana1hy6piii6uawnrm7nqy8va` FOREIGN KEY (`owner_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (1,0,'Administrator',NULL,'rlsar.valent2010@gmail.com',NULL,NULL,'2026-03-31 20:22:16.062000','2026-03-31 20:22:16.062000',1),(2,0,'Super Administrator',NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.229000','2026-03-31 20:22:16.229000',2),(3,0,'No Body',NULL,NULL,NULL,NULL,'2026-03-31 20:22:16.344000','2026-03-31 20:22:16.344000',3),(4,0,'GM Americas',NULL,'gm.amer@example.com',NULL,NULL,'2026-03-31 20:22:16.470000','2026-03-31 20:22:16.470000',4),(5,0,'GM Europe',NULL,'gm.emea@example.com',NULL,NULL,'2026-03-31 20:22:16.633000','2026-03-31 20:22:16.633000',5),(6,0,'GM Asia Pacific',NULL,'gm.apac@example.com',NULL,NULL,'2026-03-31 20:22:16.731000','2026-03-31 20:22:16.731000',6);
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `project_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_parameter` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `value` longtext NOT NULL,
  `sequence_order` int DEFAULT NULL,
  `quotation_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKihkgvkf4rn9lp2s372tgmbdgj` (`quotation_id`),
  CONSTRAINT `FKihkgvkf4rn9lp2s372tgmbdgj` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `project_parameter` WRITE;
/*!40000 ALTER TABLE `project_parameter` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_parameter` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quota` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `amount` decimal(19,2) DEFAULT NULL,
  `timespan` varchar(255) DEFAULT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `territory_id` bigint DEFAULT NULL,
  `from_date` datetime(6) DEFAULT NULL,
  `to_date` datetime(6) DEFAULT NULL,
  `person_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK79xnjpesgnmpjljtnmcfnkudu` (`created_by_id`),
  KEY `FKdnf4hmy433jf3ico4ivme9a4b` (`territory_id`),
  KEY `FKtrj3jiec3lfdbfhhaf04g58xb` (`person_id`),
  CONSTRAINT `FK79xnjpesgnmpjljtnmcfnkudu` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKdnf4hmy433jf3ico4ivme9a4b` FOREIGN KEY (`territory_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FKtrj3jiec3lfdbfhhaf04g58xb` FOREIGN KEY (`person_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `quota` WRITE;
/*!40000 ALTER TABLE `quota` DISABLE KEYS */;
/*!40000 ALTER TABLE `quota` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `quotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `created_by_id` bigint NOT NULL,
  `account_id` bigint NOT NULL,
  `customer_type` varchar(255) DEFAULT NULL,
  `created_date` datetime(6) NOT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `status_change_date` datetime(6) NOT NULL,
  `status_id` bigint NOT NULL,
  `contract_status_id` bigint NOT NULL,
  `geo_id` bigint DEFAULT NULL,
  `total_quoted_price` decimal(19,2) NOT NULL,
  `request_level1` bit(1) NOT NULL,
  `request_level2` bit(1) NOT NULL,
  `request_level3` bit(1) NOT NULL,
  `flat_discount` bit(1) NOT NULL,
  `forecast_value` decimal(19,2) NOT NULL,
  `discount_percent` decimal(19,2) NOT NULL,
  `discount_amount` decimal(19,2) NOT NULL,
  `tax_percent` decimal(19,2) NOT NULL,
  `tax_amount` decimal(19,2) NOT NULL,
  `final_price` decimal(19,2) NOT NULL,
  `validity_in_days` int NOT NULL,
  `template_text` varchar(255) NOT NULL,
  `billing_text` varchar(255) NOT NULL,
  `discount_from` decimal(19,2) DEFAULT NULL,
  `discount_to` decimal(19,2) DEFAULT NULL,
  `current_review_request_id` bigint DEFAULT NULL,
  `confidence_percentage` decimal(19,2) NOT NULL,
  `local_discount` decimal(19,2) DEFAULT NULL,
  `local_discount_description` longtext,
  `expense_amount` decimal(19,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_light` bit(1) DEFAULT NULL,
  `sow_introduction_setting_id` bigint DEFAULT NULL,
  `sow_start_date` datetime(6) DEFAULT NULL,
  `sow_end_date` datetime(6) DEFAULT NULL,
  `sow_document_template_id` bigint DEFAULT NULL,
  `convert_to_ticket` varchar(255) DEFAULT NULL,
  `is_corrected` varchar(255) DEFAULT NULL,
  `opportunity_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKivb674h3ldni7e6dc8ogctv1q` (`created_by_id`),
  KEY `FK7vajsuhk5172qvlu7p6ip9jlm` (`account_id`),
  KEY `FKqxiwj2d0ot74is3w5439wiwqr` (`status_id`),
  KEY `FKa3rj0npqkbx0vvp6h5xmhuyx6` (`contract_status_id`),
  KEY `FK16p7svtr7shrawp8y9y5ipkyv` (`geo_id`),
  KEY `FKjso6mq4gle3frk6bjo3hx6cor` (`current_review_request_id`),
  KEY `FKjxhsbm4rqrar97tvjatm8d22r` (`sow_introduction_setting_id`),
  KEY `FKrv0v4il34lgk4gpume2a5p3f5` (`sow_document_template_id`),
  KEY `FKlvqc2b9fruqvgmrbk9ro0rrwn` (`opportunity_id`),
  CONSTRAINT `FK16p7svtr7shrawp8y9y5ipkyv` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FK7vajsuhk5172qvlu7p6ip9jlm` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`),
  CONSTRAINT `FKa3rj0npqkbx0vvp6h5xmhuyx6` FOREIGN KEY (`contract_status_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKivb674h3ldni7e6dc8ogctv1q` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKjso6mq4gle3frk6bjo3hx6cor` FOREIGN KEY (`current_review_request_id`) REFERENCES `review_request` (`id`),
  CONSTRAINT `FKjxhsbm4rqrar97tvjatm8d22r` FOREIGN KEY (`sow_introduction_setting_id`) REFERENCES `setting` (`id`),
  CONSTRAINT `FKlvqc2b9fruqvgmrbk9ro0rrwn` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity` (`id`),
  CONSTRAINT `FKqxiwj2d0ot74is3w5439wiwqr` FOREIGN KEY (`status_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKrv0v4il34lgk4gpume2a5p3f5` FOREIGN KEY (`sow_document_template_id`) REFERENCES `document_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `quotation` WRITE;
/*!40000 ALTER TABLE `quotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `quotation_general_staging_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_general_staging_log` (
  `quotation_general_staging_logs_id` bigint NOT NULL,
  `general_staging_log_id` bigint DEFAULT NULL,
  KEY `FK729w7slti4rnmf8a79t679t1i` (`general_staging_log_id`),
  KEY `FK61lokl6i7aivs6o11mya30i9a` (`quotation_general_staging_logs_id`),
  CONSTRAINT `FK61lokl6i7aivs6o11mya30i9a` FOREIGN KEY (`quotation_general_staging_logs_id`) REFERENCES `quotation` (`id`),
  CONSTRAINT `FK729w7slti4rnmf8a79t679t1i` FOREIGN KEY (`general_staging_log_id`) REFERENCES `general_staging_log` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `quotation_general_staging_log` WRITE;
/*!40000 ALTER TABLE `quotation_general_staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_general_staging_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `quotation_milestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_milestone` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `milestone` varchar(255) DEFAULT NULL,
  `amount` decimal(19,2) NOT NULL,
  `percentage` decimal(19,2) DEFAULT NULL,
  `quotation_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKgwondminja318scomifx2waim` (`quotation_id`),
  CONSTRAINT `FKgwondminja318scomifx2waim` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `quotation_milestone` WRITE;
/*!40000 ALTER TABLE `quotation_milestone` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_milestone` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `quotation_sow_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_sow_discounts` (
  `quotation_id` bigint NOT NULL,
  `sow_discount_id` bigint NOT NULL,
  PRIMARY KEY (`quotation_id`,`sow_discount_id`),
  KEY `FKr5x6jf2wm5jrjgtb0cj1k5d0g` (`sow_discount_id`),
  CONSTRAINT `FK841duionrmaoqmcw16uyehbry` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`),
  CONSTRAINT `FKr5x6jf2wm5jrjgtb0cj1k5d0g` FOREIGN KEY (`sow_discount_id`) REFERENCES `sow_discount` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `quotation_sow_discounts` WRITE;
/*!40000 ALTER TABLE `quotation_sow_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_sow_discounts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `relation_delivery_geo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relation_delivery_geo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `cost_per_day` decimal(19,2) NOT NULL,
  `rate_per_day` decimal(19,2) NOT NULL,
  `geo_id` bigint NOT NULL,
  `delivery_role_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKd5x02q2ekq42uf5bleb1y5uso` (`geo_id`),
  KEY `FK5tln86i7m20df6v8xklinil2` (`delivery_role_id`),
  CONSTRAINT `FK5tln86i7m20df6v8xklinil2` FOREIGN KEY (`delivery_role_id`) REFERENCES `delivery_role` (`id`),
  CONSTRAINT `FKd5x02q2ekq42uf5bleb1y5uso` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `relation_delivery_geo` WRITE;
/*!40000 ALTER TABLE `relation_delivery_geo` DISABLE KEYS */;
/*!40000 ALTER TABLE `relation_delivery_geo` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `review_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `status_changed` varchar(255) DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `submitter_id` bigint NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_modified` datetime(6) DEFAULT NULL,
  `review_request_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKhr3gkhb5mv5xcgjb2o3del30c` (`submitter_id`),
  KEY `FKiibhrsh1lpk24o7rdww1q6iw9` (`review_request_id`),
  CONSTRAINT `FKhr3gkhb5mv5xcgjb2o3del30c` FOREIGN KEY (`submitter_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKiibhrsh1lpk24o7rdww1q6iw9` FOREIGN KEY (`review_request_id`) REFERENCES `review_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `review_comment` WRITE;
/*!40000 ALTER TABLE `review_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_comment` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `review_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_request` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `subject` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_modified` datetime(6) DEFAULT NULL,
  `open` bit(1) NOT NULL,
  `status` varchar(255) NOT NULL,
  `submitter_id` bigint NOT NULL,
  `from_stage_id` bigint DEFAULT NULL,
  `to_stage_id` bigint DEFAULT NULL,
  `service_profile_id` bigint DEFAULT NULL,
  `quotation_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKgi0wvm98yb8ip1hy1q28u6svj` (`submitter_id`),
  KEY `FKqv5omj5edoura2kglwlsxxe5o` (`from_stage_id`),
  KEY `FKp7gwpgpda08kod2roh6d3qrc1` (`to_stage_id`),
  KEY `FKi3dvccodc8l73jrid2r7t8j5r` (`service_profile_id`),
  KEY `FKhy7jh2pujddo832x0x446h215` (`quotation_id`),
  CONSTRAINT `FKgi0wvm98yb8ip1hy1q28u6svj` FOREIGN KEY (`submitter_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKhy7jh2pujddo832x0x446h215` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`),
  CONSTRAINT `FKi3dvccodc8l73jrid2r7t8j5r` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FKp7gwpgpda08kod2roh6d3qrc1` FOREIGN KEY (`to_stage_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKqv5omj5edoura2kglwlsxxe5o` FOREIGN KEY (`from_stage_id`) REFERENCES `staging` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `review_request` WRITE;
/*!40000 ALTER TABLE `review_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_request` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `review_request__user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_request__user` (
  `review_request_assignees_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  KEY `FK2k1x2cgdsfqpsqtru74n5c0ft` (`user_id`),
  KEY `FK9i4qeqiw4ombjn17sltfojed9` (`review_request_assignees_id`),
  CONSTRAINT `FK2k1x2cgdsfqpsqtru74n5c0ft` FOREIGN KEY (`user_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK9i4qeqiw4ombjn17sltfojed9` FOREIGN KEY (`review_request_assignees_id`) REFERENCES `review_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `review_request__user` WRITE;
/*!40000 ALTER TABLE `review_request__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_request__user` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `authority` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `protect` bit(1) NOT NULL,
  `date_created` datetime(6) DEFAULT NULL,
  `last_updated` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_irsamgnera6angm0prq1kemt2` (`authority`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,0,'ROLE_SYSTEM_ADMINISTRATOR','System Administrator','SYSTEM ADMINISTRATOR',_binary '\0','2026-03-31 20:22:15.923000','2026-03-31 20:22:15.923000'),(2,0,'ROLE_PORTFOLIO_MANAGER','Portfolio Manager','PORTFOLIO MANAGER',_binary '\0','2026-03-31 20:22:15.934000','2026-03-31 20:22:15.934000'),(3,0,'ROLE_PRODUCT_MANAGER','Product Manager','PRODUCT MANAGER',_binary '\0','2026-03-31 20:22:15.936000','2026-03-31 20:22:15.936000'),(4,0,'ROLE_SERVICE_DESIGNER','Service Designer','SERVICE DESIGNER',_binary '\0','2026-03-31 20:22:15.938000','2026-03-31 20:22:15.938000'),(5,0,'ROLE_SALES_PRESIDENT','Sales President','SALES PRESIDENT',_binary '\0','2026-03-31 20:22:15.940000','2026-03-31 20:22:15.940000'),(6,0,'ROLE_SALES_MANAGER','Sales Manager','SALES MANAGER',_binary '\0','2026-03-31 20:22:15.941000','2026-03-31 20:22:15.941000'),(7,0,'ROLE_SALES_PERSON','Sales Person','SALES PERSON',_binary '\0','2026-03-31 20:22:15.943000','2026-03-31 20:22:15.943000'),(8,0,'ROLE_DELIVERY_ROLE_MANAGER','Delivery Role Manager','DELIVERY ROLE MANAGER',_binary '\0','2026-03-31 20:22:15.945000','2026-03-31 20:22:15.945000'),(9,0,'ROLE_GENERAL_MANAGER','General Manager','GENERAL MANAGER',_binary '\0','2026-03-31 20:22:15.947000','2026-03-31 20:22:15.947000');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `salesforce_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesforce_credentials` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `security_token` varchar(255) DEFAULT NULL,
  `instance_uri` varchar(255) DEFAULT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsuliepbd0bj0x1il972l6jeou` (`created_by_id`),
  KEY `FKjpvb0f1lx44wq6oowachsa0eq` (`modified_by_id`),
  CONSTRAINT `FKjpvb0f1lx44wq6oowachsa0eq` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKsuliepbd0bj0x1il972l6jeou` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `salesforce_credentials` WRITE;
/*!40000 ALTER TABLE `salesforce_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `salesforce_credentials` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `sku_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `service_profile_id` bigint DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `created_by_id` bigint NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `product_manager_id` bigint DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `service_description_id` bigint DEFAULT NULL,
  `active` bit(1) NOT NULL,
  `portfolio_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_3fdbfgw6oo8g5ivmiyk7tssmo` (`service_name`),
  KEY `FKgslpmnakroetc395udp4j1sfs` (`service_profile_id`),
  KEY `FK3ln20ydgj3ahfsngddwe3bpnq` (`created_by_id`),
  KEY `FKke68ue17xwqhgx2n3xl9e509h` (`modified_by_id`),
  KEY `FKgw8brlf0yhnwiqjkabi6cx7a0` (`product_manager_id`),
  KEY `FK843i32gykj4epc0bm5bgtfm03` (`service_description_id`),
  KEY `FK4wmc0qxlad5mcqc2dwkxvgwuq` (`portfolio_id`),
  CONSTRAINT `FK3ln20ydgj3ahfsngddwe3bpnq` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FK4wmc0qxlad5mcqc2dwkxvgwuq` FOREIGN KEY (`portfolio_id`) REFERENCES `portfolio` (`id`),
  CONSTRAINT `FK843i32gykj4epc0bm5bgtfm03` FOREIGN KEY (`service_description_id`) REFERENCES `description` (`id`),
  CONSTRAINT `FKgslpmnakroetc395udp4j1sfs` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FKgw8brlf0yhnwiqjkabi6cx7a0` FOREIGN KEY (`product_manager_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKke68ue17xwqhgx2n3xl9e509h` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service__user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service__user` (
  `service_other_product_managers_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  KEY `FKfa61odlhl9uc50n68pusq8mi6` (`user_id`),
  KEY `FK82pdv5uanbuiwn1pbqqwtm8s0` (`service_other_product_managers_id`),
  CONSTRAINT `FK82pdv5uanbuiwn1pbqqwtm8s0` FOREIGN KEY (`service_other_product_managers_id`) REFERENCES `service` (`id`),
  CONSTRAINT `FKfa61odlhl9uc50n68pusq8mi6` FOREIGN KEY (`user_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service__user` WRITE;
/*!40000 ALTER TABLE `service__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `service__user` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `estimated_time_in_hours_per_base_units` decimal(19,2) DEFAULT NULL,
  `estimated_time_in_hours_flat` decimal(19,2) DEFAULT NULL,
  `category` varchar(255) NOT NULL,
  `results` varchar(255) DEFAULT NULL,
  `sequence_order` int NOT NULL,
  `service_deliverable_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5gxy4o56af8irqgbdc3dj6s4t` (`service_deliverable_id`),
  CONSTRAINT `FK5gxy4o56af8irqgbdc3dj6s4t` FOREIGN KEY (`service_deliverable_id`) REFERENCES `service_deliverable` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_activity` WRITE;
/*!40000 ALTER TABLE `service_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_activity` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_activity_delivery_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_activity_delivery_role` (
  `service_activity_roles_required_id` bigint NOT NULL,
  `delivery_role_id` bigint DEFAULT NULL,
  KEY `FKaibesqfgvobx9o2t4yu8v4941` (`delivery_role_id`),
  KEY `FKhynh627ngxc2b00t7fo50ja3t` (`service_activity_roles_required_id`),
  CONSTRAINT `FKaibesqfgvobx9o2t4yu8v4941` FOREIGN KEY (`delivery_role_id`) REFERENCES `delivery_role` (`id`),
  CONSTRAINT `FKhynh627ngxc2b00t7fo50ja3t` FOREIGN KEY (`service_activity_roles_required_id`) REFERENCES `service_activity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_activity_delivery_role` WRITE;
/*!40000 ALTER TABLE `service_activity_delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_activity_delivery_role` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_activity_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_activity_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `task` longtext,
  `sequence_order` int DEFAULT NULL,
  `service_activity_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKewyld42j1ko9at0tr6dnwi4xb` (`service_activity_id`),
  CONSTRAINT `FKewyld42j1ko9at0tr6dnwi4xb` FOREIGN KEY (`service_activity_id`) REFERENCES `service_activity` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_activity_task` WRITE;
/*!40000 ALTER TABLE `service_activity_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_activity_task` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_deliverable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_deliverable` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `sequence_order` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `phase` varchar(255) DEFAULT NULL,
  `new_description_id` bigint DEFAULT NULL,
  `service_profile_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKfb22e963c7vnca1iybboh2mne` (`new_description_id`),
  KEY `FKtiowtd9fs4523xxstudqxboo6` (`service_profile_id`),
  CONSTRAINT `FKfb22e963c7vnca1iybboh2mne` FOREIGN KEY (`new_description_id`) REFERENCES `description` (`id`),
  CONSTRAINT `FKtiowtd9fs4523xxstudqxboo6` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_deliverable` WRITE;
/*!40000 ALTER TABLE `service_deliverable` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_deliverable` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_portfolio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_portfolio` (
  `service_other_portfolios_id` bigint NOT NULL,
  `portfolio_id` bigint DEFAULT NULL,
  KEY `FKcdi8r29h0cfvkr97qc7kyos7h` (`portfolio_id`),
  KEY `FK6jces4seayhkbn5wlfecrjstt` (`service_other_portfolios_id`),
  CONSTRAINT `FK6jces4seayhkbn5wlfecrjstt` FOREIGN KEY (`service_other_portfolios_id`) REFERENCES `service` (`id`),
  CONSTRAINT `FKcdi8r29h0cfvkr97qc7kyos7h` FOREIGN KEY (`portfolio_id`) REFERENCES `portfolio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_portfolio` WRITE;
/*!40000 ALTER TABLE `service_portfolio` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_portfolio` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_product_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_product_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `units_sold_per_base_units` decimal(19,2) DEFAULT NULL,
  `units_sold_rate_per_additional_unit` decimal(19,2) NOT NULL,
  `service_profile_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKion5p71yqrb35j68sa9vur907` (`service_profile_id`),
  KEY `FKiiot5atiutssevlbsvhw3wirv` (`product_id`),
  CONSTRAINT `FKiiot5atiutssevlbsvhw3wirv` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `FKion5p71yqrb35j68sa9vur907` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_product_item` WRITE;
/*!40000 ALTER TABLE `service_product_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_product_item` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `revision` int NOT NULL,
  `version_string` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `unit_of_sale` varchar(255) DEFAULT NULL,
  `base_units` int DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_published` datetime(6) DEFAULT NULL,
  `date_modified` datetime(6) DEFAULT NULL,
  `total_estimate_in_hours_per_base_units` decimal(19,2) DEFAULT NULL,
  `total_estimate_in_hours_flat` decimal(19,2) DEFAULT NULL,
  `premium_percent` decimal(19,2) NOT NULL,
  `staging_status_id` bigint DEFAULT NULL,
  `current_step` int NOT NULL,
  `service_designer_lead_id` bigint DEFAULT NULL,
  `old_profile_id` bigint DEFAULT NULL,
  `new_profile_id` bigint DEFAULT NULL,
  `current_review_request_id` bigint DEFAULT NULL,
  `definition` longtext,
  `workflow_mode` varchar(255) DEFAULT NULL,
  `is_imported` varchar(255) DEFAULT NULL,
  `import_service_stage` varchar(255) DEFAULT NULL,
  `service_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4i2bl2lfj53nnyy7lbjvsa0ff` (`staging_status_id`),
  KEY `FK72ku93yvjkk0tskbi2k7bcqkj` (`service_designer_lead_id`),
  KEY `FKkyoebygus40armqau44jffj6u` (`old_profile_id`),
  KEY `FKdw37l2uieoati7u8orp27wiaw` (`new_profile_id`),
  KEY `FKdttsoeex698d2w581bet5umv2` (`current_review_request_id`),
  KEY `FKhj8lfvesmyvjny0x5dcoxpppv` (`service_id`),
  CONSTRAINT `FK4i2bl2lfj53nnyy7lbjvsa0ff` FOREIGN KEY (`staging_status_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FK72ku93yvjkk0tskbi2k7bcqkj` FOREIGN KEY (`service_designer_lead_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKdttsoeex698d2w581bet5umv2` FOREIGN KEY (`current_review_request_id`) REFERENCES `review_request` (`id`),
  CONSTRAINT `FKdw37l2uieoati7u8orp27wiaw` FOREIGN KEY (`new_profile_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FKhj8lfvesmyvjny0x5dcoxpppv` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`),
  CONSTRAINT `FKkyoebygus40armqau44jffj6u` FOREIGN KEY (`old_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_profile` WRITE;
/*!40000 ALTER TABLE `service_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_profile__user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profile__user` (
  `service_profile_other_service_designers_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  KEY `FKgg3172dhew9h6tl72wl0w28ys` (`user_id`),
  KEY `FKiobnpwwye323uxqwmc16n0je9` (`service_profile_other_service_designers_id`),
  CONSTRAINT `FKgg3172dhew9h6tl72wl0w28ys` FOREIGN KEY (`user_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKiobnpwwye323uxqwmc16n0je9` FOREIGN KEY (`service_profile_other_service_designers_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_profile__user` WRITE;
/*!40000 ALTER TABLE `service_profile__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile__user` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_profile_delivery_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profile_delivery_role` (
  `service_profile_roles_required_id` bigint NOT NULL,
  `delivery_role_id` bigint DEFAULT NULL,
  KEY `FK7tx90gw7edgmmi0pf5e0guya8` (`delivery_role_id`),
  KEY `FK66nh4urmkfoqvexy2iqrnffrx` (`service_profile_roles_required_id`),
  CONSTRAINT `FK66nh4urmkfoqvexy2iqrnffrx` FOREIGN KEY (`service_profile_roles_required_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FK7tx90gw7edgmmi0pf5e0guya8` FOREIGN KEY (`delivery_role_id`) REFERENCES `delivery_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_profile_delivery_role` WRITE;
/*!40000 ALTER TABLE `service_profile_delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile_delivery_role` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_profile_metaphors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profile_metaphors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `definition_string_id` bigint DEFAULT NULL,
  `sequence_order` int DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `service_profile_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjrp7w8dpuk22y2uxnxao3mrp3` (`definition_string_id`),
  KEY `FKf3waqc80slryqoe0cei6auuge` (`service_profile_id`),
  CONSTRAINT `FKf3waqc80slryqoe0cei6auuge` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FKjrp7w8dpuk22y2uxnxao3mrp3` FOREIGN KEY (`definition_string_id`) REFERENCES `setting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_profile_metaphors` WRITE;
/*!40000 ALTER TABLE `service_profile_metaphors` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile_metaphors` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_profilesowdef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_profilesowdef` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `sp_id` bigint DEFAULT NULL,
  `geo_id` bigint DEFAULT NULL,
  `part` varchar(255) DEFAULT NULL,
  `definition_setting_id` bigint NOT NULL,
  `definition` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKl1cc722gvw96xo4hpyckodwfa` (`sp_id`),
  KEY `FKom5ki9gikebr6ltkpcex1ibx` (`geo_id`),
  KEY `FKmr4hdf6vkbcy3lv1ih9mo4ojd` (`definition_setting_id`),
  CONSTRAINT `FKl1cc722gvw96xo4hpyckodwfa` FOREIGN KEY (`sp_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FKmr4hdf6vkbcy3lv1ih9mo4ojd` FOREIGN KEY (`definition_setting_id`) REFERENCES `setting` (`id`),
  CONSTRAINT `FKom5ki9gikebr6ltkpcex1ibx` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_profilesowdef` WRITE;
/*!40000 ALTER TABLE `service_profilesowdef` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profilesowdef` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_quotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_quotation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `service_id` bigint NOT NULL,
  `profile_id` bigint NOT NULL,
  `total_units` int DEFAULT NULL,
  `old_units` int DEFAULT NULL,
  `geo_id` bigint DEFAULT NULL,
  `price` decimal(19,2) DEFAULT NULL,
  `staging_status_id` bigint DEFAULT NULL,
  `old_stage` varchar(255) DEFAULT NULL,
  `is_corrected` varchar(255) DEFAULT NULL,
  `additional_unit_of_sale_json_array` varchar(255) DEFAULT NULL,
  `sequence_order` int DEFAULT NULL,
  `quotation_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlq2cdmkn9dd4jgfxjx5lp4567` (`service_id`),
  KEY `FKlktatr53n66uoa98t7wpssety` (`profile_id`),
  KEY `FKfglmuu3879g0y2n6vly0wmmuh` (`geo_id`),
  KEY `FKebruwgen0pm939eb5jh7y9wim` (`staging_status_id`),
  KEY `FKe6681cxu6lvnyo88oyo521a4e` (`quotation_id`),
  CONSTRAINT `FKe6681cxu6lvnyo88oyo521a4e` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`),
  CONSTRAINT `FKebruwgen0pm939eb5jh7y9wim` FOREIGN KEY (`staging_status_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKfglmuu3879g0y2n6vly0wmmuh` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`),
  CONSTRAINT `FKlktatr53n66uoa98t7wpssety` FOREIGN KEY (`profile_id`) REFERENCES `service_profile` (`id`),
  CONSTRAINT `FKlq2cdmkn9dd4jgfxjx5lp4567` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_quotation` WRITE;
/*!40000 ALTER TABLE `service_quotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_quotation` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `service_quotation_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_quotation_ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `role_id` bigint DEFAULT NULL,
  `budget_hours` decimal(19,2) DEFAULT NULL,
  `actual_hours` decimal(19,2) DEFAULT NULL,
  `service_activity_id` bigint DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL,
  `ticket_id` int DEFAULT NULL,
  `created_by_id` bigint DEFAULT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `created_date` datetime(6) DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  `service_quotation_id` bigint DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKoilhwbfmxa4k61m4g5y3jt2r2` (`role_id`),
  KEY `FKb03kpajg3147n8x51rtjhrdj4` (`service_activity_id`),
  KEY `FKsb9m0o68wr0je0reh0v2bk9hf` (`created_by_id`),
  KEY `FKaeabg2yt675nqf4ggkh55smgy` (`modified_by_id`),
  KEY `FK3md9ndtb31umubextrtfcn7ta` (`service_quotation_id`),
  CONSTRAINT `FK3md9ndtb31umubextrtfcn7ta` FOREIGN KEY (`service_quotation_id`) REFERENCES `service_quotation` (`id`),
  CONSTRAINT `FKaeabg2yt675nqf4ggkh55smgy` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`),
  CONSTRAINT `FKb03kpajg3147n8x51rtjhrdj4` FOREIGN KEY (`service_activity_id`) REFERENCES `service_activity` (`id`),
  CONSTRAINT `FKoilhwbfmxa4k61m4g5y3jt2r2` FOREIGN KEY (`role_id`) REFERENCES `delivery_role` (`id`),
  CONSTRAINT `FKsb9m0o68wr0je0reh0v2bk9hf` FOREIGN KEY (`created_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `service_quotation_ticket` WRITE;
/*!40000 ALTER TABLE `service_quotation_ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_quotation_ticket` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setting` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `setting` WRITE;
/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
INSERT INTO `setting` VALUES (1,0,'sowLabel',''),(2,0,'sowTemplate','<p> Use following tags to put place holder for dynamically generated contents. </p><ul><li> [@@sow_introduction_input@@] a placeholder where sales person can add introduction </li><li> [@@services@@] for print services details </li><li> [@@terms@@] for terms and conditions for given GEO </li><li> [@@billing_terms@@] for billing terms for given GEO </li><li> [@@signature_block@@] </li></ul>'),(3,0,'services','Currently This is disable.'),(4,0,'terms',''),(5,0,'billing_terms',''),(6,0,'signature_block','');
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `shipping_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_address` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `ship_address_line1` varchar(255) DEFAULT NULL,
  `ship_address_line2` varchar(255) DEFAULT NULL,
  `ship_city` varchar(255) DEFAULT NULL,
  `ship_state` varchar(255) DEFAULT NULL,
  `ship_postalcode` varchar(255) DEFAULT NULL,
  `ship_country` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `shipping_address` WRITE;
/*!40000 ALTER TABLE `shipping_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipping_address` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `solution_bundle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solution_bundle` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `solution_bundle` WRITE;
/*!40000 ALTER TABLE `solution_bundle` DISABLE KEYS */;
/*!40000 ALTER TABLE `solution_bundle` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `solution_bundle_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solution_bundle_service` (
  `solution_bundle_solution_bundle_services_id` bigint NOT NULL,
  `service_id` bigint DEFAULT NULL,
  `solution_bundle_services_idx` int DEFAULT NULL,
  KEY `FKonxenrm1hcvt47pub2myy7qj9` (`service_id`),
  CONSTRAINT `FKonxenrm1hcvt47pub2myy7qj9` FOREIGN KEY (`service_id`) REFERENCES `service` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `solution_bundle_service` WRITE;
/*!40000 ALTER TABLE `solution_bundle_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `solution_bundle_service` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `sow_discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sow_discount` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `description` longtext,
  `amount` decimal(19,2) DEFAULT NULL,
  `amount_percentage` decimal(19,2) DEFAULT NULL,
  `is_global` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sow_discount` WRITE;
/*!40000 ALTER TABLE `sow_discount` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_discount` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `sow_introduction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sow_introduction` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sow_text` longtext NOT NULL,
  `geo_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKprdr9nm20axhcdpuyb6ni9f8x` (`geo_id`),
  CONSTRAINT `FKprdr9nm20axhcdpuyb6ni9f8x` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sow_introduction` WRITE;
/*!40000 ALTER TABLE `sow_introduction` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_introduction` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `sow_support_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sow_support_parameter` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `project_parameter_text` longtext,
  `geo_id` bigint DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKbhedphdxs46m5swkudg6w4uha` (`geo_id`),
  CONSTRAINT `FKbhedphdxs46m5swkudg6w4uha` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sow_support_parameter` WRITE;
/*!40000 ALTER TABLE `sow_support_parameter` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_support_parameter` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `sow_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sow_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `quotation_id` bigint NOT NULL,
  `tag_name` varchar(255) NOT NULL,
  `tag_value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKll7lck2jj6secsketc3fvbid` (`quotation_id`),
  CONSTRAINT `FKll7lck2jj6secsketc3fvbid` FOREIGN KEY (`quotation_id`) REFERENCES `quotation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sow_tag` WRITE;
/*!40000 ALTER TABLE `sow_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `sow_tag` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `staging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staging` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `entity` varchar(255) NOT NULL,
  `sequence_order` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `scope_of_authorized_role` varchar(255) NOT NULL,
  `is_active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staging` WRITE;
/*!40000 ALTER TABLE `staging` DISABLE KEYS */;
INSERT INTO `staging` VALUES (1,1,'SERVICE',1,'init','Initialization','Create service and assign product manager to define core requirements of service','NA',_binary ''),(2,2,'SERVICE',10,'concept','Conceptualization','<ul> <li> Add requirement data for service </li> <li> Then send request to review requirements for concept </li> </ul>','NA',_binary ''),(3,2,'SERVICE',11,'conceptreview','Concept Review','Review requirement data and approve if valid','SERVICE',_binary ''),(4,2,'SERVICE',12,'conceptapproved','Concept Approved','Concept is Approved, now assign service designer to define detailed activities and estimate time required','ADMIN',_binary ''),(5,2,'SERVICE',20,'design','Design','<ul> <li>Define detailed service activities and roles required for each activity </li> <li> Define estimate time and role required for each activity </li> <li> After design is done, send it for review request to product manager </li> </ul>','NA',_binary ''),(6,2,'SERVICE',21,'designreview','Design Review','Review design and approve if valid','SERVICE',_binary ''),(7,2,'SERVICE',22,'designapproved','Design Approved','Design is approved, now send Sale approval request','SERVICE',_binary ''),(8,2,'SERVICE',31,'salesreview','Sales Review','Review Sales related concern and approve if valid','SERVICE',_binary ''),(9,2,'SERVICE',32,'salesapproval','Sales Approval','Sales is approved so GEO admins will be notified to request to publish','LEGAL',_binary ''),(10,2,'SERVICE',41,'requestforpublished','Request to Publish','Request to Publish','SERVICE',_binary ''),(11,1,'SERVICE',42,'published','Published','Published','PORTFOLIO',_binary ''),(12,1,'SERVICE',43,'requesttoremove','Request to remove','Request to remove','SERVICE',_binary ''),(13,1,'SERVICE',100,'removed','Removed','Removed','PORTFOLIO',_binary ''),(14,1,'SERVICE',23,'inActive','Not Active','New Version of service is being upgraded','NA',_binary ''),(15,1,'SETUP',111,'welcome','Welcome','Welcome','NA',_binary ''),(16,1,'SETUP',112,'companyInfo','Company Information','Company Information','NA',_binary ''),(17,1,'SETUP',114,'addUsers','Add Users','Add Users','NA',_binary ''),(18,1,'SETUP',113,'geos','Create GEOs','Create GEOs','NA',_binary ''),(19,1,'SETUP',115,'deliveryRoles','Create DeliveryRoles','Create DeliveryRoles','NA',_binary ''),(20,1,'SETUP',116,'portfolios','Create Portfolios','Create Portfolios','NA',_binary ''),(21,1,'QUOTATION',1,'development','Development','In Development','NA',_binary ''),(22,1,'QUOTATION',2,'generated','Click to Generate','Click to Generate','NA',_binary ''),(23,1,'QUOTATION',3,'sent','Sent','Document Sent','NA',_binary ''),(24,1,'QUOTATION',4,'received','Customer Received','Customer Received','NA',_binary ''),(25,1,'QUOTATION',-1,'rejected','Rejected','Document Rejected','NA',_binary ''),(26,1,'QUOTATION',0,'closedAndNewOne','Closed And Created New One','Closed And Created New One','NA',_binary ''),(27,1,'QUOTATION',5,'Accepted','Accepted','Document Accepted','NA',_binary ''),(28,1,'LEAD',50,'uncontacted','Uncontacted','Create new Lead and add requirement fields.','NA',_binary ''),(29,1,'LEAD',51,'contactinprogress','Contact In Progress','Lead is contacted and in progress.','NA',_binary ''),(30,1,'LEAD',52,'converttoopportunity','Convert To Opportunity','Lead is converting to opportunity.','NA',_binary ''),(31,1,'LEAD',53,'converted','Converted','Lead is converted to opportunity.','NA',_binary ''),(32,1,'LEAD',54,'dead','Dead','Lead is dead.','NA',_binary ''),(33,1,'OPPORTUNITY',60,'prospecting','Prospecting','Prospecting Stage.','NA',_binary ''),(34,1,'OPPORTUNITY',61,'qualification','Qualification','Qualification Stage.','NA',_binary ''),(35,1,'OPPORTUNITY',62,'needAnalysis','Need Analysis','Need Analysis Stage.','NA',_binary ''),(36,6,'OPPORTUNITY',63,'valueProposition','Value Proposition','Value Proposition Stage.','NA',_binary '\0'),(37,6,'OPPORTUNITY',64,'decisionMakers','Decision Makers','Decision Makers Stage.','NA',_binary '\0'),(38,6,'OPPORTUNITY',65,'perceptionAnalysis','Perception Analysis','Perception Analysis Stage.','NA',_binary '\0'),(39,1,'OPPORTUNITY',66,'proposalPriceQuote','Proposal/Price Quote','Proposal/Price Quote Stage.','NA',_binary ''),(40,1,'OPPORTUNITY',67,'negotiationReview','Negotiation/Review','Negotiation/Review Stage.','NA',_binary ''),(41,1,'OPPORTUNITY',68,'closedWon','Closed Won','Closed Won Stage.','NA',_binary ''),(42,1,'OPPORTUNITY',69,'closedLost','Closed Lost','<ul> <li>Closed Lost Stage.</li> <li>Click To Break Opportunity.</li><ul>','NA',_binary ''),(43,1,'SERVICEQUOTATION',121,'new','New','New ServiceQuotation','NA',_binary ''),(44,1,'SERVICEQUOTATION',122,'active','Active','Active ServiceQuotation','NA',_binary ''),(45,1,'SERVICEQUOTATION',123,'edit','Edit','Edit ServiceQuotation','NA',_binary ''),(46,1,'SERVICEQUOTATION',124,'delete','Delete','Delete ServiceQuotation','NA',_binary '');
/*!40000 ALTER TABLE `staging` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `staging_authorized_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staging_authorized_role` (
  `staging_id` bigint NOT NULL,
  `role_id` bigint DEFAULT NULL,
  KEY `FKgp0s250tb42kgg8b9ho65ajaa` (`role_id`),
  KEY `FKc67b50b3vta83sbv9a757bn05` (`staging_id`),
  CONSTRAINT `FKc67b50b3vta83sbv9a757bn05` FOREIGN KEY (`staging_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKgp0s250tb42kgg8b9ho65ajaa` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staging_authorized_role` WRITE;
/*!40000 ALTER TABLE `staging_authorized_role` DISABLE KEYS */;
INSERT INTO `staging_authorized_role` VALUES (1,2),(2,3),(3,2),(4,3),(5,4),(6,3),(7,3),(8,2),(9,2),(12,3),(13,2);
/*!40000 ALTER TABLE `staging_authorized_role` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `staging_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staging_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `action` varchar(255) NOT NULL,
  `from_stage_id` bigint DEFAULT NULL,
  `to_stage_id` bigint DEFAULT NULL,
  `comment` varchar(255) NOT NULL,
  `modified_by` varchar(255) NOT NULL,
  `revision` int NOT NULL,
  `service_profile_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3u5kyackrjafb46ili6iyq9la` (`from_stage_id`),
  KEY `FK2s4ftj6mq2pwvgybe9p4bttp4` (`to_stage_id`),
  KEY `FKl19yyru5ayl45htxsss6r21pb` (`service_profile_id`),
  CONSTRAINT `FK2s4ftj6mq2pwvgybe9p4bttp4` FOREIGN KEY (`to_stage_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FK3u5kyackrjafb46ili6iyq9la` FOREIGN KEY (`from_stage_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKl19yyru5ayl45htxsss6r21pb` FOREIGN KEY (`service_profile_id`) REFERENCES `service_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staging_log` WRITE;
/*!40000 ALTER TABLE `staging_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `staging_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `staging_reviewer_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staging_reviewer_role` (
  `staging_id` bigint NOT NULL,
  `role_id` bigint DEFAULT NULL,
  KEY `FKrnc3h2yqmuw9rn7gvocipp7u5` (`role_id`),
  KEY `FKolfptg2quddkwe5tqa5vev6cn` (`staging_id`),
  CONSTRAINT `FKolfptg2quddkwe5tqa5vev6cn` FOREIGN KEY (`staging_id`) REFERENCES `staging` (`id`),
  CONSTRAINT `FKrnc3h2yqmuw9rn7gvocipp7u5` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staging_reviewer_role` WRITE;
/*!40000 ALTER TABLE `staging_reviewer_role` DISABLE KEYS */;
INSERT INTO `staging_reviewer_role` VALUES (6,4);
/*!40000 ALTER TABLE `staging_reviewer_role` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `staging_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staging_types` (
  `staging_id` bigint NOT NULL,
  `staging$staging_type` varchar(255) DEFAULT NULL,
  KEY `FKa0yhcxuce55d6vat5gvt6h80` (`staging_id`),
  CONSTRAINT `FKa0yhcxuce55d6vat5gvt6h80` FOREIGN KEY (`staging_id`) REFERENCES `staging` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staging_types` WRITE;
/*!40000 ALTER TABLE `staging_types` DISABLE KEYS */;
INSERT INTO `staging_types` VALUES (1,'BEGIN_NEW'),(1,'NEW_STAGE'),(2,'NEW_STAGE'),(3,'NEW_STAGE'),(3,'REVIEW_REQUEST'),(4,'NEW_STAGE'),(4,'APPROVAL'),(5,'NEW_STAGE'),(5,'BEGIN_EDIT'),(5,'EDIT_STAGE'),(6,'NEW_STAGE'),(6,'EDIT_STAGE'),(6,'REVIEW_REQUEST'),(7,'NEW_STAGE'),(7,'EDIT_STAGE'),(7,'APPROVAL'),(8,'REVIEW_REQUEST'),(8,'NEW_STAGE'),(8,'EDIT_STAGE'),(9,'NEW_STAGE'),(9,'EDIT_STAGE'),(9,'APPROVAL'),(10,'NEW_STAGE'),(10,'EDIT_STAGE'),(10,'REVIEW_REQUEST'),(11,'NEW_STAGE'),(11,'EDIT_STAGE'),(11,'END_NEW'),(11,'END_EDIT'),(12,'REMOVE_STAGE'),(12,'BEGIN_REMOVE'),(12,'REVIEW_REQUEST'),(13,'REMOVE_STAGE'),(13,'END_REMOVE'),(13,'APPROVAL'),(14,'INACTIVE'),(15,'NEW_STAGE'),(15,'BEGIN_NEW'),(16,'NEW_STAGE'),(16,'BEGIN_EDIT'),(16,'EDIT_STAGE'),(17,'NEW_STAGE'),(17,'BEGIN_EDIT'),(17,'EDIT_STAGE'),(18,'NEW_STAGE'),(18,'BEGIN_EDIT'),(18,'EDIT_STAGE'),(19,'NEW_STAGE'),(19,'BEGIN_EDIT'),(19,'EDIT_STAGE'),(20,'NEW_STAGE'),(20,'BEGIN_EDIT'),(20,'EDIT_STAGE'),(21,'EDIT_STAGE'),(21,'BEGIN_NEW'),(22,'EDIT_STAGE'),(23,'EDIT_STAGE'),(24,'EDIT_STAGE'),(25,'END_REMOVE'),(25,'REMOVE_STAGE'),(25,'EDIT_STAGE'),(26,'END_REMOVE'),(26,'REMOVE_STAGE'),(26,'EDIT_STAGE'),(27,'END_EDIT'),(27,'EDIT_STAGE'),(28,'NEW_STAGE'),(28,'BEGIN_NEW'),(29,'NEW_STAGE'),(29,'BEGIN_EDIT'),(29,'EDIT_STAGE'),(30,'NEW_STAGE'),(30,'BEGIN_EDIT'),(30,'EDIT_STAGE'),(31,'NEW_STAGE'),(31,'BEGIN_EDIT'),(31,'EDIT_STAGE'),(32,'NEW_STAGE'),(32,'REMOVE_STAGE'),(32,'END_REMOVE'),(33,'NEW_STAGE'),(33,'BEGIN_NEW'),(34,'NEW_STAGE'),(34,'BEGIN_EDIT'),(34,'EDIT_STAGE'),(35,'NEW_STAGE'),(35,'BEGIN_EDIT'),(35,'EDIT_STAGE'),(36,'NEW_STAGE'),(36,'BEGIN_EDIT'),(36,'EDIT_STAGE'),(37,'NEW_STAGE'),(37,'BEGIN_EDIT'),(37,'EDIT_STAGE'),(38,'NEW_STAGE'),(38,'BEGIN_EDIT'),(38,'EDIT_STAGE'),(39,'NEW_STAGE'),(39,'BEGIN_EDIT'),(39,'EDIT_STAGE'),(40,'NEW_STAGE'),(40,'BEGIN_EDIT'),(40,'EDIT_STAGE'),(41,'NEW_STAGE'),(41,'REMOVE_STAGE'),(41,'END_REMOVE'),(42,'NEW_STAGE'),(42,'REMOVE_STAGE'),(42,'END_REMOVE'),(43,'NEW_STAGE'),(43,'BEGIN_NEW'),(44,'NEW_STAGE'),(44,'BEGIN_EDIT'),(44,'EDIT_STAGE'),(45,'NEW_STAGE'),(45,'BEGIN_EDIT'),(45,'EDIT_STAGE'),(46,'NEW_STAGE'),(46,'END_REMOVE'),(46,'REMOVE_STAGE'),(46,'EDIT_STAGE');
/*!40000 ALTER TABLE `staging_types` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `sub_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_stages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `sequence_number` int DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `staging_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKf19t82g83ndwly02fhqpymcu8` (`staging_id`),
  CONSTRAINT `FKf19t82g83ndwly02fhqpymcu8` FOREIGN KEY (`staging_id`) REFERENCES `staging` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sub_stages` WRITE;
/*!40000 ALTER TABLE `sub_stages` DISABLE KEYS */;
INSERT INTO `sub_stages` VALUES (1,0,1,'Review Service Info','showDetailedInfo',10),(2,0,2,'Approve publishing','approveRequest',10),(3,0,1,'Request Publish','request',9),(4,0,2,'Approve/Reject Sale','approveRequest',8),(5,0,1,'Review Service Info','showDetailedInfo',8),(6,0,1,'Request Sales Review','request',7),(7,0,3,'Approve/Reject Design','approveRequest',6),(8,0,2,'Edit SOW Language','editDefinition',6),(9,0,1,'Review Design','showDetailedInfo',6),(10,0,3,'Define Products','addProducts',5),(11,0,4,'Add Pre-requisites','addPrerequisites',5),(12,0,1,'Review Requirements','showInfo',5),(13,0,2,'Add Activities and Roles','addActivities',5),(14,0,7,'Request Design Review','request',5),(15,0,5,'Add Out of Scope','addOutOfScope',5),(16,0,6,'Preview','showDetailedInfo',5),(17,0,1,'Assign Designer','assignDesigner',4),(18,0,2,'Approve/Reject Concept','approveRequest',3),(19,0,1,'Review Requirements','showInfo',3),(20,0,2,'Add Service Deliverables','editDeliverables',2),(21,0,3,'Add SOW Language','editDefinition',2),(22,0,4,'Preview','showInfo',2),(23,0,1,'Add requirement data','edit',2),(24,0,5,'Request concept review','request',2);
/*!40000 ALTER TABLE `sub_stages` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `text_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `text_template` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `text` varchar(255) NOT NULL,
  `date_created` datetime(6) NOT NULL,
  `date_modified` datetime(6) NOT NULL,
  `geo_id` bigint DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK4ohijwwu70svwuyx4fbttmtqg` (`geo_id`),
  CONSTRAINT `FK4ohijwwu70svwuyx4fbttmtqg` FOREIGN KEY (`geo_id`) REFERENCES `geo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `text_template` WRITE;
/*!40000 ALTER TABLE `text_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `text_template` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ticket_planner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_planner` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `portfolio_id` bigint DEFAULT NULL,
  `task_name` varchar(255) DEFAULT NULL,
  `task_desc` varchar(255) DEFAULT NULL,
  `parent_task_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8a0ce9pwk1ua0snwfaahao37w` (`portfolio_id`),
  KEY `FKb6ing7trfldc1nqy4nnuoe4ar` (`parent_task_id`),
  CONSTRAINT `FK8a0ce9pwk1ua0snwfaahao37w` FOREIGN KEY (`portfolio_id`) REFERENCES `portfolio` (`id`),
  CONSTRAINT `FKb6ing7trfldc1nqy4nnuoe4ar` FOREIGN KEY (`parent_task_id`) REFERENCES `ticket_planner` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ticket_planner` WRITE;
/*!40000 ALTER TABLE `ticket_planner` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_planner` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `time_stamp_saver_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_stamp_saver_object` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `from_date` datetime(6) DEFAULT NULL,
  `to_date` datetime(6) DEFAULT NULL,
  `object_name` varchar(255) DEFAULT NULL,
  `modified_by_id` bigint DEFAULT NULL,
  `modified_date` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKtqvqgu3n8w48baivpyifdtdty` (`modified_by_id`),
  CONSTRAINT `FKtqvqgu3n8w48baivpyifdtdty` FOREIGN KEY (`modified_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `time_stamp_saver_object` WRITE;
/*!40000 ALTER TABLE `time_stamp_saver_object` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_stamp_saver_object` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `update_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `update_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `record_type` varchar(255) DEFAULT NULL,
  `begin_update_date` datetime(6) DEFAULT NULL,
  `last_update_date` datetime(6) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `updated_by_id` bigint DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK5ons5yr0icdg55ygbuh2pqnlx` (`updated_by_id`),
  CONSTRAINT `FK5ons5yr0icdg55ygbuh2pqnlx` FOREIGN KEY (`updated_by_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `update_record` WRITE;
/*!40000 ALTER TABLE `update_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `update_record` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `upload_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `upload_file` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `upload_file` WRITE;
/*!40000 ALTER TABLE `upload_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `upload_file` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `FKa68196081fvovjhkek5m97n3y` (`role_id`),
  CONSTRAINT `FKa68196081fvovjhkek5m97n3y` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`),
  CONSTRAINT `FKniaqoclrvx138sjw9hsollqav` FOREIGN KEY (`user_id`) REFERENCES `_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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

