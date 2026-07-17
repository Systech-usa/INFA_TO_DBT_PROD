{{ config(materialized='table', tags=["m_TEMP_DIM_PBM_PARENTED_INSERT"]) }}

with exp_landingzone as (
    select * from {{ ref('trans_exp_landingzone') }}
),

int_fltr_transformation as (
    select
        ods_pbm_cd_hk as ods_pbm_cd_hk,
        ods_pbm_nm as ods_pbm_nm,
        ods_pbm_cd as ods_pbm_cd,
        ods_pbm_leg_nm as ods_pbm_leg_nm,
        pbm_hub_sk as pbm_hub_sk,
        pbm_nm as pbm_nm,
        pbm_leg_nm as pbm_leg_nm,
        o_crt_batchid as o_crt_batchid,
        o_crt_batch_row_id as o_crt_batch_row_id,
        o_crt_tmsp as o_crt_tmsp,
        o_upd_batchid as o_upd_batchid,
        o_upd_batch_row_id as o_upd_batch_row_id,
        o_upd_tmsp as o_upd_tmsp,
        o_upd_user as o_upd_user,
        o_pbm_hub_hk as o_pbm_hub_hk,
        o_pbm_cd as o_pbm_cd
    from exp_landingzone
    where pbm_hub_sk is null or (pbm_hub_sk is not null and (iff(ods_pbm_nm is null,' ',ods_pbm_nm) <> iff(pbm_nm is null,' ',pbm_nm) or iff(ods_pbm_leg_nm is null,' ',ods_pbm_leg_nm) <> iff(pbm_leg_nm is null,' ',pbm_leg_nm) ))
)

select * from int_fltr_transformation

--End-DBShift