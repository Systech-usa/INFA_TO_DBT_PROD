{{ config(materialized='table', tags=['m_TEMP_DIM_PBM_PARENTED_INSERT']) }}

-- trans_exp_landingzone.sql
with lkp_dim_pbm_parented_on_pbm_hub_sk as (
    select * from {{ ref('int_lkp_dim_pbm_parented_on_pbm_hub_sk') }}
),

trans_exp_landingzone as (
    select
        sq.ods_pbm_cd_hk as ods_pbm_cd_hk,
        sq.ods_pbm_nm as ods_pbm_nm,
        sq.ods_pbm_cd as ods_pbm_cd,
        sq.ods_pbm_leg_nm as ods_pbm_leg_nm,
        sq.pbm_hub_sk as pbm_hub_sk,
        sq.pbm_nm as pbm_nm,
        sq.pbm_leg_nm as pbm_leg_nm,
        decode(pbm_hub_sk,NULL,ods_batch_id,crt_batch_id) as o_crt_batchid,
        decode(pbm_hub_sk,NULL,ods_batch_row_id,crt_batch_row_id) as o_crt_batch_row_id,
        current_timestamp() as o_crt_tmsp,
        decode(pbm_hub_sk,NULL,NULL,crt_batch_id) as o_upd_batchid,
        decode(pbm_hub_sk,NULL,NULL,crt_batch_row_id) as o_upd_batch_row_id,
        decode(pbm_hub_sk,NULL,NULL,crt_tmsp) as o_upd_tmsp,
        decode(pbm_hub_sk,NULL,NULL,'Changed at Source') as o_upd_user,
        sq.o_pbm_hub_hk as o_pbm_hub_hk,
        sq.o_pbm_cd as o_pbm_cd
    from lkp_dim_pbm_parented_on_pbm_hub_sk sq
)

select * from trans_exp_landingzone

--End-DBShift