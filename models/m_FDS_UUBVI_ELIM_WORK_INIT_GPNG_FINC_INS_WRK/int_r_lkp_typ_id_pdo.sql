-- int_r_lkp_typ_id_pdo.sql
{{ config(materialized='table', tags=["m_fds_uubvi_elim_work_init_gpng_finc_ins_wrk"]) }}

with asq_typ as (
    -- sql override
    select 
        a.typ_id as typ_id, 
        a.nm as nm 
    from {{ source('dbaall', 'TYP') }} a
),

lkp_typ_qualify as (
    select
        typ_id,
        nm
    from asq_typ
    qualify row_number() over (partition by upper(nm) order by nm) = 1
),

trans_exp_format_cd as (
    -- reference upstream transformation
    select 
        out_typ_id as in_nm,
        out_valdt_opert_co_cd,
        ctry_cd,
        in_dlr_nbr,
        in_contr_typ_cd,
        in_pol_purp_typ_cd,
        in_extl_org_opert_co_cd,
        rol_plyr_anchr_id,
        change_rec_flag
    from {{ ref('trans_exp_format_cd') }}
),

int_r_lkp_typ_id_pdo as (
    -- perform the connected lookup
    select
        b.typ_id,
        b.nm,
        a.in_nm,
        a.out_valdt_opert_co_cd,
        a.ctry_cd,
        a.in_dlr_nbr,
        a.in_contr_typ_cd,
        a.in_pol_purp_typ_cd,
        a.in_extl_org_opert_co_cd,
        a.rol_plyr_anchr_id,
        a.change_rec_flag
    from trans_exp_format_cd a
    left join lkp_typ_qualify b
        on upper(a.in_nm) = upper(b.nm)
)

select 
    typ_id,
    nm,
    in_nm,
    out_valdt_opert_co_cd,
    ctry_cd,
    in_dlr_nbr,
    in_contr_typ_cd,
    in_pol_purp_typ_cd,
    in_extl_org_opert_co_cd,
    rol_plyr_anchr_id,
    change_rec_flag
from int_r_lkp_typ_id_pdo

--End-DBShift