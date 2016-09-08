#!/usr/bin/perl
use warnings; use strict;
use LWP::UserAgent;
use open qw(:std :utf8);

# Downloads all 644 files from Open Evidence
# Created by Max Banister 2016

my $ua = LWP::UserAgent->new(ssl_opts => {verify_hostname => 0});
my $response = $ua->get('https://openev.debatecoaches.org/');

my $data = "";

if ($response->is_success) {
    $data = $response->decoded_content;
}
else {
    die $response->status_line;
}


my @links = $data =~ /https?:\/\/openev\.debatecoaches\.org\/bin\/download\/2016\/(.+?\.(?:docx|docm|doc))/gi;
my $worked = 0;
my $failed = 0;

for my $link (@links) {
	my $filename = $link =~ s/.+?\///r;


	my $res = $ua->get("https://openev.debatecoaches.org/bin/download/2016/".$link);
	if ($res->is_success) {

		open(my $fh, '>:raw', $filename) or die "Could not write to '$filename': $!";
		binmode $fh;

		print $fh $res->decoded_content;
		close $fh;

		print $filename." successfully created\n";
		$worked++;
	}
	else {
		print $filename." does not exist";
		$failed++;
	}

}
print("Worked: ".$worked);
print("Failed: ".$failed);

system("pause");
