/*---------------------------------------------------------------------
Nombre: Comprobantes cuyos asientos y totales no coinciden
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_CON_0230 1, 
                '20061201',
                '20061231'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0230]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0230]

go
create procedure DC_CSC_CON_0230 (

  @@us_id        int,
  @@fdesde       datetime,
  @@fhasta       datetime

)as 
begin

set nocount on

  select   1             as aux,
          fc.fc_id      as comp_id,
          fc.doct_id    as doct_id,
          fc_fecha      as Fecha,
          fc_fechaiva   as [Fecha Iva],
          prov_nombre    as Proveedor,
          fc_nrodoc     as Comprobante,
          fc_numero     as Numero,
          fc_total      as Total,
         (select sum(asi_debe) 
          from asientoitem 
          where as_id = fc.as_id 
          group by as_id 
          )  as Asiento,

         (case when doct_id = 8 then -fc_total else fc_total end) 
        -
         (select sum(asi_debe) 
          from asientoitem 
          where as_id = fc.as_id 
          group by as_id 
          )  as Dif

  
  from facturacompra fc inner join proveedor prov on fc.prov_id = prov.prov_id
  where fc_fechaiva between @@fdesde and @@fhasta
  
    and

        exists( select * from asientoitem 
                where as_id = fc.as_id 
                group by as_id 
                having abs(sum(asi_debe) - (case when doct_id = 8 then -fc_total else fc_total end))>0.01)

end
GO