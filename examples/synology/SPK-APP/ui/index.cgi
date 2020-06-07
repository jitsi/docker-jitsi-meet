#!/usr/bin/perl
use strict;
use warnings;
use File::Copy;
my $isDebug = 1; # debug modus enable for cmd-line test and to get query, token info
my $debug = ""; # debug text
my $uiDir=$0; # get current working dir runing ui
$uiDir=~s#/[^/]+$##g; # cleaning to get dirname
require "$uiDir/syno_cgi.pl"; # base cgi functions get params, usr_priv
my $dsmBuild = `/bin/get_key_value /etc.defaults/VERSION buildnumber`;
my $dsmLang = `/bin/get_key_value /etc/jitsi/.cfg SYNOPKG_DSM_LANGUAGE`;
chomp($dsmBuild) if $dsmBuild; 
chomp($dsmLang) if $dsmLang; 

# *** common head cgi section: set html context, verify login
print "Content-type: text/html\n\n";
admin_or_die($isDebug, $debug); # returns user infor in debug string, when debug is on it will not die
$debug .= " QueryStr: $ENV{'QUERY_STRING'}" if $isDebug && $ENV{'QUERY_STRING'};

# *** specific cgi section:
my %tmplhtml; # array to capture all dynamic html entries
my %tmpljs; # key-value array to capture all dynamic js entries
my $jscript = ''; # java script injected in page using ext-3 js
# add cfg files from file to js-select-combo and original dir
sub addCfgFile {
	my ($fname,$name)=@_;
	$fname=~s/^\s*//g;
	$name=~s/^\s*//g;
	if ($tmpljs{'names'}) {
		$tmpljs{'names'}.=',';
	}
	$tmpljs{'names'}.="'" .$name ."'" ;
	my $path=$uiDir .'/original/' .$name .'.original';
	if (!( -r $path)){
		copy($fname,$path);
	}
}
if (open(IN,"$uiDir/configfiles.txt")) {
	while(<IN>) {
		chop();
		if ((!(/^#/))&&(/,/)) {
			my ($fname,$name)=/([^,]+),(.*)/;
			addCfgFile($fname,$name);
		}
	}
}
# get javascript
if (open(IN,"$uiDir/script.js")) {
	while (<IN>) {
		s/==:([^:]+):==/$tmpljs{$1}/g;
		$jscript.=$_;
	}
	close(IN);
}
$tmplhtml{'javascript'}=$jscript;
$tmplhtml{'debug'}=$debug;

# print main html page embedding tags from tmplhtml incl. jscript
if (open(IN,"$uiDir/page.html")) {
	while (<IN>) {
		s/==:([^:]+):==/$tmplhtml{$1}/g;
		print $_;
	}
	close(IN);
}
