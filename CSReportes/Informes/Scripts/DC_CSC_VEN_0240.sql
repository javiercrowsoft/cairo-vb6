/*---------------------------------------------------------------------
Nombre: Lista las clientes sin provincia que tienen 
        al menos una factura en el rango de fechas indicado
---------------------------------------------------------------------*/
/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0240]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0240]

/*

select * from circuitocontable

DC_CSC_VEN_0240 1,'20050107','20050107','1','2'


*/
go
create procedure DC_CSC_VEN_0240 (

  @@us_id      int,
  @@Fini        datetime,
  @@Ffin        datetime
)as 
begin

  select distinct
         cli.cli_id,
         cli_nombre          as Nombre,
         cli_codigo          as Codigo,
         cli_razonsocial    as [Razon Social],
         cli_descrip        as Observacines

  from cliente cli inner join facturaventa fv on cli.cli_id = fv.cli_id
  where pro_id is null
    and fv_fecha between @@Fini and @@Ffin

end
go