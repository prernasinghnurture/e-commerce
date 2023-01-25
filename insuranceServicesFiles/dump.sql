DROP TABLE IF EXISTS `app_config`;

DROP TABLE IF EXISTS `invoices`;

DROP TABLE IF EXISTS `user_scheme`;

DROP TABLE IF EXISTS `scheme_faq_mapping`;

DROP TABLE IF EXISTS `scheme_criteria_mapping`;

DROP TABLE IF EXISTS `scheme`;

DROP TABLE IF EXISTS `scheme_faq`;

DROP TABLE IF EXISTS `audit_logs`;

DROP TABLE IF EXISTS `cron`;

DROP TABLE IF EXISTS `offer_scheme_mapping`;

DROP TABLE IF EXISTS `scheme_type`;

DROP TABLE IF EXISTS `seasons`;

DROP TABLE IF EXISTS `whitelisted_referrers`;

DROP TABLE IF EXISTS `discounts`;

CREATE TABLE IF NOT EXISTS `app_config` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `title` varchar(64) NOT NULL,
    `req_name` varchar(64) DEFAULT NULL,
    `res_name` varchar(64) DEFAULT NULL,
    `decl_req` tinyint(1) NOT NULL DEFAULT '1',
    `decl_res` tinyint(1) NOT NULL DEFAULT '1',
    `decl_grpc` tinyint(1) NOT NULL DEFAULT '1',
    `decl_grapql` tinyint(1) NOT NULL DEFAULT '1',
    `sql_stmt` text,
    `sql_params` text,
    `sql_uniquekey` tinyint(1) DEFAULT '0',
    `sql_replace` text,
    `sql_pool` varchar(64) DEFAULT NULL,
    `impl_dao` tinyint(1) NOT NULL DEFAULT '1',
    `impl_grpc` tinyint(1) NOT NULL DEFAULT '1',
    `impl_reacrjs` tinyint(1) NOT NULL DEFAULT '0',
    `req_override` text,
    `res_override` text,
    `mutation` enum('I','U','D','S','-') NOT NULL DEFAULT '-',
    `oauth_public` tinyint(1) DEFAULT '1',
    `oauth_claims` text,
    `status` tinyint(1) DEFAULT '1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `title` (`title`)
    ) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='Application configuration';


CREATE TABLE IF NOT EXISTS `scheme` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `scheme_name` varchar(200) NOT NULL,
    `district_id` bigint(20) NOT NULL DEFAULT '0',
    `state_id` bigint(20) NOT NULL DEFAULT '0',
    `cost` bigint(20) NOT NULL DEFAULT '0',
    `metadata` json DEFAULT NULL,
    `activated_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `sum_assured` bigint(20) NOT NULL,
    `insurance_premium` double DEFAULT NULL,
    `service_charge` double DEFAULT NULL,
    `geo_id` bigint(20) NOT NULL,
    `geo_type` varchar(64) NOT NULL,
    `scheme_type_id` bigint(20) NOT NULL,
    `default_cover_amount` double NOT NULL,
    `assured_price` double DEFAULT NULL,
    `measurement_unit` varchar(256) DEFAULT NULL,
    `is_visible` tinyint(1) DEFAULT '1',
    `is_deleted` tinyint(1) DEFAULT '0',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8 COMMENT='Table for scheme information';


CREATE TABLE `discounts` (
                             `id` bigint(20) NOT NULL AUTO_INCREMENT,
                             `name` varchar(16) NOT NULL,
                             `quantity` bigint(20) NOT NULL,
                             `discount` double NOT NULL,
                             `discount_type` varchar(16) NOT NULL,
                             `entity_type` varchar(16) NOT NULL,
                             `entity_id` bigint(20) NOT NULL,
                             `is_deleted` tinyint(1) DEFAULT '0',
                             `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='Table for discounts information';

