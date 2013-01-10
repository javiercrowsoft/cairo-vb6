if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_os_importSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_os_importSave]

/*

begin transaction

exec sp_os_importSave 14136, -1

rollback transaction

*/

go
create procedure sp_os_importSave (
  @@osTMP_ID         int,
  @@bTest            smallint,
  @@impid_id        int,
  @@impid_descrip    varchar(5000)
)
as

begin

  set nocount on

  declare @os_nrodoc varchar(255)
  declare @MsgError  varchar(255)

  -- Controlo duplicados si asi lo indica la configuracion
  --
  declare @cfg_valor varchar(5000) 
  declare @cfg_clave varchar(255) 
  set @cfg_clave = 'Controlar códigos duplicados en importación de ordenes de servicio'

  set @cfg_valor = 0
  exec sp_Cfg_GetValor  'Ventas-General',
                        @cfg_clave,
                        @cfg_valor out,
                        0
  if @@error <> 0 begin

    raiserror ('No se pudo leer la configuración general', 16, 1)
    return
  end

  set @cfg_valor = IsNull(@cfg_valor,0)

  if @@bTest <> 0 begin

    if exists(select * from OrdenServicioItemTMP osit
              where osTMP_id = @@osTMP_ID 
                and exists(select * from OrdenServicioItem osi where osi.osi_importCodigo = osit.osi_importCodigo)
                and rtrim(ltrim(osi_importCodigo)) <> ''
                and convert(int,@cfg_valor) <> 0
              )
    begin

      declare @codigo_dup  varchar(5000)
      declare @codigo_dups varchar(5000) set @codigo_dups = ''

      declare c_codigo_dup insensitive cursor for

        select osit.osi_importCodigo from OrdenServicioItemTMP osit
              where osTMP_id = @@osTMP_ID 
                and exists(select * from OrdenServicioItem osi where osi.osi_importCodigo = osit.osi_importCodigo)
                and rtrim(ltrim(osi_importCodigo)) <> ''

      open c_codigo_dup

      fetch next from c_codigo_dup into @codigo_dup
      while @@fetch_status=0
      begin

        set @codigo_dups = @codigo_dups + @codigo_dup + ', '

        fetch next from c_codigo_dup into @codigo_dup
      end

      close c_codigo_dup
      deallocate c_codigo_dup

      if len(@codigo_dups)>2 set @codigo_dups = substring(@codigo_dups,1,len(@codigo_dups)-1)

      select @os_nrodoc = Max(os_nrodoc) 
      from OrdenServicio os inner join OrdenServicioItem osi on os.os_id = osi.os_id
      where osi_importCodigo in (

              select osi_importCodigo from OrdenServicioItemTMP osit
              where osTMP_id = @@osTMP_ID 
                and exists(select * from OrdenServicioItem osi where osi.osi_importCodigo = osit.osi_importCodigo)
                
                                )    
        and rtrim(ltrim(osi_importCodigo)) <> ''
      
      set @MsgError = '@@ERROR_SP:Este código de importación ya ha sido importado ' + IsNull(@os_nrodoc,'') + ' (codigos: '+ @codigo_dups+')'
      raiserror (@MsgError, 16, 1)

    end else begin

      delete OrdenServicioItemSerieTMP where osTMP_id = @@osTMP_ID
      delete OrdenServicioItemTMP where osTMP_ID = @@osTMP_ID
      delete OrdenServicioTMP where osTMP_ID = @@osTMP_ID

      select -1

    end

  end else begin

    --/////////////////////////////////////////////////////////////////////////
    declare @prns_codigo    varchar(100)
    declare @prns_codigo2   varchar(100)
    declare @osisTMP_id     int
    declare @osiTMP_id      int
    declare @pr_id          int
    declare @os_in_codigo2   tinyint
    declare @cfg_valor2     varchar(5000) 
    
    set @cfg_clave = 'Copiar el Comprobante de la OS en el Campo prns_serie2'
  
    set @cfg_valor2 = 0
    exec sp_Cfg_GetValor  'Ventas-General',
                          @cfg_clave,
                          @cfg_valor2 out,
                          0
    if @@error <> 0 begin
  
      raiserror ('No se pudo leer la configuración general', 16, 1)
      return
    end

    set @cfg_valor2 = IsNull(@cfg_valor2,0)
    set @os_in_codigo2 = convert(int,@cfg_valor)

    if @os_in_codigo2 <> 0   set @prns_codigo2 = @os_nrodoc
    else                     set @prns_codigo2 = ''

    declare c_prns_items insensitive cursor for 
      select pr_id, osiTMP_id, osi_importCodigo from ordenServicioItemTMP where osTMP_id = @@osTMP_id

    open c_prns_items
    fetch next from c_prns_items into @pr_id, @osiTMP_id, @prns_codigo
    while @@fetch_status = 0
    begin

      exec sp_dbgetnewid 'OrdenServicioItemSerieTMP', 'osisTMP_id', @osisTMP_id out, 0
    
      insert into OrdenServicioItemSerieTMP (
                                              osis_orden
                                              ,osisTMP_id
                                              ,osiTMP_id
                                              ,osTMP_id
                                              ,pr_id
                                              ,osi_id
                                              ,prns_codigo
                                              ,prns_codigo2
                                              ,prns_codigo3
                                              ,prns_descrip
                                              ,prns_fechavto
                                              ,prns_id
                                            )
      
                                      values (
                                              1
                                              ,@osisTMP_id
                                              ,@osiTMP_id
                                              ,@@osTMP_id
                                              ,@pr_id
                                              ,0
                                              ,@prns_codigo
                                              ,@prns_codigo2
                                              ,''
                                              ,''
                                              ,'18991230'
                                              ,-1
                                            )
      --/////////////////////////////////////////////////////////////////////////
      fetch next from c_prns_items into @pr_id, @osiTMP_id, @prns_codigo
    end

    close c_prns_items
    deallocate c_prns_items

    if not exists(select * from ImportacionID where impid_id = @@impid_id)
    begin

      declare @us_id int
      select @us_id = modifico from OrdenServicioTMP where osTMP_id = @@osTMP_id

      insert into ImportacionID (impid_id, impidt_id, us_id, impid_descrip) values(@@impid_id, 1, @us_id, @@impid_descrip)
    end

    -- Llamo a las particularidades del cliente
    --
    declare @bSuccess  tinyint
    declare @MsgError2 varchar(255)

    exec sp_os_importSaveCliente @@osTMP_id, @bSuccess out, @MsgError2 out

    if @bSuccess = 0 begin

      set @MsgError = '@@ERROR_SP:Esta orden de servicio fue rechazada por las validaciones particulares del cliente ' + IsNull(@os_nrodoc,'') + '. ' + isnull(@MsgError2,'')
      raiserror (@MsgError, 16, 1)
    
      return
    end 

    declare @doc_id int
    declare @os_id  int

    select @doc_id = doc_id from OrdenServicioTMP where osTMP_id = @@osTMP_ID

    begin transaction

    exec sp_DocOrdenServicioSave @@osTMP_ID, @os_id out 

    update OrdenServicio set impid_id = @@impid_id where os_id = @os_id

    begin

      -- Controlo que no existan repeticiones en el campo codigo
      --
      if exists(select osi_importCodigo 
                from OrdenServicioItem osi inner join OrdenServicio os on osi.os_id = os.os_id
                where rtrim(ltrim(osi_importCodigo)) <> '' and doc_id = @doc_id 
                  and (exists(select * from OrdenServicioItem osi2 
                              where osi2.osi_importCodigo = osi.osi_importCodigo
                                and osi2.os_id = @os_id
                              )
                      )
                  and convert(int,@cfg_valor) <> 0
                group by osi_importCodigo having count(osi_importCodigo) > 1)
      begin
    
        select @os_nrodoc = Max(os_nrodoc) 
        from OrdenServicio os inner join OrdenServicioItem osi on os.os_id = osi.os_id
        where osi_importCodigo in (
    
                select osi_importCodigo
                from OrdenServicioItem osi inner join OrdenServicio os on osi.os_id = os.os_id
                where osi_importCodigo <> '' and doc_id = @doc_id 
                  and (exists(select * from OrdenServicioItem osi2 
                              where osi2.osi_importCodigo = osi.osi_importCodigo
                                and osi2.os_id = @os_id
                              ))
                group by osi_importCodigo having count(osi_importCodigo) > 1
          )
          and rtrim(ltrim(osi_importCodigo)) <> ''
    
        set @MsgError = '@@ERROR_SP:Este código de importación ya ha sido importado ' + IsNull(@os_nrodoc,'')
        raiserror (@MsgError, 16, 1)
      
        rollback transaction
    
      end
      else
        commit transaction
    end

  end

end
go