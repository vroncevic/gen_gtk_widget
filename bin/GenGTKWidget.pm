package GenGTKWidget;
#
# @brief    Generate GTK widget module source files
# @version  ver.1.0
# @date     Mon Dec 26 10:04:59 CET 2016
# @company  None, free software to use 2016
# @author   Vladimir Roncevic <elektron.ronca@gmail.com>
#
use strict;
use warnings;
use Exporter;
use Sys::Hostname;
use Template;
use POSIX qw(strftime);
use Cwd qw(abs_path getcwd);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use InfoMessage qw(info_message);
use Configuration qw(read_preference);
use Notification qw(notify);
use Logging qw(logging);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(gen_gtk_widget);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Generate GTK widget module source files
# @param   Value required hash argument structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# use GenGTKWidget qw(gen_gtk_widget);
#
# ...
#
# if(gen_gtk_widget(\%option) == $SUCCESS) {
#	# true
#	# notify admin | user
# } else {
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# }
#
sub gen_gtk_widget {
	my %opt = %{$_[0]};
	my $msg = "None";
	if(%opt) {
		$msg = "Generate GTK widget [$opt{WIDGET_NAME}]";
		info_message($msg);
		my ($cfg, $log, %preferences);
		$cfg = dirname(dirname(abs_path(__FILE__))) . "/conf/gengtkwidget.cfg";
		$log = dirname(dirname(abs_path(__FILE__))) . "/log/gengtkwidget.log";
		if(read_preference($cfg, \%preferences) == $SUCCESS) {
			my ($CCT, $HCT);
			$CCT = dirname(dirname(abs_path(__FILE__))) . "$preferences{CCT}";
			$HCT = dirname(dirname(abs_path(__FILE__))) . "$preferences{HCT}";
			$msg = "Setup template files:\nCCT: $CCT\n HCT: $HCT";
			info_debug_message($msg);
			if((-e "$CCT") && (-e "$HCT")) {
				my (%templateParams, $ucwn, $lcwn, $year);
				$ucwn = uc($opt{WIDGET_NAME});
				$lcwn = lc($opt{WIDGET_NAME});
				$year = strftime("%Y", localtime());
				%templateParams = (
					PN => $opt{PROJECT_NAME}, WN => $opt{WIDGET_NAME},
					WNUC => $ucwn, WNLC => $lcwn, YR => $year,
					AN => $preferences{AUTHOR_NAME},
					AE => $preferences{AUTHOR_EMAIL}
				);
				my ($templateGen, $cct, $cfh, $hct, $hfh);
				$templateGen = Template->new(ABSOLUTE => 1);
				$templateGen->process("$CCT", \%templateParams, \$cct) ||
					die($templateGen->error);
				$templateGen->process("$HCT", \%templateParams, \$hct) ||
					die($templateGen->error);
				$msg = "Processing widget parameters and generate text code";
				info_debug_message($msg);
				my ($currentDir, $uid, $gid, %log);
				$currentDir = getcwd();
				$uid = getpwnam("$preferences{UID}");
				$gid = getgrnam("$preferences{GID}");
				$msg = "Generating widget module files:\n";
				$msg .= "\t$currentDir/$lcwn.h\n";
				$msg .= "\t$currentDir/$lcwn.c";
				info_message($msg);
				open($hfh, '>', "$currentDir/$lcwn.h");
				print($hfh "$hct");
				close($hfh);
				chown($uid, $gid, "$currentDir/$lcwn.h");
				open($cfh, '>', "$currentDir/$lcwn.c");
				print($cfh "$cct");
				close($cfh);
				chown($uid, $gid, "$currentDir/$lcwn.c");
				$log{LOG_FILE_PATH} = $log;
				$log{LOG_MESSAGE} = "Generated GTK widget [$opt{WIDGET_NAME}]";
				logging(\%log);
				$msg = "Done";
				info_message($msg);
				return ($SUCCESS);
			}
			$msg = "Check files:\n\tCCT [$CCT]\n\tHCT [$HCT]";
			error_message($msg);
			return ($NOT_SUCCESS);
		}
		return ($NOT_SUCCESS);
	}
	$msg = "Missing argument [OPTION_STRUCTURE]";
	error_message($msg);
	return ($NOT_SUCCESS);
}

1;
__END__

=head1 NAME

GenGTKWidget - This module is for generating GTK widget module source files.

=head1 SYNOPSIS

	use GenGTKWidget qw(gen_gtk_widget);

	...

	if(gen_gtk_widget(\%option) == $SUCCESS) {
		# true
		# notify admin | user
	} else {
		# false
		# return $NOT_SUCCESS
		# or
		# exit 128
	}

=head1 DESCRIPTION 

This script is for generating GTK widget module source files.

=head2 EXPORT

gen_gtk_widget - return 0 for success, else 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>elektron.ronca@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by https://github.com/vroncevic/gen_gtk_widget

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