CREATE TABLE IF NOT EXISTS `user_scheme` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `actor_id` bigint(20) NOT NULL,
    `actor_type` varchar(200) NOT NULL,
    `state_id` bigint(20) NOT NULL,
    `district_id` bigint(20) NOT NULL,
    `tehsil_id` bigint(20) NOT NULL,
    `village_id` bigint(20) NOT NULL,
    `scheme_id` bigint(20) NOT NULL,
    `scheme_quantity` bigint(20) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `payment_method` varchar(64) DEFAULT 'WALLET',
    `is_active` tinyint(1) DEFAULT '1',
    `updated_by_actor_id` bigint(20) DEFAULT NULL,
    `updated_by_actor_type` varchar(64) DEFAULT NULL,
    `earnings` bigint(20) DEFAULT '0',
    `payment_status` varchar(64) DEFAULT NULL,
    `bank_details` json DEFAULT NULL,
    `purchase_status` varchar(20) DEFAULT NULL,
    `campaign_name` varchar(256) DEFAULT NULL,
    `discount_id` bigint(20) DEFAULT NULL,
    `cost` double DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `scheme_id` (`scheme_id`),
    KEY `is_active_user_scheme_index` (`is_active`),
    KEY `fk_user_scheme_discount_id` (`discount_id`),
    CONSTRAINT `fk_user_scheme_discount_id` FOREIGN KEY (`discount_id`) REFERENCES `discounts` (`id`),
    CONSTRAINT `user_scheme_ibfk_1` FOREIGN KEY (`scheme_id`) REFERENCES `scheme` (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8 COMMENT='Table for user information';

CREATE TABLE IF NOT EXISTS `invoices` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `user_scheme_id` bigint(20) NOT NULL,
    `invoice_number` bigint(20) NOT NULL,
    `service_type` varchar(32) NOT NULL,
    `uploaded_path` varchar(2048) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `user_scheme_id` (`user_scheme_id`),
    CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`user_scheme_id`) REFERENCES `user_scheme` (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='Table for insurance invoices information';


CREATE TABLE IF NOT EXISTS `audit_logs` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `actor_id` bigint(20) NOT NULL,
    `actor_type` varchar(64) NOT NULL,
    `entity_id` bigint(20) NOT NULL,
    `entity_type` varchar(64) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `cron` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `job_name` varchar(32) NOT NULL,
    `status` varchar(32) NOT NULL,
    `start_time` timestamp NULL DEFAULT NULL,
    `end_time` timestamp NULL DEFAULT NULL,
    `metadata` json DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COMMENT='Table for cron information';


CREATE TABLE IF NOT EXISTS `offer_scheme_mapping` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `offer_id` bigint(20) NOT NULL,
    `offer_type` varchar(256) NOT NULL,
    `scheme_id` bigint(20) NOT NULL,
    `campaign_name` varchar(256) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
    `consider_from` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='Table for offer scheme mapping information';


CREATE TABLE IF NOT EXISTS `scheme_criteria_mapping` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `scheme_id` bigint(20) NOT NULL,
    `criteria` varchar(200) NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `is_active` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`),
    KEY `scheme_id` (`scheme_id`),
    CONSTRAINT `scheme_criteria_mapping_ibfk_1` FOREIGN KEY (`scheme_id`) REFERENCES `scheme` (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8 COMMENT='Table for scheme_criteria mapping information';

CREATE TABLE IF NOT EXISTS `scheme_faq` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `question` varchar(200) NOT NULL,
    `answer` varchar(200) NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `is_active` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8 COMMENT='Table for scheme_faq information';


CREATE TABLE IF NOT EXISTS `scheme_faq_mapping` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `scheme_id` bigint(20) NOT NULL,
    `faq_id` bigint(20) NOT NULL,
    `faq_rank` bigint(20) NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `scheme_id` (`scheme_id`),
    KEY `faq_id` (`faq_id`),
    CONSTRAINT `scheme_faq_mapping_ibfk_1` FOREIGN KEY (`scheme_id`) REFERENCES `scheme` (`id`),
    CONSTRAINT `scheme_faq_mapping_ibfk_2` FOREIGN KEY (`faq_id`) REFERENCES `scheme_faq` (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=498 DEFAULT CHARSET=utf8 COMMENT='Table for scheme_faq_mapping information';

CREATE TABLE IF NOT EXISTS `scheme_type` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `name` varchar(256) NOT NULL,
    `category` varchar(256) NOT NULL,
    `title_key` varchar(256) NOT NULL,
    `description_key` varchar(256) NOT NULL,
    `image` json NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='Table for scheme type information';


CREATE TABLE IF NOT EXISTS `seasons` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `title` varchar(64) DEFAULT NULL,
    `start_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `end_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `is_active` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Table for seasons';


CREATE TABLE IF NOT EXISTS `whitelisted_referrers` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `phone_no` bigint(20) NOT NULL,
    `code` varchar(64) NOT NULL,
    `is_active` tinyint(1) NOT NULL DEFAULT '1',
    `name` varchar(64) DEFAULT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='Table for whitelisted referrers';