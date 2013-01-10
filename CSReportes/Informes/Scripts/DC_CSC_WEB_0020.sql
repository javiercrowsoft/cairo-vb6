
/*---------------------------------------------------------------------
Nombre: 
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_WEB_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_WEB_0020]

GO

/*
DC_CSC_WEB_0020 
                      1,
                      '20200101',
                      '0',
                      '0',
                      '0',
                      '0'
select * from rama where ram_nombre like '%dvd%'
select lp_id,pr_nombrecompra from producto where pr_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_WEB_0020 (

  @@us_id    int,

  @@lp_id   varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @lp_id int

declare @ram_id_Listaprecio int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@lp_id, @lp_id out, @ram_id_Listaprecio out

if @lp_id <> 0 begin

  declare @cfg_valor varchar(5000) 
  set @cfg_valor = convert(varchar,@lp_id)
  exec sp_Cfg_SetValor 'Catalogo Web',
                       'Lista de Precios', 
                       @cfg_valor

  select 1, 'La configuración se actualizo con éxito' as Info, '' as dummy
  union all
  select 1, 'Se ha configurado la siguiente lista para obtener' as Info, '' as dummy
  union all
  select 1, 'los precios que se muestran en el catalogo web' as Info, '' as dummy
  union all
  select 1, lp_nombre, '' as dummy
  from ListaPrecio where lp_id = @lp_id

end else begin

  select 1, 'Debe seleccionar una sola lista de precios' as Info, '' as dummy

end

GO