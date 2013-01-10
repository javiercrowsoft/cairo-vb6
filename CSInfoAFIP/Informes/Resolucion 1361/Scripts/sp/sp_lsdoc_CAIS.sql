SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_lsdoc_CAIS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_CAIS]
GO




/*
delete proveedorcai
delete proveedor
sp_lsdoc_CAISs 

*/               
create procedure sp_lsdoc_CAIS (
  @@prov_id as int
)
as

set nocount on

begin

  select 
    proveedor.prov_id,
    TypeTask  = '',
    Nombre = prov_nombre,
           CUIT   = proveedor.prov_cuit,
          Fecha  = '',
          Cargado = 1,
          Comprobante='',
          dummy=''

  from proveedor

  where proveedor.prov_id = @@prov_id

end
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
