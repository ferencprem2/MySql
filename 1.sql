CREATE DATABASE `FoxCamp` CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci;

CREATE TABLE TEST{
	`FieldInt` INT NULL DEFAULT 0 COMMENT "Valami",
	`FieldFloat` FLOAT NOT NULL 
	};
	
	
INSERT INTO TEST VALUES(3,4);

INSERT INTO TEST(`FieldFloat`) VALUES(5);

INSERT INTO TEST(`FieldInt`) VALUES(5); #ERROR

INSERT INTO TEST VALUES
	(6,7),
	(8,9),
	(10,11),;
	
CREATE TABLE TEST2(
	`Id` INT AUTO_INCREMENT,
	
	`IntField` INT NULL DEFAULT NULL,
	`FloatField` FLOAT NULL DEFAULT 0,
	`DecimalField` DECIMAL(13,4) NOT NULL DEFAULT 0,
	`UIntField` UNSIGNED NULL DEFAULT NULL,
	
	
	`BoolField` BOOLEAN NOT NULL DEFAULT FALSE,
	
	`CharField` CHAR(64) NOT NULL DEFAULT "",
	`VarcharField` VARCHAR(64) NOT NULL DEFAULT "",
	`TextField` TEXT NOT NULL DEFAULT "",
	
	`EnumField` ENUM("CODE","FOX","CAMP") NOT NULL DEFAULT "CODE",
	`SetField` SET("CODE", "FOX", "CAMP") NOT NULL DEFAULT "",
	
	`BlobField` BLOB NULL,
	
	`JsonField` JSON NOT NULL DEFAULT JSON_OBJECT(),
	
	`DateField` DATE NOT NULL DEFAULT NOW(),
	`TimeField` TIME NOT NULL DEFAULT NOW(),
	`DateTimeField` DATETIME NOT NULL DEFAULT NOW(),
	`TimestampField` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	`PrecisionDateTimeField` DATETIME(6) NOT NULL DEFAULT NOW(),
	`RowDateTime` DATETIME NOT NULL DEFAULT NOW() ON UPDATE NOW(),

	
	PRIMARY KEY (`Id`));
	
INSERT INTO TEST2() VALUES();

INSERT INTO TEST2() VALUES(),(),();

UPDATE TEST2 SET `IntField`=RAND()*1000, `DecimalField`=RAND();

UPDATE TEST2 SET `FloatField`=`IntField`/2;

UPDATE TEST2 SET `BoolField`=TRUE WHERE `IntField`>100;

SHOW FIELDS FROM TEST2 #Megmutatja 

UPDATE TEST2 SET `CharField`="VALAMI" WHERE (`IntField`>100 AND `Id`>5) or (`Id`=3);

DELETE FROM TEST2 WHERE `Id`=1;

DELETE FROM TEST2 WHERE `CharField`="VALAMI" ORDER BY `IntField` LIMIT 1; 

SELECT * FROM TEST2 
WHERE `Id`>10 
ORDER BY `IntField`;

SELECT * FROM TEST2 
WHERE `Id`>10 
ORDER BY  `BoolField`, `IntField`;

SELECT * FROM TEST2 
WHERE `Id`>10 
ORDER BY  `BoolField` ASC, `IntField` DESC; #ASC növekvő, DESC csökkenő


SELECT * FROM TEST2 
WHERE `Id`>10 
ORDER BY RAND(); --lassú

SELECT `IntField`, `Id` FROM TEST2;

SELECT `IntField`, `Id`, "ASD" FROM TEST2;

SELECT `IntField`, `Id`, "ASD", "ASD" FROM TEST2;

SELECT `IntField`, `Id`, "ASD" as "NewField1", "ASD" FROM TEST2;

SELECT `Id`, `IntField`,SUBSTR(`DateTimeField`, 1,4) AS "YEAR", "ASD" as "NewField1", "ASD" FROM TEST2

