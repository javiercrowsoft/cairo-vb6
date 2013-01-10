/*---------------------------------------------------------------------
Nombre: Listado de ventas por provincia resumido
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_COM_0190 1, '20050101','20050131','0', '0','1','0','0','2'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0190]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0190]

go
create procedure DC_CSC_COM_0190 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime,

  @@pro_id           varchar(255),
  @@prov_id         varchar(255),
  @@cico_id           varchar(255),
  @@doc_id           varchar(255),
  @@mon_id           varchar(255),
  @@emp_id           varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pro_id       int
declare @prov_id       int
declare @cico_id      int
declare @doc_id       int
declare @mon_id       int
declare @emp_id       int

declare @ram_id_provincia        int
declare @ram_id_proveedor        int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int

declare @clienteID   int
declare @IsRaiz      tinyint

exec sp_ArbConvertId @@pro_id,       @pro_id out,        @ram_id_provincia out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor out
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
exec sp_ArbConvertId @@mon_id,       @mon_id out,        @ram_id_moneda out
exec sp_ArbConvertId @@emp_id,       @emp_id out,        @ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_provincia <> 0 begin

--  exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
  end else 
    set @ram_id_provincia = 0
end

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
end

if @ram_id_circuitoContable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
  end else 
    set @ram_id_circuitoContable = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_moneda <> 0 begin

--  exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
  end else 
    set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
    isnull(pro1.pro_id,pro2.pro_id),
    1                                         as orden_id,
    IsNull(pro1.pro_codigo,pro2.pro_codigo)    as Codigo,
    IsNull(IsNull(pro1.pro_nombre,pro2.pro_nombre)
            ,'Proveedores sin provincia')     as Provincia,

    sum(case doc.doct_id
          when 8  then -fc_neto
          else          fc_neto
        end
        )                   as Neto,

    sum(case doc.doct_id
          when 8  then -(fc_ivari+fc_ivarni)
          else          fc_ivari+fc_ivarni
        end
        )                   as IVA,
    0                       as [Otros Impuestos],
    sum(case doc.doct_id
          when 8  then -fc_total
          else          fc_total
        end
        )            as Total

from 

  facturacompra fc inner join proveedor prov        on fc.prov_id   = prov.prov_id 
                   inner join documento doc         on fc.doc_id    = doc.doc_id
                   inner join moneda    mon         on fc.mon_id    = mon.mon_id
                   inner join circuitocontable cico on doc.cico_id  = cico.cico_id
                   inner join empresa   emp         on doc.emp_id   = emp.emp_id

                    left join provincia   pro1        on fc.pro_id_destino = pro1.pro_id
                    left join provincia   pro2        on prov.pro_id        = pro2.pro_id

where 

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin 

      and fc.est_id <> 7 -- Anuladas

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (    fc.pro_id_destino  = @pro_id 
       or  prov.pro_id       = @pro_id   
                                or @pro_id=0)
and   (fc.prov_id   = @prov_id   or @prov_id=0)
and   (doc.cico_id  = @cico_id   or @cico_id=0)
and   (fc.doc_id    = @doc_id   or @doc_id=0)
and   (fc.mon_id    = @mon_id   or @mon_id=0)
and   (doc.emp_id   = @emp_id   or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 6 
                  and  rptarb_hojaid = prov.pro_id
                 ) 
           )
        or 
           (@ram_id_provincia = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 
                  and  (rptarb_hojaid = fc.prov_id or rptarb_hojaid = fc.pro_id_destino)
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
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = doc.cico_id
                 ) 
           )
        or 
           (@ram_id_circuitoContable = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 
                  and  rptarb_hojaid = fc.doc_id
                 ) 
           )
        or 
           (@ram_id_documento = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 12 
                  and  rptarb_hojaid = fc.mon_id
                 ) 
           )
        or 
           (@ram_id_moneda = 0)
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
           (@ram_id_empresa = 0)
       )

group by 
    IsNull(pro1.pro_id,pro2.pro_id),
    IsNull(pro1.pro_codigo,pro2.pro_codigo),
    IsNull(IsNull(pro1.pro_nombre,pro2.pro_nombre),'Proveedores sin provincia') 

end
go

