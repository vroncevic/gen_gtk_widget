#!/usr/bin/env perl
#
# @brief    Generate GTK widget module source files
# @version  ver.1.0
# @date     Mon Dec 26 10:04:59 CET 2016
# @company  None, free software to use 2016
# @author   Vladimir Roncevic <elektron.ronca@gmail.com>
#
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/bin';
use GenGTKWidget qw(gen_gtk_widget);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use CheckStatus qw(check_status);
use Utils qw(def);
use Status;
our $TOOL_DBG = "false";

#
# @brief   Main entry point
# @params  Values required project name and widget name, optional help | manual
# @exitval Script tool gengtkwidget exit with integer value
#			0   - success operation
#			127 - run as root user
#			128 - failed to:
#				load configuration from file or
#				load template files or
#				missing argument(s)
#
my (%option, $projectName, $widgetName, $help, $man);

if(@ARGV > 0) {
	GetOptions(
		'pname=s' => \$projectName, 'wname=s' => \$widgetName,
		'help|?'  => \$help, 'manual'  => \$man
	) || pod2usage(2);
}

my $username = (getpwuid($>));
my $uid = ($<);

if(($username eq "root") && ($uid == 0)) {
	if(def($help) == $SUCCESS) {
		pod2usage(1);
	} elsif(def($man) == $SUCCESS) {
		pod2usage(VERBOSE => 2);
	} else {
		my %status = (
			projectName => def($projectName), widgetName => def($widgetName)
		);
		if(check_status(\%status) == $SUCCESS) {
			$option{PROJECT_NAME} = $projectName;
			$option{WIDGET_NAME} = $widgetName;
			if(gen_gtk_widget(\%option) == $SUCCESS) {
				exit(0);
			}
			exit(128);
		} else {
			pod2usage(1);
		}
	}
}
exit(127);

__END__

########################## POD gen_gtk_widget_run.pl ###########################

=head1 NAME

gengtkwidget - Generate GTK widget module source files

=head1 SYNOPSIS

Use:

	gengtkwidget [options]

	[options] pname wname help manual

Examples:

	# Generate GTK widget module source files example
	gengtkwidget --pname MyProject --wname MyWidget

	# Print this option
	gengtkwidget --help

	# Print code of tool
	gengtkwidget --manual

	# Return values
	0   - success operation 
	127 - run as root user
	128 - failed to:
			load configuration from file or
			load template files or
			missing argument(s)

=head1 DESCRIPTION

This script is for generating GTK widget module source files.

=head1 ARGUMENTS

gengtkwidget takes the following arguments:

=over 4

=item pname

	pname

	(Required.) Project name (destination of GTK module)

=item wname

	wname

	(Required.) Widget name

=item help

	help

	(Optional.) Show help info information

=item manual

	manual

	(Optional.) Display manual

=back

=head1 AUTHORS

Vladimir Roncevic, E<lt>elektron.ronca@gmail.comE<gt>.

=head1 COPYRIGHT

	Free software to use 2016.

=head1 DATE

26-Dec-2016

=cut

########################## POD gen_gtk_widget_run.pl ###########################
