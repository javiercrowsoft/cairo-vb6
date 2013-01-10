
/*---------------------------------------------------------------------
Nombre: Compras por proveedor y articulo
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0030]

/*
DC_CSC_COM_0030 1,
                '20060101',
                '20060105',
                '0',
                '0',
                '0',
                '1'
*/

go
create procedure DC_CSC_COM_0030(

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

  @@cico_id          varchar(255),
  @@pr_id            varchar(255),
  @@prov_id         varchar(255),
  @@emp_id           varchar(255)

) 

as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id         int
declare @prov_id       int
declare @emp_id       int 
declare @cico_id      int

declare @ram_id_producto          int
declare @ram_id_proveedor         int
declare @ram_id_Empresa          int 
declare @ram_id_circuitoContable int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id,        @pr_id out,         @ram_id_producto out
exec sp_ArbConvertId @@prov_id,      @prov_id out,       @ram_id_proveedor out
exec sp_ArbConvertId @@emp_id,        @emp_id out,       @ram_id_Empresa out 
exec sp_ArbConvertId @@cico_id,      @cico_id out,       @ram_id_circuitoContable out

exec sp_GetRptId @clienteID out

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
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

if @ram_id_circuitoContable <> 0 begin

--  exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
  end else 
    set @ram_id_circuitoContable = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
      2                                         as Orden,
      pr_nombrecompra                            as Articulo,
      prov_nombre                               as Proveedor,

      sum(case doc.doct_id
        when 8  then -(fci_neto
                            - (fci_neto * fc_descuento1 / 100)
                            - (
                                (
                                  fci_neto - (fci_neto * fc_descuento1 / 100)
                                ) * fc_descuento2 / 100
                              )
                          )
        else          (fci_neto
                            - (fci_neto * fc_descuento1 / 100)
                            - (
                                (
                                  fci_neto - (fci_neto * fc_descuento1 / 100)
                                ) * fc_descuento2 / 100
                              )
                          )
      end
          )                                       as [compras neto],

      sum(case doc.doct_id
        when 8  then -((fci_ivari+fci_ivarni)
                            - ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
                            - (
                                (
                                  (fci_ivari+fci_ivarni) - ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
                                ) * fc_descuento2 / 100
                              )
                          )
        else         ((fci_ivari+fci_ivarni)
                            - ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
                            - (
                                (
                                  (fci_ivari+fci_ivarni) - ((fci_ivari+fci_ivarni) * fc_descuento1 / 100)
                                ) * fc_descuento2 / 100
                              )
                        )
      end
          )                                       as ivacompras,

      sum(case doc.doct_id
        when 8  then -(fci_importe
                            - (fci_importe * fc_descuento1 / 100)
                            - (
                                (
                                  fci_importe - (fci_importe * fc_descuento1 / 100)
                                ) * fc_descuento2 / 100
                              )
                          )
        else          (fci_importe
                            - (fci_importe * fc_descuento1 / 100)
                            - (
                                (
                                  fci_importe - (fci_importe * fc_descuento1 / 100)
                                ) * fc_descuento2 / 100
                              )
                          )
      end
          )                                       as compras,

      sum(case doc.doct_id
            when 8  then -(fci_cantidad)
            else          fci_cantidad
          end
          )                                      as [cant. compras]

from

      Producto pr inner join FacturaCompraItem fci   on pr.pr_id   = fci.pr_id
                  inner join FacturaCompra fc        on fci.fc_id  = fc.fc_id
                  inner join Documento doc           on fc.doc_id  = doc.doc_id
                  inner join Empresa emp             on doc.emp_id = emp.emp_id 
                  inner join Proveedor prov          on fc.prov_id = prov.prov_id
where 

          fc_fecha >= @@Fini
      and  fc_fecha <= @@Ffin

      and fc.est_id <> 7 -- Todas menos anuladas

      and (
            exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (pr.pr_id     = @pr_id     or @pr_id   =0)
and   (doc.cico_id   = @cico_id  or @cico_id =0)
and   (emp.emp_id   = @emp_id   or @emp_id  =0) 
and   (fc.prov_id   = @prov_id  or @prov_id =0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 -- tbl_id de Proyecto
                  and  rptarb_hojaid = fci.pr_id
                 ) 
           )
        or 
           (@ram_id_producto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 
                  and  rptarb_hojaid = fc.prov_id
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
                  and  tbl_id = 1018
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )

group by pr_nombrecompra,prov_nombre

order by pr_nombrecompra, prov_nombre, orden

end
go