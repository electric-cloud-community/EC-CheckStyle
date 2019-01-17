# -------------------------------------------------------------------------
# Package
#    checkStyleDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Use CheckStyle tool features on Electric Commander
#
# Plugin Version
#    1.0.1
#
# Date
#    05/11/2011 
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use ElectricCommander;
use warnings;
use strict; 
$|=1;



# -------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------
use constant TYPE_TARGET_DIRECTORY => 'dir';
use constant TYPE_TARGET_FILE => 'file';

# -------------------------------------------------------------------------
# Variables
# -------------------------------------------------------------------------
########################################################################
# trim - deletes blank spaces before and after the entered value in
# the argument
#
# Arguments:
#   -shift: string that will be trimmed
#
# Returns:
#   trimmed string
#
########################################################################
sub trim($) {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

$::gJavaPath = trim(q($[javapath]));
$::gCheckStyleJarToExecute = trim(q($[commandtoexec]));
$::gConfigFile = trim(q($[configfile]));
$::gOutputFormat = "$[outputformat]";
$::gPropertiesFile = "$[propertiesfile]";
$::gOutputFile = trim(q($[outputfile]));
$::gTargetType = "$[targettype]";
$::gTargetAnalize = trim(q($[targets]));
$::gWorkingDir = trim(q($[workingDir]));
$::gAdditionalCommands = "$[checkstylecommands]";

# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------

########################################################################
# main - contains the whole process to be done by the plugin, it builds the
#        command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
    
    # create args array
    my @args = ();
    
    #properties' map
    my %props;
    
    #add path to exec if entered
    my $executable = '';
    
    if($::gJavaPath && $::gJavaPath ne ''){
        $executable = $::gJavaPath;
    }
    
    #writes the default executable for the java binary archive
    $executable .= 'java';
    push(@args, qq{"$executable"});
    
    #add additional commands if they were entered by the user
    if($::gAdditionalCommands  && $::gAdditionalCommands  ne '') {
        foreach my $checkCommand (split(' +', $::gAdditionalCommands)) {
            push(@args, "$checkCommand");
        }
    }
    
    #adds CheckStyle's jar file to be executed
    if($::gCheckStyleJarToExecute && $::gCheckStyleJarToExecute ne '') {
        push(@args, '-jar "' . $::gCheckStyleJarToExecute . '"');
    }
    
    #adds specified configuration file
    if($::gConfigFile && $::gConfigFile ne ''){
        push(@args, '-c "' . $::gConfigFile . '"');
    }

    #adds requested output format
    if($::gOutputFormat && $::gOutputFormat ne '') {
        push(@args, '-f "' . $::gOutputFormat . '"');
    }
    
    #adds specified properties file
    if($::gPropertiesFile && $::gPropertiesFile ne '') {
        push(@args, '-p "' . $::gPropertiesFile . '"');
    }
    
    #adds the output file
    if($::gOutputFile && $::gOutputFile ne '') {
        push(@args, '-o "' . $::gOutputFile . '"');
    }
    
    #adds the type of the target on which the analysis will rely
    if($::gTargetType && $::gTargetType ne ''){
     
        #is the target a directory? 
        if($::gTargetType eq TYPE_TARGET_DIRECTORY){
         
             push(@args, '-r "' . $::gTargetAnalize . '"');
        
        #is the target a file?
        }elsif($::gTargetType eq TYPE_TARGET_FILE){
         
             push(@args, '"' . $::gTargetAnalize . '"');
        
        }else{
         
             #default behavior
             push(@args, '-r "' . $::gTargetAnalize . '"');
         
        }
     
    }

    #generate the command to execute in console
    $props{'checkStyleCommandLine'} = createCommandLine(\@args);
    
    #adds the working directory to the properties hash
    $props{'workingDir'} = $::gWorkingDir;
    
    #sets the property hash
    setProperties(\%props);

}

########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine($) {

  	my ($arr) = @_;

    my $commandName = @$arr[0];

    my $command = $commandName;

    shift(@$arr);

	foreach my $elem (@$arr) {
        $command .= " $elem";
    }

    return $command;
    
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}

main();
