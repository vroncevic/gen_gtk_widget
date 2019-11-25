# Generate GTK Widget C Modules (Perl tool)

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

A README file is required for CPAN modules since CPAN extracts the
README file from a module distribution so that people browsing the
archive can use it get an idea of the modules uses. It is usually a
good idea to provide version information here so that people can
decide whether fixes for the module are worth downloading.

### INSTALLATION

To install this tool type the following:
```
cp -R  ~/bin/   /root/scripts/gen_gtk_widget/ver.1.0/
cp -R  ~/conf/  /root/scripts/gen_gtk_widget/ver.1.0/
cp -R  ~/log/   /root/scripts/gen_gtk_widget/ver.1.0/
```
### DEPENDENCIES

This tool requires these other modules and libraries:
```
strict
warnings
Template
Sys::Hostname
Getopt::Long
Pod::Usage
POSIX
Cwd
File::Basename
Utils   https://github.com/vroncevic/perl_util
Logging   https://github.com/vroncevic/perl_util
Configuration   https://github.com/vroncevic/perl_util
notification   https://github.com/vroncevic/perl_util
Status   https://github.com/vroncevic/perl_util
CheckStatus   https://github.com/vroncevic/perl_util
InfoDebugMessage   https://github.com/vroncevic/perl_util
InfoMessage   https://github.com/vroncevic/perl_util
```
### COPYRIGHT AND LICENCE

Copyright (C) 2016 by https://github.com/vroncevic/gen_gtk_widget

This tool is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.


