package Perl6::Bible;
use 5.000;
use File::Spec;

$Perl6::Bible::VERSION = '0.32';

sub new {
    my $class = shift;
    bless({@_}, $class);
}

sub process {
    my $self = shift;
    my ($args, @values) = $self->get_opts(@_);
    $self->usage, return
      unless $self->validate_args($args);
    $self->help, return
      if $args->{-h} ||
         $args->{'--help'};
    $self->version, return
      if $args->{-v} ||
         $args->{'--version'};
    $self->contents, return
      if $args->{-c} ||
         $args->{'--contents'};
    $self->perldoc($args, @values);
}

sub get_opts {
    my $self = shift;
    my ($args, @values) = ({});
    for (@_) {
        $args->{$_}++, next if /^\-/;
        push @values, $_;
    }
    return ($args, @values);
}

sub validate_args {
    my $self = shift;
    my $args = shift;
    for (keys %$args) {
        return unless /^(
            -h | --help |
            -v | --version |
            -c | --contents |
            -t | -u | -m | -T
        )$/x;
    }
    return 1;
}

sub normalize_name {
    my $self = shift;
    my $id   = uc(shift);
    $id =~ s/^(\d+)$/sprintf('S%02s', $1)/eg;
    return $id;
}

sub get_raw {
    my $self = shift;
    my $id = shift
      or die "Missing argument for get_raw";
    my $document = $self->normalize_name($id);
    $document .= '.pod';
    $document = File::Spec->catfile("Perl6", "Bible", $document);
    my $document_path = '';
    for my $path (@INC) {
        my $file_path = File::Spec->catfile($path, $document);
        next unless -e $file_path;
        $document_path = $file_path;
        last;
    }
    die "No documentation for $id"
      unless $document_path;
    open DOC, $document_path;
    my $text = do {local $/, <DOC>};
    close DOC;
    return $text;
}

sub perldoc {
    my $self = shift;
    my $args = shift;
    my $document = "Perl6::Bible";
    $document .= '::' . $self->normalize_name(shift)
      if @_;
    my $options = join ' ', grep { defined $args->{$_} } qw(-t -u -m -T);
    $options ||= '';
    my $command = "perldoc $options $document";
    $command .= " 2> /dev/null"
      unless $^O eq 'MSWin32';
    system $command;
}

sub usage {
    print <<_;
Usage: p6bible [options] [document-id]
Try `p6bible --help` for more information.
_
}

sub help {
    print <<_;
Usage: p6bible [options] [document-id]
View the Perl 6 Canon.

Possible values for document-id are:
  A01 - A33  (Perl 6 Apocalypses)
  E01 - E33  (Perl 6 Exegeses)
  S01 - S33  (Perl 6 Synopses)

Valid options:
  -h,  --help       Print this help screen
  -v,  --version    Print the publish date of this Perl6::Bible version
  -c,  --contents   Show the current table of contents

Additionally, the perldoc -t, -u, -m, or -T can be used to format the output.
_
}

sub version {
    print <<_;
This is the Perl 6 Canon as of December 22, 2005
(bundled in Perl6-Bible-$VERSION)
_
}

sub contents {
    my $module = __PACKAGE__;
    $module =~ s/::/\//g;
    $module .= '.pm';
    my $path = $INC{$module};
    open MOD, $path
      or die "Can't open $path for input";
    my $text = do {local $/; <MOD>};
    close MOD;
    $text =~ s/
        ^.*
        =head2 \s* (?=Contents)
    //sx or die "Can't find contents\n";
    $text =~ s/
        =head1 .*
    //sx or die "Can't find contents\n";
    $text =~ s/\A\s*\n//;
    $text =~ s/\s*\z/\n/;
    $text =~ s/^ {17}.*\n//mg;
    print $text;
}

__DATA__

=head1 NAME

Perl6::Bible - Perl 6 Design Documentations

=head1 VERSION

