#!perl -w

#from the internet!
sub urlencode {
    my $s = shift;
    $s =~ s/ /+/g;
    $s =~ s/([^A-Za-z0-9\+-])/sprintf("%%%02X", ord($1))/seg;
    return $s;
}

#intro slide.
system("convert -size 1024x768 -pointsize 90 -background none caption:\"!\" -trim bar.png");
system("convert -depth 8 -size 1024x768 xc:gray -gravity Center bar.png -composite foo.png");

system("mv foo.png slide.png");

while (1) {

	while (!(-e "utterance")) {
		select undef, undef, undef, 0.01;
	}

	system("mv utterance utterance_slid");

	open TEMP, "<", "utterance_slid" ;

	my $words = <TEMP>;
	chomp $words;

	close TEMP;

	unlink("utterance_slid");

	print "You may have said: $words\n";

	$ewords = urlencode($words);
	my $cmd = "wget --quiet --no-check-certificate --user-agent='firefox,really' 'https://www.google.com/search?tbm=isch&q=$ewords' -O -";

	print "-> $cmd\n";
	my $imgs = `$cmd`;

	while ($imgs =~ s/imgurl=([^&]+)&//) {
		my $url = $1;
		print $1 . "\n";

		unlink("img");
		system("wget --quiet --no-check-certificate --user-agent='firefox,iswear' '$url' -O img");
		my $type = `file img`;
		my $name = "img";
		if ($type =~ m/JPEG/) {
			$name = "jpeg:img";
		} elsif ($type =~ m/GIF image/) {
			$name = "gif:img";
		} elsif ($type =~ m/PNG image/) {
			$name = "png:img";
		} else {
			print "Unknown type: $type!!!\n";
			$name = "";
		}

		unlink("foo.png");

		if (int(rand(10)) == 0) {
			$name = "";
		}

		my @words = split(/\s+/,$words);
		$words = "";
		foreach (@words) {
			if ($_ eq "is") {
			} elsif ($_ eq "of") {
			} elsif ($_ eq "or") {
			} elsif ($_ eq "a") {
			} elsif ($_ eq "and") {
			} else {
				$_ = ucfirst;
			}
		}
		$words[0] = ucfirst($words[0]);
		$words = join(" ", @words);
#EOF

		print "Making slide\n";

		my $font = ""; #doesn't seem to change glyphs? weird. -font Luxi-Sans-Regular";

		if ($name ne "") {
			system("convert $font -size 1020x114 -background none caption:\"$words\" -trim -scale '1020x114' -gravity Center -extent 1024x118 bar.png");
			system("convert $name -depth 8 -scale '<1024x650' -background gray -gravity Center -extent '1024x650' -background tan -gravity South -extent '1024x768' bar.png -gravity North -composite foo.png");
		} else {
			system("convert $font -size 1024x768 -pointsize 90 -background none caption:\"$words\" $font -trim bar.png");
			system("convert -depth 8 -size 1024x768 xc:gray -gravity Center bar.png -composite foo.png");
		}
		system("mv foo.png slide.png");

		print " ... done.\n";

		last;
	}

}
