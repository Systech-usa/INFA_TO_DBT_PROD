{{ config(materialized='view', tags=["m_TEMP_DIM_PBM_PARENTED_INSERT"]) }}

-- SQ_GNP2_LIB_ODS_ABFORCE_PBM
with source_data as (
    select
        batch_id,
        batch_row_id,
        crt_tmsp,
        upd_tmsp,
        upd_user,
        row_stat_cd,
        pbm_cd_hk,
        pbm_cd,
        crt_dt,
        lst_mdfd_by_dt,
        pbm_nm,
        pbm_leg_nm,
        pbm_par_co,
        src_crt_tmsp,
        pbm_lgcy_sfdc_id,
        pbm_lgcy_cd_hk
    from {{ source('GNP2ODS', 'ODS_ABFORCE_PBM') }}
    where batch_id='{{ var('BATCH_ID') }}' and row_stat_cd='PASS'
)

select * from source_data

--End-DBShift