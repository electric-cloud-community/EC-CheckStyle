my %runCheckStyle = (
    label       => "CheckStyle - Code Analysis",
    procedure   => "runCheckStyle",
    description => "Integrates CheckStyle code checking tool into Electric Commander",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/CheckStyle - Code Analysis");  
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-CheckStyle - runCheckStyle");

@::createStepPickerSteps = (\%runCheckStyle);
