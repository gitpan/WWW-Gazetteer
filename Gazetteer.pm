package WWW::Gazetteer;
use strict;
use Carp qw(croak);
use HTTP::Cookies;
use LWP::UserAgent;

use vars qw($VERSION);
$VERSION = '0.10';

my $countries = {
          'Tuvalu' => 'tuvalu',
          'Sweden' => 'sweden',
          'Tonga' => 'tonga',
          'Nepal' => 'nepal',
          'Naoero' => 'naoero',
          'Anguilla' => 'anguilla',
          'Somalia' => 'somalia',
          'Guinea' => 'guinea',
          'Mozambique' => 'mozambique',
          'Guyana' => 'guyana',
          'Falkland Islands (Islas Malvinas)' => 'falklandislandsislasmalvinas',
          'Ethiopia' => 'ethiopia',
          'Equatorial Guinea' => 'equatorialguinea',
          'South Africa' => 'southafrica',
          'Peru' => 'peru',
          'Indonesia' => 'indonesia',
          'Argentina' => 'argentina',
          'Portugal' => 'portugal',
          'Nigeria' => 'nigeria',
          'Cook Islands' => 'cookislands',
          'Solomon Islands' => 'solomonislands',
          'Latvia' => 'latvia',
          'Dominican Republic' => 'dominicanrepublic',
          'Antigua and Barbuda' => 'antiguaandbarbuda',
          'Turkey' => 'turkey',
          'Serbia' => 'serbia',
          'Tunisia' => 'tunisia',
          'Morocco' => 'morocco',
          'Malawi' => 'malawi',
          'Gambia, The' => 'gambiathe',
          'Cayman Islands' => 'caymanislands',
          'Mauritius' => 'mauritius',
          'Maldives' => 'maldives',
          'Bangladesh' => 'bangladesh',
          'South Georgia and the South Sandwich Islands' => 'southgeorgiaandthesouthsandwichislands',
          'Netherlands' => 'netherlands',
          'Brazil' => 'brazil',
          'Japan' => 'japan',
          'Paraguay' => 'paraguay',
          'Georgia, Republic of' => 'georgiarepublicof',
          'Ecuador' => 'ecuador',
          'Mali' => 'mali',
          'Croatia' => 'croatia',
          'Swaziland' => 'swaziland',
          'Jamaica' => 'jamaica',
          'Dominica' => 'dominica',
          'Slovenia' => 'slovenia',
          'Israel' => 'israel',
          'Madagascar' => 'madagascar',
          'India' => 'india',
          'Belize' => 'belize',
          'Botswana' => 'botswana',
          'Namibia' => 'namibia',
          'Malta' => 'malta',
          'Algeria' => 'algeria',
          'Taiwan' => 'taiwan',
          'Macau' => 'macau',
          'Laos' => 'laos',
          'Azerbaijan' => 'azerbaijan',
          'Bulgaria' => 'bulgaria',
          'Lebanon' => 'lebanon',
          'Iraq' => 'iraq',
          'Thailand' => 'thailand',
          'Guernsey' => 'guernsey',
          'Barbados' => 'barbados',
          'United Arab Emirates' => 'unitedarabemirates',
          'Singapore' => 'singapore',
          'Belarus' => 'belarus',
          'Vietnam' => 'vietnam',
          'Niger' => 'niger',
          'Ukraine' => 'ukraine',
          'Saint Kitts and Nevis' => 'saintkittsandnevis',
          'Romania' => 'romania',
          'Cameroon' => 'cameroon',
          'Greece' => 'greece',
          'Cocos (Keeling) Islands' => 'cocoskeelingislands',
          'Grenada' => 'grenada',
          'Germany' => 'germany',
          'San Marino' => 'sanmarino',
          'Mayotte' => 'mayotte',
          'Burkina Faso' => 'burkinafaso',
          'Belgium' => 'belgium',
          'Monaco' => 'monaco',
          'Chile' => 'chile',
          'Uzbekistan' => 'uzbekistan',
          'Heard Island and McDonald Islands' => 'heardislandandmcdonaldislands',
          'Haiti' => 'haiti',
          'Costa Rica' => 'costarica',
          'France' => 'france',
          'Kiribati' => 'kiribati',
          'Bouvet Island' => 'bouvetisland',
          'Malaysia' => 'malaysia',
          'Cambodia' => 'cambodia',
          'Libya' => 'libya',
          'British Indian Ocean Territory' => 'britishindianoceanterritory',
          'Samoa' => 'samoa',
          'Panama' => 'panama',
          'Rwanda' => 'rwanda',
          'North Korea' => 'northkorea',
          'Uruguay' => 'uruguay',
          'Syria' => 'syria',
          'Benin' => 'benin',
          'Tromelin Island' => 'tromelinisland',
          'Mongolia' => 'mongolia',
          'Hungary' => 'hungary',
          'Zambia' => 'zambia',
          'Trinidad and Tobago' => 'trinidadandtobago',
          'Saint Lucia' => 'saintlucia',
          'Liechtenstein' => 'liechtenstein',
          'Pakistan' => 'pakistan',
          'Hong Kong' => 'hongkong',
          'Sri Lanka' => 'srilanka',
          'Suriname' => 'suriname',
          'China' => 'china',
          'Sierra Leone' => 'sierraleone',
          'Gibraltar' => 'gibraltar',
          'Western Sahara' => 'westernsahara',
          'Congo' => 'congo',
          'Estonia' => 'estonia',
          'Eritrea' => 'eritrea',
          'Angola' => 'angola',
          'Guatemala' => 'guatemala',
          'Armenia' => 'armenia',
          'Saudi Arabia' => 'saudiarabia',
          'Guinea-Bissau' => 'guineabissau',
          'Oman' => 'oman',
          'Turkmenistan' => 'turkmenistan',
          'Honduras' => 'honduras',
          'Ireland' => 'ireland',
          'Vanuatu' => 'vanuatu',
          'Qatar' => 'qatar',
          'Nicaragua' => 'nicaragua',
          'Tokelau' => 'tokelau',
          'Czech Republic' => 'czechrepublic',
          'Central African Republic' => 'centralafricanrepublic',
          'Iceland' => 'iceland',
          'Ghana' => 'ghana',
          'Mexico' => 'mexico',
          'Niue' => 'niue',
          'Djibouti' => 'djibouti',
          'Juan de Nova Island' => 'juandenovaisland',
          'Tristan da Cunha' => 'tristandacunha',
          'El Salvador' => 'elsalvador',
          'Jersey' => 'jersey',
          'Slovakia' => 'slovakia',
          'Turks and Caicos Islands' => 'turksandcaicosislands',
          'Tajikistan' => 'tajikistan',
          'South Korea' => 'southkorea',
          'Poland' => 'poland',
          'Coral Sea Islands' => 'coralseaislands',
          'Togo' => 'togo',
          'Vatican City' => 'vaticancity',
          'Cuba' => 'cuba',
          'Moldova' => 'moldova',
          'Spain' => 'spain',
          'Gabon' => 'gabon',
          'Kenya' => 'kenya',
          'Egypt' => 'egypt',
          'Bolivia' => 'bolivia',
          'Australia' => 'australia',
          'United Kingdom' => 'unitedkingdom',
          'Switzerland' => 'switzerland',
          'Europa Island' => 'europaisland',
          'Lithuania' => 'lithuania',
          'Norway' => 'norway',
          'Montserrat' => 'montserrat',
          'Marshall Islands' => 'marshallislands',
          'Canada' => 'canada',
          'Pitcairn Islands' => 'pitcairnislands',
          'Montenegro' => 'montenegro',
          'Cyprus' => 'cyprus',
          'Luxembourg' => 'luxembourg',
          'Papua New Guinea' => 'papuanewguinea',
          'Brunei' => 'brunei',
          'Iran' => 'iran',
          'Kyrgyzstan' => 'kyrgyzstan',
          'Mauritania' => 'mauritania',
          'Bahamas, The' => 'bahamasthe',
          'Seychelles' => 'seychelles',
          'Russia' => 'russia',
          'Clipperton Island' => 'clippertonisland',
          'Finland' => 'finland',
          'Tanzania' => 'tanzania',
          'Glorioso Islands' => 'gloriosoislands',
          'Chad' => 'chad',
          'Austria' => 'austria',
          'Fiji' => 'fiji',
          'Kazakhstan' => 'kazakhstan',
          'Cape Verde' => 'capeverde',
          'Jordan' => 'jordan',
          'Lesotho' => 'lesotho',
          'Uganda' => 'uganda',
          'Philippines' => 'philippines',
          'Italy' => 'italy',
          'Zimbabwe' => 'zimbabwe',
          'Bhutan' => 'bhutan',
          'Sao Tome and Principe' => 'saotomeandprincipe',
          'New Zealand' => 'newzealand',
          'Yemen' => 'yemen',
          'Saint Vincent and the Grenadines' => 'saintvincentandthegrenadines',
          'Colombia' => 'colombia',
          'Liberia' => 'liberia',
          'Burundi' => 'burundi',
          'Bahrain' => 'bahrain',
          'Côte d\'Ivoire' => 'ctedivoire',
          'Ashmore and Cartier Islands' => 'ashmoreandcartierislands',
          'Bosnia and Herzegovina' => 'bosniaandherzegovina',
          'Isle of Man' => 'isleofman',
          'Kuwait' => 'kuwait',
          'Venezuela' => 'venezuela',
          'Burma' => 'burma',
          'Macedonia, The Former Yugoslav Republic of' => 'macedoniatheformeryugoslavrepublicof',
          'British Virgin Islands' => 'britishvirginislands',
          'Sudan' => 'sudan',
          'Afghanistan' => 'afghanistan',
          'Denmark' => 'denmark',
          'Senegal' => 'senegal',
          'Andorra' => 'andorra',
          'Norfolk Island' => 'norfolkisland',
          'Albania' => 'albania'
        };

