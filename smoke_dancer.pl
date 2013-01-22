#!/usr/bin/perl 

use strict;
use warnings;

use 5.10.0;
 
package Smoked;
 
use Moose;

use Method::Signatures;
use IPC::Run3;
 
extends 'SmokedMeat::Smoker';
with 'SmokedMeat::Pinto';
with 'SmokedMeat::Store';

has dancer_version => (
    is => 'ro', 
    lazy => 1,
    default => method {
        my $version;
        run3 [ $self->perl_exec, '-MDancer', '-e', 'print dancer_version' ],
            \undef, \$version, \undef;
        return $version;
    }
);

has dancer_api_version => (
    is => 'ro', 
    lazy => 1,
    default => method {
        int $self->dancer_version;
    }
);
 
say __PACKAGE__->new(
    package_name  => $_,
    debug         => 1,
    log_to_stdout => 1,
)->run_tests for qw/ Dancer::Plugin::Cache::CHI /;

