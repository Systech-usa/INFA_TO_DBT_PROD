{{ config(materialized='table', tags=['m_FDS_UUBVI_ELIM_WORK_INIT_GPNG_FINC_INS_WRK']) }}

-- trans_exp_find_new.sql
with sq_ctrl_uubvi_elim_work_init_gpng_finc_ins as (
    select * from {{ ref('stg_sq_ctrl_uubvi_elim_work_init_gpng_finc_ins') }}
),

exptrans as (
    select * from {{ ref('trans_exptrans') }}
),

trans_exp_find_new as (
    select
        sq.out_cml_agmt_anchr_id as agmt_anchr_id,
        iff(iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1 AND iff(exptrans.change_rec_flag1!=1 AND iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1, 1, 0)=0, 1,0)

--iff(iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1 AND iff( iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1, 1, 0)=0, 1,0) as newlookuprow,
        iff(iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1 AND iff(exptrans.change_rec_flag1!=1 AND iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1, 1, 0)=1,1,0)

--iff(iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1 AND iff( iff(sq.out_cml_agmt_anchr_id is null OR sq.out_cml_agmt_anchr_id=0, 1, 0)=1, 1, 0)=1,1,0) as new_and_repeat,
        exptrans.rol_plyr_anchr_id as rol_plyr_anchr_id,
        exptrans.finc_servs_rol_id as finc_servs_rol_id,
        exptrans.delr_contr_typ_id as delr_contr_typ_id,
        exptrans.cml_agmt_id as cml_agmt_id,
        exptrans.agmt_id as agmt_id,
        exptrans.out_agmt_anchr_id as out_agmt_anchr_id
    from sq_ctrl_uubvi_elim_work_init_gpng_finc_ins sq
    left join exptrans exptrans
        on sq.seq_wrk_agmt_anchr_id = exptrans.seq_wrk_agmt_anchr_id and sq.out_agmt_anchr_id = exptrans.out_agmt_anchr_id
)

select * from trans_exp_find_new

--End-DBShift