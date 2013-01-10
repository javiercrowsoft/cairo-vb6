/*

frAsiento 3

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frAsiento]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frAsiento]

go
create procedure frAsiento (

  @@as_ID      int

)as 

begin

  select Asiento.*, AsientoItem.*, cue_nombre, doc_nombre, ccos_nombre
  from Asiento inner join AsientoItem on Asiento.as_id         = AsientoItem.as_id
               inner join Cuenta      on AsientoItem.cue_id    = Cuenta.cue_id
               inner join Documento   on Asiento.doc_id       = Documento.doc_id
               left join  CentroCosto on AsientoItem.ccos_id  = CentroCosto.ccos_id
  where Asiento.as_id = @@as_id
  order by asi_orden
end
go