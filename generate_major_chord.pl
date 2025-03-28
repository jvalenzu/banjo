#!/bin/perl -w

use strict;

sub generate_chord_diagram($);
sub generate_makefile($);
sub generate_anki($;$;$;$;$);

use constant TRIAD  => 0x01;
use constant MAJ7   => 0x02;
use constant BARRE  => 0x04;
use constant FLAT   => 0x10;
use constant SHARP  => 0x20;
use constant SINGLE => 0x40;
my $data_offset = tell DATA;

use constant GENAKI_FLAG_NONE     => 0x00;
use constant GENAKI_FLAG_REVERSED => 0x01;

my @diagrams = (
  {
    name => 'A\flat',
    caption => 'First Position',
    fill => 'blue',
    flags => FLAT | TRIAD,
    notes => [ { coordinate => '1-1', label => 'E\flat' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-1', label => 'A\flat', border => 1 },
               { coordinate => '4-1', label => 'E\flat' } ]
  },
  {
    name => 'A',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD,
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A', border => 1 },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'Amaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7,
    start_fret => 2,
    notes => [ { coordinate => '1-6', label => 'G\sharp' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A', border => 1 },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'B\flat',
    caption => 'First Position',
    fill => 'blue',
    flags => FLAT | TRIAD,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'B\flat', border => 1 },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'B\flatmaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7 | FLAT,
    start_fret => 3,
    notes => [ { coordinate => '1-7', label => 'A' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'B\flat', border => 1 },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'B',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD,
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-4', label => 'B', border => 1 },
               { coordinate => '4-4', label => 'F\sharp' } ]
  },
  {
    name => 'Bmaj7',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 4,
    flags => MAJ7,
    notes => [ { coordinate => '1-8', label => 'A\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-4', label => 'B', border => 1 },
               { coordinate => '4-4', label => 'F\sharp' } ]
  },
  {
    name => 'C',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD,
    open_strings => { 3 => 1 },
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-1', label => 'C', border => 1 },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'Cmaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7,
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-1', label => 'C', border => 1 },
               { coordinate => '3-4', label => 'B' },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'C\sharp',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD | SHARP,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'C\sharp', border => 1 },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'C\sharpmaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7 | SHARP,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'C\sharp', border => 1 },
               { coordinate => '3-5', label => 'B\sharp' },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'D\flat',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD | FLAT,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'D\flat', border => 1 },
               { coordinate => '3-1', label => 'A\flat' },
               { coordinate => '4-3', label => 'F' },
        ]
  },
  {
    name => 'D\flatmaj7',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 6,
    flags => MAJ7 | FLAT,
    notes => [ { coordinate => '1-10', label => 'C' },
               { coordinate => '2-6', label => 'F' },
               { coordinate => '3-6', label => 'D\flat', border => 1 },
               { coordinate => '4-6', label => 'A\flat' },
        ]
  },
  {
    name => 'D',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD,
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-3', label => 'D', border => 1 },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-4', label => 'F\sharp' },
        ]
  },
  {
    name => 'Dmaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7,
    open_strings => { 4 => 1 },
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A' }
        ]
  },
  {
    name => 'D\sharp',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 3,
    flags => TRIAD | SHARP,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-4', label => 'D\sharp', border => 1 },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-5', label => 'G' },
        ]
  },
  {
    name => 'D\sharpmaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7 | SHARP,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-1', label => 'D\sharp', border => 1 },
        ]
  },
  {
    name => 'E\flat',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 3,
    flags => TRIAD | FLAT,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-4', label => 'E\flat', border => 1 },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-5', label => 'G' },
        ]
  },
  {
    name => 'E\flatmaj7',
    caption => 'First Position',    
    fill => 'blue',
    flags => MAJ7 | FLAT,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-1', label => 'E\flat', border => 1 },
        ]
  },
  {
    name => 'E',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD,
    open_strings => { 2 => 1 },
    notes => [ { coordinate => '1-2', label => 'E', border => 1 },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-2', label => 'E', border => 1 },
        ]
  },
  {
    name => 'Emaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7,
    open_strings => { 2 => 1 },
    notes => [ { coordinate => '1-1', label => 'E\sharp' },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-2', label => 'E', border => 1 },
        ]
  },
  {
    name => 'F',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD,
    notes => [ { coordinate => '1-3', label => 'F', border => 1 },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-3', label => 'F', border => 1 }
        ]
  },
  {
    name => 'Fmaj7',
    caption => 'First Position',    
    fill => 'blue',
    flags => MAJ7,
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-3', label => 'F', border => 1 }
        ]
  },
  {
    name => 'F\sharp',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 2,
    flags => TRIAD | SHARP,
    notes => [ { coordinate => '1-4', label => 'F\sharp', border => 1 },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-4', label => 'F\sharp', border => 1 }
        ]
  },
  {
    name => 'F\sharpmaj7',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 2,
    flags => MAJ7 | SHARP,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-4', label => 'F\sharp', border => 1 }
        ]
  },
  {
    name => 'G\flat',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 2,
    flags => TRIAD | FLAT,
    notes => [ { coordinate => '1-4', label => 'G\flat', border => 1 },
               { coordinate => '2-2', label => 'D\flat' },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-4', label => 'G\flat', border => 1 } ]
  },
  {
    name => 'G\flatmaj7',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 2,
    flags => MAJ7 | FLAT,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'D\flat' },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-4', label => 'G\flat', border => 1 } ]
  },
  {
    name => 'G',
    caption => 'First Position',
    fill => 'blue',
    open_strings => { 5 => 1 },
    start_fret => 3,
    flags => TRIAD,
    notes => [ { coordinate => '1-5', label => 'G', border => 1 },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-4', label => 'B' },
               { coordinate => '4-5', label => 'G', border => 1 }
        ]
  },
  {
    name => 'Gmaj7',
    caption => 'First Position',
    fill => 'blue',
    flags => MAJ7,
    open_strings => { 5 => 1, 4 => 1, 3 => 1, 2 => 1 },
    notes => [ { coordinate => '1-4', label => 'F\sharp' } ]
  },
  {
    name => 'G\sharp',
    caption => 'First Position',
    fill => 'blue',
    flags => TRIAD | SHARP,
    notes => [ { coordinate => '1-1', label => 'D\sharp' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-1', label => 'G\sharp', border => 1 },
               { coordinate => '4-1', label => 'D\sharp' } ]
  },
  {
    name => 'G\sharpmaj7',
    caption => 'First Position',
    fill => 'blue',
    start_fret => 3,
    flags => MAJ7 | SHARP,
    notes => [ { coordinate => '1-5', label => 'F\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-5', label => 'B\sharp' },
               { coordinate => '4-6', label => 'G\sharp', border => 1 } ]
  },
  {
    name => 'open',
    fill => 'blue',
    flags => BARRE,
    open_strings => { 5 => 1, 4 => 1, 3 => 1, 2 => 1, 1 => 1 }
  },
  {
    name => 'first fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-1', label => 'D\sharp' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-1', label => 'D\sharp' } ]
  },
  {
    name => 'second fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'third fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'fourth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-4', label => 'B' },
               { coordinate => '4-4', label => 'F\sharp' } ]
  },
  {
    name => 'fifth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-5', label => 'E' },
               { coordinate => '3-5', label => 'C' },
               { coordinate => '4-5', label => 'G' } ]
  },
  {
    name => 'sixth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-6', label => 'G\sharp' },
               { coordinate => '2-6', label => 'F' },
               { coordinate => '3-6', label => 'C\sharp' },
               { coordinate => '4-6', label => 'G\sharp' } ]
  },
  {
    name => 'seventh fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-7', label => 'A' },
               { coordinate => '2-7', label => 'F\sharp' },
               { coordinate => '3-7', label => 'D' },
               { coordinate => '4-7', label => 'A' } ]
  },
  {
    name => 'eighth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-8', label => 'A\sharp' },
               { coordinate => '2-8', label => 'G' },
               { coordinate => '3-8', label => 'D\sharp' },
               { coordinate => '4-8', label => 'A\sharp' } ]
  },
  {
    name => 'ninth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-9', label => 'B' },
               { coordinate => '2-9', label => 'G\sharp' },
               { coordinate => '3-9', label => 'E' },
               { coordinate => '4-9', label => 'B' } ]
  },
  {
    name => 'tenth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-10', label => 'C' },
               { coordinate => '2-10', label => 'A' },
               { coordinate => '3-10', label => 'F' },
               { coordinate => '4-10', label => 'C' } ]
  },
  {
    name => 'eleventh fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-11', label => 'C\sharp' },
               { coordinate => '2-11', label => 'A\sharp' },
               { coordinate => '3-11', label => 'F\sharp' },
               { coordinate => '4-11', label => 'C\sharp' } ]
  },
  {
    name => 'twelvth fret',
    fill => 'blue',
    flags => BARRE,
    notes => [ { coordinate => '1-12', label => 'D' },
               { coordinate => '2-12', label => 'B' },
               { coordinate => '3-12', label => 'G' },
               { coordinate => '4-12', label => 'D' } ]
  },
  
  #
  # single
  #
  
  # open strings
  {
    name => 'D (low)',
    fill => 'blue',
    flags => SINGLE,
    open_strings => { 4 => 1 }
  },
  {
    name => 'G',
    fill => 'blue',
    flags => SINGLE,
    open_strings => { 3 => 1 }
  },
  {
    name => 'B',
    fill => 'blue',
    flags => SINGLE,
    open_strings => { 2 => 1 }
  },
  {
    name => 'D (high)',
    fill => 'blue',
    flags => SINGLE,
    open_strings => { 1 => 1 }
  },

  # first fret
  {
    name => 'D (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-1'} ]
  },
  {
    name => 'G\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-1'} ]
  },
  {
    name => 'C',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-1'} ]
  },
  {
    name => 'D\sharp (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-1'} ]
  },

  
  # second string
  {
    name => 'E (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-2'} ]
  },
  {
    name => 'A',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-2'} ]
  },
  {
    name => 'C\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-2'} ]
  },
  {
    name => 'E (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-2'} ]
  },

  # third string
  {
    name => 'F (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-3'} ]
  },
  {
    name => 'A\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-3'} ]
  },
  {
    name => 'D',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-3'} ]
  },
  {
    name => 'F (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-3'} ]
  },

  # fourth string
  {
    name => 'F\sharp (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-4'} ]
  },
  {
    name => 'B',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-4'} ]
  },
  {
    name => 'D\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-4'} ]
  },
  {
    name => 'F\sharp (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-4'} ]
  },

  # fifth string
  {
    name => 'G (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-5'} ]
  },
  {
    name => 'C',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-5'} ]
  },
  {
    name => 'E',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-5'} ]
  },
  {
    name => 'G (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-5'} ]
  },

  # sixth string
  {
    name => 'G\sharp (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-6'} ]
  },
  {
    name => 'C\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-6'} ]
  },
  {
    name => 'F',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-6'} ]
  },
  {
    name => 'G\sharp (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-6'} ]
  },

  # seventh string
  {
    name => 'A (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-7'} ]
  },
  {
    name => 'D',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-7'} ]
  },
  {
    name => 'F\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-7'} ]
  },
  {
    name => 'A (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-7'} ]
  },

  # eighth string
  {
    name => 'A\sharp (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-8'} ]
  },
  {
    name => 'D\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-8'} ]
  },
  {
    name => 'G',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-8'} ]
  },
  {
    name => 'A\sharp (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-8'} ]
  },

  # ninth fret
  {
    name => 'B (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-9'} ]
  },
  {
    name => 'E',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-9'} ]
  },
  {
    name => 'G\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-9'} ]
  },
  {
    name => 'B (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-9'} ]
  },

  # tenth fret
  {
    name => 'C (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-10'} ]
  },
  {
    name => 'F',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-10'} ]
  },
  {
    name => 'A',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-10'} ]
  },
  {
    name => 'C (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-10'} ]
  },


  # eleventh fret
  {
    name => 'C\sharp (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-11'} ]
  },
  {
    name => 'F\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-11'} ]
  },
  {
    name => 'A\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-11'} ]
  },
  {
    name => 'C\sharp (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-11'} ]
  },

  # twelfth fret
  {
    name => 'D (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-12'} ]
  },
  {
    name => 'G',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-12'} ]
  },
  {
    name => 'B',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-12'} ]
  },
  {
    name => 'D (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-12'} ]
  },

  # thirteenth fret
  {
    name => 'D\sharp (low)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '4-13'} ]
  },
  {
    name => 'G\sharp',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '3-13'} ]
  },
  {
    name => 'C',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '2-13'} ]
  },
  {
    name => 'D\sharp (high)',
    fill => 'blue',
    flags => SINGLE,
    notes => [ { coordinate => '1-13'} ]
  }
);


