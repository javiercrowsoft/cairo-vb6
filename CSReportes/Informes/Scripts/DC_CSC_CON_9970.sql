if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9970]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9970]
GO
/*  

Para testear:

[DC_CSC_CON_9970] 70,'20051001 00:00:00','20060930 00:00:00','0','0','0','0','5'

DC_CSC_CON_9970 1, 
                '20060101',
                '20060120',
                '0', 
                '0',
                '0',
                '0',
                '0'
*/

create procedure DC_CSC_CON_9970 (

  @@us_id     int,

  @@fDesde    datetime,
  @@fHasta    datetime,

  @@doc_id    int,
  @@emp_id    int,
  @@cue_id    int,
  @@ccos_id   varchar(255),
  @@cico_id    varchar(255),
  @@cue_id_si int

)as 

begin
  set nocount on

  declare @bSuccess tinyint

  exec sp_DocAsientoResumirAsientos3
                                      @@doc_id    ,
                                      @@emp_id    ,
                                      @@cue_id    ,
                                      @@cue_id_si ,
                                      @@ccos_id   ,
                                      @@cico_id    ,
                                      @@fDesde    ,
                                      @@fHasta    ,
                                      @@us_id     ,
                                      @bSuccess  out  

  if @bSuccess <> 0 begin

    select   0            as comp_id,
            0           as doct_id,
            ''          as Fecha,
            ''           as Comprobante,
            'El proceso concluyo con exito y se genero el siguiente asiento' as Observaciones

    union all

    select   as_id        as comp_id, 
            doct_id      as doct_id,
            as_fecha    as Fecha,
            as_nrodoc   as Comprobante,
            as_descrip  as Observaciones 

    from Asiento

    where as_fecha between @@fdesde and @@fhasta and as_doc_cliente like '%AR-CUENTA-%'

  end else begin

    select 0 as comp_id, 'El proceso no pudo generar los asientos de resumen' as Info

  end



end
GO