/*---------------------------------------------------------------------
Nombre: Proceso actualizador de Transporte
---------------------------------------------------------------------*/
/*  

Para testear:
DC_CSC_VEN_9995 1,1135,0,1,0

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9995]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9995]

go
create procedure DC_CSC_VEN_9995 (

  @@us_id        int,

  @@cli_id             varchar(255),
  @@exigeTransporte     smallint,
  @@exigeProvincia     smallint,
  @@pciaTransporte     smallint

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


declare @cli_id           int

declare @ram_id_cliente          int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

update cliente 

set 
    cli_pciaTransporte  = case @@pciaTransporte  when 0 then 0 else 1 end,
    cli_exigeProvincia  = case @@exigeProvincia  when 0 then 0 else 1 end,
    cli_exigeTransporte = case @@exigeTransporte when 0 then 0 else 1 end


where 

  (cli_id   = @cli_id  or @cli_id=0)

-- Arboles

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = cli_id
                 ) 
           )
        or 
           (@ram_id_cliente = 0)
       )

select 

    cli_id, 
    cli_nombre           as Nombre, 
    cli_razonsocial     as [Razon Social],
    cli_pciaTransporte  as [Toma Transp desde Pcia],  
    cli_exigeProvincia  as [Exige Pcia.],  
    cli_exigeTransporte as [Exige Transp.]

from cliente cli

where 

  (cli.cli_id   = @cli_id  or @cli_id=0)

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
           (@ram_id_cliente = 0)
       )

end
go