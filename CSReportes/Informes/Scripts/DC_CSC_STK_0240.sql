/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0240]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0240]

/*
DC_CSC_STK_0240 1,619,0
*/

go
create procedure DC_CSC_STK_0240 (

  @@us_id     int

)as 
begin
set nocount on

  select   pr_id,
          '['+substring(pr_codigobarra,2,10)+']' as [Codigo Homologación], 
          pr_nombrecompra                as Producto
  
  from producto where pr_codigobarra<>''
  
  order by 2

end
GO