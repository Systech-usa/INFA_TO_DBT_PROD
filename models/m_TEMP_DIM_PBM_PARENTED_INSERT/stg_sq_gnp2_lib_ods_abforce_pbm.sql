{{ config(materialized='view', tags=["m_TEMP_DIM_PBM_PARENTED_INSERT"]) }}

-- SQ_GNP2_LIB_ODS_ABFORCE_PBM
with source_data as (
    select * from {{ source('GNP2ODS', 'ODS_ABFORCE_PBM') }} ODS_ABFORCE_PBM
    where BATCH_ID='{{ var('BATCH_ID') }}' and ROW_STAT_CD='PASS'
)

select * from source_data