#!/usr/bin/perl

### Importing external files.
use LWP::UserAgent;
use LWP::Simple;
use HTTP::Request::Common;
use HTTP::Cookies;

$| = 1;

$atdVersion = '4.12.0.7';
#$domain = 'contentsecurity.mcafee.com';
$domain = 'contentsecurity.skyhigh.cloud';
$baseURL = 'https://'.$domain.'/update';

### Creating the UserAgent object.
my $ua = LWP::UserAgent->new(requests_redirectable => [ 'GET', 'HEAD', 'POST' ], cookie_jar => HTTP::Cookies->new, agent => "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0");
$ua->ssl_opts(verify_hostname => 0, SSL_verify_mode => 0x00);

print "Generating a definitions file";

print ".";
my $response = $ua->get($baseURL);

print ".";
$response = $ua->get($baseURL.'?action=submit1&step=1&accept=yes&btn_next=Next+Step');

print ".";
$response = $ua->get($baseURL.'?action=submit2&step=2&product=matd&btn_next=Next+Step');

print ".";
$response = $ua->get($baseURL.'?action=submit3&step=3&version='.$atdVersion.'&btn_next=Next+Step');

print ".";
$response = $ua->get($baseURL.'?action=submit4&step=4&upd_antimalware=yes&btn_next=Generate+Update+Package');

print ".";
$response = $ua->get($baseURL.'_generate');

print ".";
$response = $ua->get('https://'.$domain.'/include/js/manual_update_check.js');

print ".";
$response = $ua->post($baseURL.'_generate', {"action" => "check"});

while (!(index($response->decoded_content, '"status":"ok"') != -1))
{
	if (!(index($response->decoded_content, '"status":"process"') != -1))
	{
		print ($response->decoded_content);
		print "Error getting the update file.\n";
		exit;
	}
	sleep 60;
	print ".";
	$response = $ua->post($baseURL.'_generate', {"action" => "check"});
}

print "\nDownloading definitions file...\n";
$response = $ua->get($baseURL.'?action=submit3&btn_download=Download');
my $file = $response->decoded_content( charset => 'none' );
my $save = "matd-definitions.upd";

open my $fh, '>>', $save or die "\nCannot create save file '$save' because $!\n";
binmode $fh;
print $fh $file;
close $fh;

system('matd-definitions.exe matd-definitions.upd');

print "Done!\n";
