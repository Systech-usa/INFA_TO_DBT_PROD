-- trans_exp_lkp_trans_curr_cd.sql
{{ config(materialized='table', tags=["m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK"]) }}

with int_mplt_valdt_co_cd_pdo as (
    select * from {{ ref('int_mplt_valdt_co_cd_pdo') }}
),

trans_exptranscode as (
    select * from {{ ref('trans_exptranscode') }}
),

stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins as (
    select * from {{ ref('stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins') }}
),

trans_exp_lkp_trans_curr_cd as (
    select 
        mplt_valdt_co_cd.out_rol_plyr_anchr_id as in_rol_plyr_anchr_id,
        mplt_valdt_co_cd.out_extl_org_opert_co_cd as out_company_nbr,
        mplt_valdt_co_cd.out_ctry_cd as out_ctry_cd,
        mplt_valdt_co_cd.out_dlr_nbr as out_dlr_nbr,
        mplt_valdt_co_cd.out_contr_typ_cd as out_contr_typ_cd,
        mplt_valdt_co_cd.out_pol_purp_typ_cd as out_pol_purp_typ_cd,
        exptranscode.rol_plyr_anchr_id as rol_plyr_anchr_id,
        'NA' as in_curr_cd,
        -1 as in_cmpny_nbr_role_plyr_anchr_id,
        mplt_valdt_co_cd.rol_plyr_anchr_id1 as rol_plyr_anchr_id1,
        sq_ctrl_uubvi_elim_work_init_gpng_finc_ins.sale_dt as out_pol_eff_dt,
        mplt_valdt_co_cd.change_rec_flag1 as change_rec_flag1
    from int_mplt_valdt_co_cd_pdo mplt_valdt_co_cd
    left join trans_exptranscode exptranscode
      on mplt_valdt_co_cd.out_dlr_nbr = exptranscode.dlr_nbr
     and mplt_valdt_co_cd.out_contr_typ_cd = exptranscode.contr_typ_cd
     and mplt_valdt_co_cd.out_pol_purp_typ_cd = exptranscode.pol_purp_typ_cd
    left join stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins sq_ctrl_uubvi_elim_work_init_gpng_finc_ins
      on exptranscode.dlr_nbr = sq_ctrl_uubvi_elim_work_init_gpng_finc_ins.dlr_nbr
     and exptranscode.contr_typ_cd = sq_ctrl_uubvi_elim_work_init_gpng_finc_ins.contr_typ_cd
     and exptranscode.pol_purp_typ_cd = sq_ctrl_uubvi_elim_work_init_gpng_finc_ins.pol_purp_typ_cd
)

select * from trans_exp_lkp_trans_curr_cd

--End-DBShift