#!/bin/perl -w

use strict;

sub generate_chord_diagram($);
sub generate_makefile($);
sub generate_anki($);

my @diagrams = (
  {
    name => 'A\flat',
    fill => 'blue',
    notes => [ { coordinate => '1-1', label => 'E\flat' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-1', label => 'A\flat', border => 1 },
               { coordinate => '4-1', label => 'E\flat' } ]
  },
  {
    name => 'A',
    fill => 'blue',
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A', border => 1 },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'Amaj7',
    fill => 'blue',
    start_fret => 2,
    notes => [ { coordinate => '1-6', label => 'G\sharp' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A', border => 1 },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'B\flat',
    fill => 'blue',
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'B\flat', border => 1 },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'B\flatmaj7',
    fill => 'blue',
    start_fret => 3,
    notes => [ { coordinate => '1-7', label => 'A' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'B\flat', border => 1 },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'B',
    fill => 'blue',
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-4', label => 'B', border => 1 },
               { coordinate => '4-4', label => 'F\sharp' } ]
  },
  {
    name => 'Bmaj7',
    fill => 'blue',
    start_fret => 4,
    notes => [ { coordinate => '1-8', label => 'A\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-4', label => 'B', border => 1 },
               { coordinate => '4-4', label => 'F\sharp' } ]
  },
  {
    name => 'C',
    fill => 'blue',
    open_strings => { 3 => 1 },
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-1', label => 'C', border => 1 },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'Cmaj7',
    fill => 'blue',
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-1', label => 'C', border => 1 },
               { coordinate => '3-4', label => 'B' },
               { coordinate => '4-2', label => 'E' } ]
  },
  {
    name => 'C\sharp',
    fill => 'blue',
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'C\sharp', border => 1 },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'C\sharpmaj7',
    fill => 'blue',
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'C\sharp', border => 1 },
               { coordinate => '3-5', label => 'B\sharp' },
               { coordinate => '4-3', label => 'F' } ]
  },
  {
    name => 'D\flat',
    fill => 'blue',
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'D\flat', border => 1 },
               { coordinate => '3-1', label => 'A\flat' },
               { coordinate => '4-3', label => 'F' },
        ]
  },
  {
    name => 'D\flatmaj7',
    fill => 'blue',
    start_fret => 6,
    notes => [ { coordinate => '1-10', label => 'C' },
               { coordinate => '2-6', label => 'F' },
               { coordinate => '3-6', label => 'D\flat', border => 1 },
               { coordinate => '4-6', label => 'A\flat' },
        ]
  },
  {
    name => 'D',
    fill => 'blue',
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-3', label => 'D', border => 1 },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-4', label => 'F\sharp' },
        ]
  },
  {
    name => 'Dmaj7',
    fill => 'blue',
    open_strings => { 4 => 1 },
    notes => [ { coordinate => '1-4', label => 'F\sharp' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-2', label => 'A' }
        ]
  },
  {
    name => 'D\sharp',
    fill => 'blue',
    start_fret => 3,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-4', label => 'D\sharp', border => 1 },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-5', label => 'G' },
        ]
  },
  {
    name => 'D\sharpmaj7',
    fill => 'blue',
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-1', label => 'D\sharp', border => 1 },
        ]
  },
  {
    name => 'E\flat',
    fill => 'blue',
    start_fret => 3,
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-4', label => 'E\flat', border => 1 },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-5', label => 'G' },
        ]
  },
  {
    name => 'E\flatmaj7',
    fill => 'blue',
    notes => [ { coordinate => '1-5', label => 'G' },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-1', label => 'E\flat', border => 1 },
        ]
  },
  {
    name => 'E',
    fill => 'blue',
    open_strings => { 2 => 1 },
    notes => [ { coordinate => '1-2', label => 'E', border => 1 },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-2', label => 'E', border => 1 },
        ]
  },
  {
    name => 'Emaj7',
    fill => 'blue',
    open_strings => { 2 => 1 },
    notes => [ { coordinate => '1-1', label => 'E\sharp' },
               { coordinate => '3-1', label => 'G\sharp' },
               { coordinate => '4-2', label => 'E', border => 1 },
        ]
  },
  {
    name => 'F',
    fill => 'blue',
    notes => [ { coordinate => '1-3', label => 'F', border => 1 },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-3', label => 'F', border => 1 }
        ]
  },
  {
    name => 'Fmaj7',
    fill => 'blue',
    notes => [ { coordinate => '1-2', label => 'E' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-2', label => 'A' },
               { coordinate => '4-3', label => 'F', border => 1 }
        ]
  },
  {
    name => 'F\sharp',
    fill => 'blue',
    start_fret => 2,
    notes => [ { coordinate => '1-4', label => 'F\sharp', border => 1 },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-4', label => 'F\sharp', border => 1 }
        ]
  },
  {
    name => 'F\sharpmaj7',
    fill => 'blue',
    start_fret => 2,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'C\sharp' },
               { coordinate => '3-3', label => 'A\sharp' },
               { coordinate => '4-4', label => 'F\sharp', border => 1 }
        ]
  },
  {
    name => 'G\flat',
    fill => 'blue',
    start_fret => 2,
    notes => [ { coordinate => '1-4', label => 'G\flat', border => 1 },
               { coordinate => '2-2', label => 'D\flat' },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-4', label => 'G\flat', border => 1 } ]
  },
  {
    name => 'G\flatmaj7',
    fill => 'blue',
    start_fret => 2,
    notes => [ { coordinate => '1-3', label => 'F' },
               { coordinate => '2-2', label => 'D\flat' },
               { coordinate => '3-3', label => 'B\flat' },
               { coordinate => '4-4', label => 'G\flat', border => 1 } ]
  },
  {
    name => 'G',
    fill => 'blue',
    open_strings => { 5 => 1 },
    start_fret => 3,
    notes => [ { coordinate => '1-5', label => 'G', border => 1 },
               { coordinate => '2-3', label => 'D' },
               { coordinate => '3-4', label => 'B' },
               { coordinate => '4-5', label => 'G', border => 1 }
        ]
  },
  {
    name => 'Gmaj7',
    fill => 'blue',
    open_strings => { 5 => 1, 4 => 1, 3 => 1, 2 => 1 },
    notes => [ { coordinate => '1-4', label => 'F\sharp' } ]
  },
  {
    name => 'G\sharp',
    fill => 'blue',
    notes => [ { coordinate => '1-1', label => 'D\sharp' },
               { coordinate => '2-1', label => 'C' },
               { coordinate => '3-1', label => 'G\sharp', border => 1 },
               { coordinate => '4-1', label => 'D\sharp' } ]
  },
  {
    name => 'G\sharpmaj7',
    fill => 'blue',
    start_fret => 3,
    notes => [ { coordinate => '1-5', label => 'F\sharp' },
               { coordinate => '2-4', label => 'D\sharp' },
               { coordinate => '3-5', label => 'B\sharp' },
               { coordinate => '4-6', label => 'G\sharp', border => 1 } ]
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
generate_anki(\@diagrams);

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
  $out .= "	dvipdf \$<\n";
  $out .= "\n";
  $out .= "\$(DOCSDIR)/%.png : %.pdf\n";
  $out .= "	convert -density 300 \$< \$\@\n";
  $out .= "\n";
  $out .= "%.dvi : %.tex\n";
  $out .= "	latex \$<\n";
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
    $template .= <<HERE;
    \\foreach \\fret in {5,...,$last_fret}{
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
  my $twelve_string = $last_fret > 12 ? "{12}" : "{}";

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
    my $label = $note->{'label'};
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

sub generate_anki($)
{
  my $diagrams = shift;

  my $pyt;
  {
    local $/ = undef;
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
    $interleaved .= "  deck.add_note(genanki.Note(model, [ '$syms[$i]', '<img src=\"$pngs[$i]\">' ]))\n";
    $copy_files  .= "  shutil.copy(cwd+'/../Docs/$pngs[$i]', '.')\n";
  }

  my $notes = $interleaved . $copy_files;

  my $media_files = join ',', map { "'$_'" } @pngs;
  
  $pyt =~ s/__MEDIA_FILES__/$media_files/;
  $pyt =~ s/__NOTES__/$notes/;

  mkdir "build";
  open(my $fh, '>', "build/generate_anki_deck.py") or die $!;
  print $fh $pyt;
  close($fh);
  
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
  deck_id = 1694391122062

  # change to a scratch directory so we can write files
  cwd = os.getcwd()
  os.chdir(tempfile.mkdtemp())
  
  deck = genanki.Deck(deck_id, 'Default (G) Tuning Banjo Chords')
  model = genanki.Model(deck_id, 'Simple Banjo Model',
                        fields=[{ 'name':'Question' }, { 'name':'Answer' }],
                        templates=[{'name': 'Card 1', 'qfmt': '{{Question}}', 'afmt': '{{Answer}}'}])

__NOTES__
  
  # populate files with data
  package = genanki.Package(deck, media_files=[ __MEDIA_FILES__ ])
  package.write_to_file(cwd+'/banjo_chords.apkg')

if __name__ == '__main__':
  test_media_files_in_subdirs()
