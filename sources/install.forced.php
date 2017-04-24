<?php
/* Copyright (C) 2016       Raphaël Doursenaud      <rdoursenaud@gpcsolutions.fr>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
/** @var bool Hide PHP informations */
$force_install_nophpinfo = true;
/** @var int 1 = Lock and hide environment variables, 2 = Lock all set variables */
$force_install_noedit = 2;
$force_install_lockinstall = true;

$force_install_message = 'Welcome to your Dolibarr install for YunoHost';
$force_install_main_data_root = 'YNH_WWW_ALIAS/documents';
$force_install_mainforcehttps = true;

// Install Database for YunoHost
$force_install_type = 'mysqli';
$force_install_dbserver = 'localhost';
$force_install_port = 3306;
$force_install_prefix = 'ynh_';
$force_install_createdatabase = false;
$force_install_database = 'YNH_DBNAME';
$force_install_databaselogin = 'YNH_DBUSER';
$force_install_databasepass = 'YNH_DBPASS';
$force_install_createuser = false;
//$force_install_databaserootlogin = 'root';
//$force_install_databaserootpass = '';

/** @var string Dolibarr super-administrator username */
$force_install_dolibarrlogin = 'admin';

/** @var string Enable module(s) (Comma separated class names list) */
$force_install_module = 'modLdap';
