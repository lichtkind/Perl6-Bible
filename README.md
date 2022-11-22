### NAME

    Perl6-Bible - access to Unifont truetype file

### VERSION

    0.38

[on CPAN](https://metacpan.org/pod/Perl6-Bible)

    This is the landing page for the user documentation.
    There is also a download link on the left side under "Tools".


### BUILDING

    The git repository contains much more than the software package itself.
    If you check out sources here, you have to build the package yourself.
    In order to do that you need perl and the module Dist::Zilla.

    cpan install Dist::Zilla   
        or
    cpanm Dist::Zilla


    Then you have to check which further the Dist::Zilla plugins you miss:

    dzil authordeps

    and pipe them into your preferred installer:

    dzil authordeps | cpanm


    Than you can build a release yourself:

    dzil build

    Which gives you basically the same tgz file as under the download link
    from CPAN (as describes under HOME), just with more up to date
    (and maybe buggy) sources. Don't forget to:

    dzil clean


### INSTALLING

    Once you downloaded or created a build, you unzip it and do the usual:

        perl Makefile.PL
        make
        make test
        make install

    This should install to your site_perl directory.


### PREREQUISITES

    perl 5

[CHANGES](https://github.com/lichtkind/Perl6-Bible/blob/main/Changes)

[CONTRIBUTING](https://github.com/lichtkind/Perl6-Bible/blob/main/CONTRIBUTING)

### AUTHOR

    - Ingy <ingy@cpan.org>

### MAINTAINER

- Herbert Breunung (lichtkind@cpan.org)


### COPYRIGHT

    Copyright(c) 2007 - 2022 Ingy döt Net

    All rights reserved.  This program is free software; you can
    redistribute it and/or modify it under the same terms as Perl
    itself.

    The included  Unifont (c) by Roman Czyborra and contributors
    is licensed under the OFL (Open Font License) 1.1.
