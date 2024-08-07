with source as (
    select * from {{ ref('int_voter_base')}}
    where early_ballot_method is null
) 
select
    voterbase_id,
    st_geogpoint(vb_tsmart_longitude, vb_tsmart_latitude) voter_coordinates,
    vb_tsmart_partisan_score,
    vb_tsmart_midterm_general_turnout_score
from source