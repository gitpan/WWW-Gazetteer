#!/usr/bin/perl -w
use strict;
use Test::More tests => 4;

BEGIN { use_ok( 'WWW::Gazetteer' ); }

my $g = WWW::Gazetteer->new();
is_deeply($g->fetch("London", "United Kingdom"),
  { longitude => "-0.1167", latitude => "51.5000" });
is_deeply($g->fetch("Nice", "France"),
  { longitude => "7.2500", latitude => "43.7000"});
is_deeply([$g->fetch("Bacton", "United Kingdom")], [
  { longitude => "-2.9167", latitude => "51.9833" },
  { longitude => "1.0167", latitude => "52.2667" },
  { longitude => "1.4667", latitude => "52.8500" },
]);