SELECT `CharField`, Sum(`IntField`) FROM TEST2;
GROUP BY `CharField`

SELECT `CharField`, Sum(`IntField`), AVG(`IntField`), COUNT(DISTINCT `IntField`) AS "CNT" FROM TEST2
GROUP BY `CharField`
HAVING CNT>10

SELECT SQL_NO_CACHE * FROM TEST2 WHERE `Id` > 5

SHOW CREATE TABLE PRODUCTS #shows how to crate table

SELECT TESTA.*, TESTC.* 
FROM TESTA LEFT JOIN TESTC ON (TESTA.A1=TESTC.A1)
WHERE TESTC.A1 IS NOT NULL

SELECT #DISTINCT
#products.Pcode, products.`Name`, taric.DutyRate, 
products.Taric, COUNT(*)
FROM products LEFT JOIN taric ON (products.Taric=Taric.Taric)
WHERE products.Kind = "PRODUCT" AND Taric.Taric IS NULL
GROUP BY products.Taric

SELECT  products.`Name`, warehouse_shelf_stock.ProductId, warehouse_shelf_stock.Shelf, warehouse_shelf_stock.Quantity
FROM products RIGHT JOIN warehouse_shelf_stock ON (products.Pcode=warehouse_shelf_stock.ProductId)
WHERE warehouse_shelf_stock.ProductId AND warehouse_shelf_stock.Shelf AND warehouse_shelf_stock.Quantity IS NOT NULL


SELECT
	products.`Name`,
	warehouse_shelf_stock.ProductId,
	warehouse_shelf_stock.Shelf,
	warehouse_shelf_stock.Quantity,
	qqcCount.CNT
FROM
	warehouse_shelf_stock
LEFT JOIN products ON (
	products.ProductId = warehouse_shelf_stock.ProductId
)
LEFT JOIN warehouse_shelves ON (
	warehouse_shelf_stock.Shelf = warehouse_shelves.Shelf
)
LEFT JOIN product_storage ON (
	warehouse_shelf_stock.ProductId = product_storage.ProductId
)
LEFT JOIN product_storage_types ON (
	product_storage.StorageId = product_storage_types.StorageId
)
LEFT JOIN (
	SELECT
		qqc_labels.QqcId,
		qqc_labels.ProductId,
		qqc_labels.Shelf,
		COUNT(*) AS 'CNT'
	FROM
		qqc_labels
	WHERE
		qqc_labels.`Status` = "ON_SHELF"
	GROUP BY
		qqc_labels.Shelf,
		qqc_labels.ProductId
) qqcCount ON (
	qqcCount.ProductId = warehouse_shelf_stock.ProductId
	AND qqcCount.Shelf = warehouse_shelf_stock.Shelf
)
WHERE
	warehouse_shelves.Picking = 0
AND product_storage_types.`Name` = "Master karton"
AND product_storage.Active = 1
AND warehouse_shelf_stock.Quantity > 0 #Pcode, Name, 
#mlyik polcban melyik termékből mennyi van
#melyek azok a termékek amelyek master kartonbavannak csomagolva 
#amelyek master kartonban vannak tárolva, hány különböző dobozban vannak tárolva

SELECT Pcode FROM products WHERE ProductId IN (
	SELECT ProductId FROM qqc_labels WHERE date>"2022-01-01"
)


SELECT SQL_NO_CACHE
    Shelf,
    ProductId,
    (
        SELECT
            `StorageId`
        FROM
            product_storage
        WHERE
            product_storage.ProductId = warehouse_shelf_stock.ProductId
        AND Active = TRUE
        ORDER BY
            StorageId DESC
        LIMIT 1
    )
FROM
    warehouse_shelf_stock
	
	
SELECT Brand, GROUP_CONCAT(DISTINCT,Taric ORDER BY Taric SEPARATOR "|") FROM products Where Taric<>"" AND Brand<>""
GROUP BY Brand
ORDER BY Brand

BEGIN
COMMIT
ROLLBACK