with source as (
    select * from `prod-generation-data-176bffe6.GA_Distances.GA_Early_Ballot_Returns` 
)

select
    voterbase_id,
    vb_vf_county_name,
    aug_primary_voted_date,
    Method as early_ballot_method
from source