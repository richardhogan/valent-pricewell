-- MySQL dump 10.11
--
-- Host: localhost    Database: pricewell
-- ------------------------------------------------------
-- Server version	5.0.77-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `_group`
--

LOCK TABLES `_group` WRITE;
/*!40000 ALTER TABLE `_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_group_roles`
--

LOCK TABLES `_group_roles` WRITE;
/*!40000 ALTER TABLE `_group_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `_group_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_group_users`
--

LOCK TABLES `_group_users` WRITE;
/*!40000 ALTER TABLE `_group_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `_group_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_role`
--

LOCK TABLES `_role` WRITE;
/*!40000 ALTER TABLE `_role` DISABLE KEYS */;
INSERT INTO `_role` VALUES (1,13,'2011-05-03 21:51:22','Issued to all users','\0','2011-06-28 14:35:45','USER','',NULL),(2,1,'2011-05-03 21:51:22','Assigned to users who are considered to be system wide administrators','\0','2011-05-03 21:51:24','SYSTEM ADMINISTRATOR','',NULL),(3,6,'2011-05-03 21:51:24','Portfolio Manager','\0','2011-05-04 15:16:03','PORTFOLIO MANAGER','\0',NULL),(4,4,'2011-05-03 21:51:24','Product Manager','\0','2011-05-04 15:19:30','PRODUCT MANAGER','\0',NULL),(5,4,'2011-05-03 21:51:24','Service Designer','\0','2011-05-04 19:04:45','SERVICE DESIGNER','\0',NULL),(6,4,'2011-05-03 21:51:24','Sales Person','\0','2011-05-04 20:02:55','SALES PERSON','\0',NULL),(7,5,'2011-05-03 21:51:24','Delivery Role Manager','\0','2011-05-04 15:17:49','DELIVERY ROLE MANAGER','\0',NULL);
/*!40000 ALTER TABLE `_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_role_users`
--

LOCK TABLES `_role_users` WRITE;
/*!40000 ALTER TABLE `_role_users` DISABLE KEYS */;
INSERT INTO `_role_users` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(2,2),(7,3),(8,3),(5,4),(10,4),(6,5),(11,5),(4,6),(12,6),(3,7),(9,7);
/*!40000 ALTER TABLE `_role_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_user`
--

LOCK TABLES `_user` WRITE;
/*!40000 ALTER TABLE `_user` DISABLE KEYS */;
INSERT INTO `_user` VALUES (1,1,'860800f0b968ef5980ab5d87b28f68a1f9d3b493659438de08141348dcb01de1','2011-05-03 21:51:23','',NULL,'\0','\0',NULL,'2011-05-03 21:51:23','dfdc545fc8feccab949d24d643973f12030c724c31756f4fc23a735ae7d0bada',1,NULL,'\0','user','com.valent.pricewell.User'),(2,50,'f512965128b66c01d6725c67c3f358ec14baf07791f7a9a6c12317584b54f5bf','2011-05-03 21:51:23','',NULL,'\0','\0',NULL,'2011-07-21 01:57:19','3e6b76727a8dfffa94fdf4e9fbc01c1a16f008e6e91a9f5e0de06d1c620e068c',2,NULL,'\0','admin','com.valent.pricewell.User'),(3,5,'19044ee8f12885072e78badf03833da9ddb1a4e3ab42c981d05339ce6dc84870','2011-05-04 15:03:25','',NULL,'\0','\0',NULL,'2011-05-04 19:55:11','cd2c02d2a5bc4bdfb030dc5d3d18d0280f432acdcc1861193c3c4f513193722f',3,NULL,'\0','tbadmun','com.valent.pricewell.User'),(4,11,'1a433f3bf9cab817d20a416a9e69d923d31d99fbe721565501d0ddf9bd3a82c2','2011-05-04 15:06:11','',NULL,'\0','\0',NULL,'2011-05-23 19:06:35','743ab648214de4ee9be75604f3f7a60a4e4418ced235da33cf645b54cddd0354',4,NULL,'\0','rswanson','com.valent.pricewell.User'),(5,8,'349bc365ae975f2d341771fc8047697f620603dc07a3145a03fa7f7e85c97c50','2011-05-04 15:07:55','',NULL,'\0','\0',NULL,'2011-05-04 21:01:58','56eea93f0d70d1fe1c73a08fa0300ef7de5812c4f6992c3eced890d3d5d1639a',5,NULL,'\0','nronde','com.valent.pricewell.User'),(6,6,'cdb731f42935f1489b34525a5ac55ec162dc61e9c381a0ac7e1b851407c12ad3','2011-05-04 15:10:47','',NULL,'\0','\0',NULL,'2011-05-15 15:42:52','b71713d34643d3de850503d648402737e17ccfd10d654effa7415d1e9643bc89',6,NULL,'\0','jpodge','com.valent.pricewell.User'),(7,14,'20a3b3cfa1bb3bb7cb647a636f4ab03163fd69158fe5e5a821c7b560d2fe78bb','2011-05-04 15:12:35','',NULL,'\0','\0',NULL,'2011-05-23 18:41:20','7d82803a9e33e72012c85f35847a90b986ed428a750b04fd9e848447c54e16d5',7,NULL,'\0','jcubeline','com.valent.pricewell.User'),(8,8,'915b7ac898e8e5537fcf50630ac387d110725c30236280acfa8df9be48ffe43c','2011-05-04 15:15:33','',NULL,'\0','\0',NULL,'2011-05-15 15:29:29','cfd733b239871916150b2bbb3611af1038a643caf059d269ee673390fa5bb8c2',8,NULL,'\0','anot','com.valent.pricewell.User'),(9,3,'550ee3b07e526cabec873f7d84800d04a4519a2a307b05c87f6a89fc21c5e4f9','2011-05-04 15:17:31','',NULL,'\0','\0',NULL,'2011-05-04 15:17:52','a92bd6fe04baee69d76e5c8cf65cc2e206a4464f154a92bfc9f5ba47bd27d235',9,NULL,'\0','blinman','com.valent.pricewell.User'),(10,13,'c70c23f4e7099047ab131c7969b1128c76b4541622adc50a9f1ca3aa3d32483b','2011-05-04 15:19:11','',NULL,'\0','\0',NULL,'2011-05-15 15:35:24','3ed3e0061061265ac5ec0701ceab5e6a9feb56526c9ac0288d636bce682ca87f',10,NULL,'\0','dlang','com.valent.pricewell.User'),(11,4,'359acc1b01bdb75378866f78b0360e3f0a1cd0b9603d238dc7d949eb085abd84','2011-05-04 19:04:34','',NULL,'\0','\0',NULL,'2011-05-04 19:08:09','cea0ebd447c1d86cff7fc3b4a396a14ea1ea7c3d44aa0fba8b655423d4108143',11,NULL,'\0','qturner','com.valent.pricewell.User'),(12,5,'a8ad2c09206d77124afd47e09e32b02a30160435bce591345378876128c62b78','2011-05-04 20:02:24','',NULL,'\0','\0',NULL,'2011-05-05 00:46:41','f77ee13338e775ba5feff3145c8302017e9542249eb0979c673f038f730f0874',12,NULL,'\0','mreece','com.valent.pricewell.User'),(13,3,'d457266ffb8709810719fd5eb985d7c88c477a29a00437122d6aaba05c0c5692','2011-06-28 14:35:45','',NULL,'\0','\0',NULL,'2011-06-28 14:37:46','ef12e1c2eb268a5c68eaf394e8a9bdb0bb5bcadcc9250dc043206bfcd1df1c12',13,NULL,'','ratan','com.valent.pricewell.User');
/*!40000 ALTER TABLE `_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_user__user`
--

LOCK TABLES `_user__user` WRITE;
/*!40000 ALTER TABLE `_user__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `_user__user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `_user_passwd_history`
--

LOCK TABLES `_user_passwd_history` WRITE;
/*!40000 ALTER TABLE `_user_passwd_history` DISABLE KEYS */;
INSERT INTO `_user_passwd_history` VALUES (1,'dfdc545fc8feccab949d24d643973f12030c724c31756f4fc23a735ae7d0bada'),(2,'3e6b76727a8dfffa94fdf4e9fbc01c1a16f008e6e91a9f5e0de06d1c620e068c'),(3,'cd2c02d2a5bc4bdfb030dc5d3d18d0280f432acdcc1861193c3c4f513193722f'),(4,'743ab648214de4ee9be75604f3f7a60a4e4418ced235da33cf645b54cddd0354'),(5,'56eea93f0d70d1fe1c73a08fa0300ef7de5812c4f6992c3eced890d3d5d1639a'),(6,'b71713d34643d3de850503d648402737e17ccfd10d654effa7415d1e9643bc89'),(7,'7d82803a9e33e72012c85f35847a90b986ed428a750b04fd9e848447c54e16d5'),(8,'cfd733b239871916150b2bbb3611af1038a643caf059d269ee673390fa5bb8c2'),(9,'a92bd6fe04baee69d76e5c8cf65cc2e206a4464f154a92bfc9f5ba47bd27d235'),(10,'3ed3e0061061265ac5ec0701ceab5e6a9feb56526c9ac0288d636bce682ca87f'),(11,'cea0ebd447c1d86cff7fc3b4a396a14ea1ea7c3d44aa0fba8b655423d4108143'),(12,'f77ee13338e775ba5feff3145c8302017e9542249eb0979c673f038f730f0874'),(13,'ef12e1c2eb268a5c68eaf394e8a9bdb0bb5bcadcc9250dc043206bfcd1df1c12');
/*!40000 ALTER TABLE `_user_passwd_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `activity_role_time`
--

LOCK TABLES `activity_role_time` WRITE;
/*!40000 ALTER TABLE `activity_role_time` DISABLE KEYS */;
INSERT INTO `activity_role_time` VALUES (1,0,20,0.1,3,2),(2,0,6,0,1,3),(3,0,4,0,1,4),(4,0,4,0,1,5),(5,0,5,0.125,2,6),(6,0,4,0,3,7);
/*!40000 ALTER TABLE `activity_role_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `delivery_role`
--

LOCK TABLES `delivery_role` WRITE;
/*!40000 ALTER TABLE `delivery_role` DISABLE KEYS */;
INSERT INTO `delivery_role` VALUES (1,0,'Project Manager','PROJECT MANAGER '),(2,0,'Solution Architect','ARCHITECT'),(3,0,'Product Specialist','PRODUCT SPECIALIST');
/*!40000 ALTER TABLE `delivery_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `details`
--

LOCK TABLES `details` WRITE;
/*!40000 ALTER TABLE `details` DISABLE KEYS */;
/*!40000 ALTER TABLE `details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `federation_provider`
--

LOCK TABLES `federation_provider` WRITE;
/*!40000 ALTER TABLE `federation_provider` DISABLE KEYS */;
/*!40000 ALTER TABLE `federation_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `federation_provider_props`
--

LOCK TABLES `federation_provider_props` WRITE;
/*!40000 ALTER TABLE `federation_provider_props` DISABLE KEYS */;
/*!40000 ALTER TABLE `federation_provider_props` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `geo`
--

LOCK TABLES `geo` WRITE;
/*!40000 ALTER TABLE `geo` DISABLE KEYS */;
INSERT INTO `geo` VALUES (1,0,'USD','United States of America','UNITED STATES'),(2,0,'GBP','United Kingdom','UK'),(3,0,'EUR','Germany','GERMANY'),(4,0,'JPY','Japan','JAPAN');
/*!40000 ALTER TABLE `geo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `level_permission_fifth`
--

LOCK TABLES `level_permission_fifth` WRITE;
/*!40000 ALTER TABLE `level_permission_fifth` DISABLE KEYS */;
/*!40000 ALTER TABLE `level_permission_fifth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `level_permission_first`
--

LOCK TABLES `level_permission_first` WRITE;
/*!40000 ALTER TABLE `level_permission_first` DISABLE KEYS */;
INSERT INTO `level_permission_first` VALUES (4,'portfolio'),(5,'*'),(6,'service'),(7,'reports'),(8,'service'),(9,'*'),(10,'service'),(11,'*'),(12,'*'),(13,'quotation'),(14,'*'),(15,'deliveryRole'),(16,'geo');
/*!40000 ALTER TABLE `level_permission_first` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `level_permission_fourth`
--

LOCK TABLES `level_permission_fourth` WRITE;
/*!40000 ALTER TABLE `level_permission_fourth` DISABLE KEYS */;
/*!40000 ALTER TABLE `level_permission_fourth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `level_permission_second`
--

LOCK TABLES `level_permission_second` WRITE;
/*!40000 ALTER TABLE `level_permission_second` DISABLE KEYS */;
INSERT INTO `level_permission_second` VALUES (4,'update'),(5,'read'),(6,'update'),(6,'create'),(6,'design'),(7,'show'),(8,'update'),(8,'design'),(9,'read'),(10,'design'),(11,'read'),(12,'read'),(13,'create'),(14,'read'),(15,'create'),(16,'create');
/*!40000 ALTER TABLE `level_permission_second` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `level_permission_sixth`
--

LOCK TABLES `level_permission_sixth` WRITE;
/*!40000 ALTER TABLE `level_permission_sixth` DISABLE KEYS */;
/*!40000 ALTER TABLE `level_permission_sixth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `level_permission_third`
--

LOCK TABLES `level_permission_third` WRITE;
/*!40000 ALTER TABLE `level_permission_third` DISABLE KEYS */;
/*!40000 ALTER TABLE `level_permission_third` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `login_record`
--

LOCK TABLES `login_record` WRITE;
/*!40000 ALTER TABLE `login_record` DISABLE KEYS */;
INSERT INTO `login_record` VALUES (1,0,'2011-05-03 21:53:16','2011-05-03 21:53:16',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'),(2,0,'2011-05-04 00:08:32','2011-05-04 00:08:32',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(3,0,'2011-05-04 14:40:44','2011-05-04 14:40:44',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(4,0,'2011-05-04 15:28:11','2011-05-04 15:28:11',10,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(5,0,'2011-05-04 15:34:01','2011-05-04 15:34:01',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(6,0,'2011-05-04 15:42:17','2011-05-04 15:42:17',10,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(7,0,'2011-05-04 17:07:32','2011-05-04 17:07:32',2,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(8,0,'2011-05-04 17:08:11','2011-05-04 17:08:11',4,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(9,0,'2011-05-04 17:16:34','2011-05-04 17:16:34',10,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(10,0,'2011-05-04 17:19:32','2011-05-04 17:19:32',8,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(11,0,'2011-05-04 17:23:51','2011-05-04 17:23:51',10,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(12,0,'2011-05-04 17:31:39','2011-05-04 17:31:39',6,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(13,0,'2011-05-04 17:33:38','2011-05-04 17:33:38',10,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(14,0,'2011-05-04 17:34:52','2011-05-04 17:34:52',6,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(15,0,'2011-05-04 17:49:08','2011-05-04 17:49:08',10,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(16,0,'2011-05-04 17:50:38','2011-05-04 17:50:38',8,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(17,0,'2011-05-04 17:54:42','2011-05-04 17:54:42',4,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(18,0,'2011-05-04 18:42:31','2011-05-04 18:42:31',4,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(19,0,'2011-05-04 18:42:43','2011-05-04 18:42:43',4,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(20,0,'2011-05-04 18:43:39','2011-05-04 18:43:39',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(21,0,'2011-05-04 18:49:02','2011-05-04 18:49:02',5,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(22,0,'2011-05-04 18:55:35','2011-05-04 18:55:35',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(23,0,'2011-05-04 18:58:52','2011-05-04 18:58:52',5,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(24,0,'2011-05-04 19:03:10','2011-05-04 19:03:10',2,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(25,0,'2011-05-04 19:05:13','2011-05-04 19:05:13',5,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(26,0,'2011-05-04 19:08:09','2011-05-04 19:08:09',11,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(27,0,'2011-05-04 19:19:58','2011-05-04 19:19:58',10,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(28,0,'2011-05-04 19:45:43','2011-05-04 19:45:43',5,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(29,0,'2011-05-04 19:48:36','2011-05-04 19:48:36',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(30,0,'2011-05-04 19:52:59','2011-05-04 19:52:59',3,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(31,0,'2011-05-04 19:54:02','2011-05-04 19:54:02',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(32,0,'2011-05-04 19:55:11','2011-05-04 19:55:11',3,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(33,0,'2011-05-04 19:56:25','2011-05-04 19:56:25',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(34,0,'2011-05-04 19:57:15','2011-05-04 19:57:15',4,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(35,0,'2011-05-04 19:59:48','2011-05-04 19:59:48',8,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(36,0,'2011-05-04 20:01:19','2011-05-04 20:01:19',2,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(37,0,'2011-05-04 20:03:18','2011-05-04 20:03:18',12,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(38,0,'2011-05-04 20:05:37','2011-05-04 20:05:37',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(39,0,'2011-05-04 20:06:13','2011-05-04 20:06:13',10,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(40,0,'2011-05-04 21:01:58','2011-05-04 21:01:58',5,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(41,0,'2011-05-04 21:03:56','2011-05-04 21:03:56',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(42,0,'2011-05-04 23:38:25','2011-05-04 23:38:25',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(43,0,'2011-05-04 23:47:10','2011-05-04 23:47:10',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(44,0,'2011-05-05 00:43:14','2011-05-05 00:43:14',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(45,0,'2011-05-05 00:46:41','2011-05-05 00:46:41',12,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(46,0,'2011-05-05 02:04:42','2011-05-05 02:04:42',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(47,0,'2011-05-05 02:12:47','2011-05-05 02:12:47',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_5; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.205 Safari/534.16'),(48,0,'2011-05-05 15:31:23','2011-05-05 15:31:23',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A306 Safari/6531.22.7'),(49,0,'2011-05-05 16:42:03','2011-05-05 16:42:03',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(50,0,'2011-05-05 23:08:47','2011-05-05 23:08:47',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.57 Safari/534.24'),(51,0,'2011-05-06 22:57:20','2011-05-06 22:57:20',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(52,0,'2011-05-07 14:37:51','2011-05-07 14:37:51',2,'117.196.32.120','117.196.32.120','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.65 Safari/534.24'),(53,0,'2011-05-08 01:13:52','2011-05-08 01:13:52',2,'117.196.102.211','117.196.102.211','Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; InfoPath.2; MASN)'),(54,0,'2011-05-08 13:26:38','2011-05-08 13:26:38',2,'113.193.205.163','113.193.205.163','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.60 Safari/534.24'),(55,0,'2011-05-10 21:59:39','2011-05-10 21:59:39',10,'64.125.181.75','64.125.181.75','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(56,0,'2011-05-10 22:00:06','2011-05-10 22:00:06',8,'64.125.181.75','64.125.181.75','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(57,0,'2011-05-10 22:13:09','2011-05-10 22:13:09',4,'64.125.181.75','64.125.181.75','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(58,0,'2011-05-10 22:24:46','2011-05-10 22:24:46',2,'64.125.181.75','64.125.181.75','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(59,0,'2011-05-11 06:20:33','2011-05-11 06:20:33',2,'80.239.242.176','80.239.242.176','Opera/9.80 (J2ME/MIDP; Opera Mini/4.1.13906/24.816; U; en) Presto/2.5.25 Version/10.54'),(60,0,'2011-05-15 14:54:11','2011-05-15 14:54:11',2,'76.102.30.157','76.102.30.157','Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'),(61,0,'2011-05-15 15:29:29','2011-05-15 15:29:29',8,'76.102.30.157','76.102.30.157','Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'),(62,0,'2011-05-15 15:35:24','2011-05-15 15:35:24',10,'76.102.30.157','76.102.30.157','Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'),(63,0,'2011-05-15 15:42:52','2011-05-15 15:42:52',6,'76.102.30.157','76.102.30.157','Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'),(64,0,'2011-05-15 15:43:28','2011-05-15 15:43:28',4,'76.102.30.157','76.102.30.157','Mozilla/5.0 (Windows NT 5.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'),(65,0,'2011-05-16 10:11:41','2011-05-16 10:11:41',2,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(66,0,'2011-05-19 05:15:57','2011-05-19 05:15:57',2,'117.229.76.114','117.229.76.114','Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'),(67,0,'2011-05-23 18:41:20','2011-05-23 18:41:20',7,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110420 Firefox/3.6.17'),(68,0,'2011-05-23 19:06:35','2011-05-23 19:06:35',4,'76.126.66.3','76.126.66.3','Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110420 Firefox/3.6.17'),(69,0,'2011-06-07 18:13:27','2011-06-07 18:13:27',2,'65.113.40.1','65.113.40.1','Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2'),(70,0,'2011-06-17 02:39:29','2011-06-17 02:39:29',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(71,0,'2011-06-17 02:40:06','2011-06-17 02:40:06',2,'113.193.201.20','113.193.201.20','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(72,0,'2011-06-17 03:44:39','2011-06-17 03:44:39',2,'113.193.193.91','113.193.193.91','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(73,0,'2011-06-17 03:46:28','2011-06-17 03:46:28',2,'113.193.193.91','113.193.193.91','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(74,0,'2011-06-17 07:13:30','2011-06-17 07:13:30',2,'113.193.201.20','113.193.201.20','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(75,0,'2011-06-17 13:46:58','2011-06-17 13:46:58',2,'113.193.201.20','113.193.201.20','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(76,0,'2011-06-17 15:26:13','2011-06-17 15:26:13',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(77,0,'2011-06-17 16:04:26','2011-06-17 16:04:26',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(78,0,'2011-06-24 01:27:09','2011-06-24 01:27:09',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(79,0,'2011-06-24 01:36:57','2011-06-24 01:36:57',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(80,0,'2011-06-24 07:36:47','2011-06-24 07:36:47',2,'113.193.205.174','113.193.205.174','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(81,0,'2011-06-24 08:29:07','2011-06-24 08:29:07',2,'113.193.205.174','113.193.205.174','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(82,0,'2011-06-28 14:28:44','2011-06-28 14:28:44',2,'113.193.205.105','113.193.205.105','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(83,0,'2011-06-28 14:31:47','2011-06-28 14:31:47',2,'113.193.205.105','113.193.205.105','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(84,0,'2011-06-28 14:34:47','2011-06-28 14:34:47',2,'113.193.205.105','113.193.205.105','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(85,0,'2011-06-28 14:37:14','2011-06-28 14:37:14',2,'113.193.205.105','113.193.205.105','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(86,0,'2011-06-28 22:13:18','2011-06-28 22:13:18',2,'113.193.201.116','113.193.201.116','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(87,0,'2011-06-28 22:50:13','2011-06-28 22:50:13',2,'113.193.201.116','113.193.201.116','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(88,0,'2011-06-29 00:40:31','2011-06-29 00:40:31',2,'113.193.201.116','113.193.201.116','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30'),(89,0,'2011-06-30 13:51:23','2011-06-30 13:51:23',2,'113.193.202.7','113.193.202.7','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'),(90,0,'2011-07-01 13:28:11','2011-07-01 13:28:11',2,'113.193.206.104','113.193.206.104','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'),(91,0,'2011-07-10 19:28:48','2011-07-10 19:28:48',2,'24.5.197.88','24.5.197.88','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'),(92,0,'2011-07-11 02:13:13','2011-07-11 02:13:13',2,'67.169.142.44','67.169.142.44','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'),(93,0,'2011-07-11 04:29:45','2011-07-11 04:29:45',2,'67.169.142.44','67.169.142.44','Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'),(94,0,'2011-07-12 19:38:12','2011-07-12 19:38:12',2,'64.134.225.132','64.134.225.132','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_5) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30'),(95,0,'2011-07-21 01:57:19','2011-07-21 01:57:19',2,'1.23.249.59','1.23.249.59','Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.122 Safari/534.30');
/*!40000 ALTER TABLE `login_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (1,0,'*',NULL,'','*',NULL,'profile:edit:1','grails.plugins.nimble.auth.WildcardPermission',1,'grails.plugins.nimble.core.Permission'),(2,0,'*',NULL,'','*',NULL,'profile:edit:2','grails.plugins.nimble.auth.WildcardPermission',2,'grails.plugins.nimble.core.Permission'),(3,0,'*',NULL,'','*',NULL,'*','grails.plugins.nimble.auth.AllPermission',2,'grails.plugins.nimble.core.Permission'),(4,0,'*',NULL,'\0','*',3,'portfolio:update','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(5,0,'*',NULL,'\0','*',3,'*:read','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(6,0,'*',NULL,'\0','*',3,'service:create,design,update','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(7,0,'*',NULL,'\0','*',3,'reports:show','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(8,0,'*',NULL,'\0','*',4,'service:design,update','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(9,0,'*',NULL,'\0','*',4,'*:read','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(10,0,'*',NULL,'\0','*',5,'service:design','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(11,0,'*',NULL,'\0','*',5,'*:read','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(12,0,'*',NULL,'\0','*',6,'*:read','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(13,0,'*',NULL,'\0','*',6,'quotation:create','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(14,0,'*',NULL,'\0','*',7,'*:read','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(15,0,'*',NULL,'\0','*',7,'deliveryRole:create','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(16,0,'*',NULL,'\0','*',7,'geo:create','grails.plugins.nimble.auth.WildcardPermission',NULL,'grails.plugins.nimble.core.LevelPermission'),(17,0,'*',NULL,'','*',NULL,'profile:edit:3','grails.plugins.nimble.auth.WildcardPermission',3,'grails.plugins.nimble.core.Permission'),(18,0,'*',NULL,'','*',NULL,'profile:edit:4','grails.plugins.nimble.auth.WildcardPermission',4,'grails.plugins.nimble.core.Permission'),(19,0,'*',NULL,'','*',NULL,'profile:edit:5','grails.plugins.nimble.auth.WildcardPermission',5,'grails.plugins.nimble.core.Permission'),(20,0,'*',NULL,'','*',NULL,'profile:edit:6','grails.plugins.nimble.auth.WildcardPermission',6,'grails.plugins.nimble.core.Permission'),(21,0,'*',NULL,'','*',NULL,'profile:edit:7','grails.plugins.nimble.auth.WildcardPermission',7,'grails.plugins.nimble.core.Permission'),(22,0,'*',NULL,'','*',NULL,'profile:edit:8','grails.plugins.nimble.auth.WildcardPermission',8,'grails.plugins.nimble.core.Permission'),(23,0,'*',NULL,'','*',NULL,'profile:edit:9','grails.plugins.nimble.auth.WildcardPermission',9,'grails.plugins.nimble.core.Permission'),(24,0,'*',NULL,'','*',NULL,'profile:edit:10','grails.plugins.nimble.auth.WildcardPermission',10,'grails.plugins.nimble.core.Permission'),(25,0,'*',NULL,'','*',NULL,'profile:edit:11','grails.plugins.nimble.auth.WildcardPermission',11,'grails.plugins.nimble.core.Permission'),(26,0,'*',NULL,'','*',NULL,'profile:edit:12','grails.plugins.nimble.auth.WildcardPermission',12,'grails.plugins.nimble.core.Permission'),(27,0,'*',NULL,'','*',NULL,'profile:edit:13','grails.plugins.nimble.auth.WildcardPermission',13,'grails.plugins.nimble.core.Permission');
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `portfolio`
--

LOCK TABLES `portfolio` WRITE;
/*!40000 ALTER TABLE `portfolio` DISABLE KEYS */;
INSERT INTO `portfolio` VALUES (2,0,'2011-05-04 15:22:19','Portfolio of service offerings designed to drive adoption of virtual desktop products.',8,'vDesktop','Published'),(3,0,'2011-05-04 15:23:10','Portfolio of services designed to drive adoption of nebulous clouds.\r\n',7,'vCloud','Published');
/*!40000 ALTER TABLE `portfolio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `portfolio__user`
--

LOCK TABLES `portfolio__user` WRITE;
/*!40000 ALTER TABLE `portfolio__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `portfolio__user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `profile_base`
--

LOCK TABLES `profile_base` WRITE;
/*!40000 ALTER TABLE `profile_base` DISABLE KEYS */;
INSERT INTO `profile_base` VALUES (1,0,'2011-05-03 21:51:23',NULL,NULL,'Test User','2011-05-03 21:51:23',NULL,NULL,'com.valent.pricewell.Profile'),(2,0,'2011-05-03 21:51:23',NULL,NULL,'Administrator','2011-05-03 21:51:23',NULL,NULL,'com.valent.pricewell.Profile'),(3,0,'2011-05-04 15:03:25','tbadmun@valent-sw.com','f4eb12133998b0f74277af36961e4891','Tracy Badmun','2011-05-04 15:03:25',NULL,NULL,'com.valent.pricewell.Profile'),(4,0,'2011-05-04 15:06:11','rswanson@valent-sw.com','12a269e5737ad7e3682a6d725b2c22a7','Rick Swanson','2011-05-04 15:06:11',NULL,NULL,'com.valent.pricewell.Profile'),(5,0,'2011-05-04 15:07:55','nronde@valent-sw.com','d635fc75009d4abdd092334c35576cf2','Nathaniel Ronde','2011-05-04 15:07:55',NULL,NULL,'com.valent.pricewell.Profile'),(6,0,'2011-05-04 15:10:47','jpodge@valent-sw.com','02f7224254b6cc2748e05e18688c41c4','John Podge','2011-05-04 15:10:47',NULL,NULL,'com.valent.pricewell.Profile'),(7,0,'2011-05-04 15:12:35','jcubeline@valent-sw.com','2a9a33a495ad5ad4369f6652e35e47fd','Jennifer Cubeline','2011-05-04 15:12:35',NULL,NULL,'com.valent.pricewell.Profile'),(8,0,'2011-05-04 15:15:33','anot@valent-sw.com','4a569b4aeb828024e77690ff20ff7b52','Andy Not','2011-05-04 15:15:33',NULL,NULL,'com.valent.pricewell.Profile'),(9,0,'2011-05-04 15:17:31','blinman@valent-sw.com','aa89cb54a873ba3eeff65b94379eaf86','Ben Linman','2011-05-04 15:17:31',NULL,NULL,'com.valent.pricewell.Profile'),(10,0,'2011-05-04 15:19:11','dlang@valentsw.com','bacd14d3c6ed37595b69a741d8e60f7b','Dale Lang','2011-05-04 15:19:11',NULL,NULL,'com.valent.pricewell.Profile'),(11,0,'2011-05-04 19:04:34','qturner@valent-sw.com','4b513cc037c00fb04bf8c8bb0253ed94','Queensly Turner','2011-05-04 19:04:34',NULL,NULL,'com.valent.pricewell.Profile'),(12,0,'2011-05-04 20:02:24','mreece@valent-sw.com','3fdf7cd9b33397a253c07877ca845091','Michelle Reece','2011-05-04 20:02:24',NULL,NULL,'com.valent.pricewell.Profile'),(13,0,'2011-06-28 14:35:45','ratan_30@yahoo.co.in','dfb1841d7abee2def35d036caa012734','Ratan Mistry','2011-06-28 14:35:45',NULL,NULL,'com.valent.pricewell.Profile');
/*!40000 ALTER TABLE `profile_base` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `quotation`
--

LOCK TABLES `quotation` WRITE;
/*!40000 ALTER TABLE `quotation` DISABLE KEYS */;
INSERT INTO `quotation` VALUES (1,3,4,'2011-05-04 17:08:52','Acme Investments, LLC','Financial Services',1,'2011-05-04 17:08:52','QUOTE',12656.2),(2,2,12,'2011-05-04 20:04:02','Plenty Of Fish dot Com','Dot Com',3,'2011-05-04 20:04:02','QUOTE',49640.6),(3,1,4,'2011-05-23 19:08:49','Tim M.','Expert',3,'2011-05-23 19:08:49','QUOTE',3289.06);
/*!40000 ALTER TABLE `quotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `relation_delivery_geo`
--

LOCK TABLES `relation_delivery_geo` WRITE;
/*!40000 ALTER TABLE `relation_delivery_geo` DISABLE KEYS */;
INSERT INTO `relation_delivery_geo` VALUES (1,0,400,1,1,600),(2,0,30000,1,4,55000),(3,0,350,1,2,500),(4,0,375,1,3,550),(5,0,1000,2,1,1750),(6,0,90000,2,4,160000),(7,0,700,2,2,1450),(8,0,750,2,3,1500),(9,0,800,3,1,1400),(10,0,66000,3,4,110000),(11,0,600,3,2,1300),(12,0,700,3,3,1400);
/*!40000 ALTER TABLE `relation_delivery_geo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `review_comment`
--

LOCK TABLES `review_comment` WRITE;
/*!40000 ALTER TABLE `review_comment` DISABLE KEYS */;
INSERT INTO `review_comment` VALUES (1,0,'The customer deliverables look good and the ballpark estimate on delivery time and market size are compelling.  Concept is approved for further development.','2011-05-04 17:21:13','2011-05-04 17:21:13',1,'Stage changed from REVIEW to APPROVED',8),(2,0,'Thanks John - let\'s do it. ','2011-05-04 17:34:08','2011-05-04 17:34:08',2,'Stage changed from REVIEW to APPROVED',10),(3,0,'Approved for sales.','2011-05-04 17:53:10','2011-05-04 17:53:10',4,'Stage changed from REVIEW to APPROVED',8),(4,0,'Nathaniel - looks compelling.  Please proceed and get a design estimate.','2011-05-04 18:56:41','2011-05-04 18:56:41',5,'Stage changed from REVIEW to APPROVED',7),(5,0,'I\'ve adjusted everything and request design approval.','2011-05-04 19:45:26','2011-05-04 19:45:25',6,'Stage changed from REVIEW to REVIEW',11),(6,0,'Looks great, team!  Kudos to Nathaniel and Queensly for a job well done to complete this one early :)','2011-05-04 19:50:14','2011-05-04 19:50:14',7,'Stage changed from REVIEW to APPROVED',7),(7,0,'OK, ready for sales operations.  GO SELL!','2011-05-04 19:53:38','2011-05-04 19:53:38',8,'Stage changed from REVIEW to APPROVED',3),(8,0,'GO SELL.  Nebulous cloud storm to ensue,,,','2011-05-04 19:55:55','2011-05-04 19:55:55',9,'Stage changed from REVIEW to APPROVED',3),(9,0,'','2011-05-15 15:33:09','2011-05-15 15:33:09',3,'Stage changed from REVIEW to REVIEW',8),(10,0,'','2011-05-15 15:33:18','2011-05-15 15:33:18',3,'Stage changed from REVIEW to REJECTED',8);
/*!40000 ALTER TABLE `review_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `review_request`
--

LOCK TABLES `review_request` WRITE;
/*!40000 ALTER TABLE `review_request` DISABLE KEYS */;
INSERT INTO `review_request` VALUES (1,1,'2011-05-04 17:18:36','2011-05-04 17:18:36','Hi Andy,\r\n\r\nBased on the customer deliverables I\'ve defined and the market opportunity, can you approve this service for concept approval so that I  can get an estimate on service development time from the service design team?','',1,'APPROVED','Review for Concept Approval for Migration Planning Service ',10),(2,1,'2011-05-04 17:33:26','2011-05-04 17:33:26','Hi Dale,\r\n\r\nI\'ve fleshed out all of the key activities and think that the service engineering work can be completed in about 21 person days of effort.  Sounds good.  What\'s your budget?','',1,'APPROVED','Review of Design for Migration Planning Service ',6),(3,2,'2011-05-04 17:50:26','2011-05-04 17:50:25','Andy - please review for sales readiness and approval.','',1,'REJECTED','Sales Review Request for Migration Planning Service ',10),(4,1,'2011-05-04 17:52:37','2011-05-04 17:52:37','Ben and Tracy - please publish this new Migration Planning Service.','',1,'APPROVED','Request to publish for Migration Planning Service ',8),(5,1,'2011-05-04 18:55:15','2011-05-04 18:55:15','Jennifer - I think we have all the right stuff now that I have the customer facing work products for this Nebulous Cloudstart offering figured out.  Don\'t you agree?\r\n','',2,'APPROVED','Review for Concept Approval for Nebulous Cloudstart',5),(6,1,'2011-05-04 19:07:53','2011-05-04 19:07:53','Queensly - since you have been assigned as the new service design lead, can you please review the current state and send me any revisions for approval?  We need to get this out the door!','',2,'REVIEW','Review of Design for Nebulous Cloudstart',5),(7,1,'2011-05-04 19:48:14','2011-05-04 19:48:14','Jennifer - after lots of hard work by Queensly, this service is ready to add to the catalog.  Can you please review for sales readiness?','',2,'APPROVED','Sales Review Request for Nebulous Cloudstart',5),(8,1,'2011-05-04 19:52:37','2011-05-04 19:52:37','For release to price list','',2,'APPROVED','Publication Review',7),(9,1,'2011-05-04 19:54:51','2011-05-04 19:54:51','Tracy - please approve for publication to the current sales catalog','',2,'APPROVED','Request to publish for Nebulous Cloudstart',7);
/*!40000 ALTER TABLE `review_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `review_request__user`
--

LOCK TABLES `review_request__user` WRITE;
/*!40000 ALTER TABLE `review_request__user` DISABLE KEYS */;
INSERT INTO `review_request__user` VALUES (1,8),(2,10),(3,8),(4,9),(5,7),(6,11),(7,7),(8,3),(9,3);
/*!40000 ALTER TABLE `review_request__user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,2,2,'2011-05-04 15:27:25','2011-05-04 15:27:25',NULL,NULL,2,10,'Migration Planning Service ',1,'VDI-MIGRATE','vdi desktop migration'),(2,3,7,'2011-05-04 18:48:10','2011-05-04 18:48:10','Installation and demonstration of a reference implementation of up to 3 nebulous clouds using Nebulousity software.',NULL,3,5,'Nebulous Cloudstart',2,'CS-NEB','nebulous cloudstart cloud vCloud ');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service__user`
--

LOCK TABLES `service__user` WRITE;
/*!40000 ALTER TABLE `service__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `service__user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_activity`
--

LOCK TABLES `service_activity` WRITE;
/*!40000 ALTER TABLE `service_activity` DISABLE KEYS */;
INSERT INTO `service_activity` VALUES (1,0,'Gather key customer data',NULL,1,0,'Review Customer Order',NULL,1,1),(2,2,'Documentation',NULL,20,0.1,'Create Proposal','Migration Plan for each unit',1,2),(3,2,'Customer Acceptance','Customer Acceptance',6,0,'Engagement Wrap-up','Signed CAF Received',1,3),(4,3,'Meeting','Remote or On Site',4,0,'Orient Customer','Oriented customer',2,4),(5,3,'Phone call - prep','Preparation for Orientation',4,0,'Prepare Customer for Orientation','Customer prepared for orientation',1,4),(6,2,'Architect Time','Prepare customer facing drawings',5,0.125,'Modify template drawings for customer specific characteristics','Customer ready VISIO diagrams',1,5),(7,2,'Customer BOM','Prepare and tailor parts list for customer implementation',4,0,'Review and Finalize Parts List','Final BOM',1,6),(8,0,'INFRASTRUCTURE','Reference solution',4,0.125,'Install Reference Implementation','Ready to demo reference solution',1,7);
/*!40000 ALTER TABLE `service_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_activity_delivery_role`
--

LOCK TABLES `service_activity_delivery_role` WRITE;
/*!40000 ALTER TABLE `service_activity_delivery_role` DISABLE KEYS */;
INSERT INTO `service_activity_delivery_role` VALUES (2,3),(3,1),(4,1),(5,1),(6,2),(7,3);
/*!40000 ALTER TABLE `service_activity_delivery_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_deliverable`
--

LOCK TABLES `service_deliverable` WRITE;
/*!40000 ALTER TABLE `service_deliverable` DISABLE KEYS */;
INSERT INTO `service_deliverable` VALUES (1,1,'Presentation delivery to customer','Project Kick-off Presentation',1,1,'Presentation'),(2,1,'Proposal for migrating desktops','Desktop Migration Proposal',2,1,'PDF'),(3,1,'Summarize and review migration proposal','Customer Project Review',3,1,'Meeting'),(4,2,'web conference or on-site','Cloudstart Orientation',1,2,'PPT / Meeting'),(5,1,'Reference Implementation Diagrams','Architecture Drawings',2,2,'VISIO'),(6,1,'List of all products included in reference implemenation','Bill of Materials',3,2,'WORD'),(7,1,'Demonstrable Reference Implementation','Reference Nebulous Cloud Implementation',4,2,'INFRASTRUCTURE');
/*!40000 ALTER TABLE `service_deliverable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_product_item`
--

LOCK TABLES `service_product_item` WRITE;
/*!40000 ALTER TABLE `service_product_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_product_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_product_item_service_profile`
--

LOCK TABLES `service_product_item_service_profile` WRITE;
/*!40000 ALTER TABLE `service_product_item_service_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_product_item_service_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_profile`
--

LOCK TABLES `service_profile` WRITE;
/*!40000 ALTER TABLE `service_profile` DISABLE KEYS */;
INSERT INTO `service_profile` VALUES (1,17,20,'2011-05-04 15:27:25','2011-05-04 15:27:25',NULL,0,1,1,6,10,80,3,'DEVELOP','Desktop','1.0'),(2,20,3,'2011-05-04 18:48:10','2011-05-04 18:48:10',NULL,0,1,2,11,10,40,4,'DEVELOP','Nebulous Cloud','1.0');
/*!40000 ALTER TABLE `service_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_profile__user`
--

LOCK TABLES `service_profile__user` WRITE;
/*!40000 ALTER TABLE `service_profile__user` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile__user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_profile_delivery_role`
--

LOCK TABLES `service_profile_delivery_role` WRITE;
/*!40000 ALTER TABLE `service_profile_delivery_role` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_profile_delivery_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_quotation`
--

LOCK TABLES `service_quotation` WRITE;
/*!40000 ALTER TABLE `service_quotation` DISABLE KEYS */;
INSERT INTO `service_quotation` VALUES (1,0,1,4037.5,1,1,1,25),(2,0,1,6225,1,1,1,150),(3,0,1,2393.75,2,1,2,3),(4,0,3,2328.12,2,2,2,9),(5,0,3,47312.5,1,2,1,2500),(6,0,3,3289.06,2,3,2,50);
/*!40000 ALTER TABLE `service_quotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `staging`
--

LOCK TABLES `staging` WRITE;
/*!40000 ALTER TABLE `staging` DISABLE KEYS */;
INSERT INTO `staging` VALUES (1,0,'conceptulization','Conceptulization','SERVICE','conceptulization',1),(2,0,'reviewForConceptApproval','Review for Concept Approval','SERVICE','reviewForConceptApproval',2),(3,0,'conceptApproved','Concept Approved','SERVICE','conceptApproved',3),(4,0,'design','Design','SERVICE','design',4),(5,0,'reviewOfDesign','Review of Design','SERVICE','reviewOfDesign',5),(6,0,'designApproved','Design Approved','SERVICE','designApproved',6),(7,0,'Sales Review Request','Sales Review Request','SERVICE','salesReviewRequest',7),(8,0,'Sales Approval','Sales Approval','SERVICE','salesApproval',8),(9,0,'Request to publish','Request to publish','SERVICE','requestForPublished',9),(10,0,'Published','Published','SERVICE','published',10),(11,0,'Request to remove','Request to remove','SERVICE','requestToRemove',21),(12,0,'Removed','Removed','SERVICE','removed',22);
/*!40000 ALTER TABLE `staging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `staging_log`
--

LOCK TABLES `staging_log` WRITE;
/*!40000 ALTER TABLE `staging_log` DISABLE KEYS */;
INSERT INTO `staging_log` VALUES (1,0,'Upgrade','Hi Andy,\r\n\r\nBased on the customer deliverables I\'ve defined and the market opportunity, can you approve this service for concept approval so that I  can get an estimate on service development time from the service design team?','2011-05-04 17:18:28','Conceptulization','dlang',0,1,'Review for Concept Approval'),(2,0,'Upgrade','Deliverables look good, market opportunity looks compelling.  This concept is approved for the next step - getting a development time estimate and resource plan from the service design team.\r\n\r\nBest wishes on next steps, Dale...','2011-05-04 17:23:31','Review for Concept Approval','anot',0,1,'Concept Approved'),(3,0,'Upgrade','Approved for design estimate.','2011-05-04 17:26:10','Concept Approved','dlang',0,1,'Design'),(4,0,'Upgrade','Hi Dale,\r\n\r\nI\'ve fleshed out all of the key activities and think that the service engineering work can be completed in about 21 person days of effort.  Sounds good.  What\'s your budget?','2011-05-04 17:33:19','Design','jpodge',0,1,'Review of Design'),(5,0,'Upgrade','approved','2011-05-04 17:49:44','Review of Design','dlang',0,1,'Design Approved'),(6,0,'Upgrade','Andy - please review for sales readiness and approval.','2011-05-04 17:50:17','Design Approved','dlang',0,1,'Sales Review Request'),(7,0,'Upgrade','Approved for release to production sales catalog.','2011-05-04 17:51:37','Sales Review Request','anot',0,1,'Sales Approval'),(8,0,'Upgrade','Ben and Tracy - please publish this new Migration Planning Service.','2011-05-04 17:52:14','Sales Approval','anot',0,1,'Request to publish'),(9,0,'Upgrade','Released to the published production sales catalog and global distribution.','2011-05-04 17:54:12','Request to publish','anot',0,1,'Published'),(10,0,'Upgrade','Jennifer - I think we have all the right stuff now that I have the customer facing work products for this Nebulous Cloudstart offering figured out.  Don\'t you agree?\r\n','2011-05-04 18:55:04','Conceptulization','nronde',0,2,'Review for Concept Approval'),(11,0,'Upgrade','Nathaniel - looks compelling.  Please proceed with getting a design estimate.  Any early indication of ROI and TCO?','2011-05-04 18:58:22','Review for Concept Approval','jcubeline',0,2,'Concept Approved'),(12,0,'Upgrade','Hi John - thanks for the guestimate we discussed in our meeting.  Based on 60 days of effort and the size of the market opportunity and our ability to execute - please MOVE ON TO DESIGN :)','2011-05-04 19:01:32','Concept Approved','nronde',0,2,'Design'),(13,0,'Upgrade','Queensly - since you have been assigned as the new service design lead, can you please review the current state and send me any revisions for approval?  We need to get this out the door!','2011-05-04 19:07:50','Design','nronde',0,2,'Review of Design'),(14,0,'Upgrade','Great work, Queensly!  I\'m ready to ask jennifer for publication staging.','2011-05-04 19:46:58','Review of Design','nronde',0,2,'Design Approved'),(15,0,'Upgrade','Jennifer - after lots of hard work by Queensly, this service is ready to add to the catalog.  Can you please review for sales readiness?','2011-05-04 19:48:07','Design Approved','nronde',0,2,'Sales Review Request'),(16,0,'Upgrade','Approved for release to sales catalog.','2011-05-04 19:50:55','Sales Review Request','jcubeline',0,2,'Sales Approval'),(17,0,'Upgrade','Tracy - please approve for publication to the current sales catalog','2011-05-04 19:54:45','Sales Approval','jcubeline',0,2,'Request to publish'),(18,0,'Upgrade','Ready to sell per approval from Tracy Badmun.','2011-05-04 19:56:54','Request to publish','jcubeline',0,2,'Published');
/*!40000 ALTER TABLE `staging_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `staging_types`
--

LOCK TABLES `staging_types` WRITE;
/*!40000 ALTER TABLE `staging_types` DISABLE KEYS */;
INSERT INTO `staging_types` VALUES (1,'BEGIN_NEW'),(1,'NEW_STAGE'),(2,'NEW_STAGE'),(2,'REVIEW_REQUEST'),(3,'APPROVAL'),(3,'NEW_STAGE'),(4,'BEGIN_EDIT'),(4,'EDIT_STAGE'),(4,'NEW_STAGE'),(5,'EDIT_STAGE'),(5,'NEW_STAGE'),(5,'REVIEW_REQUEST'),(6,'APPROVAL'),(6,'EDIT_STAGE'),(6,'NEW_STAGE'),(7,'EDIT_STAGE'),(7,'NEW_STAGE'),(7,'REVIEW_REQUEST'),(8,'APPROVAL'),(8,'EDIT_STAGE'),(8,'NEW_STAGE'),(9,'EDIT_STAGE'),(9,'NEW_STAGE'),(9,'REVIEW_REQUEST'),(10,'EDIT_STAGE'),(10,'END_EDIT'),(10,'END_NEW'),(10,'NEW_STAGE'),(11,'BEGIN_REMOVE'),(11,'REMOVE_STAGE'),(11,'REVIEW_REQUEST'),(12,'APPROVAL'),(12,'END_REMOVE'),(12,'REMOVE_STAGE');
/*!40000 ALTER TABLE `staging_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `url`
--

LOCK TABLES `url` WRITE;
/*!40000 ALTER TABLE `url` DISABLE KEYS */;
/*!40000 ALTER TABLE `url` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-07-26 20:54:22
