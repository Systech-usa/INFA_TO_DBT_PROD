{{ config(materialized='table', tags=['m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS']) }}

-- trans_exp_sprd_2yr_mnthly_prem_amt_calc.sql
with sq_ctrl_sprd_mnthly_amts_temp as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp') }}
),

trans_exp_sprd_2yr_mnthly_prem_amt_calc as (
    select
        sq.out_base_amt as out_base_amt,
        sq.out_monthly_date as out_monthly_date,
        sq.out_eff_md_yr_mo as out_eff_md_yr_mo,
        sq.etl_sys_nm as etl_sys_nm,
        sq.out_pop_info_id as out_pop_info_id,
        sq.out_batch_id as out_batch_id,
        sq.out_mnth_yr_part_eff_to as out_mnth_yr_part_eff_to,
        sq.out_mnth_yr_part_last_day as out_mnth_yr_part_last_day,
        sq.covg_cmpnt_agmt_anchr_id as covg_cmpnt_agmt_anchr_id,
        sq.out_eff_md_yr_mo_dflt as out_eff_md_yr_mo_dflt,
        sq.in_comm_amt as in_comm_amt,
        sq.in_tran_prem_amt as in_tran_prem_amt,
        sq.in_tran_comm_amt as in_tran_comm_amt,
        sq.out_trl_sprd_2yr_base_amt as out_trl_sprd_2yr_base_amt,
        sq.out_trl_sprd_2yr_last_mnth_rem_days as out_trl_sprd_2yr_last_mnth_rem_days,
        sq.out_trl_sprd_2yr_comm_amt as out_trl_sprd_2yr_comm_amt,
        sq.out_trl_sprd_2yr_tran_prem_amt as out_trl_sprd_2yr_tran_prem_amt,
        sq.out_trl_sprd_2yr_tran_comm_amt as out_trl_sprd_2yr_tran_comm_amt,
        sq.out_contr_prem_amt as out_contr_prem_amt,
        sq.out_trl_sprd_2yr_contr_prem_amt as out_trl_sprd_2yr_contr_prem_amt,
        sq.out_trl_sprd_2yr_contr_comm_amt as out_trl_sprd_2yr_contr_comm_amt,
        sq.prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        sq.agmt_anchr_id as agmt_anchr_id,
        sq.eff_fm_tistmp as eff_fm_tistmp,
        sq.eff_to_tistmp as eff_to_tistmp,
        sq.eff_to_tistmp as in_org_eff_to_tistmp,
        -- Commented as part of CR#93
--iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
-- (ROUND(sq.v_days_in_mnth  * sq.daily_amt,2)),(ROUND(sq.base_amt,2))) 
-- Changed as below as part of CR#93
iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
        iff(sq.out_trl_sprd_ind = 0, 
               (ROUND(sq.v_days_in_mnth  * sq.daily_amt,2)), 
               iff(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_dly_amt, 2), 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_dly_amt, 2) 
                      )
             ), 
       (ROUND(sq.base_amt,2))
    ) as out_prem_amt,
        -- Commented as part of CR#93
--iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
-- (ROUND(sq.v_days_in_mnth  * sq.in_comm_daily_amt,2)),(ROUND(sq.in_comm_amt,2)))
-- Changed as below as part of CR#93
iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
        iff(sq.out_trl_sprd_ind = 0, 
               (ROUND(sq.v_days_in_mnth  * sq.in_comm_daily_amt,2)), 
               iff(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_comm_dly_amt, 2), 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_comm_dly_amt_1, 2) 
                      )
             ), 
       (ROUND(sq.in_comm_amt,2))
    ) as out_der_comm_amt,
        -- Commented as part of CR#93
--iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to= 1 , 
-- (ROUND(sq.v_days_in_mnth * sq.in_dly_tran_prem_amt ,2)), (ROUND(sq.in_tran_prem_amt,2)))
-- Changed as below as part of CR#93
iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
        iff(sq.out_trl_sprd_ind = 0, 
               (ROUND(sq.v_days_in_mnth  * sq.in_dly_tran_prem_amt,2)), 
               iff(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_tran_prem_dly_amt_1, 2), 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_tran_prem_dly_amt_1, 2) 
                      )
             ), 
       (ROUND(sq.in_tran_prem_amt,2))
    ) as out_der_tran_prem_amt,
        -- Commented as part of CR#93
--iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
-- (ROUND(sq.v_days_in_mnth * sq.in_dly_tran_comm_amt ,2)), (ROUND(sq.in_tran_comm_amt ,2))) 
-- Changed as below as part of CR#93
iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
        iff(sq.out_trl_sprd_ind = 0, 
               (ROUND(sq.v_days_in_mnth  * sq.in_dly_tran_comm_amt,2)), 
               iff(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_tran_comm_dly_amt_1, 2), 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_tran_comm_dly_amt_1, 2) 
                      )
             ), 
       (ROUND(sq.in_tran_comm_amt,2))
    ) as out_der_tran_comm_amt,
        -- Commented as part of CR#93
--iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to= 1 , 
-- (ROUND(sq.v_days_in_mnth * sq.in_dly_tran_prem_amt ,2)), (ROUND(sq.in_tran_prem_amt,2)))
-- Changed as below as part of CR#93
iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
        iff(sq.out_trl_sprd_ind = 0, 
               (ROUND(sq.v_days_in_mnth  * sq.in_dly_contr_prem_amt,2)), 
               iff(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_contr_prem_dly_amt_1, 2), 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_contr_prem_dly_amt_1, 2) 
                      )
             ), 
       (ROUND(sq.in_contr_prem_amt,2))
    ) as out_der_contr_prem_amt,
        sq.src_ln_of_busn_cd as src_ln_of_busn_cd,
        sq.in_contr_comm_amt as in_contr_comm_amt,
        sq.in_dly_contr_comm_amt as in_dly_contr_comm_amt,
        -- Commented as part of CR#93
--iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to= 1 , 
-- (ROUND(sq.v_days_in_mnth * sq.in_dly_tran_prem_amt ,2)), (ROUND(sq.in_tran_prem_amt,2)))
-- Changed as below as part of CR#93
iff( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to =1,
        iff(sq.out_trl_sprd_ind = 0, 
               (ROUND(sq.v_days_in_mnth  * sq.in_dly_contr_comm_amt,2)), 
               iff(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_contr_comm_dly_amt_1, 2), 
                       ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_contr_comm_dly_amt_1, 2) 
                      )
             ), 
       (ROUND(sq.in_contr_comm_amt,2))
    ) as out_der_contr_comm_amt,
        sq.crcy_cd as crcy_cd,
        sq.tran_crcy_cd as tran_crcy_cd,
        sq.contr_crcy_cd as contr_crcy_cd,
        sq.v_exp_date_diff as v_exp_date_diff,
        sq.v_chk_mnth_part_fm as v_chk_mnth_part_fm,
        sq.v_chk_mnth_part_to as v_chk_mnth_part_to,
        sq.v_days_in_mnth as v_days_in_mnth,
        sq.v_mnth_yr_part_trl_sprd_2yr_last_day as v_mnth_yr_part_trl_sprd_2yr_last_day,
        sq.v_mnth_yr_part_last_day as v_mnth_yr_part_last_day,
        sq.v_trl_sprd_2yr_dly_amt as v_trl_sprd_2yr_dly_amt,
        sq.v_trl_sprd_rem_term_dly_amt as v_trl_sprd_rem_term_dly_amt,
        sq.v_trl_sprd_2yr_comm_dly_amt as v_trl_sprd_2yr_comm_dly_amt,
        sq.v_trl_sprd_rem_term_comm_dly_amt_1 as v_trl_sprd_rem_term_comm_dly_amt,
        sq.v_trl_sprd_2yr_tran_prem_dly_amt_1 as v_trl_sprd_2yr_tran_prem_dly_amt,
        sq.v_trl_sprd_rem_term_tran_prem_dly_amt_1 as v_trl_sprd_rem_term_tran_prem_dly_amt,
        sq.v_trl_sprd_2yr_tran_comm_dly_amt_1 as v_trl_sprd_2yr_tran_comm_dly_amt,
        sq.v_trl_sprd_rem_term_tran_comm_dly_amt_1 as v_trl_sprd_rem_term_tran_comm_dly_amt,
        sq.v_trl_sprd_2yr_contr_prem_dly_amt_1 as v_trl_sprd_2yr_contr_prem_dly_amt,
        sq.v_trl_sprd_rem_term_contr_prem_dly_amt_1 as v_trl_sprd_rem_term_contr_prem_dly_amt,
        sq.v_trl_sprd_2yr_contr_comm_dly_amt_1 as v_trl_sprd_2yr_contr_comm_dly_amt,
        sq.v_trl_sprd_rem_term_contr_comm_dly_amt_1 as v_trl_sprd_rem_term_contr_comm_dly_amt,
        sq.out_trl_sprd_ind as v_trl_sprd_ind,
        sq.daily_amt as daily_amt,
        sq.base_amt as base_amt
    from sq_ctrl_sprd_mnthly_amts_temp sq
)

select * from trans_exp_sprd_2yr_mnthly_prem_amt_calc

--End-DBShift