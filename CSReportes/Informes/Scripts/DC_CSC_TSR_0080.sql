
/*---------------------------------------------------------------------
Nombre: Cheques emitidos
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0080 1,'20000101','20051231','0','0','0','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0080]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0080]

go
create procedure DC_CSC_TSR_0080 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cue_id  varchar(255),
  @@bco_id  varchar(255),
  @@cli_id  varchar(255),
  @@tjc_id  varchar(255), 
  @@emp_id  varchar(255),
  @@cupon   varchar(255)

)as 

begin

set nocount on

set @@cupon = replace(@@cupon,'*','%')

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id   int
declare @bco_id   int
declare @cli_id   int
declare @tjc_id   int
declare @emp_id   int  

declare @ram_id_cuenta           int
declare @ram_id_banco           int
declare @ram_id_cliente         int
declare @ram_id_tarjetaCredito  int
declare @ram_id_Empresa         int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,   @cue_id out,   @ram_id_cuenta out
exec sp_ArbConvertId @@bco_id,   @bco_id out,   @ram_id_banco out
exec sp_ArbConvertId @@cli_id,   @cli_id out,   @ram_id_cliente out
exec sp_ArbConvertId @@tjc_id,  @tjc_id out,  @ram_id_tarjetaCredito out
exec sp_ArbConvertId @@emp_id,   @emp_id out,   @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
  end else 
    set @ram_id_cuenta = 0
end

if @ram_id_banco <> 0 begin

--  exec sp_ArbGetGroups @ram_id_banco, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_banco, @clienteID 
  end else 
    set @ram_id_banco = 0
end

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
end

if @ram_id_tarjetaCredito <> 0 begin

--  exec sp_ArbGetGroups @ram_id_tarjetaCredito, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_tarjetaCredito, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_tarjetaCredito, @clienteID 
  end else 
    set @ram_id_tarjetaCredito = 0
end


if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

            tjcc_id,

            cobz.doct_id      as doct_id,
            tjcc.cobz_id      as comp_id,

            emp_nombre        as [Empresa],
            doc.doc_nombre    as [Doc. Cobranza],
            cobz_nrodoc       as [Cobranza],
            cobz_numero       as [Cobranza Numero],
            cli_codigo        as [Codigo],
            cli_nombre        as [Cliente],
            bco_nombre        as [Banco],
            c.cue_nombre      as [Cuenta],
            mon_nombre        as [Moneda],
            tjc_nombre        as [Tarjeta],
            tjccu_cantidad    as [Cuotas],
            tjcc_numero        as [Numero],
            tjcc_numerodoc    as [Comprobante],
            cobz_fecha        as [Fecha Cobranza],
            tjcc_fechaVto      as [Fecha Vto.],
            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
            tjcc_importe      as [Importe],

            case when tjcc_descrip <> '' then tjcc_descrip
                 else                         cobz_descrip     
            end as [Observaciones]

from 

      TarjetaCreditoCupon tjcc 
                  inner join TarjetaCredito tjc   on tjcc.tjc_id        = tjc.tjc_id

                  inner join TarjetaCreditoCuota tjccu on tjcc.tjccu_id = tjccu.tjccu_id

                  inner join Cuenta cuebco        on tjc.cue_id_banco    = cuebco.cue_id
                  inner join Banco  b             on cuebco.bco_id      = b.bco_id
                  inner join Moneda m             on tjcc.mon_id         = m.mon_id
                  inner join Cliente cli          on tjcc.cli_id        = cli.cli_id
                  inner join Cobranza cobz        on tjcc.cobz_id       = cobz.cobz_id
                  inner join Documento doc        on cobz.doc_id        = doc.doc_id
                  inner join Empresa emp          on doc.emp_id          = emp.emp_id 
                  left  join Cuenta c             on tjcc.cue_id         = c.cue_id
                  left  join Legajo l             on cobz.lgj_id        = l.lgj_id

where 

          @@Fini <= cobz_fecha
      and  @@Ffin >= cobz_fecha

      and (tjcc_numerodoc like @@cupon or @@cupon = '')

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where cli_id = tjcc.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )
          

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (c.cue_id = @cue_id or @cue_id=0)
and   (b.bco_id = @bco_id or @bco_id=0)
and   (tjcc.cli_id = @cli_id or @cli_id=0)
and   (tjcc.tjc_id = @tjc_id or @tjc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = c.cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 13 
                  and  rptarb_hojaid = b.bco_id
                 ) 
           )
        or 
           (@ram_id_banco = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 16
                  and  rptarb_hojaid = tjcc.tjc_id
                 ) 
           )
        or 
           (@ram_id_tarjetaCredito = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = tjcc.cli_id
                 ) 
           )
        or 
           (@ram_id_cliente = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

end
go