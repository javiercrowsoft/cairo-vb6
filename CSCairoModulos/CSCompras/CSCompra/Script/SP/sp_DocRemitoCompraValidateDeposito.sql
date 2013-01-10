-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraValidateDeposito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraValidateDeposito]

go

create procedure sp_DocRemitoCompraValidateDeposito (

  @@rcTMP_id    int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  declare @bError tinyint

  set @bError     = 0
  set @@bSuccess   = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  declare @llevaStock tinyint
  select @llevaStock = doc_muevestock 
  from Documento doc inner join RemitoCompraTMP rc on doc.doc_id = rc.doc_id
  where rc.rcTMP_id = @@rcTMP_id

  if @llevaStock <> 0 begin

    if exists(select * 
              from RemitoCompraItemTMP rci 
                      inner join RemitoCompraTMP rc 
                              on rci.rcTMP_id = rc.rcTMP_id
                      inner join Documento doc
                              on rc.doc_id = doc.doc_id
              where
                    rc.rcTMP_id = @@rcTMP_id
                and  not exists(select * from ProductoDepositoEntrega where pr_id = rci.pr_id and depl_id = rc.depl_id and suc_id = rc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = rc.prov_id))
                and  exists(select * from ProductoDepositoEntrega where pr_id = rci.pr_id and depl_id <> rc.depl_id and suc_id = rc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = rc.prov_id))
              ) begin
  
  
        declare @depl_nombre varchar(255)
  
        select @depl_nombre = depl_nombre
        from RemitoCompraTMP rc inner join DepositoLogico depl
                on rc.depl_id = depl.depl_id
        where rc.rcTMP_id = @@rcTMP_id
  
        declare c_productos insensitive cursor for
        select pr_nombrecompra 
              from RemitoCompraItemTMP rci 
                      inner join RemitoCompraTMP rc 
                              on rci.rcTMP_id = rc.rcTMP_id
                      inner join Producto pr
                              on rci.pr_id = pr.pr_id
                      inner join Documento doc
                              on rc.doc_id = doc.doc_id
              where
                    rc.rcTMP_id = @@rcTMP_id
                and  not exists(select * from ProductoDepositoEntrega where pr_id = rci.pr_id and depl_id = rc.depl_id and suc_id = rc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = rc.prov_id))
                and  exists(select * from ProductoDepositoEntrega where pr_id = rci.pr_id and depl_id <> rc.depl_id and suc_id = rc.suc_id and emp_id = doc.emp_id and (prov_id is null or prov_id = rc.prov_id))
  
        declare @pr_nombrecompra varchar(2000)
        declare @productos        varchar(8000)
  
        set @productos = ''
  
        open c_productos
  
        fetch next from c_productos into @pr_nombrecompra
        while @@fetch_status=0
        begin
  
          set @productos = @productos + @pr_nombrecompra + char(10)
  
          fetch next from c_productos into @pr_nombrecompra
        end
        close c_productos
        deallocate c_productos
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'Este remito indica articulos que no estan habilitados para ingresar en el deposito ' 
                                      + char(10)+ char(10)+ @depl_nombre + char(10)+ char(10)  
                                      + 'Los articulos son:' + char(10) + char(10) + @productos
  
    end
  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO