/*---------------------------------------------------------------------
Nombre: Cobros en mercado pago
---------------------------------------------------------------------*/

/*DC_CSC_CVX_0010 1, '20100101', '20101231', '0' */

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CVX_0010]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CVX_0010]

GO
create procedure DC_CSC_CVX_0010 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cli_id   varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int

declare @ram_id_cliente int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out

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


select 

        cmic_id,
        cmic_cobroid        as [Cobro Id],
        cmic_nick            as Nick,
        cmic_articulo        as Articulo,
        cmic_articuloid      as [Articulo Id],
        cmic_estado          as Estado,
        cmic_cobrado        as Cobrado,
        cmic_fechastr        as [Fecha Str],
        cmic_fecha          as Fecha,
        cmi_nombre          as Comunidad,
        cli_nombre          as Cliente,
        cli_codigo          as [Codigo],
        cli_codigocomunidad as [Codigo Comunidad],
        pr_nombreventa      as Articulo,
        pv_nrodoc            as Comprobante,
        pv_fecha            as [Fecha Pedido],
        cmic.creado          as Creado,
        cmic_descrip        as Observaciones

from 

      ComunidadInternetCobro cmic left join Cliente cli on cmic.cli_id = cli.cli_id
                                  left join Producto pr on cmic.pr_id = pr.pr_id
                                  left join ComunidadInternet cmi on cmic.cmi_id = cmi.cmi_id
                                  left join PedidoVenta pv on cmic.pv_id = pv.pv_id
where 

          cmic_fecha >= @@Fini
      and  cmic_fecha <= @@Ffin 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.cli_id        = @cli_id or @cli_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28
                  and  rptarb_hojaid = cmic.cli_id
                 ) 
           )
        or 
           (@ram_id_cliente = 0)
       )

order by cmic_fecha

GO