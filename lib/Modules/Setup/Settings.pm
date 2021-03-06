#!/usr/bin/env perl

package Modules::Setup::Settings;

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../";
use Log::Log4perl;

#object creation
sub new {
	my ($class) = shift;
	my $self = {};
	bless( $self, $class );
	$self->_initialize(@_);
	return $self;
}

sub _initialize{
	my($self)=shift;

    #logging
    $self->logger(Log::Log4perl->get_logger());    
    $self->logger->info("Logger initialized in Modules::Setup::Settings");  

    $self->_getSettingsFromConfigurationFile(@_);
    $self->_setDefaults();
}


#class variables
sub logger{
	my $self=shift;
	$self->{'_logger'} = shift // return $self->{'_logger'};
}

sub queryFile{
	my $self=shift;
	$self->{'_queryFile'}=shift // return $self->{'_queryFile'};
}

sub numberOfLoci{
	my $self=shift;
	$self->{'_numberOfLoci'}=shift // return $self->{'_numberOfLoci'};
}

sub blastDatabase{
	my $self=shift;
	$self->{'_blastDatabase'} = shift // return $self->{'_blastDatabase'};	
}

sub toAnnotate{
	my $self=shift;
	$self->{'_toAnnotate'}=shift // return $self->{'_toAnnotate'};
}

sub mummerNumberOfInstances{
	my $self=shift;
	$self->{'_mummerNumberOfInstances'}=shift // return $self->{'_mummerNumberOfInstances'};
}

sub queryDirectory {
	my $self = shift;
	$self->{'_queryDirectory'} = shift // return $self->{'_queryDirectory'};
}

sub referenceDirectory {
	my $self = shift;
	$self->{'_referenceDirectory'} = shift // return $self->{'_referenceDirectory'};
}

sub baseDirectory {
	my $self = shift;
	$self->{'_baseDirectory'} = shift // return $self->{'_baseDirectory'};
}

sub numberOfCores {
	my $self = shift;
	$self->{'_numberOfCores'} = shift // return $self->{'_numberOfCores'};
}

sub mummerDirectory {
	my $self = shift;
	$self->{'_mummerDirectory'} = shift // return $self->{'_mummerDirectory'};
}

sub minimumNovelRegionSize {
	my $self = shift;
	$self->{'_minimumNovelRegionSize'} = shift // return $self->{'_minimumNovelRegionSize'};
}

sub createGraphic {
	my $self = shift;
	$self->{'_createGraphic'} = shift // return $self->{'_createGraphic'};
}

sub combinedQueryFile {
	my $self = shift;
	$self->{'_combinedQueryFile'} = shift // return $self->{'_combinedQueryFile'};
}

sub combinedReferenceFile{
	my $self=shift;
	$self->{'_combinedReferenceFile'}=shift // return $self->{'_combinedReferenceFile'};
}

sub queryNameObjectHash {
	my $self = shift;
	$self->{'_queryNameObjectHash'} = shift // return $self->{'_queryNameObjectHash'};
}

sub nucB {
	my $self = shift;
	$self->{'_PanseqShared_novel_nucB'} = shift // return $self->{'_PanseqShared_novel_nucB'};
}

sub nucC {
	my $self = shift;
	$self->{'_PanseqShared_novel_nucC'} = shift // return $self->{'_PanseqShared_novel_nucC'};
}

sub nucD {
	my $self = shift;
	$self->{'_PanseqShared_novel_nucD'} = shift // return $self->{'_PanseqShared_novel_nucD'};
}

sub nucG {
	my $self = shift;
	$self->{'_PanseqShared_novel_nucG'} = shift // return $self->{'_PanseqShared_novel_nucG'};
}

sub nucL {
	my $self = shift;
	$self->{'_PanseqShared_novel_nucL'} = shift // return $self->{'_PanseqShared_novel_nucL'};
}

sub validator {
	my $self = shift;
	$self->{'_panseqShared_validator'} = shift // return $self->{'_panseqShared_validator'};
}

sub blastDirectory{
	my $self=shift;
	$self->{'_CoreAccessory_blastDirectory'}=shift // return $self->{'_CoreAccessory_blastDirectory'};
}

sub mummerNumberOfSplitFiles{
	my $self=shift;
	$self->{'_mummerNumberOfSplitFiles'}=shift // return $self->{'_mummerNumberOfSplitFiles'};
}

sub mummerBpPerSplitFile{
	my $self=shift;
	$self->{'_mummerBpPerSplitFile'}=shift // return $self->{'_mummerBpPerSplitFile'};
}

sub novelRegionFinderMode{
	my $self=shift;
	$self->{'_novelRegionFinderMode'} = shift // return $self->{'_novelRegionFinderMode'};
}

sub runMode{
	my $self=shift;
	$self->{'_mode'}=shift // return $self->{'_mode'};
}

sub fragmentationSize{
	my $self=shift;
	$self->{'_fragmentationSize'}=shift // return $self->{'_fragmentationSize'};
}

sub percentIdentityCutoff{
	my $self=shift;
	$self->{'_percentIdentityCutoff'}=shift // return $self->{'_percentIdentityCutoff'};
}

sub coreGenomeThreshold{
	my $self=shift;
	$self->{'_coreGenomeThreshold'}=shift // return $self->{'_coreGenomeThreshold'};
}

sub muscleExecutable{
	my $self=shift;
	$self->{'_muscleExecutable'}=shift // return $self->{'_muscleExecutable'};
}

sub accessoryType{
	my $self=shift;
	$self->{'_accessoryType'}=shift // return $self->{'_accessoryType'};
}

#methods
sub _getSettingsFromConfigurationFile {
	my ($self) = shift;

	if (@_) {
		my $fileName = shift;
		my $inFile = IO::File->new( '<' . $fileName ) or die "\nCannot open $fileName\n $!";
		
		while ( my $line = $inFile->getline ) {
			next unless $line =~ m/\t/;
			
			$line =~ s/\R//g;
			my @la = split(/\t/,$line);

			my $setting = $la[0] // undef;
			my $value   = $la[1] // undef;
			
			$self->_setSettingValue($setting,$value);
		}
		$inFile->close();
	}
	else {
		$self->logger->fatal("No configuration file specified");
		exit(1);
	}
}

sub _setSettingValue{
	my $self = shift;
	my $setting=shift;
	my $value=shift;

	#we check to see if a setting set in the config file exists
	#if it does, we add the value
	#if not, we print a warning

	if($self->can($setting)){
		$self->$setting($value);

		$self->logger->debug("Loading setting $setting with value $value");
	}
	else{
		$self->logger->info("Setting $setting is not valid, skipping");
	}
}

sub _setDefaults{
	my $self=shift;

	unless(defined $self->minimumNovelRegionSize){
		$self->minimumNovelRegionSize(0);
		$self->logger->info("Setting default minimumNovelRegionSize to 0");
	}

	unless(defined $self->fragmentationSize){
		$self->fragmentationSize(0);
		$self->logger->info("Setting default fragmentation size to 0");
	}

	unless(defined $self->runMode && $self->runMode eq 'pan' && defined $self->accessoryType){
		$self->accessoryType('binary');
	}
}

1;

