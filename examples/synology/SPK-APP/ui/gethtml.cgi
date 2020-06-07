#!/usr/bin/perl
use strict;
use warnings;
my $isDebug = 1; # debug modus enable for cmd-line test and to get query, token info
my $debug = ""; # debug text
my $uiDir=$0; # get current working dir runing ui
$uiDir=~s#/[^/]+$##g; # cleaning to get dirname
require "$uiDir/syno_cgi.pl"; # base cgi functions get params, usr_priv

# *** common head cgi section: set html context, verify login
print "Content-type: text/html\n\n";
admin_or_die($isDebug, $debug); # returns user infor in debug string, when debug is on it will not die
$debug .= " QueryStr: $ENV{'QUERY_STRING'}" if $isDebug && $ENV{'QUERY_STRING'};

# *** specific cgi section:
my $dsmLang = `/bin/get_key_value /etc/jitsi/.cfg SYNOPKG_DSM_LANGUAGE`;
chomp($dsmLang) if $dsmLang; 
my $action = param('action'); # action has the html file to load
my $fname = $action . '_' .$dsmLang .'.html';
if ( !  -e "$uiDir/$fname") {
    $fname = $action .'_enu.html';
}

if (open(IN,"$uiDir/$fname")) { 
	while(<IN>) {
		print "$_";
	}
	close(IN);
}
else {
	print "could not find $fname to show\n";
}
