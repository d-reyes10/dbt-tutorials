with source as (
  select * from `prod-generation-data-176bffe6.GA_targetsmart.voter_base`
)

SELECT 
  timestamp(created_at) utc_created_at, 
  timestamp(updated_at) utc_updated_at,
  cast(vb_tsmart_cd as string) vb_tsmart_cd,
  cast(vb_vf_cd as string) vb_vf_cd,
  cast(vb_voterbase_age as int64) vb_voterbase_age
FROM source