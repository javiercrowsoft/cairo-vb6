if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_GetIvasForFactura]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_GetIvasForFactura]

/*

 sp_FE_GetIvasForFactura 1

*/

go
create procedure [dbo].[sp_FE_GetIvasForFactura] (
  @@fv_id int
)

as

begin

  select   fvi_ivariporc,
          case 
                when fvi_ivariporc = 10.5 then 4
                when fvi_ivariporc = 21.0 then 5
                 when fvi_ivariporc = 21.0 then 6
          end as ivaId,
          convert(decimal(18,2),round(sum(fvi_neto),2)) as baseImp,
          convert(decimal(18,2),round(sum(fvi_ivari),2)) as importe
  from FacturaVentaItem fvi 
  where fv_id = @@fv_id and fvi_ivariporc <> 0
  group by fvi_ivariporc

end
