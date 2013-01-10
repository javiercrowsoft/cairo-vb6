/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de ordenes de pago
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9981]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9981]

/*

select * from documento where doct_id = 1

select * from facturaventa

[DC_CSC_VEN_9981] 1,2,12

*/

go
create procedure DC_CSC_VEN_9981 (

  @@us_id        int,

  @@fHasta      datetime,

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
declare @ram_id_cliente       int
declare @ram_id_documento     int

declare @IsRaiz    tinyint
declare @clienteID int

exec sp_ArbConvertId @@emp_id,       @emp_id out,       @ram_id_empresa   out
exec sp_ArbConvertId @@cli_id,       @cli_id out,        @ram_id_cliente   out
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

--////////////////////////////////////////////////////////////////////////////////////

  create table #t_pedidos (pv_id int)

  insert into #t_pedidos (pv_id)
  
  select pv_id 
  from PedidoVenta pv inner join Documento doc on pv.doc_id = doc.doc_id
  where
        pv_fecha <= @@fHasta

    and est_id not in (5,7) -- anulado o finalizado

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

     and (doc.emp_id = @emp_id or @emp_id = 0)
     and (
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

     and (pv.doc_id = @doc_id or @doc_id = 0)
     and (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 4001
                    and  rptarb_hojaid = pv.doc_id
                   ) 
             )
          or 
             (@ram_id_documento = 0)
         )

--////////////////////////////////////////////////////////////////////////////////////

  update PedidoVentaItem set pvi_pendiente = 0
  
  where pv_id in (select pv_id from #t_pedidos)

--////////////////////////////////////////////////////////////////////////////////////

  declare @pv_id int

  declare c_pedidos insensitive cursor for select pv_id from #t_pedidos

  open c_pedidos

  fetch next from c_pedidos into @pv_id
  while @@fetch_status=0
  begin

    exec sp_DocPedidoVentaSetEstado @pv_id
    exec sp_DocPedidoVentaSetItemStock @pv_id, 0

    fetch next from c_pedidos into @pv_id
  end

  close c_pedidos
  deallocate c_pedidos

  select 1 as aux_id, 'El proceso se ejecuto con éxito, los pedidos han sido actualizados' as Info

end
go
 