-- int_agg_last_mnth.sql
{{ config(
    materialized='table',
    tags=["m_FDS_CTRL_SPRD_MNTHLY_AMTS_ATOMIC_LAST_INS"]
) }}

with int_srt_dates as (
    select * from {{ ref('int_srt_dates') }}
),

int_agg_last_mnth as (
    select
        PRTCLR_MONY_PROVSN_ID,
        ETL_SYS_NM,
        max(AGMT_ANCHR_ID) as AGMT_ANCHR_ID,
        max(BASE_AMT) as BASE_AMT,
        max(PREM_AMT) as PREM_AMT,
        SUM(CASE WHEN MNTH_YR_PART_EFF_TO != MNTH_YR_PART_LAST_DAY THEN PREM_AMT ELSE 0 END) as out_ADDED_AMT,
        max(EFF_MD_YR_MO) as EFF_MD_YR_MO,
        max(POP_INFO_ID) as POP_INFO_ID,
        max(BATCH_ID) as BATCH_ID,
        max(MONTHLY_DATE) as out_MONTHLY_DATE,
        max(COVG_CMPNT_AGMT_ANCHR_ID) as COVG_CMPNT_AGMT_ANCHR_ID,
        max(out_COMM_AMT) as COMM_AMT,
        max(out_DER_COMM_AMT) as DER_COMM_AMT,
        SUM(CASE WHEN MNTH_YR_PART_EFF_TO != MNTH_YR_PART_LAST_DAY THEN out_DER_COMM_AMT ELSE 0 END) as out_COMM_ADDED_AMT,
        max(out_TRAN_PREM_AMT) as TRAN_PREM_AMT,
        max(TRAN_COMM_AMT) as TRAN_COMM_AMT,
        SUM(CASE WHEN MNTH_YR_PART_EFF_TO != MNTH_YR_PART_LAST_DAY THEN out_DER_TRAN_PREM_AMT ELSE 0 END) as TRAN_PREM_ADDED_AMT,
        SUM(CASE WHEN MNTH_YR_PART_EFF_TO != MNTH_YR_PART_LAST_DAY THEN out_DER_TRAN_COMM_AMT ELSE 0 END) as TRAN_COMM_ADDED_AMT,
        max(out_CONTR_PREM_AMT) as CONTR_PREM_AMT,
        SUM(CASE WHEN MNTH_YR_PART_EFF_TO != MNTH_YR_PART_LAST_DAY THEN out_DER_CONTR_PREM_AMT ELSE 0 END) as CONTR_PREM_ADDED_AMT,
        max(SRC_LN_OF_BUSN_CD41) as SRC_LN_OF_BUSN_CD41,
        max(out_CONTR_COMM_AMT41) as CONTR_COMM_AMT41,
        SUM(CASE WHEN MNTH_YR_PART_EFF_TO != MNTH_YR_PART_LAST_DAY THEN out_DER_CONTR_COMM_AMT41 ELSE 0 END) as CONTR_COMM_ADDED_AMT,
        max(CRCY_CD) as CRCY_CD,
        max(TRAN_CRCY_CD) as TRAN_CRCY_CD,
        max(CONTR_CRCY_CD) as CONTR_CRCY_CD
    from int_srt_dates
    group by
        PRTCLR_MONY_PROVSN_ID,
        ETL_SYS_NM
)

select * from int_agg_last_mnth

--End-DBShift