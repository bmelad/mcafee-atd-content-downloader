#!/usr/bin/perl

### Importing external files.
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Request::Common;
use HTTP::Cookies;

$| = 1;

### Creating the UserAgent object.
my $ua = LWP::UserAgent->new(requests_redirectable => [ 'GET', 'HEAD', 'POST' ], cookie_jar => HTTP::Cookies->new, agent => "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0");
#$ua->ssl_opts(verify_hostname => 0, SSL_verify_mode => 0x00); # ignore ssl/tls issues.

print "Generating a definitions file";

print ".";
my $response = $ua->get('https://contentsecurity.mcafee.com/update');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->get('https://contentsecurity.mcafee.com/update?action=submit1&step=1&accept=yes&btn_next=Next+Step');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->get('https://contentsecurity.mcafee.com/update?action=submit2&step=2&product=matd&btn_next=Next+Step');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->get('https://contentsecurity.mcafee.com/update?action=submit3&step=3&version=4.8.0.17&btn_next=Next+Step');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->get('https://contentsecurity.mcafee.com/update?action=submit4&step=4&upd_antimalware=yes&btn_next=Generate+Update+Package');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->get('https://contentsecurity.mcafee.com/update_generate');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->get('https://contentsecurity.mcafee.com/include/js/manual_update_check.js');
#print "Response:\n".$response->decoded_content."\n======================================================\n";

print ".";
$response = $ua->post('https://contentsecurity.mcafee.com/update_generate', {"action" => "check"});
#print "Response:\n".$response->decoded_content."\n======================================================\n";

while (!(index($response->decoded_content, '"status":"ok"') != -1))
{
	if (!(index($response->decoded_content, '"status":"process"') != -1))
	{
		print "Error getting the update file.\n";
		exit;
	}
	#print "Response:\n".$response->decoded_content."\n======================================================:)\n";
	sleep 60;
	print ".";
	$response = $ua->post('https://contentsecurity.mcafee.com/update_generate', {"action" => "check"});
}

print "\nDownloading definitions file...\n";
$response = $ua->get('https://contentsecurity.mcafee.com/update?action=submit3&btn_download=Download');
my $file = $response->decoded_content( charset => 'none' );
my $save = "matd-definitions.upd";

open my $fh, '>>', $save or die "\nCannot create save file '$save' because $!\n";
binmode $fh;
print $fh $file;
close $fh;

system('matd-definitions.exe matd-definitions.upd');

print "Done!\n";