my @fnames = ();

mkdir "build";
foreach my $diagram (@diagrams)
{
  (my $fname = $diagram->{name}) =~ s/ /_/g;
  $fname =~ s/\\flat/♭/g;
  $fname =~ s/\\sharp/♯/g;

  push @fnames, $fname;

  open(my $fh, '>', 'build/'.$fname.".tex") or die $!;
  print $fh generate_chord_diagram($diagram);
  close($fh);
}

{
  mkdir "build";
  mkdir "build/Docs";
  
  open(my $fh, '>', "build/Docs/Chords.md") or die $!;
  for (my $i=0; $i<=$#diagrams; ++$i)
  {
    my $diagram = $diagrams[$i];
    my $fname = $fnames[$i];
    (my $label = $fname) =~ s/_/ /g;
    
    print $fh "<div style=\"display: flex; align-items: center\">\n";
    print $fh "  <div style=\"width: 5em;\">\n";
    print $fh "  <b>$label</b>\n";
    print $fh "  </div>\n";
    print $fh "  <div>\n";
    print $fh "\n";
    print $fh "![\"$label\"]($fname\.png)\n";
    print $fh "\n";
    print $fh "  </div>\n";
    print $fh "</div>\n";
    print $fh "<br>\n";
    
  }
  close($fh);
}


generate_makefile(\@fnames);

{
  my @triads = grep { (($_->{flags} & TRIAD)) == TRIAD } @diagrams;
  my $text = generate_anki('banjo_chords.apkg', 1694391122062, 'Banjo Chords (G Tuning)', GENAKI_FLAG_NONE, \@triads);
  
  mkdir "build";
  open(my $fh, '>', "build/generate_anki_deck_triad.py") or die $!;
  print $fh $text;
  close($fh);
}

{
  my @maj7s = grep { ($_->{flags} & MAJ7) == MAJ7 } @diagrams;
  my $text = generate_anki('banjo_major7_chords.apkg', 1694391122063, 'Banjo Major 7th Chords (G Tuning)', GENAKI_FLAG_NONE, \@maj7s);
  
  mkdir "build";
  open(my $fh, '>', "build/generate_anki_deck_maj7.py") or die $!;
  print $fh $text;
  close($fh);
}


{
  my @barre_chords = grep { ($_->{flags} & BARRE) == BARRE } @diagrams;
  my $text = generate_anki('banjo_barre_chords.apkg', 1694391122064, 'Banjo Barre Chords (G Tuning)', GENAKI_FLAG_NONE, \@barre_chords);
  
  mkdir "build";
  open(my $fh, '>', "build/generate_anki_deck_barre.py") or die $!;
  print $fh $text;
  close($fh);
}

{
  my @barre_chords = grep { ($_->{flags} & SINGLE) == SINGLE } @diagrams;
  my $text = generate_anki('banjo_single_notes.apkg', 1694391122065, 'Banjo Single Notes (G Tuning)', GENAKI_FLAG_REVERSED, \@barre_chords);
  
  mkdir "build";
  open(my $fh, '>', "build/generate_anki_deck_single.py") or die $!;
  print $fh $text;
  close($fh);
}

sub generate_makefile($)
{
  my $fnames = shift;
  
  my $auxs = join ' ', map { "$_.aux"; } @{$fnames};
  my $logs = join ' ', map { "$_.log"; } @{$fnames};
  my $pdfs = join ' ', map { "$_.pdf"; } @{$fnames};
  my $pngs = join ' ', map { "$_.png"; } @{$fnames};
  my $dvis = join ' ', map { "$_.dvi"; } @{$fnames};
  my $texes = join ' ', map { "$_.tex"; } @{$fnames};
  
  my $out = "";

  
  
  $out .= "DOCSDIR=Docs\n";
  $out .= "FINALPNG=\$(foreach p,$pngs,\$(DOCSDIR)/\$(p))\n";
  $out .= "\n";
  $out .= "test: \$(FINALPNG)\n";
  $out .= "\n";
  $out .= "%.pdf : %.dvi\n";
  $out .= "	dvipdf \"\$<\"\n";
  $out .= "\n";
  $out .= "\$(DOCSDIR)/%.png : %.pdf\n";
  $out .= "	convert -define png:color-type=6 -density 300 \"\$<[0]\" ../\"\$\@\"\n";
  $out .= "\n";
  $out .= "%.dvi : %.tex\n";
  $out .= "	latex \"\$<\"\n";
  $out .= "clean:\n";
  $out .= "\trm -f $pdfs $pngs $dvis $auxs $logs $texes\n";
  $out .= "\n";
  $out .= "distclean: clean\n";
  $out .= "\trm -f \$(FINALPNG)\n";

  mkdir "build";
  open(my $fh, '>', "build/Makefile") or die $!;
  print $fh $out;
  close($fh);
}

sub generate_chord_diagram($)
{
  my $diagram = shift;

  my $name = $diagram->{name};
  my $fill = $diagram->{fill};
  my $open_strings = $diagram->{open_strings};
  my $notes = $diagram->{notes};

  # find start fret (default)
  my $start_fret = 1;
  if (defined($diagram->{start_fret}))
  {
    $start_fret = $diagram->{start_fret};
  }

  # find last fret
  my $last_fret = 0;
  foreach my $note (@{$notes})
  {
    my $coordinate = $note->{coordinate};
    my ($string, $fret) = split /-/, $coordinate;
    $last_fret = $last_fret < $fret ? $fret : $last_fret;

    $note->{coordinate} = (6-$string).'-'.$fret;
  }

  my $first_interval_end = $last_fret > 4 ? 4 : $last_fret;
  my $draw_fifth_string = $last_fret > 5 ? 1 : 0;
  
  # move this because we may not be drawing the first fret
  my $fifth_nut_start = 0.94387431268**(6-$start_fret);
  my $template = <<HERE;
\\documentclass[margin=.2cm]{standalone}

\\usepackage{tikz}
\\usepackage{xfp}
\\usepackage{algorithm}
\\usetikzlibrary{calc,arrows}

\\begin{document}

\\begin{tikzpicture}[
    ynode/.style={draw=red!50,circle,fill=red!50,scale=.35,inner sep=1pt,minimum size=1.7em}]

  %%%% Draw the base and set coordinates %%%%
  \\begin{scope}[xscale=-15,yscale=.3,line width=.5]

    \\def\\plushalf[#1]{\\fpeval{0.5 + #1}}
    \\def\\fretname[#1]{\\coordinate (fret#1) at (\\fpeval{0.9875}, 5.5) }
    \\def\\nutoffset{0.015}
    \\def\\fifthnutx{$fifth_nut_start} 

    \\xdef\\x{1}

    \\coordinate (Nut-5) at (\\fpeval{1.0 + \\nutoffset},                5);
    \\coordinate (Nut-4) at (\\fpeval{1.0 + \\nutoffset},                4);
    \\coordinate (Nut-3) at (\\fpeval{1.0 + \\nutoffset},                3);
    \\coordinate (Nut-2) at (\\fpeval{1.0 + \\nutoffset},                2);
    \\coordinate (Nut-1) at (\\fpeval{\\fifthnutx + \\nutoffset},        1);

    \\draw[line width=1.5] (1,2) -- (1,5);
HERE

  if ($draw_fifth_string)
  {
    $template .= "\\draw[line width=1.5] (\\fifthnutx,1) -- (\\fifthnutx,2); % fifth string peg\n";
  }

  if ($start_fret <= $first_interval_end)
  {
  $template .= <<HERE;  
    \\foreach \\fret in {$start_fret,...,$first_interval_end}{

      %% define coordinate for fret label
      \\fretname[\\fret];
  
      %% Set coordinate for each string
      \\foreach \\str in {1,...,5}{
        \\coordinate (\\str-\\fret) at (0.97193715634*\\x,\\str);
        \\coordinate (plushalf\\str-\\fret) at (0.97193715634*\\x,\\plushalf[\\str]);
      }
      %% Set coordinate for the text above
      \\coordinate (Top-\\fret) at (0.97193715634*\\x,7);
      %% Compute the position of the fret
      \\pgfmathsetmacro\\x{\\x * 0.94387431268}
      \\xdef\\x{\\x}
      %% Draw the fret
      \\draw[black] (\\x,2) -- (\\x,5);
    }
HERE
  }

  if ($last_fret >= 5)
  {
    my $second_interval_start = 5;
    if ($start_fret > 5)
    {
      $second_interval_start = $start_fret;
    }
    
    $template .= <<HERE;
    \\foreach \\fret in {$second_interval_start,...,$last_fret}{
HERE
    $template .= <<'HERE';
      %% define coordinate for fret label
      \fretname[\fret];

      %% Set coordinate for each string
      \foreach \str in {1,...,5}{
        \coordinate (\str-\fret) at (0.97193715634*\x,\str);
        \coordinate (plushalf\str-\fret) at (0.97193715634*\x,\plushalf[\str]);
      }
      %% Set coordinate for the text above
      \coordinate (Top-\fret) at (0.97193715634*\x,7);
      %% Compute the position of the fret
      \pgfmathsetmacro\x{\x * 0.94387431268}
      \xdef\x{\x}
      %% Draw the fret
      \draw (\x,2) -- (\x,5);
      \draw (\x,1) -- (\x,2);
    }
HERE
  }

$template .= <<'HERE';
    %% Draw each string
    \foreach \str in {2,...,5}{
      \draw (1,\str) -- (0.97153194115*\x,\str);
      \coordinate (start\str) at (1,\str);
    }
HERE

  if ($draw_fifth_string)
  {
$template .= <<'HERE';  
    \foreach \str in {1,...,1}{
      \draw (\fifthnutx,\str) -- (0.97153194115*\x,\str);
      \coordinate (start\str) at (1,\str);
    }
HERE
  }

$template .= <<'HERE';
  \end{scope}
HERE
  
  my @circles = (3,5,7,9,15,17);
  while ($#circles>=0 && $circles[0] < $start_fret)
  {
    shift @circles;
  }
  
  for (my $i=0; $i<=$#circles; ++$i)
  {
    if ($circles[$i] > $last_fret)
    {
      $#circles = $i-1;
      last;
    }
  }
  
  my $circle_string = "{".join(',',@circles)."}";
  my $twelve_string = $last_fret >= 12 ? "{12}" : "{}";

$template .= <<HERE;
  %% Draw the inlay circles
  \\foreach \\f in $circle_string {
    \\draw[black!20,fill=black!20] (\$(3-\\f)!.5!(4-\\f)\$) circle (.08);
  }
  \\foreach \\f in $twelve_string {
    \\draw[black!20,fill=black!20] (plushalf2-12) circle (.08) (plushalf4-12) circle (.08);
  }
HERE
  
  if ($start_fret > 1)
  {
    $template .= "  \\draw[black!50, text=black] (fret$start_fret) node {\\tiny $start_fret };\n";    
  }
  
  # open_strings
  
  $template .= "  %% label nut\n";
  if ($open_strings->{1})
  {
    $template .= "  \\draw[black!50, text=black, fill=$fill!15] (Nut-5) circle [radius=.15] node {\\tiny D};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-5) node {\\tiny D};\n";
  }

  if ($open_strings->{2})
  {
    $template .= "  \\draw[black!50, text=black, fill=$fill!15] (Nut-4) circle [radius=.15] node {\\tiny B};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-4) node {\\tiny B};\n";
  }
  
  if ($open_strings->{3})
  {
    $template .= "  \\draw[black!50, text=black, fill=$fill!15] (Nut-3) circle [radius=.15] node {\\tiny G};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-3) node {\\tiny G};\n";
  }
  
  if ($open_strings->{4})
  {
    $template .= "  \\draw[black!50, text=black, fill=$fill!15] (Nut-2) circle [radius=.15] node {\\tiny D};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-2) node {\\tiny D};\n";
  }
  
  if ($open_strings->{4} && $draw_fifth_string)
  {
    $template .= "  \\draw[black!50, text=black] (Nut-1) circle [radius=.15] node {\\tiny G};\n";
  }
  elsif ($draw_fifth_string)
  {
    $template .= "  \\draw[black!100] (Nut-1) node {\\tiny G};\n";
  }
  
  $template .="    % do a $name chord\n";

  foreach my $note (@{ $notes })
  { 
    my $coordinate = $note->{'coordinate'};
    my $label = $note->{'label'} || "";
    my $border = defined($note->{'border'}) ? $note->{'border'} : 0;

    if ($border)
    {
      $template .= "  \\draw[black!100,fill=$fill!15]            ($coordinate) circle [radius=.15] node {\\tiny \$$label\$};\n";
    }
    else
    {
      $template .= "  \\draw[black!40, text=black,fill=$fill!15] ($coordinate) circle [radius=.15] node {\\tiny \$$label\$};\n";
    }
  }
  
  $template .= "\n";
  $template .= "\\end{tikzpicture}\n";
  $template .= "\\end{document}\n";

  return $template;
}

sub generate_anki($;$;$;$;$)
{
  my $package_name = shift;
  my $deck_id = shift;
  my $deck_name = shift;
  my $flags = shift;
  my $diagrams = shift;
  
  my $pyt;
  {
    local $/ = undef;
    seek DATA, $data_offset, 0;
    $pyt = <DATA>;
  }
  
  my @syms = map
  {
    my $t0 = $_->{'name'};
    (my $t1 = $t0) =~ s/\\flat/♭/g;
    (my $t2 = $t1) =~ s/\\sharp/♯/g;
    $t2;
  } @{ $diagrams };
  
  my @pngs = map
  {
    (my $t0 = $_) =~ s/ /_/g;
    $t0.".png";
  } @syms;
  
  my $interleaved = "";
  my $copy_files = "";
  
  for (my $i=0; $i<=$#syms; ++$i)
  {
    if (($flags & GENAKI_FLAG_REVERSED) == GENAKI_FLAG_REVERSED)
    {
      $interleaved .= "  deck.add_note(genanki.Note(model, [ '<img src=\"$pngs[$i]\">', '$syms[$i]']))\n";
    }
    else
    {
      $interleaved .= "  deck.add_note(genanki.Note(model, [ '$syms[$i]', '<img src=\"$pngs[$i]\">' ]))\n";
    }
    
    $copy_files  .= "  shutil.copy(cwd+'/../Docs/$pngs[$i]', '.')\n";
  }
  
  my $notes = $interleaved . $copy_files;
  
  my $media_files = join ',', map { "'$_'" } @pngs;
  
  $pyt =~ s/__DECK_ID__/$deck_id/;
  $pyt =~ s/__DECK_NAME__/$deck_name/;
  $pyt =~ s/__MEDIA_FILES__/$media_files/;
  $pyt =~ s/__NOTES__/$notes/;
  $pyt =~ s/__APKG_NAME__/$package_name/;

  return $pyt;
}


__DATA__
import shutil
import datetime
import os
import tempfile
import textwrap
import warnings
import itertools
import time
import sys
sys.path.insert(1, '../External/genanki')
import genanki

def test_media_files_in_subdirs():
  deck_id = __DECK_ID__

  # change to a scratch directory so we can write files
  cwd = os.getcwd()
  os.chdir(tempfile.mkdtemp())
  
  deck = genanki.Deck(deck_id, '__DECK_NAME__')
  model = genanki.Model(deck_id, 'Simple Banjo Model',
                        fields=[{ 'name':'Question' }, { 'name':'Answer' }],
                        templates=[{'name': 'Card 1', 'qfmt': '{{Question}}', 'afmt': '{{Answer}}'}])

__NOTES__
  
  # populate files with data
  package = genanki.Package(deck, media_files=[ __MEDIA_FILES__ ])
  package.write_to_file(cwd+'/__APKG_NAME__')

if __name__ == '__main__':
  test_media_files_in_subdirs()
