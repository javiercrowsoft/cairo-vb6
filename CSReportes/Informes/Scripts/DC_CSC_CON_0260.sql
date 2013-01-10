/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de Venta
---------------------------------------------------------------------*/

/*


[DC_CSC_CON_0260] 1,'20060101','20070301','0','0','0'


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0260]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0260]


go
create procedure DC_CSC_CON_0260 (

  @@us_id        int,

  @@Fini        datetime,
  @@Ffin        datetime,

  @@cli_id           varchar(255),
  @@doc_id          varchar(255),
  @@emp_id           varchar(255) 

)as 
begin

  set nocount on

declare @emp_id        int
declare @cli_id       int
declare @doc_id       int

declare @ram_id_empresa        int
declare @ram_id_cliente        int
declare @ram_id_documento     int

declare @IsRaiz     tinyint
declare @clienteID  int

exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_empresa out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente out
exec sp_ArbConvertId @@doc_id,       @doc_id out,        @ram_id_documento out
  
exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--  exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
  end else 
    set @ram_id_cliente = 0
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

  select   cue.cue_id, 
           cue_nombre                 as Cuenta, 
           sum(asi_debe)              as Debe, 
          sum(asi_haber)            as Haber,
          sum(asi_debe-asi_haber)   as saldo

  from AsientoItem asi inner join Cuenta cue on asi.cue_id = cue.cue_id

  where as_id in (

              select as_id
              from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
              where 
                    fv_fecha between @@Fini and @@Ffin
            
                and   (cli_id = @cli_id or @cli_id = 0)
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
            
                 and fv.doc_id = doc.doc_id
            
                 and (fv.emp_id = @emp_id or @emp_id = 0)
                 and (
                        (exists(select rptarb_hojaid 
                                from rptArbolRamaHoja 
                                where
                                     rptarb_cliente = @clienteID
                                and  tbl_id = 1018 
                                and  rptarb_hojaid = fv.emp_id
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

  group by
           cue.cue_id, 
           cue_nombre
end
go
 