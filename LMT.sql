/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.10-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: LMT
-- ------------------------------------------------------
-- Server version	10.11.10-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Author`
--

DROP TABLE IF EXISTS `Author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Author` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Author`
--

LOCK TABLES `Author` WRITE;
/*!40000 ALTER TABLE `Author` DISABLE KEYS */;
/*!40000 ALTER TABLE `Author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BookDescription`
--

DROP TABLE IF EXISTS `BookDescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BookDescription` (
  `ISBN` bigint(13) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `pubYear` int(11) DEFAULT NULL,
  `synopsis` text DEFAULT NULL,
  `totalStock` int(11) DEFAULT NULL,
  PRIMARY KEY (`ISBN`),
  KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BookDescription`
--

LOCK TABLES `BookDescription` WRITE;
/*!40000 ALTER TABLE `BookDescription` DISABLE KEYS */;
/*!40000 ALTER TABLE `BookDescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Book_Author`
--

DROP TABLE IF EXISTS `Book_Author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Book_Author` (
  `bISBN` bigint(20) NOT NULL,
  `authorId` int(11) NOT NULL,
  PRIMARY KEY (`bISBN`,`authorId`),
  KEY `authorId` (`authorId`),
  CONSTRAINT `Book_Author_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Book_Author_ibfk_2` FOREIGN KEY (`authorId`) REFERENCES `Author` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Book_Author`
--

LOCK TABLES `Book_Author` WRITE;
/*!40000 ALTER TABLE `Book_Author` DISABLE KEYS */;
/*!40000 ALTER TABLE `Book_Author` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Book_Genre`
--

DROP TABLE IF EXISTS `Book_Genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Book_Genre` (
  `bISBN` bigint(13) NOT NULL,
  `gId` int(11) NOT NULL,
  PRIMARY KEY (`bISBN`,`gId`),
  KEY `gId` (`gId`),
  CONSTRAINT `Book_Genre_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Book_Genre_ibfk_2` FOREIGN KEY (`gId`) REFERENCES `Genre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Book_Genre`
--

LOCK TABLES `Book_Genre` WRITE;
/*!40000 ALTER TABLE `Book_Genre` DISABLE KEYS */;
/*!40000 ALTER TABLE `Book_Genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Book_Series`
--

DROP TABLE IF EXISTS `Book_Series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Book_Series` (
  `bISBN` bigint(20) NOT NULL,
  `seriesId` int(11) NOT NULL,
  PRIMARY KEY (`bISBN`,`seriesId`),
  KEY `seriesId` (`seriesId`),
  CONSTRAINT `Book_Series_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Book_Series_ibfk_2` FOREIGN KEY (`seriesId`) REFERENCES `Series` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Book_Series`
--

LOCK TABLES `Book_Series` WRITE;
/*!40000 ALTER TABLE `Book_Series` DISABLE KEYS */;
/*!40000 ALTER TABLE `Book_Series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Checkout`
--

DROP TABLE IF EXISTS `Checkout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Checkout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bISBN` bigint(13) NOT NULL,
  `uId` int(11) NOT NULL,
  `dueDate` date NOT NULL,
  `returned` tinyint(1) DEFAULT 0,
  `renew` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `bISBN` (`bISBN`),
  KEY `uId` (`uId`),
  CONSTRAINT `Checkout_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Checkout_ibfk_2` FOREIGN KEY (`uId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Checkout`
--

LOCK TABLES `Checkout` WRITE;
/*!40000 ALTER TABLE `Checkout` DISABLE KEYS */;
/*!40000 ALTER TABLE `Checkout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genre`
--

DROP TABLE IF EXISTS `Genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Genre` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `genreName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `genreName` (`genreName`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genre`
--

LOCK TABLES `Genre` WRITE;
/*!40000 ALTER TABLE `Genre` DISABLE KEYS */;
/*!40000 ALTER TABLE `Genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Hold`
--

DROP TABLE IF EXISTS `Hold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Hold` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bISBN` bigint(13) NOT NULL,
  `uId` int(11) NOT NULL,
  `end` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bISBN` (`bISBN`),
  KEY `uId` (`uId`),
  CONSTRAINT `Hold_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Hold_ibfk_2` FOREIGN KEY (`uId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Hold`
--

LOCK TABLES `Hold` WRITE;
/*!40000 ALTER TABLE `Hold` DISABLE KEYS */;
/*!40000 ALTER TABLE `Hold` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rating`
--

DROP TABLE IF EXISTS `Rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bISBN` bigint(13) NOT NULL,
  `uId` int(11) NOT NULL,
  `stars` int(11) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bISBN` (`bISBN`),
  KEY `uId` (`uId`),
  CONSTRAINT `Rating_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Rating_ibfk_2` FOREIGN KEY (`uId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rating`
--

LOCK TABLES `Rating` WRITE;
/*!40000 ALTER TABLE `Rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `Rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Register`
--

DROP TABLE IF EXISTS `Register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Register` (
  `username` varchar(100) NOT NULL,
  `password` varbinary(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `validTimeout` timestamp NOT NULL,
  `valcode` char(6) NOT NULL,
  `salt` varbinary(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Register`
--

LOCK TABLES `Register` WRITE;
/*!40000 ALTER TABLE `Register` DISABLE KEYS */;
/*!40000 ALTER TABLE `Register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Series`
--

DROP TABLE IF EXISTS `Series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Series` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Series`
--

LOCK TABLES `Series` WRITE;
/*!40000 ALTER TABLE `Series` DISABLE KEYS */;
/*!40000 ALTER TABLE `Series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varbinary(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `salt` varbinary(50) DEFAULT NULL,
  `librarian` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES
(5,'test1','$2b$12$AM.KkF6tDtU0xI9ez3z2m.hJ16K5gnSg2k2OnedZSd7ESo8VDAoIq','bspat11037@gmail.com','$2b$12$AM.KkF6tDtU0xI9ez3z2m.',0),
(6,'Beth','$2b$12$xP6QCC5gegV8KQ/tVnTiM.v6j12/ECaM2aEgtYqya/2w8g6hdJL4i','bspat11037@gmail.com','$2b$12$xP6QCC5gegV8KQ/tVnTiM.',1);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Waitlist`
--

DROP TABLE IF EXISTS `Waitlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Waitlist` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bISBN` bigint(13) NOT NULL,
  `uId` int(11) NOT NULL,
  `submit` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `bISBN` (`bISBN`),
  KEY `uId` (`uId`),
  CONSTRAINT `Waitlist_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Waitlist_ibfk_2` FOREIGN KEY (`uId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Waitlist`
--

LOCK TABLES `Waitlist` WRITE;
/*!40000 ALTER TABLE `Waitlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `Waitlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-18 20:59:45
