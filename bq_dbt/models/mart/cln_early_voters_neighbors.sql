{{
config(
    materialized = 'table',
)
}}

with early_voters as (
    select * from {{ ref('int_early_ballot_returns')}}
)
, voters as (
    select * from {{ ref('int_non_voters')}}
)
, voters_joined as (
    select
        ev.early_voter_id,
        neighbors.voterbase_id nearby_neighbor, 
        neighbors.vb_tsmart_partisan_score,
        round(
            st_distance(early_voter_coordinates, voter_coordinates), 2) nearby_voter_distance
    from early_voters ev
    join voters neighbors 
        on st_dwithin(early_voter_coordinates, voter_coordinates, 3218.69)
)
select
    early_voter_id,
    array_agg(
        json_object(
            'nearby_neighbor', nearby_neighbor,
            'partisan_score', vb_tsmart_partisan_score,
            'distance', nearby_voter_distance) order by nearby_voter_distance asc) neighbor_voters
from voters_joined
group by 1