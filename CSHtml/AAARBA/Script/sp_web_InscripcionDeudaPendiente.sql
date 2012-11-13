if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionDeudaPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionDeudaPendiente]

/*
sp_columns inscripcion
*/

go
create procedure sp_web_InscripcionDeudaPendiente

as

begin

	set nocount on

	select 	insc_id, 
					insc_tipodocumento, 
					insc_documento, 
					insc_socio,
					insc_categoria,
					insc_fecha,
					insc_importe,
					insc_apellido,
          insc_nombre,
					insc_numero,
					cpg_id

	from aaarbaweb..inscripcion insc

	where aabainsc_pagada = 0 and cpg_id not in (4,7,9,10,11,12)
	
/*
1	Por caja en efectivo en AAARBA
2	Por sistema de boleta personalizada del banco Galicia
3	Por debito de cuenta bancaria mediante CBU
4	Por caja en efectivo en el congreso
5	Por debito de honorarios
6	Por caja en dolares en AAARBA
7	Por caja en dolares en el congreso
8	Mediante tarjeta de credito VISA
9	Invitado Comite Ejecutivo sin cargo
10	Invitado Industria Farmaceutica
11  Orador
*/

end

go
