if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AfipGetCuitForConstancia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AfipGetCuitForConstancia]

/*

sp_AfipGetCuitForConstancia '0',1,'0',1

*/

go
create procedure sp_AfipGetCuitForConstancia(

  @@cli_id       varchar(255),
  @@bcliente     smallint,
  @@prov_id      varchar(255),
  @@bproveedor  smallint
)
  
as 
begin

  set nocount on

declare @cli_id   int
declare @prov_id  int

declare @ram_id_Cliente   int
declare @ram_id_Proveedor int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
  end else 
    set @ram_id_Cliente = 0
end

if @ram_id_Proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
end

select cli_codigo       as codigo,
       cli_nombre        as nombre, 
       cli_cuit          as cuit,
       'Cliente'        as QueEs

from cliente cli

where 
      cli_cuit <> ''
      and @@bcliente <> 0
      and (cli.cli_id = @cli_id or @cli_id=0)

      -- Arboles
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 28 
                        and  rptarb_hojaid = cli.cli_id
                       ) 
                 )
              or 
                 (@ram_id_Cliente = 0)
             )

union all

select prov_codigo       as codigo,
       prov_nombre      as nombre, 
       prov_cuit        as cuit,
       'Proveedor'      as QueEs

from proveedor prov

where 
      prov_cuit <> ''
      and @@bproveedor <> 0
      and (prov.prov_id = @prov_id or @prov_id=0)

      -- Arboles
      and   (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 29 
                        and  rptarb_hojaid = prov.prov_id
                       ) 
                 )
              or 
                 (@ram_id_Proveedor = 0)
             )

end

GO