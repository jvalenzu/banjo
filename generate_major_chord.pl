#!/bin/perl -w

use strict;

sub generate_chord_diagram($);
sub generate_makefile($);

my @diagrams = (
  {
    name => 'C major',
    fill => 'blue',
    open_strings => { 5 => 1, 3 => 1 },
    notes => [ { coordinate => '4-1', label => 'C' },
               { coordinate => '2-2', label => 'E' },
               { coordinate => '5-2', label => 'E' } ]
  },
  {
    name => 'G major',
    fill => 'blue',
    open_strings => { 5 => 1 },
    start_fret => 3,
    notes => [ { coordinate => '4-3', label => 'D' },
               { coordinate => '5-5', label => 'G' },
               { coordinate => '2-5', label => 'G' },
               { coordinate => '3-4', label => 'B' } ]
  }
  
    );

my @fnames = ();

foreach my $diagram (@diagrams)
{
  (my $fname = $diagram->{name}) =~ s/ /_/g;

  push @fnames, $fname;
  
  open(my $fh, '>', "$fname.tex") or die $!;
  print $fh generate_chord_diagram($diagram);
  close($fh);
}

generate_makefile(\@fnames);

sub generate_makefile($)
{
  my $fnames = shift;

  my $pdfs = join '', map { $_ . ".pdf " } @{$fnames};
  my $dvis = join '', map { $_ . ".dvi " } @{$fnames};

  my $out = "";
  
  $out .= "test: $pdfs\n";
  $out .= "\n";
  $out .= "%.pdf : %.dvi\n";
  $out .= "	dvipdf \$<\n";
  $out .= "\n";
  $out .= "%.dvi : %.tex\n";
  $out .= "	latex \$<\n";
  $out .= "clean:\n";
  $out .= "\trm -f $pdfs $dvis\n";

  open(my $fh, '>', "Makefile") or die $!;
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
  }

  my $first_interval_end = $last_fret > 4 ? 4 : $last_fret;
  my $draw_fifth_string = $last_fret >= 5 ? 1 : 0;

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
  while ($#circles>0 && $circles[0] > $start_fret)
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

#open_strings    

  $template .= "  %% label nut\n";
  if ($open_strings->{1})
  {
    $template .= "  \\draw[black!50, text=black, fill=blue!15] (Nut-5) circle [radius=.15] node {\\tiny D};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-5) node {\\tiny D};\n";
  }

  if ($open_strings->{2})
  {
    $template .= "  \\draw[black!50, text=black, fill=blue!15] (Nut-4) circle [radius=.15] node {\\tiny B};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-4) node {\\tiny B};\n";
  }

  if ($open_strings->{3})
  {
    $template .= "  \\draw[black!50, text=black, fill=blue!15] (Nut-3) circle [radius=.15] node {\\tiny G};\n";
  }
  else
  {
    $template .= "  \\draw[black!100] (Nut-3) node {\\tiny G};\n";
  }

  if ($open_strings->{4})
  {
    $template .= "  \\draw[black!50, text=black, fill=blue!15] (Nut-2) circle [radius=.15] node {\\tiny D};\n";
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

  {
    my $note = shift @{ $notes };
    my $coordinate = $note->{'coordinate'};
    my $label = $note->{'label'};
    
    $template .= "  \\draw[black!100,fill=$fill!15]            ($coordinate) circle [radius=.15] node {\\tiny $label};\n";
  }

  foreach my $note (@{ $notes })
  { 
    my $coordinate = $note->{'coordinate'};
    my $label = $note->{'label'};
    
    $template .= "  \\draw[black!40, text=black,fill=$fill!15] ($coordinate) circle [radius=.15] node {\\tiny $label};\n";
  }
  
  $template .= "\n";
  $template .= "\\end{tikzpicture}\n";
  $template .= "\\end{document}\n";

  return $template;
}
