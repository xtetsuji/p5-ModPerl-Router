# NAME

ModPerl::Router - mod\_perl2 HTTP handler router system.

# SYNOPSIS

    use strict;
    use warnings;
    use Apache2::RequestRec  ();
    use Apache2::RequestUtil ();
    #use Apache2::Response    (); # if you need.
    use ModPerl::Router; # import "head", "get", "put", "post", "del" methods.

    get '/user/:username' => sub {
        my $r = shift;
        my $match = $r->pnotes->get('match');
        my $username = $match->{username};
        ...;
    };

    post '/user/' => sub {
        my $r = shift;
        ...;
    };

# METHODS

## head, get, put, post, del

    head URL_PATTERN, THIS_HANDLER;
    get  URL_PATTERN, THIS_HANDLER;
    put  URL_PATTERN, THIS_HANDLER;
    post URL_PATTERN, THIS_HANDLER;
    del  URL_PATTERN, THIS_HANDLER;

`URL_PATTERN` is [Router::Simple](http://search.cpan.org/perldoc?Router::Simple) syntax.

`THIS_HANDLER` is handler that its pattern is matched.
THIS\_HANDLER is non-named subroutine and given [Apache2::RequestRec](http://search.cpan.org/perldoc?Apache2::RequestRec)
object as 1st argument.

# COPYRIGHT AND LICENSE

Copyright (C) 2013 by OGATA Tetsuji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
