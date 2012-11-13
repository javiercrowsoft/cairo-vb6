if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetPuntoVta]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetPuntoVta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*

select dbo.FEGetPuntoVta (611)

sp_Cfg_SetValor 'Contabilidad-General', 'Punto Venta FE', 1, 1

*/

create function FEGetPuntoVta (

@@fv_id int

)

returns smallint

as
begin

	declare @doc_id int
	select @doc_id = doc_id from FacturaVenta where fv_id = @@fv_id

	declare @emp_id int
	select @emp_id = emp_id from Documento where doc_id = @doc_id

	declare @cfg_valor varchar(5000) 
	declare @cfg_clave varchar(255)

	set @cfg_clave = 'Punto Venta FE'

	select @cfg_valor = cfg_valor
	from 	Configuracion
	where cfg_grupo   = 'Contabilidad-General'
	  and cfg_aspecto = @cfg_clave
		and (emp_id = @emp_id or (emp_id is null and @emp_id is null))

	declare @puntoVta smallint
	set @puntoVta = 0

	if isnumeric(@cfg_valor)<>0 

		set @puntoVta = convert(int,@cfg_valor)

	return @puntoVta

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

