-- trans_exp_sprd_mnthly_prem_amt_calc.sql
{{ config(materialized='view', tags=['m_fds_ctrl_sprd_mnthly_amts_atomic_last_ins']) }}

with stg_sq_ctrl_sprd_mnthly_amts_temp1 as (
    -- Source: upstream transformation
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

trans_exp_eff_to as (
    -- Source: upstream transformation
    select * from {{ ref('trans_exp_eff_to') }}
),

joined_inputs as (
    select
        sq.prtclr_mony_provsn_id as PRTCLR_MONY_PROVSN_ID,
        sq.agmt_anchr_id as AGMT_ANCHR_ID,
        sq.eff_fm_tistmp as EFF_FM_TISTMP,
        eff.out_EFF_TO_TISTMP as EFF_TO_TISTMP,
        sq.eff_to_tistmp as in_ORG_EFF_TO_TISTMP,
        sq.in_comm_amt as in_COMM_AMT,
        sq.in_comm_daily_amt as in_COMM_DAILY_AMT,
        sq.in_tran_prem_amt as in_TRAN_PREM_AMT,
        sq.in_tran_comm_amt as in_TRAN_COMM_AMT,
        sq.in_dly_tran_comm_amt as in_DLY_TRAN_COMM_AMT,
        sq.in_dly_tran_prem_amt as in_DLY_TRAN_PREM_AMT,
        sq.in_contr_prem_amt as in_CONTR_PREM_AMT,
        sq.in_dly_contr_prem_amt as in_DLY_CONTR_PREM_AMT,
        sq.src_ln_of_busn_cd as SRC_LN_OF_BUSN_CD,
        sq.in_contr_comm_amt as in_CONTR_COMM_AMT,
        sq.in_dly_contr_comm_amt as in_DLY_CONTR_COMM_AMT,
        sq.crcy_cd as CRCY_CD,
        sq.tran_crcy_cd as TRAN_CRCY_CD,
        sq.contr_crcy_cd as CONTR_CRCY_CD,
        sq.v_exp_date_diff as v_EXP_DATE_DIFF,
        sq.v_chk_mnth_part_fm as v_CHK_MNTH_PART_FM,
        sq.v_chk_mnth_part_to as v_CHK_MNTH_PART_TO,
        sq.v_days_in_mnth as v_DAYS_IN_MNTH,
        sq.v_mnth_yr_part_trl_sprd_2yr_last_day as v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY,
        sq.v_mnth_yr_part_last_day as v_MNTH_YR_PART_LAST_DAY,
        sq.v_trl_sprd_2yr_dly_amt as v_TRL_SPRD_2YR_DLY_AMT,
        sq.v_trl_sprd_rem_term_dly_amt as v_TRL_SPRD_REM_TERM_DLY_AMT,
        sq.v_trl_sprd_2yr_comm_dly_amt as v_TRL_SPRD_2YR_COMM_DLY_AMT,
        sq.v_trl_sprd_rem_term_comm_dly_amt_1 as v_TRL_SPRD_REM_TERM_COMM_DLY_AMT,
        sq.v_trl_sprd_2yr_tran_prem_dly_amt_1 as v_TRL_SPRD_2YR_TRAN_PREM_DLY_AMT,
        sq.v_trl_sprd_rem_term_tran_prem_dly_amt_1 as v_TRL_SPRD_REM_TERM_TRAN_PREM_DLY_AMT,
        sq.v_trl_sprd_2yr_tran_comm_dly_amt_1 as v_TRL_SPRD_2YR_TRAN_COMM_DLY_AMT,
        sq.v_trl_sprd_rem_term_tran_comm_dly_amt_1 as v_TRL_SPRD_REM_TERM_TRAN_COMM_DLY_AMT,
        sq.v_trl_sprd_2yr_contr_prem_dly_amt_1 as v_TRL_SPRD_2YR_CONTR_PREM_DLY_AMT,
        sq.v_trl_sprd_rem_term_contr_prem_dly_amt_1 as v_TRL_SPRD_REM_TERM_CONTR_PREM_DLY_AMT,
        sq.v_trl_sprd_2yr_contr_comm_dly_amt_1 as v_TRL_SPRD_2YR_CONTR_COMM_DLY_AMT,
        sq.v_trl_sprd_rem_term_contr_comm_dly_amt_1 as v_TRL_SPRD_REM_TERM_CONTR_COMM_DLY_AMT,
        sq.out_trl_sprd_ind as v_TRL_SPRD_IND,
        sq.daily_amt as DAILY_AMT,
        sq.base_amt as BASE_AMT
    from stg_sq_ctrl_sprd_mnthly_amts_temp1 sq
    left join trans_exp_eff_to eff 
        on sq.prtclr_mony_provsn_id = eff.prtclr_mony_provsn_id
        and sq.agmt_anchr_id = eff.agmt_anchr_id
),

trans_exp_sprd_mnthly_prem_amt_calc as (
    select
        PRTCLR_MONY_PROVSN_ID,
        AGMT_ANCHR_ID,
        EFF_FM_TISTMP,
        EFF_TO_TISTMP,
        in_ORG_EFF_TO_TISTMP,
        
        IFF(v_CHK_MNTH_PART_FM = 1 OR v_CHK_MNTH_PART_TO = 1,
            IFF(v_TRL_SPRD_IND = 0, 
                ROUND(v_DAYS_IN_MNTH * DAILY_AMT, 2), 
                IFF(v_MNTH_YR_PART_LAST_DAY <= v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY, 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_2YR_DLY_AMT, 2), 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_REM_TERM_DLY_AMT, 2) 
                )
            ), 
            ROUND(BASE_AMT, 2)
        ) as out_PREM_AMT,
        
        IFF(v_CHK_MNTH_PART_FM = 1 OR v_CHK_MNTH_PART_TO = 1,
            IFF(v_TRL_SPRD_IND = 0, 
                ROUND(v_DAYS_IN_MNTH * in_COMM_DAILY_AMT, 2), 
                IFF(v_MNTH_YR_PART_LAST_DAY <= v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY, 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_2YR_COMM_DLY_AMT, 2), 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_REM_TERM_COMM_DLY_AMT, 2) 
                )
            ), 
            ROUND(in_COMM_AMT, 2)
        ) as out_DER_COMM_AMT,
        
        IFF(v_CHK_MNTH_PART_FM = 1 OR v_CHK_MNTH_PART_TO = 1,
            IFF(v_TRL_SPRD_IND = 0, 
                ROUND(v_DAYS_IN_MNTH * in_DLY_TRAN_PREM_AMT, 2), 
                IFF(v_MNTH_YR_PART_LAST_DAY <= v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY, 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_2YR_TRAN_PREM_DLY_AMT, 2), 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_REM_TERM_TRAN_PREM_DLY_AMT, 2) 
                )
            ), 
            ROUND(in_TRAN_PREM_AMT, 2)
        ) as out_DER_TRAN_PREM_AMT,
        
        IFF(v_CHK_MNTH_PART_FM = 1 OR v_CHK_MNTH_PART_TO = 1,
            IFF(v_TRL_SPRD_IND = 0, 
                ROUND(v_DAYS_IN_MNTH * in_DLY_TRAN_COMM_AMT, 2), 
                IFF(v_MNTH_YR_PART_LAST_DAY <= v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY, 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_2YR_TRAN_COMM_DLY_AMT, 2), 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_REM_TERM_TRAN_COMM_DLY_AMT, 2) 
                )
            ), 
            ROUND(in_TRAN_COMM_AMT, 2)
        ) as out_DER_TRAN_COMM_AMT,
        
        IFF(v_CHK_MNTH_PART_FM = 1 OR v_CHK_MNTH_PART_TO = 1,
            IFF(v_TRL_SPRD_IND = 0, 
                ROUND(v_DAYS_IN_MNTH * in_DLY_CONTR_PREM_AMT, 2), 
                IFF(v_MNTH_YR_PART_LAST_DAY <= v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY, 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_2YR_CONTR_PREM_DLY_AMT, 2), 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_REM_TERM_CONTR_PREM_DLY_AMT, 2) 
                )
            ), 
            ROUND(in_CONTR_PREM_AMT, 2)
        ) as out_DER_CONTR_PREM_AMT,
        
        SRC_LN_OF_BUSN_CD,
        in_CONTR_COMM_AMT,
        in_DLY_CONTR_COMM_AMT,
        
        IFF(v_CHK_MNTH_PART_FM = 1 OR v_CHK_MNTH_PART_TO = 1,
            IFF(v_TRL_SPRD_IND = 0, 
                ROUND(v_DAYS_IN_MNTH * in_DLY_CONTR_COMM_AMT, 2), 
                IFF(v_MNTH_YR_PART_LAST_DAY <= v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY, 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_2YR_CONTR_COMM_DLY_AMT, 2), 
                    ROUND(v_DAYS_IN_MNTH * v_TRL_SPRD_REM_TERM_CONTR_COMM_DLY_AMT, 2) 
                )
            ), 
            ROUND(in_CONTR_COMM_AMT, 2)
        ) as out_DER_CONTR_COMM_AMT,
        
        CRCY_CD,
        TRAN_CRCY_CD,
        CONTR_CRCY_CD,
        v_EXP_DATE_DIFF,
        v_CHK_MNTH_PART_FM,
        v_CHK_MNTH_PART_TO,
        v_DAYS_IN_MNTH,
        v_MNTH_YR_PART_TRL_SPRD_2YR_LAST_DAY,
        v_MNTH_YR_PART_LAST_DAY,
        v_TRL_SPRD_2YR_DLY_AMT,
        v_TRL_SPRD_REM_TERM_DLY_AMT,
        v_TRL_SPRD_2YR_COMM_DLY_AMT,
        v_TRL_SPRD_REM_TERM_COMM_DLY_AMT,
        v_TRL_SPRD_2YR_TRAN_PREM_DLY_AMT,
        v_TRL_SPRD_REM_TERM_TRAN_PREM_DLY_AMT,
        v_TRL_SPRD_2YR_TRAN_COMM_DLY_AMT,
        v_TRL_SPRD_REM_TERM_TRAN_COMM_DLY_AMT,
        v_TRL_SPRD_2YR_CONTR_PREM_DLY_AMT,
        v_TRL_SPRD_REM_TERM_CONTR_PREM_DLY_AMT,
        v_TRL_SPRD_2YR_CONTR_COMM_DLY_AMT,
        v_TRL_SPRD_REM_TERM_CONTR_COMM_DLY_AMT,
        v_TRL_SPRD_IND,
        DAILY_AMT,
        BASE_AMT

    from joined_inputs
)

select * from trans_exp_sprd_mnthly_prem_amt_calc

--End-DBShift