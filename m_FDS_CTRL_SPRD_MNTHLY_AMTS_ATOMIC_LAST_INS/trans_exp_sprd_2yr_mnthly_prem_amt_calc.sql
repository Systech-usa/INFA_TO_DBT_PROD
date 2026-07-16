-- trans_exp_sprd_2yr_mnthly_prem_amt_calc.sql
{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with stg_sq_ctrl_sprd_mnthly_amts_temp as (
    -- Source: upstream transformation
    select 
        prtclr_mony_provsn_id,
        agmt_anchr_id,
        eff_fm_tistmp,
        eff_to_tistmp as in_org_eff_to_tistmp,
        in_comm_amt,
        in_comm_daily_amt,
        in_tran_prem_amt,
        in_tran_comm_amt,
        in_dly_tran_comm_amt,
        in_dly_tran_prem_amt,
        in_contr_prem_amt,
        in_dly_contr_prem_amt,
        src_ln_of_busn_cd,
        in_contr_comm_amt,
        in_dly_contr_comm_amt,
        crcy_cd,
        tran_crcy_cd,
        contr_crcy_cd,
        v_exp_date_diff,
        v_chk_mnth_part_fm,
        v_chk_mnth_part_to,
        v_days_in_mnth,
        v_mnth_yr_part_trl_sprd_2yr_last_day,
        v_mnth_yr_part_last_day,
        v_trl_sprd_2yr_dly_amt,
        v_trl_sprd_rem_term_dly_amt,
        v_trl_sprd_2yr_comm_dly_amt,
        v_trl_sprd_rem_term_comm_dly_amt_1 as v_trl_sprd_rem_term_comm_dly_amt,
        v_trl_sprd_2yr_tran_prem_dly_amt_1 as v_trl_sprd_2yr_tran_prem_dly_amt,
        v_trl_sprd_rem_term_tran_prem_dly_amt_1 as v_trl_sprd_rem_term_tran_prem_dly_amt,
        v_trl_sprd_2yr_tran_comm_dly_amt_1 as v_trl_sprd_2yr_tran_comm_dly_amt,
        v_trl_sprd_rem_term_tran_comm_dly_amt_1 as v_trl_sprd_rem_term_tran_comm_dly_amt,
        v_trl_sprd_2yr_contr_prem_dly_amt_1 as v_trl_sprd_2yr_contr_prem_dly_amt,
        v_trl_sprd_rem_term_contr_prem_dly_amt_1 as v_trl_sprd_rem_term_contr_prem_dly_amt,
        v_trl_sprd_2yr_contr_comm_dly_amt_1 as v_trl_sprd_2yr_contr_comm_dly_amt,
        v_trl_sprd_rem_term_contr_comm_dly_amt_1 as v_trl_sprd_rem_term_contr_comm_dly_amt,
        out_trl_sprd_ind as v_trl_sprd_ind,
        daily_amt,
        base_amt
    from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp') }}
),

trans_exp_sprd_2yr_mnthly_prem_amt_calc as (
    select 
        prtclr_mony_provsn_id as prtclr_mony_provsn_id,
        agmt_anchr_id as agmt_anchr_id,
        eff_fm_tistmp as eff_fm_tistmp,
        NULL as eff_to_tistmp,
        in_org_eff_to_tistmp as in_org_eff_to_tistmp,
        
        -- out_PREM_AMT
        IFF(
            v_chk_mnth_part_fm = 1 OR v_chk_mnth_part_to = 1,
            IFF(
                v_trl_sprd_ind = 0, 
                ROUND(v_days_in_mnth * daily_amt, 2), 
                IFF(
                    v_mnth_yr_part_last_day <= v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(v_days_in_mnth * v_trl_sprd_2yr_dly_amt, 2), 
                    ROUND(v_days_in_mnth * v_trl_sprd_rem_term_dly_amt, 2)
                )
            ), 
            ROUND(base_amt, 2)
        ) as out_prem_amt,
        
        -- out_DER_COMM_AMT
        IFF(
            v_chk_mnth_part_fm = 1 OR v_chk_mnth_part_to = 1,
            IFF(
                v_trl_sprd_ind = 0, 
                ROUND(v_days_in_mnth * in_comm_daily_amt, 2), 
                IFF(
                    v_mnth_yr_part_last_day <= v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(v_days_in_mnth * v_trl_sprd_2yr_comm_dly_amt, 2), 
                    ROUND(v_days_in_mnth * v_trl_sprd_rem_term_comm_dly_amt, 2)
                )
            ), 
            ROUND(in_comm_amt, 2)
        ) as out_der_comm_amt,
        
        -- out_DER_TRAN_PREM_AMT
        IFF(
            v_chk_mnth_part_fm = 1 OR v_chk_mnth_part_to = 1,
            IFF(
                v_trl_sprd_ind = 0, 
                ROUND(v_days_in_mnth * in_dly_tran_prem_amt, 2), 
                IFF(
                    v_mnth_yr_part_last_day <= v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(v_days_in_mnth * v_trl_sprd_2yr_tran_prem_dly_amt, 2), 
                    ROUND(v_days_in_mnth * v_trl_sprd_rem_term_tran_prem_dly_amt, 2)
                )
            ), 
            ROUND(in_tran_prem_amt, 2)
        ) as out_der_tran_prem_amt,
        
        -- out_DER_TRAN_COMM_AMT
        IFF(
            v_chk_mnth_part_fm = 1 OR v_chk_mnth_part_to = 1,
            IFF(
                v_trl_sprd_ind = 0, 
                ROUND(v_days_in_mnth * in_dly_tran_comm_amt, 2), 
                IFF(
                    v_mnth_yr_part_last_day <= v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(v_days_in_mnth * v_trl_sprd_2yr_tran_comm_dly_amt, 2), 
                    ROUND(v_days_in_mnth * v_trl_sprd_rem_term_tran_comm_dly_amt, 2)
                )
            ), 
            ROUND(in_tran_comm_amt, 2)
        ) as out_der_tran_comm_amt,
        
        -- out_DER_CONTR_PREM_AMT
        IFF(
            v_chk_mnth_part_fm = 1 OR v_chk_mnth_part_to = 1,
            IFF(
                v_trl_sprd_ind = 0, 
                ROUND(v_days_in_mnth * in_dly_contr_prem_amt, 2), 
                IFF(
                    v_mnth_yr_part_last_day <= v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(v_days_in_mnth * v_trl_sprd_2yr_contr_prem_dly_amt, 2), 
                    ROUND(v_days_in_mnth * v_trl_sprd_rem_term_contr_prem_dly_amt, 2)
                )
            ), 
            ROUND(in_contr_prem_amt, 2)
        ) as out_der_contr_prem_amt,
        
        src_ln_of_busn_cd as src_ln_of_busn_cd,
        in_contr_comm_amt as in_contr_comm_amt,
        in_dly_contr_comm_amt as in_dly_contr_comm_amt,
        
        -- out_DER_CONTR_COMM_AMT
        IFF(
            v_chk_mnth_part_fm = 1 OR v_chk_mnth_part_to = 1,
            IFF(
                v_trl_sprd_ind = 0, 
                ROUND(v_days_in_mnth * in_dly_contr_comm_amt, 2), 
                IFF(
                    v_mnth_yr_part_last_day <= v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(v_days_in_mnth * v_trl_sprd_2yr_contr_comm_dly_amt, 2), 
                    ROUND(v_days_in_mnth * v_trl_sprd_rem_term_contr_comm_dly_amt, 2)
                )
            ), 
            ROUND(in_contr_comm_amt, 2)
        ) as out_der_contr_comm_amt,
        
        crcy_cd as crcy_cd,
        tran_crcy_cd as tran_crcy_cd,
        contr_crcy_cd as contr_crcy_cd,
        v_exp_date_diff as v_exp_date_diff,
        v_chk_mnth_part_fm as v_chk_mnth_part_fm,
        v_chk_mnth_part_to as v_chk_mnth_part_to,
        v_days_in_mnth as v_days_in_mnth,
        v_mnth_yr_part_trl_sprd_2yr_last_day as v_mnth_yr_part_trl_sprd_2yr_last_day,
        v_mnth_yr_part_last_day as v_mnth_yr_part_last_day,
        v_trl_sprd_2yr_dly_amt as v_trl_sprd_2yr_dly_amt,
        v_trl_sprd_rem_term_dly_amt as v_trl_sprd_rem_term_dly_amt,
        v_trl_sprd_2yr_comm_dly_amt as v_trl_sprd_2yr_comm_dly_amt,
        v_trl_sprd_rem_term_comm_dly_amt as v_trl_sprd_rem_term_comm_dly_amt,
        v_trl_sprd_2yr_tran_prem_dly_amt as v_trl_sprd_2yr_tran_prem_dly_amt,
        v_trl_sprd_rem_term_tran_prem_dly_amt as v_trl_sprd_rem_term_tran_prem_dly_amt,
        v_trl_sprd_2yr_tran_comm_dly_amt as v_trl_sprd_2yr_tran_comm_dly_amt,
        v_trl_sprd_rem_term_tran_comm_dly_amt as v_trl_sprd_rem_term_tran_comm_dly_amt,
        v_trl_sprd_2yr_contr_prem_dly_amt as v_trl_sprd_2yr_contr_prem_dly_amt,
        v_trl_sprd_rem_term_contr_prem_dly_amt as v_trl_sprd_rem_term_contr_prem_dly_amt,
        v_trl_sprd_2yr_contr_comm_dly_amt as v_trl_sprd_2yr_contr_comm_dly_amt,
        v_trl_sprd_rem_term_contr_comm_dly_amt as v_trl_sprd_rem_term_contr_comm_dly_amt,
        v_trl_sprd_ind as v_trl_sprd_ind,
        daily_amt as daily_amt,
        base_amt as base_amt
    from stg_sq_ctrl_sprd_mnthly_amts_temp
)

select * from trans_exp_sprd_2yr_mnthly_prem_amt_calc

--End-DBShift