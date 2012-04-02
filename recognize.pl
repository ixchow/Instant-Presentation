#!perl -w

while (1) {

	while (!(-e "words.flac")) {
		select undef, undef, undef, 0.01;
	}

	system("mv words.flac words_rec.flac");

	#Recognizes some speech from a flac file:
	my $ret = `curl -s -S 'https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US' -H 'Content-Type: audio/x-flac; rate=16000' --data-binary '\@words_rec.flac'`;

	unlink("words_rec.flac");

	print $ret . "\n";

	my $words = "";

	if ($ret =~ m/"utterance":"([^"]+)"/) {
		$words = $1;
	} else {
		next;
	}

	print "You may have said: $words\n";

	open TEMP, ">", "utterance_temp";

	print TEMP $words;

	close TEMP;

	system("mv utterance_temp utterance");
}
