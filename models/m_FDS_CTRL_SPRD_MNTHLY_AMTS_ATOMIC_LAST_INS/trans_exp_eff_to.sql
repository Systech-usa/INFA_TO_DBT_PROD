{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

-- trans_exp_eff_to.sql
with sq_ctrl_sprd_mnthly_amts_temp1 as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

trans_exp_eff_to as (
    select
        sq.v_exp_date_diff as v_exp_date_diff,
        sq.v_chk_mnth_part_fm as v_chk_mnth_part_fm,
        sq.v_chk_mnth_part_to as v_chk_mnth_part_to,
        sq.v_days_in_mnth as v_days_in_mnth,
        sq.v_mnth_yr_part_trl_sprd_2yr_last_day as v_mnth_yr_part_trl_sprd_2yr_last_day,
        sq.v_mnth_yr_part_last_day as v_mnth_yr_part_last_day,
        sq.v_trl_sprd_2yr_dly_amt as v_trl_sprd_2yr_dly_amt,
        sq.v_trl_sprd_rem_term_dly_amt as v_trl_sprd_rem_term_dly_amt,
        sq.v_trl_sprd_2yr_comm_dly_amt as v_trl_sprd_2yr_comm_dly_amt,
        sq.v_trl_sprd_rem_term_comm_dly_amt_1 as v_trl_sprd_rem_term_comm_dly_amt_1,
        sq.v_trl_sprd_2yr_tran_prem_dly_amt_1 as v_trl_sprd_2yr_tran_prem_dly_amt_1,
        sq.v_trl_sprd_rem_term_tran_prem_dly_amt_1 as v_trl_sprd_rem_term_tran_prem_dly_amt_1,
        sq.v_trl_sprd_2yr_tran_comm_dly_amt_1 as v_trl_sprd_2yr_tran_comm_dly_amt_1,
        sq.v_trl_sprd_rem_term_tran_comm_dly_amt_1 as v_trl_sprd_rem_term_tran_comm_dly_amt_1,
        sq.v_trl_sprd_2yr_contr_prem_dly_amt_1 as v_trl_sprd_2yr_contr_prem_dly_amt_1,
        sq.v_trl_sprd_rem_term_contr_prem_dly_amt_1 as v_trl_sprd_rem_term_contr_prem_dly_amt_1,
        sq.v_trl_sprd_2yr_contr_comm_dly_amt_1 as v_trl_sprd_2yr_contr_comm_dly_amt_1,
        sq.v_trl_sprd_rem_term_contr_comm_dly_amt_1 as v_trl_sprd_rem_term_contr_comm_dly_amt_1,
        sq.daily_amt as daily_amt,
        sq.out_trl_sprd_ind as out_trl_sprd_ind,
        sq.base_amt as base_amt,
        sq.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        sq.agmt_anchr_id as agmt_anchr_id,
        sq.eff_fm_tistmp as eff_fm_tistmp,
        sq.in_comm_amt as in_comm_amt,
        sq.in_comm_daily_amt as in_comm_daily_amt,
        sq.in_tran_prem_amt as in_tran_prem_amt,
        sq.in_tran_comm_amt as in_tran_comm_amt,
        sq.in_dly_tran_comm_amt as in_dly_tran_comm_amt,
        sq.in_dly_tran_prem_amt as in_dly_tran_prem_amt,
        sq.in_contr_prem_amt as in_contr_prem_amt,
        sq.in_dly_contr_prem_amt as in_dly_contr_prem_amt,
        sq.src_ln_of_busn_cd as src_ln_of_busn_cd,
        sq.in_contr_comm_amt as in_contr_comm_amt,
        sq.in_dly_contr_comm_amt as in_dly_contr_comm_amt,
        sq.crcy_cd as crcy_cd,
        sq.tran_crcy_cd as tran_crcy_cd,
        sq.contr_crcy_cd as contr_crcy_cd,
        sq.eff_to_tistmp as eff_to_tistmp,
        iff(sq.eff_to_tistmp = sq.eff_fm_tistmp OR TO_CHAR(sq.eff_to_tistmp, 'YYYY-MM-DD HH24:MI:SS') = '1900-01-01 00:00:00' OR TO_CHAR(sq.eff_to_tistmp, 'YYYY-MM-DD HH24:MI:SS') = 
'2999-12-31 00:00:00'  , sq.eff_to_tistmp,dateadd(day, -1, sq.eff_to_tistmp)) as out_eff_to_tistmp
    from sq_ctrl_sprd_mnthly_amts_temp1 sq
)

select * from trans_exp_eff_to

--End-DBShift