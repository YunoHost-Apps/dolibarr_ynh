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
('YUNOHOST_BASE_DOMAIN', '{{YUNOHOST_BASE_DOMAIN}}', 'chaine'),
('YUNOHOST_MAIN_GROUP', '{{YUNOHOST_MAIN_GROUP}}', 'chaine'),
('YUNOHOST_OLD_MEMBERS', '{{YUNOHOST_OLD_MEMBERS}}', 'chaine')
ON DUPLICATE KEY UPDATE value = VALUES(value);
