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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Author`
--

LOCK TABLES `Author` WRITE;
/*!40000 ALTER TABLE `Author` DISABLE KEYS */;
INSERT INTO `Author` VALUES
(13,'Craig Larman'),
(17,'Desmond Meade'),
(14,'Douglas Adams'),
(10,'Jamie Ford'),
(22,'Kenneth H. Rosen'),
(12,'Lawrence C. Washington'),
(18,'Maggie Stiefvater'),
(19,'Maggie Stiefvater'),
(20,'Maggie Stiefvater'),
(21,'Maggie Stiefvater'),
(9,'Marissa Meyer'),
(15,'Naomi Novik'),
(16,'Tricia Sullivan'),
(11,'Wade Trappe');
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
INSERT INTO `BookDescription` VALUES
(131489062,'Applying UML and Patterns',2005,'Draawing on his unsurpassed experience as a mentor and consultant, Larman helps you understand evolutionary requirements and use cases, domain object modeling, responsibility-driven design, essential OO design, layered architectures, \"Gang of Four\" design patterns, GRASP, iterative methods, an agile approach to the Unified Process (UP), and much more.',5),
(978059312850,'A Deadly Education',2020,'I decided that Orion Lake needed to die after the second time he saved my life. Everyone loves Orion Lake. Everyone else, that is. Far as I\'m concerned, he can keep his flashy combat magic to himself. I\'m not joining his pack of adoring fans. I don\'t need help surviving the Scholomance, even if they do. Forget the hordes of monsters and cursed artifacts- I\'m probably the most dangerous thing in the place. Just give me a chance and I\'ll level mountains and kill untold millions, make myself the dark queen of the world. At least, that\'s what the world expects. Most of the other students in here would be delighted if Orion killed me like one more evil thing that\'s crawled out of the drains. Sometimes I think they want me to turn into the evil witch they assume I am. The school certainly does. But the Scholomance isn\'t getting what it wants from me. And neither is Orion Lake. I may not be anyone\'s idea of the shining hero, but I\'m going to make it out of this place alive, and I\'m not oging to slaughter thousands to do it, either. Although I\'m giving serious consideration to just one.',5),
(9780134860992,'Introduction to Cryptography with Number Theory',2020,'This book is based on a course in cryptography at the upper-level undergraduate and beginning graduate level that has been given at the University of Maryland since 1997, and a course that has been taught at Rutgers University since 2003',4),
(9780345453747,'The Ultimate Hitchhiker\'s Guide to the Galaxy',2002,'Seconds before the Earth is demolished for a galactic freeway, Arthur Dent is saved by Ford Prefect, a researcher for the revised Guide. Together they stick out their thumbs to the stars and begin a wild journey through time and space.',1),
(9780545424936,'The Raven Boys',2012,'Every year, Blue Sargent stands next to her clairvoyant mother as the soon-to-be dead walk past. Blue never sees them- until this year, when a boy emerges from the dark and speaks to her. His name is Gansey, and he\'s a rich student at Aglionby, the local private school. Blue has a policy of staying away from Aglionby boys. Known as Raven Boys, they can only mean trouble. But Blue is drawn to Gansey, in a way she can\'t entirely explain. He is on a quest that has encompassed three other Raven Boys: Adam, the scholarship student who resents the privilege around him; Ronan, the fierce soul whose emotions range from anger to despair; and Noah, the taciturn watccher who notices many things but says very little. For as long as she can remember, Blue has been warned that she will cause her true love to die. She doesn\'t believe in true love and never though this would be a problem. But as her life becomes caught up in the strange and sinister world of the Raven Boys, she\'s not so sure anymore.',3),
(9780545424950,'The Dream Thieves',2013,'If you could steal things from dreams, what would you take? Ronan Lynch has secrets. Some he keeps from others. Some he keeps from himself. One secret: Ronan can bring things out of his dreams. And sometimes he\'s not the only one who wants those things. Ronan is one of the raven boys- a group of friends, practically brothers, searching for a dead king neamed Glendower, who they think is hidden somewhere in the hills by their elite private school, Aglionby Academy. The path to Glendower has long lived as an undercurrent beneath the town. But now, like Ronan\'s secrets, it is beginning to rise to the surface- changing everything in its wake.',3),
(9780545424974,'Blue Lily, Lily Blue',2014,'There is danger in dreaming. But there is even more danger in waking up. Blue Sargent has found things. For the first time in her life, she has friends she can trust, a group to which she can belong. The raven boys have taken her in as one of their own. Their problems have become hers, and her problems have become theirs. The trick with found things, though, is how easily they can be lost. Friends can betray. Mothers can disappear. Visions can mislead. Certainties can unravel.',1),
(9780545424998,'The Raven King',2016,'Nothing living is safe. Nothing dead is to be trusted. For years, Gansey has been on a quest to find a lost king. One by one, he\'s drawn others into this quest: Ronan, who steals from dreams; Adam, whose life is no longer his own; Noah, whose life is no longer a life; and Blue, who loves Gansey... and is certain she is destined to kill him. Now the endgame has begun. Dreams and nightmares are converging. Love and loss are inseparable. And the quest refuses to be pinned to a path.',1),
(9780807062326,'Let My People Vote',2020,'\"You may think the right to vote is a small matter, and if you do, I would bet you have never had it taken away from you.\" Thus begins the story of Desmond Meade and his inspiring battle to restore voting rights to roughly 1.4 million returning citizens in Florida- resulting in a stunning victory in 2018 that enfranchised the most people at once in any single initiative since women\'s suffrage. Desmond Meade, JD, is the president of the Florida RIghts Restoration Coalition and chair of Floridians for a Fair Democracy. Desmond continues to fight against new restrictions placed on citizens that have been likened to Jim Crow laws.',4),
(9781250007209,'Cinder',2013,'Humans and androids crowd the raucous streets of New Beijing. A deadly plague ravages the population. From space, a ruthless lunar people watch, waiting to make their move. No one knows that Earth\'s fate hinges on one girl.... Sixteen-year-old Cinder, a gifted mechanic, is a cyborg. She\'s a second-class citizen with a mysterious past and is reviled by her stepmother. But when her life becomes intertwined with the handsome Prince Kai\'s, she suddenly finds herself at the center of an intergalactic struggle, and a forbidden attraction. Caught between duty and freedom, loyalty and betrayal, she must uncover secrets about her past in order to protect her worlds future. Becuase there is something unusual about Cinder, something that others would kill for.',2),
(9781250007216,'Scarlet',2014,'Cinder, the cyborg mechanic, returns in the second thrilling installment of the bestselling Lunar Chronicles. She is trying to break out of prison -even though if she succeeds, shell be the Commonwealth\'s most wanted fugitive. Halfway around the world, Scarlet Benoit\'s grandmother is missing. When Scarlet encounters Wolf, a street fighter who may have information about her grandmother\'s whereabouts, she is loath to trust this stranger, but is inexplicably drawn to him, and he to her. As Scarlet and Wolf unravel one mystery, they encounter another when they meet Cinder. Now, all of them must stay one step ahead of the vicious Lunar Queen Levana, who will do anything for the handsome Prince Kai to become her husband, her king, her prisoner.',2),
(9781250007223,'Cress',2015,'Cress, having risked everything to warn Cinder of Queen Levana\'s evil plan, has a slight problem. She\'s been imprisooned on a satellite since childhood and has only ever had her netscreens as company. All that screen time has made Cress an excellent hacker. Unfortunately, she\'s just received orders from Levana to track down Cinder and her handsome accomplice. When a daring rescue of Cress involving Cinder, Captain Thorne, Scarlet, and Wolf goes awry, the gropu is separated. Cress finally has her freedom, but it comes at a high price. Meanwhile, Queen Levana will let nothing prevent her marriage to Emperor Kai. Cress, Scarlet, and Cinder may not have signed up to save the world, but they may be the only hope the world has.',2),
(9781250069665,'Fairest',2015,'Queen Levana is a ruler who uses her \'glamour\' to gain power. But long before she crossed paths with Cinder, Scarlet, and Cress, Levana lived a very different story-a story that has never been told... until now',1),
(9781250074218,'Winter',2015,'Princess Winter is admired by the Lunar people for her grace and kindness, and despite the scars that mark her face, her beauty is said to be more breathtaking than that of her stepmother, Queen Levana. Winter despises her stepmother, and knows Levana won\'t approve of her feelings for her childhood friend--the handsome palace guard, Jacin. But Winter isn\'t as weak as Levana believes her to be and she\'s been undermining her stepmother\'s wishes for years. Together with the cyborg, Cinder, and her allies, Winter might even have the power to launch a revolution and win a war that\'s been raging for far too long. Can Cinder, Scarlet, Cress, and Winter defeat Levana and find their happily ever afters?',2),
(9781250104458,'Stars Above',2016,'The universe of the Lunar Chronicles holds stories—and secrets—that are wondrous, vicious, and romantic. How did Cinder first arrive in New Beijing? How did the brooding soldier Wolf transform from young man to killer? When did Princess Winter and the palace guard Jacin realize their destinies?',1),
(9781259676512,'Discrete Mathematics and Its Applications',2011,'Discrete Mathematics and its Applications is a focused introduction to the primary themes in a discrete mathematics course, as introduced through extensive applications, expansive discussion, and detailed exercise sets.',2),
(9781785658006,'Sweet Dreams',2019,'Charlie is a dreamhacker, able to enter your dreams and mold their direction. Forget that recurring nightmare about being naked in an exam- Charlie will step into your dream, bring you a dressing gown and give you the answers. In London 2022 her skills are in demand, though they still only just pay the bills. Hired by a celebrity whose nights are haunted by a masked figure who stalks her through a bewildering and sinister landscape, Charlie hopes her star is on the rise. THen her client sleepwalks straight off a tall building, and Charlie starts to realize that these horros are not all just a dream...',3),
(9781982158217,'The Many Daughters of Afong Moy',2022,'Dorothy Moy breaks her own heart for a living. As Washington\'s former poet laureate, that\'s how she describes channeling her dissociative episodes and mental health struggles into her art. But when her five-year-old daughter exhibits similar behavior and begins remembering things from the lives of their ancestors, Dorothy believes the past has truly come to haunt her. Fearing that her child is predestined to endure the same debilitating depression that has marked her own life, Dorothy seeks radical help. Through an experimental treatment designed to mitigate inherited trauma, Dorothy intimately connects with past generations of women in her family: FayeMoy, a nurse in China serving with the Flying Tigers; Zoe Moy, a student in England at a famous school with no rules; Lai King Moy, a gril quarantined in San Francisco during a plague epidemic; Greta Moy, a tech executive with a unique dating app; and Afong Moy, the first Chinese woman to set foot in America. As painful recollections affect her present life, Dorothy discovers that trauma isn\'t the only thing she\'s inherited. A stranger is searching for her in each time period. A stranger who\'s loved her through all of her genetic memories. Dorothy endeavors to break the cycle of pain and abandonment, to finally find peace for her daughter, and to gain the love that has long been waiting, knowing she may pay the ultimate price.',5);
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
INSERT INTO `Book_Author` VALUES
(131489062,13),
(978059312850,15),
(9780134860992,11),
(9780134860992,12),
(9780345453747,14),
(9780545424936,18),
(9780545424950,18),
(9780545424950,19),
(9780545424974,18),
(9780545424974,19),
(9780545424974,20),
(9780545424998,18),
(9780545424998,19),
(9780545424998,20),
(9780545424998,21),
(9780807062326,17),
(9781250007209,9),
(9781250007216,9),
(9781250007223,9),
(9781250069665,9),
(9781250074218,9),
(9781250104458,9),
(9781259676512,22),
(9781785658006,16),
(9781982158217,10);
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
INSERT INTO `Book_Genre` VALUES
(131489062,40),
(131489062,41),
(131489062,42),
(978059312850,33),
(978059312850,35),
(9780134860992,40),
(9780134860992,41),
(9780134860992,42),
(9780345453747,34),
(9780345453747,35),
(9780345453747,47),
(9780545424936,33),
(9780545424936,35),
(9780545424936,36),
(9780545424936,59),
(9780545424950,33),
(9780545424950,35),
(9780545424950,36),
(9780545424950,59),
(9780545424974,33),
(9780545424974,35),
(9780545424974,36),
(9780545424974,59),
(9780545424998,33),
(9780545424998,35),
(9780545424998,36),
(9780545424998,59),
(9780807062326,40),
(9780807062326,55),
(9781250007209,33),
(9781250007209,34),
(9781250007209,35),
(9781250007209,36),
(9781250007216,33),
(9781250007216,34),
(9781250007216,35),
(9781250007216,36),
(9781250007223,33),
(9781250007223,34),
(9781250007223,35),
(9781250007223,36),
(9781250069665,33),
(9781250069665,34),
(9781250069665,35),
(9781250069665,36),
(9781250074218,33),
(9781250074218,34),
(9781250074218,35),
(9781250074218,36),
(9781250104458,33),
(9781250104458,34),
(9781250104458,35),
(9781250104458,36),
(9781259676512,40),
(9781259676512,41),
(9781259676512,42),
(9781785658006,34),
(9781785658006,35),
(9781785658006,53),
(9781982158217,33),
(9781982158217,35),
(9781982158217,38);
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
INSERT INTO `Book_Series` VALUES
(131489062,9),
(131489062,10),
(131489062,11),
(978059312850,13),
(9780134860992,9),
(9780134860992,10),
(9780345453747,9),
(9780345453747,10),
(9780345453747,11),
(9780345453747,12),
(9780545424936,16),
(9780545424950,16),
(9780545424950,17),
(9780545424974,16),
(9780545424974,17),
(9780545424974,18),
(9780545424998,16),
(9780545424998,17),
(9780545424998,18),
(9780545424998,19),
(9780807062326,9),
(9780807062326,10),
(9780807062326,11),
(9780807062326,12),
(9780807062326,14),
(9780807062326,15),
(9781250007209,8),
(9781250007216,8),
(9781250007223,8),
(9781250069665,8),
(9781250074218,8),
(9781250104458,8),
(9781259676512,9),
(9781259676512,10),
(9781259676512,11),
(9781259676512,12),
(9781259676512,14),
(9781259676512,15),
(9781259676512,20),
(9781785658006,9),
(9781785658006,10),
(9781785658006,11),
(9781785658006,12),
(9781785658006,14),
(9781982158217,9);
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
  `renew` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `bISBN` (`bISBN`),
  KEY `uId` (`uId`),
  CONSTRAINT `Checkout_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Checkout_ibfk_2` FOREIGN KEY (`uId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Checkout`
--

LOCK TABLES `Checkout` WRITE;
/*!40000 ALTER TABLE `Checkout` DISABLE KEYS */;
/*!40000 ALTER TABLE `Checkout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FriendRequests`
--

DROP TABLE IF EXISTS `FriendRequests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FriendRequests` (
  `from_id` int(11) NOT NULL,
  `to_id` int(11) NOT NULL,
  PRIMARY KEY (`from_id`,`to_id`),
  KEY `to_id` (`to_id`),
  CONSTRAINT `FriendRequests_ibfk_1` FOREIGN KEY (`from_id`) REFERENCES `User` (`id`),
  CONSTRAINT `FriendRequests_ibfk_2` FOREIGN KEY (`to_id`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FriendRequests`
