#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Spamd;

use strict;
use warnings;

our $VERSION = '0.94';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Implements( qw(ServerControl::Module::PidFile) );

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Spamd::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   print "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my $pid_dir     = ServerControl::FsLayout->get_directory("Runtime", "pid");
   my $conf_dir    = ServerControl::FsLayout->get_directory("Configuration", "conf");

   my ($name, $path)    = ($class->get_name, $class->get_path);
   my $user             = ServerControl::Args->get->{"user"};
   my $pid_file         = "$path/$pid_dir/$name.pid";

   my $exec_file   = ServerControl::FsLayout->get_file("Exec", "spamd");

   my @options = (
      "-C $path/$conf_dir",
      "-d",
      "-i " . ServerControl::Args->get->{"ip"},
      "-p " . ServerControl::Args->get->{"port"},
      "-m " . ServerControl::Args->get->{"max-children"},
      "--min-spare " . ServerControl::Args->get->{"min-spare"},
      "--max-conn-perl-child=" . ServerControl::Args->get->{"max-conn-per-child"},
      "--pidfile $pid_file",
      "-u " . ServerControl::Args->get->{"user"},
      "-g " . ServerControl::Args->get->{"group"},
   );

   spawn("$path/$exec_file " . join(" ", @options));
}


1;
