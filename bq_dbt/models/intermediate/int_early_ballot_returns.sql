with source as (
    select * from {{ ref('int_voter_base')}}
    where early_ballot_method is not null
) 
select
    voterbase_id early_voter_id,
    st_geogpoint(vb_tsmart_longitude, vb_tsmart_latitude) early_voter_coordinates,
    early_ballot_method,
    vb_tsmart_partisan_score
from source