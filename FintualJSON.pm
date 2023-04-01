#!/usr/bin/perl
#
#    The code is developed by Murugan Muruganandam, Krishnadas K to
#    retrieve stock information from Fintual.cl through json calls
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
#    02111-1307, USA

package Finance::Quote::FintualJSON;

require 5.005;

use strict;
use JSON qw( decode_json );
use vars qw($VERSION $YIND_URL_HEAD $YIND_URL_TAIL);
use LWP::UserAgent;
use HTTP::Request::Common;
use HTML::TableExtract;
use Time::Piece; 
#use JSON::Parse 'parse_json';


our $VERSION = '1.54'; # VERSION

$YIND_URL_HEAD = 'https://fintual.cl/api/real_assets/';
$YIND_URL_TAIL = '';

sub methods {
    return ( fintual_json => \&fintual_json,
    );
}
{
    my @labels = qw/name last date isodate volume currency method exchange type
        div_yield eps pe year_range open high low close/;

    sub labels {
        return ( fintual_json => \@labels,
        );
    }
}

sub fintual_json {

	#local vatiables
    my $quoter = shift;
	my %info;
	my @stocks = @_;
	my $stocks;
    my $inputdata;

	foreach $stocks (@stocks) {

        #Split the input string using "-"
        my @inputsplit = split /-/, $stocks;
        my $realassetid = $inputsplit[0];
        my $currency = $inputsplit[1];

		#Request       
		my $UserAgent = new LWP::UserAgent;
		my $url   = $YIND_URL_HEAD . $realassetid . $YIND_URL_TAIL;

		my $Request= new HTTP::Request('GET',$url);
		$UserAgent->default_header('Accept',  'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8');
		$UserAgent->default_header('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:82.0) Gecko/20100101 Firefox/82.0');

		# Response
		my $Response= $UserAgent->request($Request);

		# Response Details
		my $code    = $Response->code;
		my $desc    = HTTP::Status::status_message($code);
		my $headers = $Response->headers_as_string;
		my $contenttype = $Response->content_type;
		my $body    = $Response->content;

		if ( $code == 200 ) {
			
			my $json_data = JSON::decode_json $body;
			my $id = $json_data->{'data'}{'id'};
			my $type = $json_data->{'data'}{'type'};
			my $startdate = $json_data->{'data'}{'attributes'}{'start_date'};
			my $name = $json_data->{'data'}{'attributes'}{'name'};
			my $symbol = $json_data->{'data'}{'attributes'}{'symbol'};
			my $serie = $json_data->{'data'}{'attributes'}{'serie'};
			my $netassetvalue = $json_data->{'data'}{'attributes'}{'last_day'}{'net_asset_value'};
			my $date = $json_data->{'data'}{'attributes'}{'last_day'}{'date'};

			$info{ $stocks, "success" } = 1;
			$info{ $stocks, "symbol" } = $symbol;
			$info{ $stocks, "exchange" } = "Sourced from fintual.cl (as JSON)";
			$info{ $stocks, "method" } = "fintual_json";
			$info{ $stocks, "name" }   = $name; 
			$info{ $stocks, "currency"} = $currency;  
			$info{ $stocks, "nav" }   = $netassetvalue;
			$info{ $stocks, "serie" }   = $serie;
			$info{ $stocks, "type" }   = $type;
			$info{ $stocks, "isodate" }   = $date;

			my @dt = split /-/, $date;
            my $localdt = $dt[2] . '/' . $dt[1] . '/' . $dt[0];
			$info{ $stocks, "date" } = $localdt;
            
            my $my_date = $dt[2] . '.' . $dt[1] . '.' . $dt[0];
            $quoter->store_date( \%info, $stocks, { eurodate => $my_date } );


		}else{
			$info{ $stocks, "success" } = 0;
            $info{ $stocks, "errormsg" } =
                "Error retrieving quote for $stocks. Attempt to fetch the URL $url resulted in HTTP response $code ($desc)";
		}
	}
	
	return wantarray() ? %info : \%info;
};

1;

=head1 NAME

Finance::Quote::FintualJSON - Obtain quotes from Fintual.cl through JSON call

=head1 SYNOPSIS

    use Finance::Quote;

    $q = Finance::Quote->new;

    %info = Finance::Quote->fetch("fintual_json","11100-CLP");

=head1 DESCRIPTION

This module fetches information from Fintual.cl as JSON
This module provides the "fintual_json" fetch method.
Currency code is not returned by the Fintual.cl webservice 
Currency is passed as part of the stocks 
eg:- 11100-CLP


=head1 LABELS RETURNED

The following labels may be returned by Finance::Quote::FintualJSON :
name, serie, nav, isodate, currency, method, exchange, type, symbol

=head1 SEE ALSO

=cut