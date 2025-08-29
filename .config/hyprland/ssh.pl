#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;

my $ssh_config_file = "~/.ssh/config";
my $terminal        = 'alacritty -e zsh -c';
my $ssh_command     = 'ssh';

sub get_hosts {
    my @hosts;

    my $parse_file;
    $parse_file = sub {
        my ($filename) = @_;
        $filename =~ s/^~/$ENV{HOME}/;    # Expand tilde manually

        open my $fh, '<', $filename or do {
            warn "Error opening $filename: $!\n";
            return;
        };

        while ( my $line = <$fh> ) {
            $line =~ s/^\s+//;    # lstrip

            # Ignore wildcards
            if ( $line =~ /^Host\s+/ && $line !~ /\*/ ) {
                my @parts = split /\s+/, $line;
                shift @parts;     # Remove 'Host'
                push @hosts, @parts;
            }
            elsif ( $line =~ /^Include\s+/ && $line !~ /\*/ ) {
                my $include_file = $line;
                $include_file =~ s/^Include\s+//;
                chomp $include_file;
                $parse_file->($include_file);
            }
        }
        close $fh;
    };

    $parse_file->($ssh_config_file);

    # Remove duplicates and sort
    my %seen;
    @hosts = sort grep { !$seen{$_}++ } @hosts;

    return @hosts;
}

sub parse_hosts {
    my (@hosts) = @_;
    return join( "\n", @hosts );
}

sub show_menu {
    my ($hosts) = @_;

    # Check which menu program is available
    my $command;
    if ( system("which wofi > /dev/null 2>&1") == 0 ) {
        $command = 'wofi -p "SSH hosts: " -d -i --hide-scroll';
    }
    elsif ( system("which rofi > /dev/null 2>&1") == 0 ) {
        $command = 'rofi -dmenu -p "SSH hosts: " -i';
    }
    else {
        die "Neither wofi nor rofi is installed\n";
    }

    my $selected = `echo '$hosts' | $command`;
    chomp $selected;
    return $selected;
}

sub ssh_to_host {
    my ( $host, $terminal, $ssh_command ) = @_;
    my $command = sprintf "%s '%s %s'", $terminal, $ssh_command, $host;
    system($command);
}

# Main

my @hosts        = get_hosts();
my $parsed_hosts = parse_hosts(@hosts);

my $selected = show_menu($parsed_hosts);
chomp $selected;

if ($selected) {
    ssh_to_host( $selected, $terminal, $ssh_command );
}