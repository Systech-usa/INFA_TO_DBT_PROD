{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

-- trans_exp_trl_sprd_2yr_last_mnth.sql
with agg_trl_sprd_2yr_last_mnth as (
    select * from {{ ref('int_agg_trl_sprd_2yr_last_mnth') }}
),

trans_exp_trl_sprd_2yr_last_mnth as (
    select
        sq.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        sq.etl_sys_nm as etl_sys_nm,
        sq.out_monthly_date as monthly_date,
        sq.agmt_anchr_id as agmt_anchr_id,
        sq.base_amt as base_amt,
        sq.daily_amt as daily_amt,
        sq.trl_sprd_2yr_base_amt as trl_sprd_2yr_base_amt,
        sq.trl_sprd_2yr_last_mnth_rem_days as trl_sprd_2yr_last_mnth_rem_days,
        sq.trl_sprd_rem_term_dly_amt as trl_sprd_rem_term_dly_amt,
        sq.prem_amt as prem_amt,
        sq.out_prem_added_amt as prem_added_amt,
        ROUND( ( ( sq.trl_sprd_2yr_base_amt - iff(sq.out_prem_added_amt is null, 0, sq.out_prem_added_amt) )  +  (sq.trl_sprd_2yr_last_mnth_rem_days * sq.trl_sprd_rem_term_dly_amt)  ), 2 ) as out_prem_amt,
        sq.eff_md_yr_mo as eff_md_yr_mo,
        sq.pop_info_id as pop_info_id,
        sq.batch_id as batch_id,
        sq.mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        sq.mnth_yr_part_last_day as mnth_yr_part_last_day,
        sq.mnth_yr_part_trl_sprd_2yr_last_day as mnth_yr_part_trl_sprd_2yr_last_day,
        sq.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        sq.out_comm_amt as out_comm_amt,
        sq.trl_sprd_2yr_comm_amt as trl_sprd_2yr_comm_amt,
        sq.trl_sprd_rem_term_comm_dly_amt as trl_sprd_rem_term_comm_dly_amt,
        sq.der_comm_amt as der_comm_amt,
        sq.out_der_comm_added_amt as der_comm_added_amt,
        ROUND( ( ( sq.trl_sprd_2yr_comm_amt - iff(sq.out_der_comm_added_amt is null, 0, sq.out_der_comm_added_amt) )  +  ( sq.trl_sprd_2yr_last_mnth_rem_days * sq.trl_sprd_rem_term_comm_dly_amt) ), 2 ) as out_der_comm_amt,
        sq.tran_prem_amt as tran_prem_amt,
        sq.tran_comm_amt as tran_comm_amt,
        sq.trl_sprd_2yr_tran_prem_amt as trl_sprd_2yr_tran_prem_amt,
        sq.trl_sprd_rem_term_tran_prem_dly_amt as trl_sprd_rem_term_tran_prem_dly_amt,
        sq.der_tran_prem_amt as der_tran_prem_amt,
        sq.out_der_tran_prem_added_amt as der_tran_prem_added_amt,
        ROUND( ( ( sq.trl_sprd_2yr_tran_prem_amt-iff(sq.out_der_tran_prem_added_amt is null, 0, sq.out_der_tran_prem_added_amt) )  +  ( sq.trl_sprd_2yr_last_mnth_rem_days * sq.trl_sprd_rem_term_tran_prem_dly_amt) ), 2 ) as out_der_tran_prem_amt,
        sq.out_trl_sprd_2yr_tran_comm_amt as out_trl_sprd_2yr_tran_comm_amt,
        sq.trl_sprd_rem_term_tran_comm_dly_amt as trl_sprd_rem_term_tran_comm_dly_amt,
        sq.der_tran_comm_amt as der_tran_comm_amt,
        sq.out_der_tran_comm_added_amt as der_tran_comm_added_amt,
        ROUND( ( ( sq.out_trl_sprd_2yr_tran_comm_amt-iff(sq.out_der_tran_comm_added_amt is null, 0, sq.out_der_tran_comm_added_amt) )  +  ( sq.trl_sprd_2yr_last_mnth_rem_days * sq.trl_sprd_rem_term_tran_comm_dly_amt) ), 2 ) as out_der_tran_comm_amt,
        sq.contr_prem_amt as contr_prem_amt,
        sq.trl_sprd_2yr_contr_prem_amt as trl_sprd_2yr_contr_prem_amt,
        sq.trl_sprd_rem_term_contr_prem_dly_amt as trl_sprd_rem_term_contr_prem_dly_amt,
        sq.der_contr_prem_amt as der_contr_prem_amt,
        sq.out_der_contr_prem_added_amt as der_contr_prem_added_amt,
        ROUND( ( ( sq.trl_sprd_2yr_contr_prem_amt - iff(sq.out_der_contr_prem_added_amt is null, 0, sq.out_der_contr_prem_added_amt) )  +  ( sq.trl_sprd_2yr_last_mnth_rem_days * sq.trl_sprd_rem_term_contr_prem_dly_amt) ), 2 ) as out_der_contr_prem_amt,
        sq.src_ln_of_busn_cd as src_ln_of_busn_cd,
        sq.contr_comm_amt as contr_comm_amt,
        sq.trl_sprd_2yr_contr_comm_amt as trl_sprd_2yr_contr_comm_amt,
        sq.trl_sprd_rem_term_contr_comm_dly_amt as trl_sprd_rem_term_contr_comm_dly_amt,
        sq.der_contr_comm_amt as der_contr_comm_amt,
        sq.out_der_contr_comm_added_amt as der_contr_comm_added_amt,
        ROUND( ( ( sq.trl_sprd_2yr_contr_comm_amt - iff(sq.out_der_contr_comm_added_amt is null, 0, sq.out_der_contr_comm_added_amt) )  +  ( sq.trl_sprd_2yr_last_mnth_rem_days * sq.trl_sprd_rem_term_contr_comm_dly_amt) ), 2 ) as out_der_contr_comm_amt,
        sq.crcy_cd as crcy_cd,
        sq.tran_crcy_cd as tran_crcy_cd,
        sq.contr_crcy_cd as contr_crcy_cd
    from agg_trl_sprd_2yr_last_mnth sq
)

select * from trans_exp_trl_sprd_2yr_last_mnth