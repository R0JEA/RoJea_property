CREATE TABLE `rojea_property` (
  `id` INT(11) NOT NULL,
  `identifier` VARCHAR(40) NOT NULL,

  PRIMARY KEY (`id`)
);

CREATE TABLE `rojea_property_clothing` (
  `identifier` VARCHAR(40) NOT NULL,
  `clothes` LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`identifier`)
);

