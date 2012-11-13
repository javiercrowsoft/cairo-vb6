if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ChequeraSet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ChequeraSet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 select * from Chequera
 exec sp_ChequeraSet 2,'x-0001-0002405'
*/
create procedure sp_ChequeraSet (
	@@chq_id	      int,
  @@chq_numero    varchar(255)
)
as

set nocount on

begin

	declare @numero 			int
  declare @c            varchar(1)
  declare @n            tinyint
  declare @ultimoNumero int

	set @n = len(@@chq_numero)
	set @c = substring(@@chq_numero,@n,1)

	while charindex(@c,'1234567890') <> 0 begin
  	set @n = @n - 1
	  if @n <= 0 goto Listo 
		set @c = substring(@@chq_numero,@n,1)
  end

Listo:
 	set @n = @n + 1
	set @numero = convert(int,substring(@@chq_numero,@n,len(@@chq_numero)))
	select @ultimoNumero = chq_ultimoNumero from Chequera where chq_id = @@chq_id
	if @ultimoNumero < @numero update Chequera set chq_ultimoNumero = @numero where chq_id = @@chq_id
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



