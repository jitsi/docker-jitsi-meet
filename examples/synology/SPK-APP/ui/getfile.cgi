#!/usr/bin/perl
use strict;
use warnings;
my $isDebug = 0; # debug modus enable for cmd-line test and to get query, token info
my $debug = ""; # debug text
my $uiDir=$0; # get current working dir runing ui
$uiDir=~s#/[^/]+$##g; # cleaning to get dirname
require "$uiDir/syno_cgi.pl"; # base cgi functions get params, usr_priv

# *** common head cgi section: set html context, verify login
print "Content-type: text/html\n\n";
admin_or_die($isDebug, $debug); # returns user infor in debug string, when debug is on it will not die
$debug .= " QueryStr: $ENV{'QUERY_STRING'}" if $isDebug && $ENV{'QUERY_STRING'};

# *** specific cgi section:
my $action = param('action'); # action has the cfg-filename to parse
my %fileVal; # key-value array to capture cfg-files

if (open(IN,"$uiDir/configfiles.txt")) { 
	while(<IN>) {
		chop();
		if ((!(/^#/))&&(/,/)) { 
			my ($file,$name)=/([^,]+),([^,]+)/;
			$file=~s/^\s*//;
			$name=~s/^\s*//;
			$fileVal{$name}=$file;
            # replicate entry for file name copy in original folder with same ending
			$fileVal{$name .'.original'}="$uiDir/" .'/original/' .$name .'.original';
		}
	}
	close(IN);
}

if ($action && open (IN,$fileVal{$action})) {
	while(<IN>) {
		print;
	}
	close(IN);
}
else {
	print "no cfg file found or no action paramater provided\n";
}
