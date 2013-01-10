if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaGetCuentaAcreedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaGetCuentaAcreedor]

go

/*

select * from cuentacategoria

exec sp_DocCobranzaGetCuentaAcreedor '13,14,19,20,21,22,23,24,25,26,27,28'

sp_DocCobranzaGetCuentaAcreedor '1'

*/

create procedure sp_DocCobranzaGetCuentaAcreedor (
  @@strIds             varchar(5000)
)
as

begin

  declare @cue_acreedoresXvta int 
  set @cue_acreedoresXvta = 8

  declare @timeCode datetime
  set @timeCode = getdate()
  exec sp_strStringToTable @timeCode, @@strIds, ','

  select

      fc_id,
      c.cue_id,
      c.cue_nombre

  from AsientoItem inner join FacturaCompra           on AsientoItem.as_id    = FacturaCompra.as_id
                   inner join TmpStringToTable        on FacturaCompra.fc_id   = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                   inner join Cuenta c                on AsientoItem.cue_id   = c.cue_id
  where 
          asi_haber      <> 0
    and   tmpstr2tbl_id =  @timeCode
    and   cuec_id       =  @cue_acreedoresXvta

  group by fc_id,c.cue_id,cue_nombre

end
go