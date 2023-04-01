# gnucash-chile-mutual-fund-quote
Online Price quote for Chile Mutual Funds in GNUCash
1. Place the attached file FintualJSON.pm inside the folder

Linux depends on the way it was installed:
by package manager: /usr/share/perl5/[vendor/]Finance/Quote
by CPAN or gnc-fq-update: /usr/share/perl5/site/Finance/Quote
self compiled: /usr/local/share/perl/5.xx.x/Finance
Windows: C:\Strawberry\perl\site\lib\Finance\Quote
macOS: /Library/Perl/5.xx/Finance/Quote  where xx depends on the version of perl in use when you installed Finanace::Quote.
macOS upgrades may require reinstallation of Finance::Quote because older version directories are not included in @INC.

2. Below file needs to be edited to include the line "FintualJSON"

FileName = Quote.pm

Where the F::Q files are stored depends on your OS/Distro:

Linux depends on the way it was installed:
by package manager: /usr/share/perl5/[vendor/]Finance
by CPAN or gnc-fq-update: /usr/share/perl5/site/Finance
self compiled: /usr/local/share/perl/5.xx.x/Finance
Windows: C:\Strawberry\perl\site\lib\Finance
macOS: /Library/Perl/5.xx/Finance where xx depends on the version of perl in use when you installed Finanace::Quote.
macOS upgrades may require reinstallation of Finance::Quote because older version directories are not included in @INC.
