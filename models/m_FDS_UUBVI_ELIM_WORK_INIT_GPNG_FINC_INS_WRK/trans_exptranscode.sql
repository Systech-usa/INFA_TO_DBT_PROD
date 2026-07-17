{{ config(materialized='table', tags=['m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK']) }}

-- trans_exptranscode.sql
with sq_ctrl_uubvi_elim_work_init_gpng_finc_ins as (
    select * from {{ ref('stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins') }}
),

trans_exptranscode as (
    select
        sq.opert_co_cd as out_opert_co_cd,
        sq.ctry_cd as ctry_cd,
        sq.dlr_nbr as dlr_nbr,
        sq.contr_typ_cd as contr_typ_cd,
        sq.pol_purp_typ_cd as pol_purp_typ_cd,
        sq.v_elim_co_id as v_uubvi_co_id,
        sq.rol_plyr_anchr_id as rol_plyr_anchr_id,
        sq.change_rec_flag as change_rec_flag
    from sq_ctrl_uubvi_elim_work_init_gpng_finc_ins sq
)

select * from trans_exptranscode

--End-DBShift