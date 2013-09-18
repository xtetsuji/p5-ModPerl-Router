package ModPerl::Router;

use strict;
use warnings;

use Router::Simple;

sub import {
    my $pkg = shift;
    my @args = @_;
    my $callpkg = caller(0);

    # sub handler definition
    require Apache2::RequestRec;
    require Apache2::RequestUtil;
    require APR::Table;

    my $router = Router::Simple->new();

    no strict 'refs';
    *{"$callpkg\::handler"} = \&import_handler;
    ${"$callpkg\::ROUTER"}  = $router;
    for my $method (qw(head get post put del any)) {
        *{"$callpkg\::$method"} = sub {
            my ($url, $handler) = @_;
            if ( $method ne 'any' ) {
                $router->connect($url, { callback_handler => $handler }, { method => $method } );
            }
            else {
                $router->connect($url, { callback_handler => $handler } );
            }
        };
    }
}

# called package's "handler" method.
sub import_handler : method {
    my $class = shift;
    my $r = shift;

    # fake PSGI environment necessary on Router::Simple.
    my $env = {
        HTTP_HOST      => $r->hostname,
        REQUEST_METHOD => $r->method,
        PATH_INFO      => $r->path_info,
        HTTP_REFERER   => scalar $r->headers_in->get('Referer'),
    };
    my $router = do {
        no strict 'refs';
        ${"$class\::ROUTER"};
    };
    if ( my $match = $router->match($env) ) {
        my $handler = delete $match->{callback_handler};
        $r->pnotes->set( match => $match );
        return $handler->($r);
    }

    ### is routing not found?
    #require Apache2::Const;
    #Apache2::Const->import( -compile => qw(HTTP_NOT_FOUND) );
    #return Apache2::Const::HTTP_NOT_FOUND;

    return 404; # loose saying.
}

1;

=pod

=head1 NAME

ModPerl::Router - mod_perl2 HTTP handler router system.

=head1 SYNOPSIS

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

=head1 METHODS

=head2 head, get, put, post, del

 head URL_PATTERN, THIS_HANDLER;
 get  URL_PATTERN, THIS_HANDLER;
 put  URL_PATTERN, THIS_HANDLER;
 post URL_PATTERN, THIS_HANDLER;
 del  URL_PATTERN, THIS_HANDLER;

C<URL_PATTERN> is L<Router::Simple> syntax.

C<THIS_HANDLER> is handler that its pattern is matched.
THIS_HANDLER is non-named subroutine and given L<Apache2::RequestRec>
object as 1st argument.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by OGATA Tetsuji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
