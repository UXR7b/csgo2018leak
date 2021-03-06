#! perl
use Math::Trig;

# generate a table of vectors to use for the k dop basis. We will add
# the 3 basic vectors and then add more vectors until we get to the
# target of 16 directions.

srand(31456);

print <<END
//========= Copyright ? 1996-2006, Valve Corporation, All rights reserved. ============//
//
// Purpose: static vector table for 32-plane kdops
//
// \$Workfile:     \$
// \$NoKeywords: \$
//=============================================================================//
//
//    **** DO NOT EDIT THIS FILE. GENERATED BY genvectors.PL ****
//

END
;

my $nNumVectors = 3;

for( $i = 0; $i < 3; $i++ )
{
  push @XC, &ZeroOne( $i == 0 );
  push @YC, &ZeroOne( $i == 1 );
  push @ZC, &ZeroOne( $i == 2 );
}

# now, generate a bunch of random vectors and keep whichever is farthest away from all vectors chosen thus far

while( $#XC < 15 )
  {
	my $mindot = 2.0;
	for( $t = 0; $t < 1000*100; $t++ )
	  {
		my $closest_comp_dot = 0;
		$z=rand(2)-1;
		$phi=rand(2.0*3.141592654);
		$theta=asin($z);
		$x = cos($theta)*cos($phi);
		$y = cos($theta)*sin($phi);
		for( $c = 0; $c <= $#XC; $c++ )
		  {
			my $dot = abs( $x * $XC[$c] + $y * $YC[$c] + $z * $ZC[$c] );
			$closest_comp_dot = $dot if ( $closest_comp_dot < $dot );
		  }
		if ( $closest_comp_dot < $mindot )
		  {
			$mindot = $closest_comp_dot;
			$bestx = $x;
			$besty = $y;
			$bestz = $z;
		  }
	  }
	#print "dot = $mindot ($bestx, $besty, $bestz)\n";
	push @XC, $bestx;
	push @YC, $besty;
	push @ZC, $bestz;
  }

# output
foreach $_ ( ( 'X', 'Y', 'Z' ) )
{
  print "const fltx4 g_KDop32$_"."Dirs[] =\n{\n";
  for( $i = 0; $i <= $#XC; $i++ )
	{
	  print "\t{ " if ( ( $i & 3 ) == 0 );
	  $vname= $_."C";
	  printf "%f, ",$$vname[$i];
	  print " },\n" if ( ( $i & 3 ) == 3 );
	}
  print "};\n\n";
}

sub ZeroOne
  {
	my $n = pop(@_);
	return 0 unless( $n );
	return 1;
  }
