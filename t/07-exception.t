#!/usr/bin/env raku

use Test;
use Test::Mock;
use HTTP::UserAgent;
use HTTP::Response;

use WebService::AWS::S3;

my $content = $*PROGRAM.parent.add('mock/data/error-response.xml').slurp;

my $response = mocked(HTTP::Response, returning => {
    code => 404,
    content => $content
});

my $ua = mocked(HTTP::UserAgent, returning  => {
    request => $response
});

my $s3 = S3.new(:secret-access-key<none>, :access-key-id<none>, :$ua, :region<none>, :exception);

throws-like { $s3.get("s3://jns-test-1/hxllo/world.txt") }, X::AWS::S3, operation => 'GET', message => /'Got NoSuchKey ( The specified key does not exist'/ ,'throws with exception';

done-testing;
# vim: ft=raku
