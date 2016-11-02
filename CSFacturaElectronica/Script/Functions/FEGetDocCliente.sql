if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetDocCliente]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetDocCliente]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function FEGetDocCliente  (

@@cli_cuit varchar(50)

)

returns varchar(50)

as
begin

/* Tabla AFIP

Código	Descripción
1	IVA Responsable Inscripto
2	IVA Responsable no Inscripto
3	IVA no Responsable
4	IVA Sujeto Exento
5	Consumidor Final
6	Responsable Monotributo
7	Sujeto no Categorizado
8	Proveedor del Exterior
9	Cliente del Exterior
10	IVA Liberado – Ley Nº 19.640
11	IVA Responsable Inscripto – Agente de Percepción
12	Pequeño Contribuyente Eventual
13	Monotributista Social
14	Pequeño Contribuyente Eventual Social

*/

	declare @nroDoc varchar(50)
	set @nroDoc = ltrim(rtrim(replace(@@cli_cuit,'-','')))
	if @nroDoc = '' set @nroDoc = '0'
	return @nroDoc

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