--

LOCK TABLES `FriendRequests` WRITE;
/*!40000 ALTER TABLE `FriendRequests` DISABLE KEYS */;
/*!40000 ALTER TABLE `FriendRequests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Friends`
--

DROP TABLE IF EXISTS `Friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Friends` (
  `user1_id` int(11) NOT NULL,
  `user2_id` int(11) NOT NULL,
  PRIMARY KEY (`user1_id`,`user2_id`),
  KEY `user2_id` (`user2_id`),
  CONSTRAINT `Friends_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `User` (`id`),
  CONSTRAINT `Friends_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `User` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Friends`
--

LOCK TABLES `Friends` WRITE;
/*!40000 ALTER TABLE `Friends` DISABLE KEYS */;
/*!40000 ALTER TABLE `Friends` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genre`
--

LOCK TABLES `Genre` WRITE;
/*!40000 ALTER TABLE `Genre` DISABLE KEYS */;
INSERT INTO `Genre` VALUES
(59,'Adventure'),
(55,'Biography'),
(47,'Comedy'),
(41,'Educational'),
(33,'Fantasy'),
(35,'Fiction'),
(38,'Historical Fiction'),
(40,'Non-Fiction'),
(42,'Resource'),
(36,'Romance'),
(34,'Science Fiction'),
(53,'Thriller');
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
  `stars` tinyint(4) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bISBN` (`bISBN`),
  KEY `uId` (`uId`),
  CONSTRAINT `Rating_ibfk_1` FOREIGN KEY (`bISBN`) REFERENCES `BookDescription` (`ISBN`),
  CONSTRAINT `Rating_ibfk_2` FOREIGN KEY (`uId`) REFERENCES `User` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Series`
--

LOCK TABLES `Series` WRITE;
/*!40000 ALTER TABLE `Series` DISABLE KEYS */;
INSERT INTO `Series` VALUES
(9,''),
(10,''),
(11,''),
(12,''),
(14,''),
(15,''),
(20,''),
(8,'Lunar Chronicles'),
(16,'The Raven Cycle'),
(17,'The Raven Cycle'),
(18,'The Raven Cycle'),
(19,'The Raven Cycle'),
(13,'The Scholomance');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
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

-- Dump completed on 2025-04-23 21:16:07
