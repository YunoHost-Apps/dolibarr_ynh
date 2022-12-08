#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================
YNH_PHP_VERSION="7.4"

php_dependencies="php$YNH_PHP_VERSION-mysql \
						php$YNH_PHP_VERSION-imagick \
						php$YNH_PHP_VERSION-gd \
						php$YNH_PHP_VERSION-mbstring \
						php$YNH_PHP_VERSION-soap \
						php$YNH_PHP_VERSION-curl \
						php$YNH_PHP_VERSION-intl \
						php$YNH_PHP_VERSION-opcache \
						php$YNH_PHP_VERSION-calendar \
						php$YNH_PHP_VERSION-zip \
						php$YNH_PHP_VERSION-xml \
						php$YNH_PHP_VERSION-fileinfo \
						php$YNH_PHP_VERSION-imap"

# dependencies used by the app (must be on a single line)
pkg_dependencies="$php_dependencies"

#=================================================
# PERSONAL HELPERS
#=================================================

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
