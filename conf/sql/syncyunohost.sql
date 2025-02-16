-- Insert existing configuration values
INSERT INTO `llx_const` (`name`, `value`, `type`) VALUES
('MAIN_FEATURES_LEVEL', '0', 'chaine'),
('MAIN_MODULE_SYNCYUNOHOST', '1', 'string'),
('MAIN_MODULE_SYNCYUNOHOST_TRIGGERS', '1', 'chaine'),
('MAIN_MODULE_SYNCYUNOHOST_ICON', 'fa-file-o', 'chaine'),
('MAIN_MODULE_ADHERENT', '1', 'string'),
('ADHERENT_LOGIN_NOT_REQUIRED', '0', 'chaine'),
('ADHERENT_MAIL_REQUIRED', '1', 'chaine');

-- Insert new configuration values from user input
INSERT INTO `llx_const` (`name`, `value`, `type`) VALUES
('YUNOHOST_BASE_DOMAIN', '{{syncyunohost_base_domain}}', 'chaine'),
('YUNOHOST_MAIN_GROUP', '{{syncyunohost_main_group}}', 'chaine'),
('YUNOHOST_OLD_MEMBERS', '{{syncyunohost_old_members}}', 'chaine')
ON DUPLICATE KEY UPDATE value = VALUES(value);
