/*---------------------------------------------------------------------
Nombre: Listado de Cheques
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0140 1,'0000115','0','0','0','0','0'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0140]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0140]

go
create procedure DC_CSC_TSR_0140 (

  @@us_id    int,

  @@cheq_numerodoc  varchar(255),
  @@cue_id          varchar(255),
  @@bco_id          varchar(255),
  @@cli_id          varchar(255),
  @@prov_id          varchar(255), 
  @@emp_id          varchar(255)

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

declare @cue_id   int
declare @bco_id   int
declare @cli_id   int
declare @prov_id   int
declare @emp_id   int  --TODO:EMPRESA

declare @ram_id_cuenta     int
declare @ram_id_banco     int
declare @ram_id_cliente   int
declare @ram_id_proveedor int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,   @cue_id out,   @ram_id_cuenta out
exec sp_ArbConvertId @@bco_id,   @bco_id out,   @ram_id_banco out
exec sp_ArbConvertId @@cli_id,   @cli_id out,   @ram_id_cliente out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_proveedor out
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

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
end


if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end

set @@cheq_numerodoc = '%' + @@cheq_numerodoc + '%'

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  select top 4000
      c.cobz_id        as comp_id,
      cobz.doct_id    as doct_id,
      cli_nombre       as Cliente,
      prov_nombre      as Proveedor,
      cheq_numerodoc  as Cheque,
      cheq_importe    as Monto,
      cue_nombre      as Cuenta,
      cobz_nrodoc     as Cobranza,
      cobz_fecha      as [Fecha Cobz.],
      opg_nrodoc      as [Orden de Pago],
      opg_fecha       as [Fecha OP],
      mf_nrodoc       as [Movimiento de Fondos],
      cheq_numero     as Numero,
      cheq_fechacobro  as Cobro,
      cle_nombre      as Clearing,
      bco_nombre      as Banco,
      cheq_descrip    as Observaciones
  
  from Cheque c left join Cliente cli on c.cli_id = cli.cli_id
                left join Proveedor prov on c.prov_id = prov.prov_id
                left join Cobranza cobz on c.cobz_id = cobz.cobz_id
                left join OrdenPago opg on c.opg_id = opg.opg_id
                left join MovimientoFondo mf on c.mf_id = mf.mf_id
                left join Cuenta cue on c.cue_id = cue.cue_id
                left join Clearing cle on c.cle_id = cle.cle_id
                left join Banco bco on c.bco_id = bco.bco_id 

  where c.cheq_numerodoc like @@cheq_numerodoc
  
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (c.cue_id  = @cue_id or @cue_id=0)
  and   (c.bco_id  = @bco_id or @bco_id=0)
  and   (c.cli_id  = @cli_id or @cli_id=0)
  and   (c.prov_id = @prov_id or @prov_id=0)
  and   (c.emp_id  = @emp_id or @emp_id=0) 
  
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
                    and  rptarb_hojaid = c.bco_id
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
                    and  tbl_id = 29 
                    and  rptarb_hojaid = c.prov_id
                   ) 
             )
          or 
             (@ram_id_proveedor = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 28 
                    and  rptarb_hojaid = c.cli_id
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
                    and  rptarb_hojaid = c.emp_id
                   ) 
             )
          or 
             (@ram_id_Empresa = 0)
         )

end
GO