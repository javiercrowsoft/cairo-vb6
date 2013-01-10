/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de compra
---------------------------------------------------------------------*/

/*


[DC_CSC_CON_0250] 1,'20060101','20070301','0','0','0'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0250]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0250]


go
create procedure DC_CSC_CON_0250 (

  @@us_id        int,

  @@Fini        datetime,
  @@Ffin        datetime,

  @@prov_id         varchar(255),
  @@doc_id          varchar(255),
  @@emp_id           varchar(255),

  @@soloacreedor    smallint

)as 
begin

  set nocount on

declare @emp_id        int
declare @prov_id       int
declare @doc_id       int

declare @ram_id_empresa        int
declare @ram_id_proveedor     int
declare @ram_id_documento     int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_empresa out
exec sp_ArbConvertId @@prov_id,       @prov_id out,      @ram_id_proveedor out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
  
exec sp_GetRptId @clienteID out

if @ram_id_proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
  end else 
    set @ram_id_proveedor = 0
end

if @ram_id_documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
  end else 
    set @ram_id_documento = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end


  select   
          cue.cue_id, 
          'Facturas / NC / ND'      as [Tipo de Documento],
           cue_nombre                 as Cuenta, 
           sum(asi_debe)              as Debe, 
          sum(asi_haber)            as Haber,
          sum(asi_debe-asi_haber)   as saldo

  from AsientoItem asi inner join Cuenta cue on asi.cue_id = cue.cue_id

  where as_id in (

              select as_id
              from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
              where 
                    fc_fecha between @@Fini and @@Ffin
            
                and   (prov_id = @prov_id or @prov_id = 0)
                and   (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 29 
                                and  rptarb_hojaid = prov_id
                               ) 
                         )
                      or 
                         (@ram_id_proveedor = 0)
                     )                  
            
                 and fc.doc_id = doc.doc_id
            
                 and (emp_id = @emp_id or @emp_id = 0)
                 and (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 1018 
                                and  rptarb_hojaid = emp_id
                               ) 
                         )
                      or 
                         (@ram_id_empresa = 0)
                     )
            
            
                  and  (doc.doc_id = @doc_id or @doc_id = 0)
                  and (
                          (exists(select rptarb_hojaid 
                                  from rptArbolRamaHoja 
                                  where
                                       rptarb_cliente = @clienteID
                                  and  tbl_id = 4001 
                                  and  rptarb_hojaid = doc.doc_id
                                 ) 
                           )
                        or 
                           (@ram_id_documento = 0)
                       )
            
        )

    and (asi_tipo = 2 or @@soloacreedor = 0)

  group by
           cue.cue_id, 
           cue_nombre

  union all

  select   
          cue.cue_id, 
          'Ordenes de Pago'          as [Tipo de Documento],
           cue_nombre                 as Cuenta, 
           sum(asi_debe)              as Debe, 
          sum(asi_haber)            as Haber,
          sum(asi_debe-asi_haber)   as saldo

  from AsientoItem asi inner join Cuenta cue on asi.cue_id = cue.cue_id

  where as_id in (

              select as_id
              from OrdenPago opg inner join Documento doc on opg.doc_id = doc.doc_id
              where 
                    opg_fecha between @@Fini and @@Ffin
            
                and   (prov_id = @prov_id or @prov_id = 0)
                and   (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 29 
                                and  rptarb_hojaid = prov_id
                               ) 
                         )
                      or 
                         (@ram_id_proveedor = 0)
                     )                  
            
                 and opg.doc_id = doc.doc_id
            
                 and (opg.emp_id = @emp_id or @emp_id = 0)
                 and (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 1018 
                                and  rptarb_hojaid = opg.emp_id
                               ) 
                         )
                      or 
                         (@ram_id_empresa = 0)
                     )
            
            
                  and  (doc.doc_id = @doc_id or @doc_id = 0)
                  and (
                          (exists(select rptarb_hojaid 
                                  from rptArbolRamaHoja 
                                  where
                                       rptarb_cliente = @clienteID
                                  and  tbl_id = 4001 
                                  and  rptarb_hojaid = doc.doc_id
                                 ) 
                           )
                        or 
                           (@ram_id_documento = 0)
                       )
            
        )

      and (
              asi.cue_id in (

                  select opgi.cue_id
                  from OrdenPago opg inner join Documento doc on opg.doc_id = doc.doc_id
                                     inner join OrdenPagoItem opgi on opg.opg_id = opgi.opgi_id
                  where 
                        opg_fecha between @@Fini and @@Ffin
                
                    and opgi_tipo = 5 -- Cuenta corriente
    
                    and   (prov_id = @prov_id or @prov_id = 0)
                    and   (
                            (exists(select rptarb_hojaid 
                                    from rptArbolRamaHoja 
                                    where
                                         rptarb_cliente = @clienteID
                                    and  tbl_id = 29 
                                    and  rptarb_hojaid = prov_id
                                   ) 
                             )
                          or 
                             (@ram_id_proveedor = 0)
                         )                  
                
                     and opg.doc_id = doc.doc_id
                
                     and (opg.emp_id = @emp_id or @emp_id = 0)
                     and (
                            (exists(select rptarb_hojaid 
                                    from rptArbolRamaHoja 
                                    where
                                         rptarb_cliente = @clienteID
                                    and  tbl_id = 1018 
                                    and  rptarb_hojaid = opg.emp_id
                                   ) 
                             )
                          or 
                             (@ram_id_empresa = 0)
                         )
                
                
                      and  (doc.doc_id = @doc_id or @doc_id = 0)
                      and (
                              (exists(select rptarb_hojaid 
                                      from rptArbolRamaHoja 
                                      where
                                           rptarb_cliente = @clienteID
                                      and  tbl_id = 4001 
                                      and  rptarb_hojaid = doc.doc_id
                                     ) 
                               )
                            or 
                               (@ram_id_documento = 0)
                           )
                  )

            or (@@soloacreedor = 0)
        )

  group by
           cue.cue_id, 
           cue_nombre


end
go
 