#-------------------------------------------------------------------------
# setup.pl -
#
# Perform setup steps needed by the test suite.  Clears out state that
# might interfere with the tests and installs the plugin to test.
#-------------------------------------------------------------------------

use strict;
use ElectricCommander;

$|=1;

use constant EXIT_CODE_ERROR_1 => 1;

my $server = shift;
my $outtop = shift;

my $N = new ElectricCommander({
    server => $server,
    abortOnError => 0
});

$N->login('admin','changeme');

my @prereqs = ('EC-CheckStyle');

foreach (@prereqs) {
    print "Uninstalling $_\n";
    $N->uninstallPlugin("\$[/plugins/$_]");
}

foreach (@prereqs) {
    print "Installing $_\n";
    my $file = "$outtop/$_/$_.jar";
    my $xpath = $N->installPlugin($file);
    my $msg = $N->getError();
    if ($msg ne '') {
        print "Error installing plugin.\n";
        print $msg;
        exit EXIT_CODE_ERROR_1;
    }
    $N->promotePlugin($xpath->findvalue("//pluginName")->value);
    $msg = $N->getError();
    if ($msg ne '') {
        print "Error promoting plugin.\n";
        print $msg;
        exit EXIT_CODE_ERROR_1;
    }
}


