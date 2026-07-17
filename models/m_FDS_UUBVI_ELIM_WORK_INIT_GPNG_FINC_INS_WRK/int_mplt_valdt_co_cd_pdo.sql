-- int_mplt_valdt_co_cd_pdo.sql
{{ config(materialized='table', tags=["m_fds_uubvi_elim_work_init_gpng_finc_ins_wrk"]) }}

with trans_exptranscode as (
    select 
        out_opert_co_cd as in_opert_co_cd,
        ctry_cd,
        dlr_nbr as in_dlr_nbr,
        contr_typ_cd as in_contr_typ_cd,
        pol_purp_typ_cd as in_pol_purp_typ_cd,
        null as in_extl_org_opert_co_cd,
        rol_plyr_anchr_id,
        change_rec_flag
    from {{ ref('trans_exptranscode') }}
),

int_r_lkp_typ_id_pdo as (
    -- reusable lookup: r_lkp_typ_id
    select 
        typ_id, 
        nm 
    from {{ ref('int_r_lkp_typ_id_pdo') }}
),

lkp_extl_org as (
    -- lookup: lkp_extl_org
    select 
        a.rol_plyr_anchr_id as rol_plyr_anchr_id,
        a.opert_co_cd as opert_co_cd,
        a.typ_id as typ_id 
    from {{ source('dbaall', 'EXTL_ORG') }} a 
    where a.actv_rec_ind = 'Y'
),

exp_format_cd as (
    -- expression: exp_format_cd
    select
        in_opert_co_cd as in_opert_co_cd,
        'COMPANY' as out_typ_id,
        case 
            when in_opert_co_cd is null or in_opert_co_cd = '' then 'null' 
            else in_opert_co_cd 
        end as out_valdt_opert_co_cd,
        ctry_cd,
        in_dlr_nbr,
        in_contr_typ_cd,
        in_pol_purp_typ_cd,
        in_extl_org_opert_co_cd,
        rol_plyr_anchr_id,
        change_rec_flag
    from trans_exptranscode
),

exp_evaluate_lkp as (
    -- expression: exp_evaluate_lkp integrating lookups
    select
        l2.rol_plyr_anchr_id as lkp_rol_plyr_anchr_id,
        a.out_valdt_opert_co_cd as io_opert_co_cd,
        l1.typ_id as io_typ_id,
        case 
            when l2.rol_plyr_anchr_id is null then 0 
            else 1 
        end as out_validflag,
        a.ctry_cd,
        a.in_dlr_nbr,
        a.in_contr_typ_cd,
        a.in_pol_purp_typ_cd,
        a.in_extl_org_opert_co_cd,
        a.rol_plyr_anchr_id,
        a.change_rec_flag
    from exp_format_cd a
    left join int_r_lkp_typ_id_pdo l1
        on l1.nm = a.out_typ_id
    left join lkp_extl_org l2
        on l2.opert_co_cd = a.out_valdt_opert_co_cd 
        and l2.typ_id = l1.typ_id
),

int_mplt_valdt_co_cd_pdo as (
    select
        lkp_rol_plyr_anchr_id as out_rol_plyr_anchr_id,
        io_opert_co_cd as out_opert_co_cd,
        io_typ_id as out_typ_id,
        out_validflag as out_validflag,
        ctry_cd as out_ctry_cd,
        in_dlr_nbr as out_dlr_nbr,
        in_contr_typ_cd as out_contr_typ_cd,
        in_pol_purp_typ_cd as out_pol_purp_typ_cd,
        in_extl_org_opert_co_cd as out_extl_org_opert_co_cd,
        rol_plyr_anchr_id as rol_plyr_anchr_id1,
        change_rec_flag as change_rec_flag1
    from exp_evaluate_lkp
)

select * from int_mplt_valdt_co_cd_pdo

--End-DBShift