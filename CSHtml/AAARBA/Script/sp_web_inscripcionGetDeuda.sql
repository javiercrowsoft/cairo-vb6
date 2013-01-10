if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionGetDeuda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionGetDeuda]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_inscripcionGetDeuda 13

sp_col inscripcion

*/

go
create procedure sp_web_inscripcionGetDeuda

as

begin

  set nocount on

  select   insc_id, 
          insc_tipodocumento, 
          insc_documento, 
          insc_socio,
          insc_categoria,
          insc_fecha,
          insc_importe,
          insc_apellido,
          insc_nombre,
          insc_numero,
          insc.cpg_id,
          cpg_nombre 

  from aaarbaweb..inscripcion insc inner join condicionPago cpg on insc.cpg_id = cpg.cpg_id

  where (      (AABAinsc_deuda         is null and insc_id_padre is null)
          or  (AABAinsc_deudaLASRA     is null and AABAinsc_lasra <> 0)
          or  (AABAinsc_deudaInfo     is null and AABAinsc_info  <> 0)
          or  (AABAinsc_deudaAerea     is null and AABAinsc_aerea <> 0)
        )
    and insc_categoria not in(5,4,7,8) -- categoria invitado Comite Ejecutivo sin cargo
    and aabainsc_pagada = 0 
    and insc.cpg_id not in (4,7,9,10)

  order by cpg_nombre, insc_categoria
  
end

go
