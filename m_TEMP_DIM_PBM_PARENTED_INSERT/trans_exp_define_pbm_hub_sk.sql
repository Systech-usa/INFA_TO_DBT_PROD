-- trans_exp_define_pbm_hub_sk
{{ config(materialized='table', tags=['m_temp_dim_pbm_parented_insert']) }}

with stg_sq_gnp2_lib_ods_abforce_pbm as (
    select 
        pbm_cd_hk as i_pbm_cd_hk,
        pbm_cd as i_pbm_cd,
        pbm_lgcy_sfdc_id as i_pbm_lgcy_sfdc_id,
        pbm_lgcy_cd_hk as i_pbm_lgcy_cd_hk
    from {{ ref('stg_sq_gnp2_lib_ods_abforce_pbm') }}
),

trans_exp_define_pbm_hub_sk as (
    select 
        iff(i_pbm_lgcy_sfdc_id is null, i_pbm_cd_hk, i_pbm_lgcy_cd_hk) as o_pbm_hub_hk,
        iff(i_pbm_lgcy_sfdc_id is null, i_pbm_cd, i_pbm_lgcy_sfdc_id) as o_pbm_cd
    from stg_sq_gnp2_lib_ods_abforce_pbm
)

select * from trans_exp_define_pbm_hub_sk
--End-DBShift