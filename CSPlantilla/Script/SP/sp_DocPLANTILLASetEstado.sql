if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCSetEstado]

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
CAMPO_FIRMADO                reemplazar por el nombre del campo firmado ej. pv_firmado

 select * from estado

1  Pendiente                pend  
2  Pendiente de Despachar  desp  
3  Pendiente de Crédito    cred  
4  Pendiente de Firma      firma  
5  Finalizado              fin     
6  Rechazado                rechazado     

select * from clientecachecredito

 select * from NOMBRE_TABLA
 select * from NOMBRE_TABLAitem

 sp_col NOMBRE_TABLAitem

 select * from NOMBRE_TABLAtmp
 select * from NOMBRE_TABLAitemtmp
 sp_DocNOMBRE_DOCSetEstado 21
*/

go
create procedure sp_DocNOMBRE_DOCSetEstado (
  PARAM_ID       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if PARAM_ID = 0 return

  declare @est_id          int
  declare @cli_id          int
  declare @pendiente       decimal (18,6)
  declare @creditoTotal    decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint

  declare @estado_pendienteDespacho int set @estado_pendienteDespacho =2
  declare @estado_pendienteCredito  int set @estado_pendienteCredito  =3
  declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
  declare @estado_anulado           int set @estado_anulado           = 7

  select @cli_id = cli_id, @firmado = CAMPO_FIRMADO, @est_id = est_id
  from NOMBRE_TABLA where CAMPO_ID = PARAM_ID

  if @est_id <> @estado_anulado begin
    select 
           @pendiente     = sum(clicc_importe)
    from ClienteCacheCredito where cli_id = @cli_id
  
    select 
           @creditoTotal   = cli_creditototal 
    from Cliente where cli_id = @cli_id
  
    if @pendiente = 0 begin                
        set @est_id = @estado_finalizado 
    end
    else begin 
      if @pendiente > @creditoTotal begin  
        set @est_id = @estado_pendienteCredito 
      end 
      else begin
        if @firmado = 0 begin             
          set @est_id = @estado_pendienteFirma 
        end
        else begin                                
            set @est_id = @estado_pendienteDespacho
        end
      end
    end
  
    update NOMBRE_TABLA set est_id = @est_id
    where CAMPO_ID = PARAM_ID
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado TEXTO_ERROR. sp_DocNOMBRE_DOCSetEstado.', 16, 1)

end