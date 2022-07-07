use ExtUtils::MakeMaker;
use strict;
use warnings;
use 5.008003;

## No version.pm for this one, as the prereqs are not loaded yet.
my $VERSION = '5.6.0';

WriteMakefile(
    NAME         => 'bucordo',
    clean        => { FILES => 'log.bucordo.* *~ *.tmp outgoingmail.* bucordo_test_database*/ test.sqlite.db' },
    ABSTRACT     => 'Postgres asynchronous multi-master replication system',
    AUTHOR       => 'Greg Sabino Mullane <greg@turnstep.com>',
    LICENSE      => 'BSD',
    PREREQ_PM    => {
                     'CGI'                 => '0',
                     'DBD::Pg'             => '2.0',
                     'DBI'                 => '1.51',
                     'DBIx::Safe'          => '1.2.4',
                     'Encode::Locale'      => '0',
                     'ExtUtils::MakeMaker' => '6.32',
                     'File::Spec'          => '0',
                     'IO::Handle'          => '1.24',
                     'List::Util'          => '0',
                     'MIME::Base64'        => '0',
                     'Net::SMTP'           => '0',
                     'Pod::Parser'         => '0',
                     'Pod::Usage'          => '0',
                     'Sys::Hostname'       => '1.11',
                     'Sys::Syslog'         => '0.13',
                     'Test::Harness'       => '2.03',
                     'Test::More'          => '0.61',
                     'Time::HiRes'         => '0',
                 },
    NO_META      => 1,
    NEEDS_LINKING => 0,
    VERSION_FROM => 'bucordo.pm',
    EXE_FILES    => ['bucordo'],
    MAN1PODS     => { 'bucordo' => 'blib/man1/bucordo.1pm' },
    NORECURS     => 1,
    META_MERGE   => {
        resources => {
            repository => 'https://github.com/bucordo/bucordo',
        },
    },
);

package MY;

sub clean {
    my $string = shift->SUPER::clean(@_);
    $string =~ s{\t}{\tperl t/98-cleanup\.t\n\t};
    $string .= qq{\n\nhtml : \n\t};
    $string .= qq{\t\$(NOECHO) pod2html bucordo.pm > bucordo.pm.html\n};
    $string .= qq{\t\$(NOECHO) pod2html bucordo > bucordo.html\n};
    $string .= qq{\t\$(NOECHO) \$(RM_F) pod*.tmp pm_to_blib\n};
    $string .= qq{\t\$(NOECHO) \$(PERL) -pi -e "s/<link.*?>//" bucordo.pm.html bucordo.html\n};
    $string .= qq{\t\$(NOECHO) \$(PERL) -pi -e "s~\\`\\`(.+?)''~&quot;\\1&quot;~g" bucordo.pm.html bucordo.html\n};
    $string .= qq{\t\$(NOECHO) \$(ECHO) Created bucordo.pm.html and bucordo.html\n};
    return $string;
}

sub blibdirs {
    my $string = shift->SUPER::blibdirs_target(@_);
    $string = qq{INST_SHARE = blib/share\n\n$string};
    $string =~ s{(blibdirs : .+)}{$1 \$(INST_SHARE)\$(DFSEP).exists};
    $string .= qq{\$(INST_SHARE)\$(DFSEP).exists :: Makefile.PL\n};
    $string .= qq{\t\$(NOECHO) \$(MKPATH) \$(INST_SHARE)\n};
    $string .= qq{\t\$(NOECHO) \$(CHMOD) 755 \$(INST_SHARE)\n};
    $string .= qq{\t\$(NOECHO) \$(TOUCH) \$(INST_SHARE)\$(DFSEP).exists\n};
    $string .= qq{\t\$(CP) bucordo.schema \$(INST_SHARE)/bucordo.schema\n};
    $string .= qq{\t-\$(NOECHO) \$(CHMOD) \$(PERM_RW) \$(INST_SHARE)/bucordo.schema\n};
    return $string;
}

sub install {
    my $string = shift->SUPER::install(@_);
    my $vars = qq{DESTINSTALLSHARE = \$(INSTALL_BASE)/usr/local/share/bucordo\n};
    $vars .= qq{DESTINSTALLSITESHARE = \$(INSTALL_BASE)/usr/local/share/bucordo\n};
    $vars .= qq{DESTINSTALLVENDORSHARE = \$(INSTALL_BASE)/usr/share/bucordo\n};

    if ($ENV{INSTALL_bucordoDIR}) {
        for my $dir (qw{SCRIPT LIB MAN1DIR MAN3DIR}) {
            $vars .= qq{INSTALLSITE$dir=$ENV{INSTALL_bucordoDIR}\n};
        }
        for my $dir (qw{SITEARCH ARCHLIB SITESHARE}) {
            $vars .= qq{DESTINSTALL$dir=$ENV{INSTALL_bucordoDIR}\n};
        }
    }

    $string = "\n$vars\n$string";
    $string =~ s{(\t"?\$\(INST_BIN\)"? "?\$\((DESTINSTALL.*?)BIN.+)"?}{$1\n\t\t\$(INST_SHARE) \$($2SHARE) \\}g;
    return $string;
}
