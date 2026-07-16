{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

with trans_exp_sprd_2yr_mnthly_prem_amt_calc as (
    select * from {{ ref('trans_exp_sprd_2yr_mnthly_prem_amt_calc') }}
),

stg_sq_ctrl_sprd_mnthly_amts_temp as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp') }}
),

int_filt_not_trl_sprd_2yr_last_mnth as (
    select
        trans.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        sq.etl_sys_nm as etl_sys_nm,
        trans.agmt_anchr_id as agmt_anchr_id,
        trans.eff_fm_tistmp as eff_fm_tistmp,
        trans.eff_to_tistmp as eff_to_tistmp,
        sq.out_base_amt as base_amt,
        sq.out_monthly_date as monthly_date,
        trans.daily_amt as daily_amt,
        trans.out_prem_amt as prem_amt,
        sq.out_eff_md_yr_mo as eff_md_yr_mo,
        sq.out_pop_info_id as pop_info_id,
        sq.out_batch_id as batch_id,
        sq.out_mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        sq.out_mnth_yr_part_last_day as mnth_yr_part_last_day,
        sq.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        sq.out_eff_md_yr_mo_dflt as out_eff_md_yr_mo_dflt,
        sq.in_comm_amt as out_comm_amt,
        trans.out_der_comm_amt as out_der_comm_amt,
        sq.in_tran_prem_amt as out_tran_prem_amt,
        sq.in_tran_comm_amt as tran_comm_amt,
        trans.out_der_tran_prem_amt as out_der_tran_prem_amt,
        trans.out_der_tran_comm_amt as out_der_tran_comm_amt,
        trans.v_trl_sprd_ind as out_trl_sprd_ind,
        trans.v_mnth_yr_part_trl_sprd_2yr_last_day as out_mnth_yr_part_trl_sprd_2yr_last_day,
        sq.out_trl_sprd_2yr_base_amt as out_trl_sprd_2yr_base_amt,
        sq.out_trl_sprd_2yr_last_mnth_rem_days as out_trl_sprd_2yr_last_mnth_rem_days,
        trans.v_trl_sprd_rem_term_dly_amt as out_trl_sprd_rem_term_dly_amt,
        sq.out_trl_sprd_2yr_comm_amt as out_trl_sprd_2yr_comm_amt,
        trans.v_trl_sprd_rem_term_comm_dly_amt as out_trl_sprd_rem_term_comm_dly_amt,
        sq.out_trl_sprd_2yr_tran_prem_amt as out_trl_sprd_2yr_tran_prem_amt,
        trans.v_trl_sprd_rem_term_tran_prem_dly_amt as out_trl_sprd_rem_term_tran_prem_dly_amt,
        sq.out_trl_sprd_2yr_tran_comm_amt as out_trl_sprd_2yr_tran_comm_amt,
        trans.v_trl_sprd_rem_term_tran_comm_dly_amt as out_trl_sprd_rem_term_tran_comm_dly_amt,
        sq.out_contr_prem_amt as out_contr_prem_amt,
        sq.out_trl_sprd_2yr_contr_prem_amt as out_trl_sprd_2yr_contr_prem_amt,
        trans.v_trl_sprd_rem_term_contr_prem_dly_amt as out_trl_sprd_rem_term_contr_prem_dly_amt,
        trans.out_der_contr_prem_amt as out_der_contr_prem_amt,
        trans.src_ln_of_busn_cd as src_ln_of_busn_cd,
        trans.in_contr_comm_amt as out_contr_comm_amt,
        sq.out_trl_sprd_2yr_contr_comm_amt as out_trl_sprd_2yr_contr_comm_amt,
        trans.v_trl_sprd_rem_term_contr_comm_dly_amt as out_trl_sprd_rem_term_contr_comm_dly_amt,
        trans.out_der_contr_comm_amt as out_der_contr_comm_amt,
        trans.crcy_cd as crcy_cd,
        trans.tran_crcy_cd as tran_crcy_cd,
        trans.contr_crcy_cd as contr_crcy_cd,
        trans.v_exp_date_diff as v_exp_date_diff
    from trans_exp_sprd_2yr_mnthly_prem_amt_calc trans
    left join stg_sq_ctrl_sprd_mnthly_amts_temp sq
        on trans.prtclr_mony_provsn_id = sq.prtclr_mony_provsn_id
        and trans.agmt_anchr_id = sq.agmt_anchr_id
    where trans.v_trl_sprd_ind = 0 
       or (trans.v_trl_sprd_ind = 1 and sq.out_mnth_yr_part_last_day <> trans.v_mnth_yr_part_trl_sprd_2yr_last_day)
)

select * from int_filt_not_trl_sprd_2yr_last_mnth
--End-DBShift