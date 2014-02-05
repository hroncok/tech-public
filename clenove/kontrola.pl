#!/usr/bin/env perl
use strict;
use warnings;

use Data::Dumper;

my @clenove;

my @soubory = <*.txt>;
foreach my $soubor (@soubory) {
	# parsovat soubor člena
	print "otevírá se soubor $soubor\n";
	open(MEMBERFILE, $soubor);
	my %clen;

	# zapsat login
	$clen{'login'} = substr($soubor, 0, -4);

	while (<MEMBERFILE>) {
		chomp $_;

		# rozsekat na typ a hodnotu
		my ($typ, $hodnota) = split / /, $_, 2;
		#print "typ: $typ, hodnota: $hodnota\n";

		# single záznamy
		if (	$typ eq "jmeno" or 
			$typ eq "telefon"
		) {
			if (exists($clen{$typ})) {
				die("Zázmam $typ je duplicitní");
			} else {
				$clen{$typ} = $hodnota;
			}
		} else {
			# multivalue záznamy
			if (!exists($clen{$typ})) {
				$clen{$typ}[0] = $hodnota;;	
			} else {
				push($clen{$typ}, $hodnota);	
			}
		}


	}

	print Dumper(\%clen);

	# uložit člena do pole členů
	push(@clenove, %clen);



	close(MEMBERFILE);
}

