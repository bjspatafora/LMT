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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Author`
--

LOCK TABLES `Author` WRITE;
/*!40000 ALTER TABLE `Author` DISABLE KEYS */;
INSERT INTO `Author` VALUES
(1,'Marissa Meyer');
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
  PRIMARY KEY (`ISBN`),
  KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BookDescription`
--

LOCK TABLES `BookDescription` WRITE;
/*!40000 ALTER TABLE `BookDescription` DISABLE KEYS */;
INSERT INTO `BookDescription` VALUES
(9781250007209,'Cinder',2013,'Humans and androids crowd the raucous streets of New Beijing. A deadly plague ravages the population. From space, a ruthless lunar people watch, waiting to make their move. No one knows that Earth\'s fate hinges on one girl.... Sixteen-year-old Cinder, a gifted mechanic, is a cyborg. She\'s a second-class citizen with a mysterious past and is reviled by her stepmother. But when her life becomes intertwined with the handsome Prince Kai\'s, she suddenly finds herself at the center of an intergalactic struggle, and a forbidden attraction. Caught between duty and freedom, loyalty and betrayal, she must uncover secrets about her past in order to protect her worlds future. Becuase there is something unusual about Cinder, something that others would kill for.'),
(9781250007216,'Scarlet',2014,'Cinder, the cyborg mechanic, returns in the second thrilling installment of the bestselling Lunar Chronicles. She is trying to break out of prison -even though if she succeeds, shell be the Commonwealth\'s most wanted fugitive. Halfway around the world, Scarlet Benoit\'s grandmother is missing. When Scarlet encounters Wolf, a street fighter who may have information about her grandmother\'s whereabouts, she is loath to trust this stranger, but is inexplicably drawn to him, and he to her. As Scarlet and Wolf unravel one mystery, they encounter another when they meet Cinder. Now, all of them must stay one step ahead of the vicious Lunar Queen Levana, who will do anything for the handsome Prince Kai to become her husband, her king, her prisoner.'),
(9781250007223,'Cress',2015,'Cress, having risked everything to warn Cinder of Queen Levana\'s evil plan, has a slight problem. She\'s been imprisooned on a satellite since childhood and has only ever had her netscreens as company. All that screen time has made Cress an excellent hacker. Unfortunately, she\'s just received orders from Levana to track down Cinder and her handsome accomplice. When a daring rescue of Cress involving Cinder, Captain Thorne, Scarlet, and Wolf goes awry, the gropu is separated. Cress finally has her freedom, but it comes at a high price. Meanwhile, Queen Levana will let nothing prevent her marriage to Emperor Kai. Cress, Scarlet, and Cinder may not have signed up to save the world, but they may be the only hope the world has.'),
(9781250069665,'Fairest',2015,'Queen Levana is a ruler who uses her \'glamour\' to gain power. But long before she crossed paths with Cinder, Scarlet, and Cress, Levana lived a very different story-a story that has never been told... until now'),
(9781250074218,'Winter',2015,'Princess Winter is admired by the Lunar people for her grace and kindness, and despite the scars that mark her face, her beauty is said to be more breathtaking than that of her stepmother, Queen Levana. Winter despises her stepmother, and knows Levana won\'t approve of her feelings for her childhood friend--the handsome palace guard, Jacin. But Winter isn\'t as weak as Levana believes her to be and she\'s been undermining her stepmother\'s wishes for years. Together with the cyborg, Cinder, and her allies, Winter might even have the power to launch a revolution and win a war that\'s been raging for far too long. Can Cinder, Scarlet, Cress, and Winter defeat Levana and find their happily ever afters?'),
(9781250104458,'Stars Above',2016,'The universe of the Lunar Chronicles holds stories—and secrets—that are wondrous, vicious, and romantic. How did Cinder first arrive in New Beijing? How did the brooding soldier Wolf transform from young man to killer? When did Princess Winter and the palace guard Jacin realize their destinies?');
/*!40000 ALTER TABLE `BookDescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BookGenre`
--

DROP TABLE IF EXISTS `BookGenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BookGenre` (
  `bISBN` bigint(20) DEFAULT NULL,
  `genre` varchar(20) DEFAULT NULL,
  KEY `bISBN` (`bISBN`),
  CONSTRAINT `BookGenre_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BookGenre`
--

LOCK TABLES `BookGenre` WRITE;
/*!40000 ALTER TABLE `BookGenre` DISABLE KEYS */;
INSERT INTO `BookGenre` VALUES
(9781250007209,'Fantasy'),
(9781250007223,'Fantasy'),
(9781250069665,'Fantasy'),
(9781250007216,'Fantasy'),
(9781250104458,'Fantasy'),
(9781250074218,'Fantasy'),
(9781250007209,'Science Fiction'),
(9781250007223,'Science Fiction'),
(9781250069665,'Science Fiction'),
(9781250007216,'Science Fiction'),
(9781250104458,'Science Fiction'),
(9781250074218,'Science Fiction'),
(9781250007209,'Fiction'),
(9781250007223,'Fiction'),
(9781250069665,'Fiction'),
(9781250007216,'Fiction'),
(9781250104458,'Fiction'),
(9781250074218,'Fiction'),
(9781250007209,'Romance'),
(9781250007223,'Romance'),
(9781250069665,'Romance'),
(9781250007216,'Romance'),
(9781250104458,'Romance'),
(9781250074218,'Romance');
/*!40000 ALTER TABLE `BookGenre` ENABLE KEYS */;
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
INSERT INTO `Book_Author` VALUES
(9781250007209,1),
(9781250007216,1),
(9781250007223,1),
(9781250069665,1),
(9781250074218,1),
(9781250104458,1);
/*!40000 ALTER TABLE `Book_Author` ENABLE KEYS */;
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
INSERT INTO `Book_Series` VALUES
(9781250007209,1),
(9781250007216,1),
(9781250007223,1),
(9781250069665,1),
(9781250074218,1),
(9781250104458,1);
/*!40000 ALTER TABLE `Book_Series` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Series`
--

LOCK TABLES `Series` WRITE;
/*!40000 ALTER TABLE `Series` DISABLE KEYS */;
INSERT INTO `Series` VALUES
(1,'Lunar Chronicles');
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
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES
(5,'test1','$2b$12$AM.KkF6tDtU0xI9ez3z2m.hJ16K5gnSg2k2OnedZSd7ESo8VDAoIq','bspat11037@gmail.com','$2b$12$AM.KkF6tDtU0xI9ez3z2m.');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-13 19:13:43
