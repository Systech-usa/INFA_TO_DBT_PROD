{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

-- trans_exp_cal_lst_mnth.sql
with agg_last_mnth as (
    select * from {{ ref('int_agg_last_mnth') }}
),

trans_exp_cal_lst_mnth as (
    select
        sq.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        sq.etl_sys_nm as etl_sys_nm,
        sq.out_monthly_date as monthly_date,
        sq.agmt_anchr_id as agmt_anchr_id,
        sq.base_amt as base_amt,
        sq.prem_amt as prem_amt,
        sq.out_added_amt as added_amt,
        ROUND(sq.base_amt - iff(sq.out_added_amt is null,0 , sq.out_added_amt),2) as out_prem_amt,
        sq.eff_md_yr_mo as eff_md_yr_mo,
        sq.pop_info_id as pop_info_id,
        sq.batch_id as batch_id,
        sq.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        sq.comm_amt as comm_amt,
        sq.der_comm_amt as der_comm_amt,
        ROUND(sq.comm_amt - iff(sq.out_comm_added_amt is null,0 , sq.out_comm_added_amt),2) as out_der_comm_amt,
        sq.tran_prem_amt as tran_prem_amt,
        sq.tran_comm_amt as tran_comm_amt,
        ROUND(sq.tran_prem_amt - iff(sq.tran_prem_added_amt is null,0 , sq.tran_prem_added_amt),2) as out_der_tran_prem_amt,
        ROUND(sq.tran_comm_amt - iff(sq.tran_comm_added_amt is null,0 ,sq.tran_comm_added_amt),2) as out_der_tran_comm_amt,
        sq.contr_prem_amt as contr_prem_amt,
        ROUND(sq.contr_prem_amt - iff(sq.contr_prem_added_amt is null,0 , sq.contr_prem_added_amt),2) as out_der_contr_prem_amt,
        sq.src_ln_of_busn_cd41 as src_ln_of_busn_cd41,
        sq.contr_comm_amt41 as contr_comm_amt41,
        ROUND(contr_comm_amt41 - iff(sq.contr_comm_added_amt is null,0 , sq.contr_comm_added_amt),2) as out_der_contr_comm_amt,
        sq.crcy_cd as crcy_cd,
        sq.tran_crcy_cd as tran_crcy_cd,
        sq.contr_crcy_cd as contr_crcy_cd
    from agg_last_mnth sq
)

select * from trans_exp_cal_lst_mnth