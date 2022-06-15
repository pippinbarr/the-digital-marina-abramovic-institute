 #!/usr/local/bin/perl

 use strict;
 use Text::CSV;

 my $csv = Text::CSV->new({ sep_char => ',' });
 
 my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
 
 my $sum;

 open(my $data, '<', $file) or die "Could not open '$file' $!\n";

 while (my $line = <$data>) 
 {
 	chomp $line;

 	if ($csv->parse($line)) 
 	{
 		my @fields = $csv->fields();

 		print @fields;

 	}
 	else 
 	{
 		warn "Line could not be parsed: $line\n\n";
 	}
 }
 	
