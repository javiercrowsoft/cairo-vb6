if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_CBUGaliciaApplyPago]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_CBUGaliciaApplyPago]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_CBUGaliciaApplyPago 13

sp_col inscripcion

*/

go
create procedure sp_web_CBUGaliciaApplyPago (
  @@insc_id         int,
  @@idRegistro      varchar(255),
  @@pago            decimal(18,6),
  @@us_id           int
)
as

begin

  set nocount on

  declare @inscpcbu_id int

  if not exists(select * from aaarbaweb..inscripcionPagoCBU where inscpcbu_idRegistro = @@idRegistro) begin

    exec SP_DBGetNewId 'aaarbaweb..inscripcionPagoCBU', 'inscpcbu_id', @inscpcbu_id out, 0

    insert into aaarbaweb..inscripcionPagoCBU  (inscpcbu_id, inscpcbu_importe, inscpcbu_idRegistro, insc_id, modifico) 
                              values(@inscpcbu_id, @@pago, @@idRegistro, @@insc_id, @@us_id)
  end else
    update aaarbaweb..inscripcionPagoCBU set 
                                              inscpcbu_importe = @@pago,
                                              modifico         = @@us_id
    where inscpcbu_idRegistro = @@idRegistro
  
  select @@pago = sum(inscpcbu_importe) from aaarbaweb..inscripcionPagoCBU where insc_id = @@insc_id

  update aaarbaweb..inscripcion set 
                                        aabainsc_pagoCBU = @@pago 
                                        /*todo estado*/
  where insc_id = @@insc_id
                      
end

go