 #!/usr/local/bin/perl

 use strict;
 # use Text::Unaccent::PurePerl; 
 # use Text::Unidecode;
 require Encode;
 # use Unicode::Normalize;


 my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
 
 my $names;

 open(my $data, '<:encoding(UTF-8)', $file) or die "Could not open '$file' $!\n";

 my $process_next = 0;
 my $count = 0;

 while (my $line = <$data>) 
 {
 	chomp $line;

 	if ($process_next == 1)
 	{
 		$process_next = 0;

 		$line =~ s/^<a href=\"\/\w+\/\w+\">//;

 		$line =~ s/<\/a>//;

 		utf8::decode($line);

 		if (!($line =~ /[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ]+/))
 		{
 			# print "                  \"" . $line . "\",\n";
 			# print $line . "\n";
 		}
 		else
 		{
 			print "\"" . $line . "\",\n";
 		}

 		# $line = unac_string($line);
 		# $line = unidecode($line);

		# for ( $line ) {  # the variable we work on

  #  		##  convert to Unicode first
  #  		##  if your data comes in Latin-1, then uncomment:
  #  		$_ = Encode::decode( 'iso-8859-1', $_ );  

  #  		s/\xe4/ae/g;  ##  treat characters ä ñ ö ü ÿ
  #  s/\xf1/ny/g;  ##  this was wrong in previous version of this doc    
  #  s/\xf6/oe/g;
  #  s/\xfc/ue/g;
  #  s/\xff/yu/g;

  #  $_ = NFD( $_ );   ##  decompose (Unicode Normalization Form D)
  #  s/\pM//g;         ##  strip combining characters

  #  # additional normalizations:

  #  s/\x{00df}/ss/g;  ##  German beta “ß” -> “ss”
  #  s/\x{00c6}/AE/g;  ##  Æ
  #  s/\x{00e6}/ae/g;  ##  æ
  #  s/\x{0132}/IJ/g;  ##  Ĳ
  #  s/\x{0133}/ij/g;  ##  ĳ
  #  s/\x{0152}/Oe/g;  ##  Œ
  #  s/\x{0153}/oe/g;  ##  œ

  #  tr/\x{00d0}\x{0110}\x{00f0}\x{0111}\x{0126}\x{0127}/DDddHh/; # ÐĐðđĦħ
  #  tr/\x{0131}\x{0138}\x{013f}\x{0141}\x{0140}\x{0142}/ikLLll/; # ıĸĿŁŀł
  #  tr/\x{014a}\x{0149}\x{014b}\x{00d8}\x{00f8}\x{017f}/NnnOos/; # ŊŉŋØøſ
  #  tr/\x{00de}\x{0166}\x{00fe}\x{0167}/TTtt/;                   # ÞŦþŧ

   # s/[^\0-\x80]//g;  ##  clear everything else; optional
# }


$count++;
}
else
{
	if ($line =~ /.*<h5>.*/)
	{
		$process_next = 1;
	}
}
}

print "\n\nProcessed " . $count . " backers.\n\n";

