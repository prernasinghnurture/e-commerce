
DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
                         `ID` int NOT NULL AUTO_INCREMENT,
                         `UserName` varchar(45) DEFAULT NULL,
                         `Password` varchar(45) DEFAULT NULL,
                         `Address` varchar(45) DEFAULT NULL,
                         `Date` int DEFAULT NULL,
                         `Month` int DEFAULT NULL,
                         `Year` int DEFAULT NULL,
                         PRIMARY KEY (`ID`),
                         UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `Products`;
CREATE TABLE `Products` (
                            `ProductId` int NOT NULL AUTO_INCREMENT,
                            `Name` varchar(45) DEFAULT NULL,
                            `Price` int DEFAULT NULL,
                            `Quantity` int DEFAULT NULL,
                            PRIMARY KEY (`ProductId`),
                            UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `Cart`;
CREATE TABLE `Cart` (
                        `UserId` int DEFAULT NULL,
                        `ProductId` int DEFAULT NULL,
                        `Name` varchar(45) DEFAULT NULL,
                        `Quantity` int DEFAULT NULL,
                        UNIQUE KEY `UserId` (`UserId`,`ProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




