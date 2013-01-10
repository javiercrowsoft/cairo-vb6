
/*---------------------------------------------------------------------
Nombre: Compras por proveedor y articulo
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0650]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0650]

/*
DC_CSC_VEN_0650 1,
                '20050501',
                '20060531',
                '0',
                '0',
                '0',
                '1'
*/

go
create procedure DC_CSC_VEN_0650(

  @@us_id    int,
  @@emp_id   varchar(255),
  @@ptoVta   smallint,
  @@numero   int,
  @@tipo     smallint

) 

as 

begin

set nocount on

  declare @emp_id           int 
  declare @ram_id_Empresa   int 

  declare @clienteID int
  declare @IsRaiz    tinyint

  exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

  if @emp_id = 0 begin

    select 1, 'Debe seleccionar una empresa.' as Info, '' as dummycol

    return

  end

  if @@ptoVta <= 0 begin

    select 1, 'El punto de venta debe ser mayor a cero.' as Info, '' as dummycol

    return

  end

  if @@numero <= 0 begin

    select 1, 'El numero de factura debe ser mayor a cero.' as Info, '' as dummycol

    return

  end

  declare @cuit varchar(50)

  select @cuit = emp_cuit from Empresa where emp_id = @emp_id

  set @cuit = replace(@cuit,'-','')

  insert into  FacturaElectronicaConsulta
  (
  fvfec_id,
  fvfec_ptovta,
  fvfec_cuit,
  fvfec_numero,
  fvfec_tipdoc
  )
  select max(fvfec_id)+1,
  @@ptoVta,
  @cuit,
  @@numero,
  @@tipo
  from FacturaElectronicaConsulta

  declare @n int
  set @n = 1

  -- Cada 3 segundos veo si ya procese la factura (lo hago durante 1 minuto)
  --
  while @n < 20 /* 1 minuto */ and (
                                      not exists(select 1 
                                                  from FacturaElectronicaConsulta 
                                                  where fvfec_numero = @@numero
                                                    and fvfec_tipdoc = @@tipo
                                                    and fvfec_respuesta <> '')
                                  )
  begin

    exec sp_sleep '000:00:03'
    set @n = @n +1

  end

  select distinct
  1,
  fvfec_ptovta as [Punto de Venta],
  fvfec_tipdoc as [Tipo], 
  case fvfec_tipdoc
      when 1
        then 'Factura A'
      when 6
        then 'Factura B'
      when 11
        then 'Factura C'
      when 3
        then 'Nota de Credito A'
      when 8
        then 'Nota de Credito B'
      when 13
        then 'Nota de Credito C'
      when 2
        then 'Nota de Dedito A'
      when 7
        then 'Nota de Dedito B'
      when 12
        then 'Nota de Dedito C'
  end as [Tipo Comprobante], 
  fvfec_numero as [Comprobante],
  (substring(fvfec_respuesta,charindex('Fecha:',fvfec_respuesta)+6,charindex('Vto:',fvfec_respuesta)-charindex('Fecha:',fvfec_respuesta)-6)) as Fecha,
  (substring(fvfec_respuesta,charindex('Neto:',fvfec_respuesta)+5,charindex('Tot Conce',fvfec_respuesta)-charindex('Neto:',fvfec_respuesta)-5)) as Neto,
  (substring(fvfec_respuesta,charindex('Imp. Iva:',fvfec_respuesta)+9,charindex('Imp. Trib',fvfec_respuesta)-charindex('Imp. Iva:',fvfec_respuesta)-9)) as IVA,
  (substring(fvfec_respuesta,charindex('Total:',fvfec_respuesta)+6,charindex('Resultado',fvfec_respuesta)-charindex('Total:',fvfec_respuesta)-6)) as Total,
  (substring(fvfec_respuesta,charindex('Nro:',fvfec_respuesta)+4,charindex('Tipo:',fvfec_respuesta)-charindex('Nro:',fvfec_respuesta)-4)) as CUIT,
  (substring(fvfec_respuesta,charindex('CAE:',fvfec_respuesta)+4,charindex('Concepto:',fvfec_respuesta)-charindex('CAE:',fvfec_respuesta)-4)) as CAE
  from FacturaElectronicaConsulta 
  where fvfec_respuesta <>''
  and fvfec_respuesta not like 'Ocurrio un error al solicitar informacion sobre el comprobante%'
  and fvfec_numero = @@numero
  and fvfec_tipdoc = @@tipo
  order by fecha

end
go