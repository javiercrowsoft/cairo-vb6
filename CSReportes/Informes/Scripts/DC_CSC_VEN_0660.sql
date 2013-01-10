if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0660]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0660]
go
/*
begin tran
 exec DC_CSC_VEN_0660 1, 2, 126951, '62011438526949', '2528', '20120114'
rollback tran
*/

create procedure DC_CSC_VEN_0660(

  @@us_id        int,
  @@emp_id      varchar(255),
  @@numero      int,
  @@cae          varchar(50),
  @@caenrodoc    varchar(50),
  @@caevto      varchar(50)
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

  if @@numero <= 0 begin

    select 1, 'El numero de factura debe ser mayor a cero.' as Info, '' as dummycol

    return

  end

  declare @fv_id int

  select @fv_id = fv_id
  from FacturaVenta
  where fv_numero = @@numero
    and emp_id = @emp_id

  if @fv_id is null  begin

    select 1, 'No existe una factura con el numero: ' + convert(varchar, @@numero) + ' en la empresa ' + emp_nombre, '' as dummy_col
    from Empresa
    where emp_id = @emp_id

  end
  else  begin

    update FacturaVenta set fv_cae = @@cae, fv_cae_nrodoc = @@caenrodoc, fv_cae_vto = @@caevto
    where fv_id = @fv_id and fv_cae = '' and fv_cae_nrodoc = '' and fv_cae_vto = ''

    select fv_id, 
            fv_nrodoc        as Comprobante,
            fv_cae          as CAE,
            fv_fecha        as Fecha,
            fv_cae_vto      as CAE_Vto,
            fv_cae_nrodoc   as CAE_Nro,
            ''              as dummy_col
    from FacturaVenta
    where fv_id = @fv_id

  end
end