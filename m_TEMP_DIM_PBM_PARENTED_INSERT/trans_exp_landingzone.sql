-- trans_exp_landingzone
{{ config(materialized='table', tags=["m_TEMP_DIM_PBM_PARENTED_INSERT"]) }}

with int_lkp_dim_pbm_parented_on_pbm_hub_sk as (
    select 
        ods_pbm_cd_hk,
        ods_pbm_nm,
        ods_pbm_cd,
        ods_pbm_leg_nm,
        ods_batch_id,
        ods_batch_row_id,
        ods_crt_tmsp,
        pbm_hub_sk,
        pbm_nm,
        pbm_leg_nm,
        crt_batch_id,
        crt_batch_row_id,
        crt_tmsp,
        pbm_hub_hk as o_pbm_hub_hk,
        o_pbm_cd
    from {{ ref('int_lkp_dim_pbm_parented_on_pbm_hub_sk') }}
),

trans_exp_landingzone as (
    select 
        ods_pbm_cd_hk,
        ods_pbm_nm,
        ods_pbm_cd,
        ods_pbm_leg_nm,
        pbm_hub_sk,
        pbm_nm,
        pbm_leg_nm,
        iff(pbm_hub_sk is null, ods_batch_id, crt_batch_id) as o_crt_batchid,
        iff(pbm_hub_sk is null, ods_batch_row_id, crt_batch_row_id) as o_crt_batch_row_id,
        current_timestamp() as o_crt_tmsp,
        iff(pbm_hub_sk is null, null, crt_batch_id) as o_upd_batchid,
        iff(pbm_hub_sk is null, null, crt_batch_row_id) as o_upd_batch_row_id,
        iff(pbm_hub_sk is null, null, crt_tmsp) as o_upd_tmsp,
        iff(pbm_hub_sk is null, null, 'Changed at Source') as o_upd_user,
        o_pbm_hub_hk,
        o_pbm_cd
    from int_lkp_dim_pbm_parented_on_pbm_hub_sk
)

select 
    ods_pbm_cd_hk,
    ods_pbm_nm,
    ods_pbm_cd,
    ods_pbm_leg_nm,
    pbm_hub_sk,
    pbm_nm,
    pbm_leg_nm,
    o_crt_batchid,
    o_crt_batch_row_id,
    o_crt_tmsp,
    o_upd_batchid,
    o_upd_batch_row_id,
    o_upd_tmsp,
    o_upd_user,
    o_pbm_hub_hk,
    o_pbm_cd
from trans_exp_landingzone

--End-DBShift