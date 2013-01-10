if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionGetDeuda2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionGetDeuda2]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_inscripcionGetDeuda2 13

sp_col inscripcion

*/

go
create procedure sp_web_inscripcionGetDeuda2(
  @@insc_id int
)
as

begin

  set nocount on

  select   insc_id, 
          insc_fecha,
          insc_categoria,
          insc_tipodocumento,
          insc_documento,
          insc_nombre,
          insc_apellido,
          insc_numero,
          aabainsc_acompannantes,
          insc.cpg_id,
          cpg_nombre 

  from aaarbaweb..inscripcion insc inner join condicionPago cpg on insc.cpg_id = cpg.cpg_id

  where insc_id = @@insc_id
  
end

go
