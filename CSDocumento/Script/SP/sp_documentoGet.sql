if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_DocumentoGet 21

create procedure sp_DocumentoGet (
	@@doc_id	int
)
as

set nocount on

begin

select 
		Documento.*, 
    emp_nombre,
    fca_nombre,
		doct_nombre,
		cico_nombre, 
		Talonario.ta_nombre,

		tInscripto.ta_nombre  as taInscripto,
		tFinal.ta_nombre      as taFinal,
		tExterno.ta_nombre    as taExterno,
		tInscriptoM.ta_nombre as taInscriptoM,
		tHaberes.ta_nombre 		as taHaberes,

		mon_nombre,
    cueg_nombre,

		tDocAsiento.doc_nombre as DocAsiento,
		tDocRemito.doc_nombre  as DocRemito,
		tDocStock.doc_nombre   as DocStock,

		docg_nombre

from 
		Documento, 
		DocumentoTipo, 
		Talonario, 
		CircuitoContable,
		Empresa,

		Talonario as tFinal, 
		Talonario as tInscripto, 
		Talonario as tExterno, 
		Talonario as tInscriptoM, 
		Talonario as tHaberes, 

		Moneda, 
		FechaControlAcceso,
    CuentaGrupo,
    Documento as tDocAsiento,
    Documento as tDocRemito,
    Documento as tDocStock,

		DocumentoGrupo as docg
where 

		Documento.doc_id = @@doc_id

and Documento.doct_id 				=  DocumentoTipo.doct_id
and Documento.cico_id         =  CircuitoContable.cico_id
and Documento.emp_id          =  Empresa.emp_id

and Documento.ta_id           *= Talonario.ta_id
and Documento.mon_id 					*= Moneda.mon_id
and Documento.fca_id          *= FechaControlAcceso.fca_id
and Documento.cueg_id         *= CuentaGrupo.cueg_id

and Documento.ta_id_final           *= tFinal.ta_id
and Documento.ta_id_externo         *= tExterno.ta_id
and Documento.ta_id_inscripto       *= tInscripto.ta_id
and Documento.ta_id_inscriptom      *= tInscriptoM.ta_id
and Documento.ta_id_haberes         *= tHaberes.ta_id

and Documento.doc_id_asiento        *= tDocAsiento.doc_id

and Documento.doc_id_remito         *= tDocRemito.doc_id
and Documento.doc_id_stock          *= tDocStock.doc_id

and Documento.docg_id               *= docg.docg_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