sub new {
  my($class) = @_;

  my $self = {};
  my $ua = LWP::UserAgent->new(
    env_proxy => 1,
    keep_alive => 1,
    timeout => 30,
  );
  $ua->agent("WWW::Gazetteer/$VERSION " . $ua->agent);

  $self->{ua} = $ua;

  bless $self, $class;
  return $self;
}

sub fetch {
  my($self, $city, $country) = @_;

  my $ua = $self->{ua};

  my $base_url = 'http://www.calle.com/world/';
  my $countrycode = $countries->{$country};
  if (not defined $countrycode) {
    croak("WWW::Gazetteer: Country $country not found");
    return;
  }

  my ($prefix) = $city =~ /^(..)/;
  my $request = HTTP::Request->new('GET', $base_url . $countries->{$country} . "/$prefix.html");
  sleep 1; # be nice to the remote server
  my $response = $ua->request($request);
	
  if (not $response->is_success) {
    croak("WWW::Gazetteer: City $city in $country not found");
    return;
  }

  my @cities;
  my $content = $response->content;
  while ($content =~ s#<tr><td><a href="http://www.calle.com/info.cgi\?lat=([\-\d\.]+)\&long=([\-\d\.]+)\&name=[^&]+\&cty=[^&]+\&alt=\d+">$city( City)?</a>##) {
    my($lat, $long) = ($1, $2);
    push @cities, { latitude => $lat, longitude => $long };
   }
  return @cities;
}

