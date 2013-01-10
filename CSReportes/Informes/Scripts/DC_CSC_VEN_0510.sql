/*---------------------------------------------------------------------
Nombre: Clientes con Provincia y Vendedor para Exportar a Excel
---------------------------------------------------------------------*/

/*
Para testear:

DC_CSC_VEN_0510 
                    1,
                    '0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0510]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0510]

go
create procedure DC_CSC_VEN_0510 (

  @@us_id    int,

  @@cli_id        varchar(255)
)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id  int
declare @suc_id  int

declare @ram_id_Cliente   int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente   out

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
  end else 
    set @ram_id_Cliente = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select  

        cli_id,
        cli_nombre,
        cli_codigo,
        cli_contacto,
        cli_razonsocial,
        cli_cuit,
        cli_ingresosbrutos,
        cli_catfiscal,
        cli_chequeorden,
        cli_codpostal,
        cli_localidad,
        cli_calle,
        cli_callenumero,
        cli_piso,
        cli_depto,
        cli_tel,
        cli_fax,
        cli_email,
        cli_web,
        ven_nombre,
        pro_nombre,
        pa_nombre,
        cli_descrip
 
from cliente cli left join vendedor ven  on cli.ven_id = ven.ven_id
                 left join provincia pro on cli.pro_id = pro.pro_id
                 left join pais pa on pro.pa_id = pa.pa_id

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.cli_id  = @cli_id  or @cli_id =0)

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

end

go

