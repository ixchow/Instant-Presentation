#!perl -w

#$foo = <<'EOF';

my $audio = "-t alsa \"hw:3,0\"";
if (`uname` =~ m/Darwin/) {
	$audio =  "-t coreaudio \"default\"";
}
my $pid = 0;

while (1) {

	#grabs audio from USB mic with sox...
	system("sox $audio -b 16 words_temp.flac silence 1 0.1 1% 1 1.0 1% rate 16k trim 0 3");

	system("mv words_temp.flac words.flac");
}
