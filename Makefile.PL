use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME	 => "WWW::Gazetteer",
  VERSION_FROM => 'Gazetteer.pm',
  PREREQ_PM    =>  {
   'LWP::UserAgent' => 0.01,
   'Test::Simple' => 0.01,
  },
  AUTHOR       => 'Leon Brocard <acme@astray.com>',
);


