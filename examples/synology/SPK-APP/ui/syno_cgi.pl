#**************************************************************************#
#  syno_cgi.pl                                                             #
#  Description: Script to get the query parameters and permissions of      #
#               active user for the calling perl 3rd party application.    #
#               Replaces the need for CGI.pm no longer shipped in DSM-6.   #
#               my $p = param ('foo') provides qs-parameter same as CGI.pm #
#               my ($a,$u,$t) = usr_priv() provides user sys priviledges.  #
#               $a=in admin grp, $u=name of active user, $t=syno token.    #
#  Author:      TosoBoso & QTip's input; German Synology Support Forum.    #
#  Copyright:   2017-2020 by TosoBoso                                      #
#  License:     GNU GPLv3 (see LICENSE)                                    #
#  ------------------------------------------------------------------- --  #
#  Version:     0.3 - 05/65/2020                                           #
#**************************************************************************#
my $rpInitialised = 0; # to have requestParams only loaded once
my $reqParams; # html query string captured from cgi

sub parse_qs { # parsing the quesry string provided via get or post
    my $queryString = shift; # query string to parse from get or post
    my @pairs = split(/&/, $queryString);
    foreach $pair (@pairs) {
        my ($key, $value) = split(/=/, $pair);
        $value =~ tr/+/ /; # trim away +
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $value =~ s/\r\n/\n/g; # windows fix
        $value =~ s/\r/\n/g; # mac fix
        $reqParams->{lc($key)}=$value; # normalize to lower case
    }
    $rpInitialised = 1;
}
sub param { # html-get / post parameters as alternative to cgi.pm not always shiped on syno
    my $rp = shift; # the get request parameter
    return '' if ( !$rp || !$ENV{'REQUEST_METHOD'} ); # exit if no request set
    # parse once url params from query string this will catch anything after the "?"
    if( ($ENV{'REQUEST_METHOD'} eq 'GET') && $ENV{'QUERY_STRING'} && !$rpInitialised) {
        parse_qs($ENV{'QUERY_STRING'});
    }    
    if( ($ENV{'REQUEST_METHOD'} eq 'POST') && !$rpInitialised) {
        my $formData; # data from form via post
        read(STDIN, $formData, $ENV{'CONTENT_LENGTH'});
        parse_qs($formData);
    }
    return $reqParams->{$rp};
}
sub usr_ingrp { # check if user is in particular group
    my $user = shift; # the user parameter
    my $group = shift; # the group parameter
    my $isInGroup = 0;
    return 0 if (!$user || !$group); # no point for empty parameters
    if (open (IN,"/etc/group")) {
        while(<IN>) {
            $isInGroup = 1 if ( /$group:/ && /$user/ );
        }
        close(IN);
    }
    return ($isInGroup);
}
sub usr_priv { # admin priviledge on system level via id -G = 101
    my $isAdmin = 0;
    my $user = '';
    my $token = '';
    # save http_get environment and restore later to get syno-cgi working for token and user
    my $tmpenv = $ENV{'QUERY_STRING'};
    my $tmpreq = $ENV{'REQUEST_METHOD'};
    $ENV{'QUERY_STRING'}="";
    $ENV{'REQUEST_METHOD'} = 'GET';
    # get the synotoken to verify login
    if (open (IN,"/usr/syno/synoman/webman/login.cgi|")) {
        while(<IN>) {
            if (/SynoToken/) { ($token)=/SynoToken" *: *"([^"]+)"/; }
        }
        close(IN);
    }
    else {
        $token = 'no-permission login.cgi';
    }
    if ( $token ne '' && $token ne 'no-permission login.cgi' ) { # no token no query respectively in cmd-line mode
        $ENV{'QUERY_STRING'}="SynoToken=$token";
        $ENV{'X-SYNO-TOKEN'} = $token;
        if (open (IN,"/usr/syno/synoman/webman/modules/authenticate.cgi|")) {
            $user=<IN>;
            chop($user);
            close(IN);
        }
        $ENV{QUERY_STRING} = $tmpenv;
        $ENV{'REQUEST_METHOD'} = $tmpreq;
    }
    else {
        $ENV{QUERY_STRING} = $tmpenv;
        $ENV{'REQUEST_METHOD'} = $tmpreq;
        return (0,'null',$token);
    }
    # verify if active user is part of administrators group on syno: 101
    if ($user && open (IN,"id -G ".$user." |")) {
        my $groupIds=<IN>;
        chop($groupIds) if $groupIds;
        $isAdmin = 1 if index($groupIds, "101") != -1;
        close(IN);
    }    
    return ($isAdmin,$user,$token);
}
sub admin_or_die { # wrappes isadmin from user_priv and exit html msg
    my $isDebug = shift; # debug modus enable for cmd-line test and to get query, token info
    my $debug = shift; # debug text
    my $cgiUser = $ENV{LOGNAME} || getpwuid($<) || $ENV{USER};
    my $xsToken = !$ENV{'X-SYNO-TOKEN'} ? 'null' : $ENV{'X-SYNO-TOKEN'}; # synology token against xss in header
    # get the users priviledges and synotoken to verify login
    my ($isAdmin,$uiUser,$dsmToken) = usr_priv();
    if ($uiUser eq 'null' && $isDebug) { # tweak for debugging from cmd-line
       $isAdmin = 1;
       $uiUser = $cgiUser;
    }
    $debug = "CGI-User: $cgiUser, UI-User: $uiUser isAdmin: $isAdmin, dsmToken: $dsmToken, xsToken: $xsToken" if $isDebug;
    # exit with warning if not admin or in admin group
    if ( !$isAdmin ) {
        print "<HTML><HEAD><TITLE>Login Required</TITLE></HEAD><BODY><H3>&nbsp;Please login as priviledged admin for using this webpage<br>&nbsp;user cgi / ui: $cgiUser / $uiUser, token: $dsmToken</H3></BODY></HTML>\n";
        die;
    }
    return ($debug);
}
# return true for included libraries
1;
