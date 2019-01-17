use Cwd;

@::gMatchers = (
  {
   id =>        "cs-annotation",
   pattern =>          q{(A|a)nnotation },
   action =>           q{incValueWithString("cs-annotation-sum", "Annotations: Detected 0 issues");updateSummary();},
  },
  {
   id =>        "cs-block",
   pattern =>          q{ (B|b)lock },
   action =>           q{incValueWithString("cs-block-sum", "Block: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-line",
   pattern =>          q{ (L|l)ine },
   action =>           q{incValueWithString("cs-line-sum", "Lines: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-method",
   pattern =>          q{ (M|m)ethod },
   action =>           q{incValueWithString("cs-method-sum", "Methods: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-parentheses",
   pattern =>          q{(P|p)arentheses },
   action =>           q{incValueWithString("cs-parentheses-sum", "Parentheses: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-package",
   pattern =>          q{(P|p)acakage },
   action =>           q{incValueWithString("cs-package-sum", "Packages: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-duplicate",
   pattern =>          q{ (D|d)uplicate },
   action =>           q{incValueWithString("cs-duplicate-sum", "Duplicated: 0 inconsistencies");updateSummary();},
  },
  {
   id =>        "cs-header",
   pattern =>          q{ (H|e)ader },
   action =>           q{incValueWithString("cs-header-sum", "Headers status: Detected 0 issues");updateSummary();},
  },
  {
   id =>        "cs-variable",
   pattern =>          q{ (V|v)ariable },
   action =>           q{incValueWithString("cs-variable-sum", "Variables: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-field",
   pattern =>          q{ (F|f)ield },
   action =>           q{incValueWithString("cs-field-sum", "Fields: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-equals",
   pattern =>          q{[^']equals[^']},
   action =>           q{incValueWithString("cs-equals-sum", "Equals usage: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-import",
   pattern =>          q{ (I|i)mport },
   action =>           q{incValueWithString("cs-import-sum", "Import usage: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-indentation",
   pattern =>          q{ (I|i)ndentation },
   action =>           q{incValueWithString("cs-indentation-sum", "Indentation: 0 issues");updateSummary();},
  },
  {
   id =>        "javadoc",
   pattern =>          q{[^'](J|j)avadoc[^']},
   action =>           q{incValueWithString("cs-javadoc-sum", "Javadoc: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-modifier",
   pattern =>          q{ Modifier },
   action =>           q{incValueWithString("cs-modifier-sum", "Modifier: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-parameters",
   pattern =>          q{ (P|p)arameters },
   action =>           q{incValueWithString("cs-parameters-sum", "Parameters: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-whitespace",
   pattern =>          q{ (W|w)hitespace },
   action =>           q{incValueWithString("cs-whitespace-sum", "White Spaces: 0 issues");updateSummary();},
  },
  {
   id =>        "cs-illegalcharacter",
   pattern =>          q{illegal character},
   action =>           q{incValueWithString("cs-illegalcharacter-sum", "Illegal chars: 0 inconsistencies detected");updateSummary();},
  },
  {
   id =>        "cs-exception",
   pattern =>          q{Got an exception},
   action =>           q{ incValueWithString("cs-exception-sum", "Exception while validating");
                          if(defined $::gProperties{"cs-exception-sum"}){
                            if($::gProperties{"cs-exception-sum"} ne ''){
                              #exit 1;
                            }
                          }
                         }
    },
    #Generic errors
    {
        id =>        "endOfLogFile",
        pattern =>          q{^Audit done|</checkstyle> (.*)},
        action =>           q{&fancyReport();updateSummary();},
    },
  
  
);

sub incValueWithString($;$$) {
    my ($name, $patternString, $increment) = @_;

    $increment = 1 unless defined($increment);

    my $localString = (defined $::gProperties{$name}) ? $::gProperties{$name} :
                                                        $patternString;

    $localString =~ /([^\d]*)(\d+)(.*)/;
    my $leading = $1;
    my $numeric = $2;
    my $trailing = $3;
    
    $numeric += $increment;
    $localString = $leading . $numeric . $trailing;

    setProperty ($name, $localString);
}

#reads a template and create a new chart report to display results
sub fancyReport{
    #my ($passed,$failed,$inconclusive,$skipped) = @_;
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);
    
    
    #Variables
    my $annotations= (defined $::gProperties{"cs-annotation-sum"}) ? getNumberFromString($::gProperties{"cs-annotation-sum"}) : 0;
    my $blocks= (defined $::gProperties{"cs-block-sum"}) ? getNumberFromString($::gProperties{"cs-block-sum"}) : 0;
    my $lines= (defined $::gProperties{"cs-line-sum"}) ? getNumberFromString($::gProperties{"cs-line-sum"}) : 0;
    my $methods= (defined $::gProperties{"cs-method-sum"}) ? getNumberFromString($::gProperties{"cs-method-sum"}) : 0;
    my $parentheses= (defined $::gProperties{"cs-parentheses-sum"}) ? getNumberFromString($::gProperties{"cs-parentheses-sum"}) : 0;
    my $packages= (defined $::gProperties{"cs-package-sum"}) ? getNumberFromString($::gProperties{"cs-package-sum"}) : 0;
    my $duplicates= (defined $::gProperties{"cs-duplicate-sum"}) ? getNumberFromString($::gProperties{"cs-duplicate-sum"}) : 0;
    my $headers= (defined $::gProperties{"cs-header-sum"}) ? getNumberFromString($::gProperties{"cs-header-sum"}) : 0;
    my $variables= (defined $::gProperties{"cs-variable-sum"}) ? getNumberFromString($::gProperties{"cs-variable-sum"}) : 0;
    my $fields= (defined $::gProperties{"cs-field-sum"}) ? getNumberFromString($::gProperties{"cs-field-sum"}) : 0;
    my $equals= (defined $::gProperties{"cs-equals-sum"}) ? getNumberFromString($::gProperties{"cs-equals-sum"}) : 0;
    my $imports= (defined $::gProperties{"cs-import-sum"}) ? getNumberFromString($::gProperties{"cs-import-sum"}) : 0;
    my $indentations= (defined $::gProperties{"cs-indentation-sum"}) ? getNumberFromString($::gProperties{"cs-indentation-sum"}) : 0;
    my $javadocs= (defined $::gProperties{"cs-javadoc-sum"}) ? getNumberFromString($::gProperties{"cs-javadoc-sum"}) : 0;
    my $modifiers= (defined $::gProperties{"cs-modifier-sum"}) ? getNumberFromString($::gProperties{"cs-modifier-sum"}) : 0;
    my $parameters= (defined $::gProperties{"cs-parameters-sum"}) ? getNumberFromString($::gProperties{"cs-parameters-sum"}) : 0;
    my $whitespaces= (defined $::gProperties{"cs-whitespace-sum"}) ? getNumberFromString($::gProperties{"cs-whitespace-sum"}) : 0;
    my $illegalcharacters= (defined $::gProperties{"cs-illegalcharacter-sum"}) ? getNumberFromString($::gProperties{"cs-illegalcharacter-sum"}) : 0;
    my $exceptions= (defined $::gProperties{"cs-exception-sum"}) ? getNumberFromString($::gProperties{"cs-exception-sum"}) : 0;
    
    my $template = ($ec->getProperty( "/projects/@PLUGIN_KEY@-@PLUGIN_VERSION@/template" ))->findvalue('//value')->string_value;
    #replace template values for the real results
    $template =~ s/_title_/CheckStyle Issues Summary/g;
   
    $template =~ s/_annotations_/$annotations/g;
    $template =~ s/_blocks_/$blocks/g;
	$template =~ s/_lines_/$lines/g;
    $template =~ s/_methods_/$methods/g;
	$template =~ s/_parentheses_/$parentheses/g;
    $template =~ s/_packages_/$packages/g;
	$template =~ s/_duplicates_/$duplicates/g;
    $template =~ s/_headers_/$headers/g;
	$template =~ s/_variables_/$variables/g;
    $template =~ s/_fields_/$fields/g;
	$template =~ s/_equals_/$equals/g;
    $template =~ s/_imports_/$imports/g;
	$template =~ s/_indentations_/$indentations/g;
    $template =~ s/_javadocs_/$javadocs/g;
	$template =~ s/_modifiers_/$modifiers/g;
    $template =~ s/_parameters_/$parameters/g;
	$template =~ s/_whitespaces_/$whitespaces/g;
    $template =~ s/_illegalcharacters_/$illegalcharacters/g;
	$template =~ s/_exceptions_/$exceptions/g;
    
    
    #create a report in the job's folder
    open (MYFILE, '>>CheckStyleIssuesSummary.html');
    print MYFILE "$template";
    close (MYFILE);
    #get the jobId
    my $jobId = getStepId();
    #create the new report url pointing to our brand new report
    $ec->setProperty("/myJob/artifactsDirectory", '');
    $ec->setProperty("/myJob/report-urls/@PLUGIN_KEY@ Issues Summary Report","jobSteps/$jobId/CheckStyleIssuesSummary.html");
}

#returns the current job id
sub getStepId{
    my $folder = cwd.'/';
    my $filter = "*.log";
    my @files = <$folder$filter>;
    print join("\n",@files);
    my $file = @files[0];
    $file =~ m/runCommandLine\.(\d+)/;
    return $1;
}

sub getNumberFromString{

  my $number= 0; #Default is 0
  my ($parameter_String) = @_;
  #my $data = 'Becky Alcorn,25,female,Melbourne';

  my @values = split(' ', $parameter_String);

  foreach my $val (@values) {
    #print "$val\n";
    if ($val =~ /^[+-]?\d+$/ ) {
        $number= $val;
    }
  }

  return $number;

}

sub updateSummary() {
 
    my $summary = (defined $::gProperties{"cs-annotation-sum"}) ? $::gProperties{"cs-annotation-sum"} . "\n" : '';
    
    $summary .= (defined $::gProperties{"cs-block-sum"}) ? $::gProperties{"cs-block-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-line-sum"}) ? $::gProperties{"cs-line-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-method-sum"}) ? $::gProperties{"cs-method-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-parentheses-sum"}) ? $::gProperties{"cs-parentheses-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-package-sum"}) ? $::gProperties{"cs-package-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-duplicate-sum"}) ? $::gProperties{"cs-duplicate-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-header-sum"}) ? $::gProperties{"cs-header-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-variable-sum"}) ? $::gProperties{"cs-variable-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-field-sum"}) ? $::gProperties{"cs-field-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-equals-sum"}) ? $::gProperties{"cs-equals-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-import-sum"}) ? $::gProperties{"cs-import-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-indentation-sum"}) ? $::gProperties{"cs-indentation-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-javadoc-sum"}) ? $::gProperties{"cs-javadoc-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-modifier-sum"}) ? $::gProperties{"cs-modifier-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-parameters-sum"}) ? $::gProperties{"cs-parameters-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-whitespace-sum"}) ? $::gProperties{"cs-whitespace-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-illegalcharacter-sum"}) ? $::gProperties{"cs-illegalcharacter-sum"} . "\n" : '';
    $summary .= (defined $::gProperties{"cs-exception-sum"}) ? $::gProperties{"cs-exception-sum"} . "\n" : '';

    setProperty ('summary', $summary);
}