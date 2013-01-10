-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Cheques de terceros
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0040 1,'20000101','20041231','0','0','0','0',0,'1'

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0040]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0040]

go
create procedure DC_CSC_TSR_0040 (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@bco_id  varchar(255),
@@cli_id  varchar(255), -- TODO:EMPRESA
@@prov_id varchar(255),
@@cue_id  varchar(255),
@@cheq_id int,
@@emp_id  varchar(255)

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

declare @bco_id  int
declare @cli_id  int
declare @prov_id int
declare @cue_id  int
declare @emp_id  int -- TODO:EMPRESA

declare @ram_id_banco     int
declare @ram_id_Cliente   int
declare @ram_id_Proveedor int
declare @ram_id_Cuenta    int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@bco_id, @bco_id  out, @ram_id_banco out
exec sp_ArbConvertId @@cli_id, @cli_id  out, @ram_id_Cliente out
exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_Cuenta out
exec sp_ArbConvertId @@emp_id, @emp_id  out, @ram_id_Empresa out -- TODO:EMPRESA


exec sp_GetRptId @clienteID out


if @ram_id_banco <> 0 begin

--  exec sp_ArbGetGroups @ram_id_banco, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_banco, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_banco, @clienteID 
  end else 
    set @ram_id_banco = 0
end

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

if @ram_id_Cuenta <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Cuenta, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Cuenta, @clienteID 
  end else 
    set @ram_id_Cuenta = 0
end

-- TODO:EMPRESA
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

            cheq.cheq_id,
            o.opg_id,
            cli_nombre        as [Cliente],
            cheq_numero        as [Numero],
            cheq_numerodoc    as [Cheque],
            cheq_fechaVto      as [Fecha],
            mon_nombre        as [Moneda],
            bco_nombre        as [Banco],
            isnull(cue_nombre,'(Pago a proveedores)')         
                              as [Cuenta],
            cheq_importe      as [Importe],
            cobz_nrodoc       as [Cobranza],
            cobz_numero       as [Cobranza Numero],
            doc_nombre        as [Documento],
            emp_nombre        as [Empresa], -- TODO:EMPRESA
            cheq_descrip      as [Observaciones],
            prov_nombre       as [Proveedor],
            opg_nrodoc        as [Orden de pago],
            opg_numero        as [Numero OPG]
            

from 

      Cheque cheq inner join Cobranza  c            on cheq.cobz_id   = c.cobz_id
                  inner join CobranzaItem ci      on cheq.cheq_id   = ci.cheq_id
                  inner join Banco  b             on cheq.bco_id    = b.bco_id
                  inner join Moneda m             on cheq.mon_id    = m.mon_id
                  inner join Cliente cli           on c.cli_id       = cli.cli_id
                  inner join Documento doc        on c.doc_id       = doc.doc_id
                  inner join Empresa              on doc.emp_id     = Empresa.emp_id -- TODO:EMPRESA
                  
                  left  join OrdenPago o          on cheq.opg_id    = o.opg_id
                  left  join Proveedor p          on o.prov_id      = p.prov_id
                  left  join Cuenta cue           on cheq.cue_id    = cue.cue_id

where 

          @@Fini <= cheq_fechacobro
      and  @@Ffin >= cheq_fechacobro
      and (cheq.cheq_id = @@cheq_id or @@cheq_id = 0)

-- TODO:EMPRESA
      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
      and (
            exists(select * from UsuarioEmpresa where cli_id = c.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
          )
          
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (b.bco_id = @bco_id or @bco_id=0)
and   (c.cli_id = @cli_id or @cli_id=0)
and   (o.prov_id = @prov_id or @prov_id=0)
and   (cheq.cue_id = @cue_id or @cue_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 13 -- tbl_id de Proyecto
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
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cli.cli_id
                 ) 
           )
        or 
           (@ram_id_Cliente = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 -- select * from tabla where tbl_nombre = 'proveedor'
                  and  rptarb_hojaid = o.prov_id
                 ) 
           )
        or 
           (@ram_id_Proveedor = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- select * from tabla where tbl_nombre = 'cuenta'
                  and  rptarb_hojaid = cheq.cue_id
                 ) 
           )
        or 
           (@ram_id_cuenta = 0)
       )

-- TODO:EMPRESA
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

end
go