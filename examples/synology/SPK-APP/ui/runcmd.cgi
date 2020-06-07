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
my %cmdVal; # key-value array to capture commands
my $cmd = param('cmd'); # the command incl. path to run
my $action = param('action'); # action are the paramters

if (open(IN,"$uiDir/commands.txt")) { 
	while(<IN>) {
		chop();
		if ((!(/^#/))&&(/,/)) { 
			my ($script,$name)=/([^,]+),([^,]+)/;
			$script=~s/^\s*//;
			$name=~s/^\s*//;
			$cmdVal{$name}=$script;
		}
	}
	close(IN);
}

if ($cmdVal{$cmd}) { # cmd was found so run it
	my $return;
	if (open (IN,$cmdVal{$cmd}." " .$action." >/tmp/cmd.out 2>&1 |")) {
		$return=<IN>;
    	chop($return) if $return;
		print "$return\n";
	    close(IN);
		if (open(IN,'/tmp/cmd.out')) { 
			while(<IN>) {
				chomp();
				#$_=~ s/[^[:print:]]+//g; # remove non-printable chars and colour codes if not run with --no-ansi
				s/[^[:print:]]+//g; # remove non-printable chars and colour codes from docker-compose
				s/\[32m//g; # remove non-printable chars
				s/\[0m\[[0-9]B//g; # remove non-printable chars
				s/\[[0-9]A\[2K/\n/g; # remove non-printable chars
				print "$_\n" if $_ ne '';
			}
			close(IN);
		}
		unlink('/tmp/cmd.out');
	}
	else {
		print "failed to run $cmdVal{$cmd} $action \n";
	}
}
else {
	print "error: command $cmd not part of registered ones to run\n";
}