This document describes version 0.32 of Perl6::Bible, released
December 23, 2007.

=head1 SYNOPSIS

    > p6bible -h     # Show p6bible help
    > p6bible -c     # Show Table of Contents
    > p6bible s05    # Browse Synopsis 05
    > p6bible 5      # Same thing

=head1 DESCRIPTION

This Perl module distribution contains all the latest Perl 6
documentation and a utility called C<p6bible> for viewing it.

Below is the list of documents that are currently available; a number
in the column indicates the document is currently available. An
asterisk next to a number means that the document is an unofficial
draft written by a member of the Perl community but not approved by
the Perl 6 Design Team.

=head2 Contents

  S01  The Ugly, the Bad, and the Good   (A01)
  S02  Bits and Pieces                   (A02) (E02)
  S03  Operators                         (A03) (E03)
  S04  Syntax                            (A04) (E04)
  S05  Pattern Matching                  (A05) (E05)
  S06  Subroutines                       (A06) (E06)
       Formats                                 (E07)
       References
  S09  Data Structures
  S10  Packages
  S11  Modules
  S12  Objects                           (A12)
  S13  Overloading
       Tied Variables
       Unicode
       Interprocess Communication
  S16* IPC / IO / Signals  
  S17* Threads
       Compiling
       The Command-Line Interface
       The Perl Debugger
       Internals and Externals
  S22* CPAN
       Security
       Common Practices
       Portable Perl
  S26* Perl Documentation
  S27* Perl Culture
  S28* Special Names
  S29* Functions


=head1 NOTES

Perl 6 developers are refactoring relevant introductions,
tutorials, specifications into the L<Perl6::Doc> namespace;
expect to see this module subsumed by it in the near future.

If you are interested in helping out the documentation project,
please contact us on C<irc.freenode.net #perl6> or
C<perl6-compiler@perl.org>.

=head2 Synopses

The document codes C<S01 - S33> refer to the Perl 6 Synopses.

The Synopsis documents are to be taken as the formal specification for
Perl 6 implementations, while still being reference documentation for
Perl 6, like _Programming Perl_ is for Perl 5.

Note that while these documents are considered "formal specifications",
they are still being subjected to the rigours of cross-examination
through implementation.

In other words, they may change slightly or radically. But the
expectation is that they are "very close" to the final shape of Perl 6.

=head2 Apocalypses (outdated)

The document codes C<A01 - A33> refer to the Perl 6 Apocalypses.

Larry Wall started the Apocalypse series as a systematic way of
answering the RFCs (Request For Comments) that started the design
process for Perl 6.  Each Apocalypse corresponds to a chapter in the
book _Programming Perl_, 3rd edition, and addresses the features
relating to that chapter in the book that are likely to change.

Larry addresses each relevant RFC, and gives reasons why he accepted
or rejected various pieces of it.  But each Apocalypse also goes
beyond a simple "yes" and "no" response to attack the roots of the
problems identified in the RFCs.

=head2 Exegeses (outdated)

The document codes C<E01 - E33> refer to the Perl 6 Exegeses.

Damian Conway's Exegeses are extensions of each Apocalypse.  Each
Exegesis is built around a practical code example that applies and
explains the new ideas.

=head1 METHODS

Perl6::Bible provides a class method to get the raw text of a document:

    my $text = Perl6::Bible->get_raw('s01');

=head1 SCRIBES

* Brian Ingerson <ingy@cpan.org>

* Sam Vilain <samv@cpan.org>

* Audrey Tang <autrijus@cpan.org>

* Herbert Breunung <lichtkind@cpan.org>

=head1 COPYRIGHT

This Copyright applies only to the C<Perl6::Bible> Perl software
distribution, not the documents bundled within.

A couple of paragraphs from _Perl 6 Essentials_ were used for the
overview. Most docs are from the official Perl development site. 

http://dev.perl.org/perl6/

All draft Synopses were taken out of the Pugs SVN repository.

Copyright (c) 2005. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
