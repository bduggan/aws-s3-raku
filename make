#!/usr/bin/env raku

if %*ENV<VERBOSE> {
  &shell.wrap: -> |c { say c.raku; callsame; }
  &QX.wrap: -> |c { say c.raku; callsame; }
}

my $module = 'AWS-S3';
my $version = q:x[jq -r .version META6.json].trim or exit note 'no version';

multi MAIN('test') {
  shell "TEST_AUTHOR=1 prove -e 'raku -Ilib' t/*";
}

multi MAIN('dist') {
  my $out = "tar/{$module}-{$version}.tar.gz";
  shell qq:to/SH/;
    echo "Making $version";
    mkdir -p tar
    git archive --prefix={$module}-{$version}/ -o $out {$version}
    SH
  say "wrote $out";
}

multi MAIN('bump') {
  my $next = qq:x[raku -e '"$version".split(".") >>+>> <0 0 1> ==> join(".") ==> say()'].trim;
  say "$version -> $next";
  exit note "no next version" unless $next;
  shell qq:to/SH/;
    perl -p -i -e "s/{$version}/{$next}/" META6.json
    SH
}

multi MAIN('clean') {
  shell 'rm -f dist/*.tar.gz';
}