__END__

=head1 NAME

WWW::Gazetteer - Find location of world towns and cities

=head1 SYNOPSYS

  use WWW::Gazetteer;
  my $g = WWW::Gazetteer->new();
  my $london = $g->fetch("London", "United Kingdom");
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  my $nice = $g->fetch("Nice", "France");
  my @bactons = $g->fetch("Bacton", "United Kingdom");
  # note: more than one Bacton in the UK!

=head1 DESCRIPTION

A gazetteer is a geographical dictionary (as at the back of an
atlas). The C<WWW::Gazetteer> module uses the information at
http://www.calle.com/world/ to return geographical location
(longitude, latitude) for towns and cities in countries in the world.

Once you have imported the module and created a gazetteer object,
calling fetch($town, $country) will return a list of hashrefs with
longitude and latitude information.

  my $london = $g->fetch("London", "United Kingdom");
  print $london->{longitude}, ", ", $london->{latitude}, "\n";
  # prints -0.1167, 51.5000

Note that there may be more than one town or city with that name in
the country. In that case, you will get a list of hashrefs for each
town/city.

The following countries are valid: Afghanistan, Albania, Algeria,
Andorra, Angola, Anguilla, Antigua and Barbuda, Argentina, Armenia,
Ashmore and Cartier Islands, Australia, Austria, Azerbaijan, Bahamas,
The, Bahrain, Bangladesh, Barbados, Belarus, Belgium, Belize, Benin,
Bhutan, Bolivia, Bosnia and Herzegovina, Botswana, Bouvet Island,
Brazil, British Indian Ocean Territory, British Virgin Islands,
Brunei, Bulgaria, Burkina Faso, Burma, Burundi, Cambodia, Cameroon,
Canada, Cape Verde, Cayman Islands, Central African Republic, Chad,
Chile, China, Clipperton Island, Cocos (Keeling) Islands, Colombia,
Congo, Cook Islands, Coral Sea Islands, Costa Rica, Croatia, Cuba,
Cyprus, Czech Republic, Côte d'Ivoire, Denmark, Djibouti, Dominica,
Dominican Republic, Ecuador, Egypt, El Salvador, Equatorial Guinea,
Eritrea, Estonia, Ethiopia, Europa Island, Falkland Islands (Islas
Malvinas), Fiji, Finland, France, Gabon, Gambia, The, Georgia,
Republic of, Germany, Ghana, Gibraltar, Glorioso Islands, Greece,
Grenada, Guatemala, Guernsey, Guinea, Guinea-Bissau, Guyana, Haiti,
Heard Island and McDonald Islands, Honduras, Hong Kong, Hungary,
Iceland, India, Indonesia, Iran, Iraq, Ireland, Isle of Man, Israel,
Italy, Jamaica, Japan, Jersey, Jordan, Juan de Nova Island,
Kazakhstan, Kenya, Kiribati, Kuwait, Kyrgyzstan, Laos, Latvia,
Lebanon, Lesotho, Liberia, Libya, Liechtenstein, Lithuania,
Luxembourg, Macau, Macedonia, The Former Yugoslav Republic of,
Madagascar, Malawi, Malaysia, Maldives, Mali, Malta, Marshall Islands,
Mauritania, Mauritius, Mayotte, Mexico, Moldova, Monaco, Mongolia,
Montenegro, Montserrat, Morocco, Mozambique, Namibia, Naoero, Nepal,
Netherlands, New Zealand, Nicaragua, Niger, Nigeria, Niue, Norfolk
Island, North Korea, Norway, Oman, Pakistan, Panama, Papua New Guinea,
Paraguay, Peru, Philippines, Pitcairn Islands, Poland, Portugal,
Qatar, Romania, Russia, Rwanda, Saint Kitts and Nevis, Saint Lucia,
Saint Vincent and the Grenadines, Samoa, San Marino, Sao Tome and
Principe, Saudi Arabia, Senegal, Serbia, Seychelles, Sierra Leone,
Singapore, Slovakia, Slovenia, Solomon Islands, Somalia, South Africa,
South Georgia and the South Sandwich Islands, South Korea, Spain, Sri
Lanka, Sudan, Suriname, Swaziland, Sweden, Switzerland, Syria, Taiwan,
Tajikistan, Tanzania, Thailand, Togo, Tokelau, Tonga, Trinidad and
Tobago, Tristan da Cunha, Tromelin Island, Tunisia, Turkey,
Turkmenistan, Turks and Caicos Islands, Tuvalu, Uganda, Ukraine,
United Arab Emirates, United Kingdom, Uruguay, Uzbekistan, Vanuatu,
Vatican City, Venezuela, Vietnam, Western Sahara, Yemen, Zambia,
Zimbabwe.

=head1 COPYRIGHT

Copyright (C) 2002, Leon Brocard

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.

=head1 AUTHOR

Leon Brocard, acme@astray.com. Based upon ideas and code by Nathan Bailey.


