#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';
use lib qw( t/lib );

use Test::More 'no_plan';
use JSON::XS;

# application loads
BEGIN {
    $ENV{AUTOCRUD_TESTING} = 1;
    use_ok "Test::WWW::Mechanize::Catalyst" => "TestApp"
}
my $mech = Test::WWW::Mechanize::Catalyst->new;

# get metadata for the artist table
$mech->get_ok( '/site/default/schema/dbic/source/artist/dumpmeta', 'Get artist autocrud metadata' );
is( $mech->ct, 'application/json', 'Metadata content type' );

my $response = JSON::XS::decode_json( $mech->content );

#use Data::Dumper;
#print STDERR Dumper $response;

my $expected = {
    'table_info' => {
        'AutoCRUD::DBIC::Artist' => {
            'mfks'    => { 'albums' => 'Albums' },
            'pk'      => 'id',
            'moniker' => 'Artist',
            'col_order' => [ 'id', 'forename', 'surname', 'pseudonym', 'born' ],
            'path'  => 'artist',
            'title' => 'Artist',
            'cols'  => {
                'pseudonym' => {
                    'required' => 1,
                    'editable' => 1,
                    'heading'  => 'Pseudonym'
                },
                'forename' => {
                    'required' => 1,
                    'editable' => 1,
                    'heading'  => 'Forename'
                },
                'born' => {
                    'required'    => 1,
                    'extjs_xtype' => 'datefield',
                    'editable'    => 1,
                    'heading'     => 'Born'
                },
                'id' => {
                    'required'    => 1,
                    'extjs_xtype' => 'numberfield',
                    'editable'    => 0,
                    'heading'     => 'Id'
                },
                'surname' => {
                    'required' => 1,
                    'editable' => 1,
                    'heading'  => 'Surname'
                }
            }
        }
    },
    'model'      => 'AutoCRUD::DBIC::Artist',
    'table2path' => {
        'dbic' => {
            'Album'        => 'album',
            'Copyright'    => 'copyright',
            'Sleeve Notes' => 'sleeve_notes',
            'Track'        => 'track',
            'Artist'       => 'artist'
        }
    },
    'tab_order' => { 'AutoCRUD::DBIC::Artist' => 1 },
    'main'      => {
        'mfks'    => { 'albums' => 'Albums' },
        'pk'      => 'id',
        'moniker' => 'Artist',
        'col_order' => [ 'id', 'forename', 'surname', 'pseudonym', 'born' ],
        'path'      => 'artist',
        'title'     => 'Artist',
        'cols'      => {
            'pseudonym' => {
                'required' => 1,
                'editable' => 1,
                'heading'  => 'Pseudonym'
            },
            'forename' => {
                'required' => 1,
                'editable' => 1,
                'heading'  => 'Forename'
            },
            'born' => {
                'required'    => 1,
                'extjs_xtype' => 'datefield',
                'editable'    => 1,
                'heading'     => 'Born'
            },
            'id' => {
                'required'    => 1,
                'extjs_xtype' => 'numberfield',
                'editable'    => 0,
                'heading'     => 'Id'
            },
            'surname' => {
                'required' => 1,
                'editable' => 1,
                'heading'  => 'Surname'
            }
        }
    },
    'editable' => {
        'dbic' => {
            'sleeve_notes' => 1,
            'artist'       => 1,
            'album'        => 1,
            'track'        => 1,
            'copyright'    => 1,
        }
    },
    'path2model' => {
        'dbic' => {
            'sleeve_notes' => 'AutoCRUD::DBIC::SleeveNotes',
            'artist'       => 'AutoCRUD::DBIC::Artist',
            'album'        => 'AutoCRUD::DBIC::Album',
            'track'        => 'AutoCRUD::DBIC::Track',
            'copyright'    => 'AutoCRUD::DBIC::Copyright'
        }
    },
    'db2path'      => { 'Dbic' => 'dbic' },
    'dbpath2model' => { 'dbic' => 'AutoCRUD::DBIC' },

};

is_deeply( $response->{cpac}, $expected, 'Metadata is as we expect' );

#warn $mech->content;
__END__
