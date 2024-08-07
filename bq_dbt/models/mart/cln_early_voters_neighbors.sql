{{
config(
    materialized = 'view',
)
}}

with early_voters as (
    select voterbase_id, st_geogpoint(vb_tsmart_longitude, vb_tsmart_latitude) ev_coordinates 
    from {{ ref('int_ballot_returns') }}
    where early_ballot_method is not null
)
, voters as (
    select voterbase_id, st_geogpoint(vb_tsmart_longitude, vb_tsmart_latitude) voter_coordinates, vb_tsmart_partisan_score, vb_tsmart_midterm_general_turnout_score 
    from {{ ref('int_ballot_returns') }}
    where early_ballot_method is null
)
, voters_joined as (
    select
        ev.voterbase_id early_voter,
        neighbors.voterbase_id nearby_neighbor, 
        neighbors.vb_tsmart_partisan_score,
        round(
            st_distance(ev_coordinates, voter_coordinates), 2) nearby_voter_distance
    from early_voters ev
    cross join voters neighbors
)
select
    early_voter,
    array_agg(
        json_object(
            'nearby_neighbor', nearby_neighbor,
            'partisan_score', vb_tsmart_partisan_score,
            'distance', nearby_voter_distance) order by nearby_voter_distance asc) neighbor_voters
from voters_joined
group by 1