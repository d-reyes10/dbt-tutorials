with source as (
    select * from {{ ref('int_ballot_returns')}}
)
, district_ballot_counts as (
    select
        vb_vf_cd,
        count(voterbase_id) ballot_returns,
        dense_rank() over(order by count(*) desc) district_rank
    from source
    where vb_vf_cd is not null
    group by 1
)

select * from district_ballot_counts