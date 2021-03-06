package OTRS::OPM::Analyzer::Role::License;

# ABSTRACT: Check if an appropriate License is used

use Moose::Role;
use Software::License;
use Software::LicenseUtils;

with 'OTRS::OPM::Analyzer::Role::Base';

sub check {
    my ($self,$opm) = @_;
    
    my $license  = $opm->license;
    my $name     = $opm->name;
    return "Could not find any license for $name." if !$license;
    
    # software::licenseutils expect pod, so we have to fake
    # a small pod section
    my $pod = qq~
    =head1 License
    
    $license
    ~;
    
    # try to find the appropriate license
    my @licenses_found = Software::LicenseUtils->guess_license_from_pod( $pod );
    
    my $warning = '';
    if ( !@licenses_found ) {
        $warning = "Could not find the open source license in Software::License for $license.";
    }
    
    return $warning;
}

no Moose::Role;

1;
=head1 METHODS

=head2 check

Check if a license is used that is recognised by L<Software::License>


