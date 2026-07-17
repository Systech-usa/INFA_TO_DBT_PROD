-- trans_exptrans
{{ config(materialized='view', tags=['m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK']) }}

with int_mplt_valdt_curr_cd_pdo as (
    select * from {{ ref('int_mplt_valdt_curr_cd_pdo') }}
),

stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins as (
    select * from {{ ref('stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins') }}
),

trans_exptrans as (
    select 
        -- join key pass-through
        mplt.__row_id,

        -- out_fm_agmt_id
        mplt.out_dlr_nbr || mplt.out_contr_typ_cd as out_fm_agmt_id,

        -- out_ctry_cd
        iff(mplt.out_ctry_cd is null or mplt.out_ctry_cd = '', '          ', mplt.out_ctry_cd) as out_ctry_cd,

        -- out_change_rec
        1 as out_change_rec, -- iff(in_dlr_nbr != v_dlr_nbr_prev or in_contr_typ_cd != v_contr_typ_cd or in_pol_purp_typ_cd != v_pol_purp_typ_cd_prev, 1, 0)

        -- out_pol_purp_typ_cd
        mplt.out_pol_purp_typ_id as out_pol_purp_typ_cd,

        -- rol_plyr_anchr_id
        mplt.rol_plyr_anchr_id1 as rol_plyr_anchr_id,

        -- finc_servs_rol_id
        null::bigint as finc_servs_rol_id,

        -- delr_contr_typ_id
        null::bigint as delr_contr_typ_id,

        -- cml_agmt_id
        null::bigint as cml_agmt_id,

        -- agmt_id
        sq.seq_wrk_agmt_anchr_id as agmt_id,

        -- out_agmt_anchr_id
        sq.out_agmt_anchr_id as out_agmt_anchr_id,

        -- change_rec_flag1
        mplt.change_rec_flag1 as change_rec_flag1

    from int_mplt_valdt_curr_cd_pdo mplt
    left join stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins sq 
        on mplt.__row_id = sq.__row_id
)

select * from trans_exptrans
--End-DBShift