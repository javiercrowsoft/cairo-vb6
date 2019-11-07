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
		Documento
		inner join DocumentoTipo on Documento.doct_id =  DocumentoTipo.doct_id
		inner join CircuitoContable on Documento.cico_id = CircuitoContable.cico_id
		inner join Empresa on Documento.emp_id = Empresa.emp_id

		left join Talonario on Documento.ta_id = Talonario.ta_id
		left join Talonario as tFinal on Documento.ta_id_final = tFinal.ta_id
		left join Talonario as tInscripto on Documento.ta_id_inscripto = tInscripto.ta_id
		left join Talonario as tExterno on Documento.ta_id_externo = tExterno.ta_id
		left join Talonario as tInscriptoM on Documento.ta_id_inscriptom = tInscriptoM.ta_id
		left join Talonario as tHaberes on Documento.ta_id_haberes = tHaberes.ta_id

		left join Moneda on Documento.mon_id = Moneda.mon_id
		left join FechaControlAcceso on Documento.fca_id = FechaControlAcceso.fca_id

		left join CuentaGrupo on Documento.cueg_id = CuentaGrupo.cueg_id
		left join Documento as tDocAsiento on Documento.doc_id_asiento = tDocAsiento.doc_id
		left join Documento as tDocRemito on Documento.doc_id_remito = tDocRemito.doc_id
		left join Documento as tDocStock on Documento.doc_id_stock = tDocStock.doc_id
		left join DocumentoGrupo as docg on Documento.docg_id = docg.docg_id

where Documento.doc_id = @@doc_id

end

go
set quoted_identifier off
go
set ansi_nulls on
go
