-- int_filt_not_trl_sprd_2yr_last_mnth
{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

with stg_sq_ctrl_sprd_mnthly_amts_temp as (
    select * 
    from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp') }}
),

trans_exp_sprd_2yr_mnthly_prem_amt_calc as (
    select * 
    from {{ ref('trans_exp_sprd_2yr_mnthly_prem_amt_calc') }}
),

int_filt_not_trl_sprd_2yr_last_mnth as (
    select
        exp.prtclr_mony_provsn_id,
        sq.etl_sys_nm,
        exp.agmt_anchr_id,
        exp.eff_fm_tistmp,
        exp.eff_to_tistmp,
        sq.out_base_amt as base_amt,
        sq.out_monthly_date as monthly_date,
        exp.daily_amt,
        exp.out_prem_amt as prem_amt,
        sq.out_eff_md_yr_mo as eff_md_yr_mo,
        sq.out_pop_info_id as pop_info_id,
        sq.out_batch_id as batch_id,
        sq.out_mnth_yr_part_eff_to as mnth_yr_part_eff_to,
        sq.out_mnth_yr_part_last_day as mnth_yr_part_last_day,
        sq.covg_cmpnt_agmt_anchr_id,
        sq.out_eff_md_yr_mo_dflt,
        sq.in_comm_amt as out_comm_amt,
        exp.out_der_comm_amt,
        sq.in_tran_prem_amt as out_tran_prem_amt,
        sq.in_tran_comm_amt as tran_comm_amt,
        exp.out_der_tran_prem_amt,
        exp.out_der_tran_comm_amt,
        exp.v_trl_sprd_ind as out_trl_sprd_ind,
        exp.v_mnth_yr_part_trl_sprd_2yr_last_day as out_mnth_yr_part_trl_sprd_2yr_last_day,
        sq.out_trl_sprd_2yr_base_amt,
        sq.out_trl_sprd_2yr_last_mnth_rem_days,
        exp.v_trl_sprd_rem_term_dly_amt as out_trl_sprd_rem_term_dly_amt,
        sq.out_trl_sprd_2yr_comm_amt,
        exp.v_trl_sprd_rem_term_comm_dly_amt as out_trl_sprd_rem_term_comm_dly_amt,
        sq.out_trl_sprd_2yr_tran_prem_amt,
        exp.v_trl_sprd_rem_term_tran_prem_dly_amt as out_trl_sprd_rem_term_tran_prem_dly_amt,
        sq.out_trl_sprd_2yr_tran_comm_amt,
        exp.v_trl_sprd_rem_term_tran_comm_dly_amt as out_trl_sprd_rem_term_tran_comm_dly_amt,
        sq.out_contr_prem_amt,
        sq.out_trl_sprd_2yr_contr_prem_amt,
        exp.v_trl_sprd_rem_term_contr_prem_dly_amt as out_trl_sprd_rem_term_contr_prem_dly_amt,
        exp.out_der_contr_prem_amt,
        exp.src_ln_of_busn_cd,
        exp.in_contr_comm_amt as out_contr_comm_amt,
        sq.out_trl_sprd_2yr_contr_comm_amt,
        exp.v_trl_sprd_rem_term_contr_comm_dly_amt as out_trl_sprd_rem_term_contr_comm_dly_amt,
        exp.out_der_contr_comm_amt,
        exp.crcy_cd,
        exp.tran_crcy_cd,
        exp.contr_crcy_cd,
        exp.v_exp_date_diff
    from stg_sq_ctrl_sprd_mnthly_amts_temp as sq
    left join trans_exp_sprd_2yr_mnthly_prem_amt_calc as exp
        on sq.prtclr_mony_provsn_id = exp.prtclr_mony_provsn_id
        and sq.agmt_anchr_id = exp.agmt_anchr_id
    where exp.v_trl_sprd_ind = 0 
       or (exp.v_trl_sprd_ind = 1 and sq.out_mnth_yr_part_last_day != exp.v_mnth_yr_part_trl_sprd_2yr_last_day)
)

select * from int_filt_not_trl_sprd_2yr_last_mnth
--End-DBShift