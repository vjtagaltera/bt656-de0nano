#!/usr/bin/perl -w
#
#  ref: https://www.intersil.com/content/dam/Intersil/documents/an97/an9728.pdf
#    intersil an9728 rev 2.0 jul 2002 : BT.656 Video Interface for ICs

use strict;

sub calc {
    my ($l1, $l2, $f, $v) = @_;
    my $h = 0; #sav
    my $sav = ($f << 6) | ($v << 5) | (($v ^ $h) << 3) | (($f ^ $h) << 2) | (($f ^ $v) << 1)|($f ^ $v ^ $h) ;
    $h = 1; # eav
    my $eav = ($f << 6) | ($v << 5) | (1<<4) | (($v ^ $h) << 3) | (($f ^ $h) << 2) | (($f ^ $v) << 1)|($f ^ $v ^ $h) ;
    print sprintf(" %3d %3d - %3d : f %d , v %d , sav %02x , eav %02x\n", 
                  $l2+1-$l1, $l1, $l2, $f, $v, $sav + 0x80, $eav + 0x80);
    return "ok";
}

# calculate based on the intersil an9728
print "\n625/50 video", "\n";
calc(1, 22,    0, 1);
calc(23, 310,  0, 0);
calc(311, 312, 0, 1);
calc(313, 335, 1, 1);
calc(336, 623, 1, 0);
calc(624, 625, 1, 1);

print "\n525/60 video", "\n";
calc(1, 3, 1, 1);
calc(4, 20,    0, 1);
calc(21, 263,  0, 0);
calc(264, 265, 0, 1);
calc(266, 282, 1, 1);
calc(283, 525, 1, 0);

exit 0;

__END__


document video formats lines: 

  525/60 square video line lengths: 
       eav   blanking   sav   data
        4      272       4    1280
      total 1560

  625/50 square video line lengths:
       eav   blanking   sav   data
        4      344       4    1536
      total 1888


$ perl synccode.pl

  625/50 video
    22   1 -  22 : f 0 , v 1 , sav ab , eav b6
   288  23 - 310 : f 0 , v 0 , sav 80 , eav 9d
     2 311 - 312 : f 0 , v 1 , sav ab , eav b6
    23 313 - 335 : f 1 , v 1 , sav ec , eav f1
   288 336 - 623 : f 1 , v 0 , sav c7 , eav da
     2 624 - 625 : f 1 , v 1 , sav ec , eav f1

  525/60 video
     3   1 -   3 : f 1 , v 1 , sav ec , eav f1
    17   4 -  20 : f 0 , v 1 , sav ab , eav b6
   243  21 - 263 : f 0 , v 0 , sav 80 , eav 9d
     2 264 - 265 : f 0 , v 1 , sav ab , eav b6
    17 266 - 282 : f 1 , v 1 , sav ec , eav f1
   243 283 - 525 : f 1 , v 0 , sav c7 , eav da


default line 787  field 363 signaltap2 capture: 
 line count    sav    eav
     0..2       ab     b6
     3..8       80     9d
     9..a       ab     b6
     0x3fffffff
     0..2       ec     f1
     3..        c7     da


calculate  525/60 video setting in verilog

    line:  1280/140/140
    field:  243/10/10


