package WWW::Gazetteer;
use strict;
use Class::Factory;

use vars qw($VERSION @ISA);
@ISA = qw(Class::Factory);
$VERSION = '0.21';

__PACKAGE__->register_factory_type(calle => 'WWW::Gazetteer::Calle');
__PACKAGE__->register_factory_type(Calle => 'WWW::Gazetteer::Calle');
__PACKAGE__->register_factory_type(HeavensAbove => 'WWW::Gazetteer::HeavensAbove');
__PACKAGE__->register_factory_type(heavensabove => 'WWW::Gazetteer::HeavensAbove');

sub new {
  my ($pkg, $type, @params) = @_;
  my $class = $pkg->get_factory_class($type);
  return $class->new(@params);
}

1;

__END__

=head1 NAME

WWW::Gazetteer - Find location of world towns and cities

=head1 SYNOPSYS

  use WWW::Gazetteer;
  my $g = WWW::Gazetteer->new('calle');
  my @londons = $g->find('London', 'UK');
  my $london = $londons[0];
  print $london->{longitude}, ", ", $london->{latitude}, "\n";

=head1 DESCRIPTION

A gazetteer is a geographical dictionary (as at the back of an
atlas). The C<WWW::Gazetteer> module is a generic interface to the
C<WWW::Gazetteer::*> modules which can return geographical location
(longitude, latitude, elevation) for towns and cities in countries in
the world.

This is a factory module which dispatches to one of the many
C<WWW::Gazetteer::*> modules. This provides a simple interface and
lets the subclasses actually provide the communication to the online
gazetteers. You may think of this as the DBI and the subclasses as the
DBDs.

Valid subclasses as of this release are: C<WWW::Gazetteer::Calle> and
C<WWW::Gazetteer::HeavensAbove>. To create a gazetteer object, pass
the name of the subclass as the first argument to new:

  my $g = WWW::Gazetteer->new('calle');
  my $g2 = WWW::Gazetteer->new('heavensabove');

Calling find($town, $country) will return a list of hashrefs with
the country, town, longitude, and latitude information. Additional
information such as elevation may also be available. You should check
the documentation of your subclass for the particular features that it
supports.

  my @londons = $g->find('London', 'UK');
  my $london = $londons[0];
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  # prints -0.1167, 51.5000

=head1 METHODS

=head2 new()

This returns a new WWW::Gazetteer::* object. It has one argument, the
name of the subclass (and optionally configuration for the subclass):

  use WWW::Gazetteer;
  my $g = WWW::Gazetteer->new('calle');

=head2 find()

The find method looks up geographical information and returns it to
you. It takes in a city and a country, with the recommended syntax
being te city name and ISO 3166 country code.

Note that there may be more than one town or city with that name in
the country. You will get a list of hashrefs for each town/city.

  my @londons = $g->find("London", "UK");

Check the documentation of your subclass for which countries, which
syntax it supports, and what information it returns.

=head1 SEE ALSO

L<WWW::Gazetteer::Calle>, L<WWW::Gazetteer::HeavensAbove>.

=head1 COPYRIGHT

Copyright (C) 2002, Leon Brocard

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.

=head1 AUTHOR

Leon Brocard, acme@astray.com. Thanks to Philippe 'BooK' Bruhat.


