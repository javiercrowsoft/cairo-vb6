if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocChequeFechaUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocChequeFechaUpdate]

go

/*

  sp_DocChequeFechaUpdate 2,61,1,17002

*/

create procedure sp_DocChequeFechaUpdate (
  @@cheq_id        int
)
as

set nocount on

begin

  declare @cheq_fecha   datetime
  declare @fecha2       datetime
  declare @cle_id       int
  
  select @cheq_fecha = cheq_fechacobro, @cle_id = cle_id from cheque where cheq_id = @@cheq_id

  exec sp_DocGetFecha2 @cheq_fecha,@fecha2 out, 1, @cle_id
  update cheque set cheq_fecha2 = @fecha2 where cheq_id = @@cheq_id

end

go
