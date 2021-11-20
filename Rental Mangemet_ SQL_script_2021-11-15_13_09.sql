-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-11-15 10:48:28.601

-- tables
-- Table: country
CREATE TABLE `country` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(128) NOT NULL,
    UNIQUE INDEX `country_ak_1` (`name`),
    CONSTRAINT `country_pk` PRIMARY KEY (`id`)
);

-- Table: grade
CREATE TABLE `grade` (
    `id` int NOT NULL AUTO_INCREMENT,
    `item_leased_id` int NOT NULL,
    `grade_category_id` int NOT NULL,
    `user_from` int NOT NULL,
    `user_to` int NOT NULL,
    `grade` decimal(3,1) NOT NULL,
    `description` text NOT NULL,
    CONSTRAINT `grade_pk` PRIMARY KEY (`id`)
);

-- Table: grade_category
CREATE TABLE `grade_category` (
    `id` int NOT NULL AUTO_INCREMENT,
    `category_name` varchar(64) NOT NULL,
    `item_type_id` int NOT NULL,
    `who_grades` int NOT NULL COMMENT 'e.g. 1 - rentier, 2 - renter',
    UNIQUE INDEX `grade_category_ak_1` (`category_name`,`item_type_id`,`who_grades`),
    CONSTRAINT `grade_category_pk` PRIMARY KEY (`id`)
);

