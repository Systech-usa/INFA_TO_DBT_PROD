-- trans_exp_sprd_mnthly_prem_amt_calc
{{ config(materialized='view', tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]) }}

with stg_sq_ctrl_sprd_mnthly_amts_temp1 as (
    select * from {{ ref('stg_sq_ctrl_sprd_mnthly_amts_temp1') }}
),

trans_exp_eff_to as (
    select * from {{ ref('trans_exp_eff_to') }}
),

trans_exp_sprd_mnthly_prem_amt_calc as (
    select
        sq.prtclr_mony_provsn_id as PRTCLR_MONY_PROVSN_ID,
        sq.agmt_anchr_id as AGMT_ANCHR_ID,
        sq.eff_fm_tistmp as EFF_FM_TISTMP,
        eff_to.out_EFF_TO_TISTMP as EFF_TO_TISTMP,
        sq.eff_to_tistmp as in_ORG_EFF_TO_TISTMP,
        
        IFF( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to = 1,
            IFF(sq.out_trl_sprd_ind = 0, 
                ROUND(sq.v_days_in_mnth * sq.daily_amt, 2), 
                IFF(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_dly_amt, 2), 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_dly_amt, 2) 
                )
            ), 
            ROUND(sq.base_amt, 2)
        ) as out_PREM_AMT,

        IFF( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to = 1,
            IFF(sq.out_trl_sprd_ind = 0, 
                ROUND(sq.v_days_in_mnth * sq.in_comm_daily_amt, 2), 
                IFF(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_comm_dly_amt, 2), 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_comm_dly_amt_1, 2) 
                )
            ), 
            ROUND(sq.in_comm_amt, 2)
        ) as out_DER_COMM_AMT,

        IFF( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to = 1,
            IFF(sq.out_trl_sprd_ind = 0, 
                ROUND(sq.v_days_in_mnth * sq.in_dly_tran_prem_amt, 2), 
                IFF(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_tran_prem_dly_amt_1, 2), 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_tran_prem_dly_amt_1, 2) 
                )
            ), 
            ROUND(sq.in_tran_prem_amt, 2)
        ) as out_DER_TRAN_PREM_AMT,

        IFF( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to = 1,
            IFF(sq.out_trl_sprd_ind = 0, 
                ROUND(sq.v_days_in_mnth * sq.in_dly_tran_comm_amt, 2), 
                IFF(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_tran_comm_dly_amt_1, 2), 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_tran_comm_dly_amt_1, 2) 
                )
            ), 
            ROUND(sq.in_tran_comm_amt, 2)
        ) as out_DER_TRAN_COMM_AMT,

        IFF( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to = 1,
            IFF(sq.out_trl_sprd_ind = 0, 
                ROUND(sq.v_days_in_mnth * sq.in_dly_contr_prem_amt, 2), 
                IFF(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_contr_prem_dly_amt_1, 2), 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_contr_prem_dly_amt_1, 2) 
                )
            ), 
            ROUND(sq.in_contr_prem_amt, 2)
        ) as out_DER_CONTR_PREM_AMT,

        sq.src_ln_of_busn_cd as SRC_LN_OF_BUSN_CD,
        sq.in_contr_comm_amt as in_CONTR_COMM_AMT,
        sq.in_dly_contr_comm_amt as in_DLY_CONTR_COMM_AMT,

        IFF( sq.v_chk_mnth_part_fm = 1 OR sq.v_chk_mnth_part_to = 1,
            IFF(sq.out_trl_sprd_ind = 0, 
                ROUND(sq.v_days_in_mnth * sq.in_dly_contr_comm_amt, 2), 
                IFF(sq.v_mnth_yr_part_last_day <= sq.v_mnth_yr_part_trl_sprd_2yr_last_day, 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_2yr_contr_comm_dly_amt_1, 2), 
                    ROUND(sq.v_days_in_mnth * sq.v_trl_sprd_rem_term_contr_comm_dly_amt_1, 2) 
                )
            ), 
            ROUND(sq.in_contr_comm_amt, 2)
        ) as out_DER_CONTR_COMM_AMT,

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
    left join trans_exp_eff_to eff_to
        on sq.prtclr_mony_provsn_id = eff_to.PRTCLR_MONY_PROVSN_ID
        and sq.agmt_anchr_id = eff_to.AGMT_ANCHR_ID
)

select * from trans_exp_sprd_mnthly_prem_amt_calc

--End-DBShift