-- Table: item
CREATE TABLE `item` (
    `id` int NOT NULL AUTO_INCREMENT,
    `item_name` varchar(255) NOT NULL,
    `item_type_id` int NOT NULL,
    `location_id` int NOT NULL,
    `item_location` text NOT NULL,
    `description` text NOT NULL,
    `owner_id` int NOT NULL,
    `price_per_unit` decimal(8,2) NOT NULL COMMENT 'price per unit',
    `unit_id` int NOT NULL,
    `available` blob NOT NULL COMMENT 'is item currently available (maybe it''''s leased at the moment or owner canceled it)',
    CONSTRAINT `item_pk` PRIMARY KEY (`id`)
);

-- Table: item_leased
CREATE TABLE `item_leased` (
    `id` int NOT NULL AUTO_INCREMENT,
    `item_id` int NOT NULL,
    `renter_id` int NOT NULL,
    `time_from` timestamp NOT NULL,
    `time_to` timestamp NOT NULL,
    `unit_id` int NOT NULL,
    `price_per_unit` decimal(8,2) NOT NULL,
    `discount` decimal(8,2) NOT NULL,
    `fee` decimal(8,2) NOT NULL,
    `price_total` decimal(8,2) NOT NULL,
    `rentier_grade_description` text NULL COMMENT 'description renter wrote about rentier',
    `renter_grade_description` text NULL COMMENT 'description rentier wrote about renter',
    CONSTRAINT `item_leased_pk` PRIMARY KEY (`id`)
);

-- Table: item_type
CREATE TABLE `item_type` (
    `id` int NOT NULL AUTO_INCREMENT,
    `type_name` varchar(64) NOT NULL,
    UNIQUE INDEX `item_type_ak_1` (`type_name`),
    CONSTRAINT `item_type_pk` PRIMARY KEY (`id`)
);

-- Table: location
CREATE TABLE `location` (
    `id` int NOT NULL AUTO_INCREMENT,
    `postal_code` varchar(16) NOT NULL,
    `name` varchar(255) NOT NULL,
    `description` text NOT NULL,
    `country_id` int NOT NULL,
    CONSTRAINT `location_pk` PRIMARY KEY (`id`)
);

-- Table: unit
CREATE TABLE `unit` (
    `id` int NOT NULL AUTO_INCREMENT,
    `unit_name` varchar(64) NOT NULL,
    UNIQUE INDEX `unit_ak_1` (`unit_name`),
    CONSTRAINT `unit_pk` PRIMARY KEY (`id`)
);

-- Table: user_account
CREATE TABLE `user_account` (
    `id` int NOT NULL AUTO_INCREMENT,
    `username` varchar(64) NOT NULL,
    `password` varchar(64) NOT NULL,
    `location_id` int NOT NULL,
    `location_details` text NOT NULL,
    `phone` varchar(255) NULL,
    `mobile` varchar(255) NULL,
    `email` varchar(255) NOT NULL,
    `registration_time` timestamp NOT NULL,
    UNIQUE INDEX `user_account_ak_1` (`username`),
    UNIQUE INDEX `user_account_ak_2` (`email`),
    CONSTRAINT `user_account_pk` PRIMARY KEY (`id`)
);

-- foreign keys
-- Reference: grade_category_item_type (table: grade_category)
ALTER TABLE `grade_category` ADD CONSTRAINT `grade_category_item_type` FOREIGN KEY `grade_category_item_type` (`item_type_id`)
    REFERENCES `item_type` (`id`);

-- Reference: grade_grade_category (table: grade)
ALTER TABLE `grade` ADD CONSTRAINT `grade_grade_category` FOREIGN KEY `grade_grade_category` (`grade_category_id`)
    REFERENCES `grade_category` (`id`);

-- Reference: grade_item_leased (table: grade)
ALTER TABLE `grade` ADD CONSTRAINT `grade_item_leased` FOREIGN KEY `grade_item_leased` (`item_leased_id`)
    REFERENCES `item_leased` (`id`);

-- Reference: grade_user_account_from (table: grade)
ALTER TABLE `grade` ADD CONSTRAINT `grade_user_account_from` FOREIGN KEY `grade_user_account_from` (`user_from`)
    REFERENCES `user_account` (`id`);

-- Reference: grade_user_account_to (table: grade)
ALTER TABLE `grade` ADD CONSTRAINT `grade_user_account_to` FOREIGN KEY `grade_user_account_to` (`user_to`)
    REFERENCES `user_account` (`id`);

-- Reference: house leased (table: item_leased)
ALTER TABLE `item_leased` ADD CONSTRAINT `house leased` FOREIGN KEY `house leased` (`item_id`)
    REFERENCES `item` (`id`);

-- Reference: item_item_type (table: item)
ALTER TABLE `item` ADD CONSTRAINT `item_item_type` FOREIGN KEY `item_item_type` (`item_type_id`)
    REFERENCES `item_type` (`id`);

-- Reference: item_leased_unit (table: item_leased)
ALTER TABLE `item_leased` ADD CONSTRAINT `item_leased_unit` FOREIGN KEY `item_leased_unit` (`unit_id`)
    REFERENCES `unit` (`id`);

-- Reference: item_leased_user_account (table: item_leased)
ALTER TABLE `item_leased` ADD CONSTRAINT `item_leased_user_account` FOREIGN KEY `item_leased_user_account` (`renter_id`)
    REFERENCES `user_account` (`id`);

-- Reference: item_location (table: item)
ALTER TABLE `item` ADD CONSTRAINT `item_location` FOREIGN KEY `item_location` (`location_id`)
    REFERENCES `location` (`id`);

-- Reference: item_unit (table: item)
ALTER TABLE `item` ADD CONSTRAINT `item_unit` FOREIGN KEY `item_unit` (`unit_id`)
    REFERENCES `unit` (`id`);

-- Reference: item_user_account (table: item)
ALTER TABLE `item` ADD CONSTRAINT `item_user_account` FOREIGN KEY `item_user_account` (`owner_id`)
    REFERENCES `user_account` (`id`);

-- Reference: location_country (table: location)
ALTER TABLE `location` ADD CONSTRAINT `location_country` FOREIGN KEY `location_country` (`country_id`)
    REFERENCES `country` (`id`);

-- Reference: user_account_location (table: user_account)
ALTER TABLE `user_account` ADD CONSTRAINT `user_account_location` FOREIGN KEY `user_account_location` (`location_id`)
    REFERENCES `location` (`id`);

-- inserting values in appointment schedule table --
INSERT INTO appointment_schedules (Scheduled_Date, StaffId, Resident_Id, MeetingNotes, is_MR_Logged, MR_notes)
values ('2021-11-13',1,2,'Payment queries solved','N','');
INSERT INTO appointment_schedules (Scheduled_Date, StaffId,Resident_Id,MeetingNotes,is_MR_Logged,MR_notes)
values('2021-11-13',3,1,'Maintenance Request','Y','Service the taps in washrooms.');
INSERT INTO appointment_schedules(Scheduled_Date,StaffId,Resident_Id,MeetingNotes,is_MR_Logged,MR_notes)
values('2021-11-13',2,2,'Feedback','N','');
INSERT INTO appointment_schedules(Scheduled_Date,StaffId,Resident_Id,MeetingNotes,is_MR_Logged,MR_notes)
values('2021-11-14',4,3,'Raised a Maintenance Request','Y','Water in sink doesnot drain');
INSERT INTO appointment_schedules(Scheduled_Date,StaffId,Resident_Id,MeetingNotes,is_MR_Logged,MR_notes)
values('2018-12-14',1,3,'','N','');




-- Reference: item_leased_unit (table: item_leased)
ALTER TABLE `item_leased` ADD CONSTRAINT `item_leased_unit` FOREIGN KEY `item_leased_unit` (`unit_id`)
    REFERENCES `unit` (`id`);

-- Reference: item_leased_user_account (table: item_leased)
ALTER TABLE `item_leased` ADD CONSTRAINT `item_leased_user_account` FOREIGN KEY `item_leased_user_account` (`renter_id`)
    REFERENCES `user_account` (`id`);








-- End of file.

