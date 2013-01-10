if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TalonarioSet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TalonarioSet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 select * from talonario
 exec sp_TalonarioSet 2,'x-0001-0002405'
*/
create procedure sp_TalonarioSet (
  @@ta_id        int,
  @@ta_numero   varchar(255)
)
as

set nocount on

begin

  declare @numero       int
  declare @c            varchar(1)
  declare @n            tinyint
  declare @ultimoNumero int

  set @n = len(@@ta_numero)
  set @c = substring(@@ta_numero,@n,1)

  while charindex(@c,'1234567890') <> 0 begin
    set @n = @n - 1
    if @n <= 0 goto Listo 
    set @c = substring(@@ta_numero,@n,1)
  end

Listo:
   set @n = @n + 1
  set @numero = convert(int,substring(@@ta_numero,@n,len(@@ta_numero)))
  select @ultimoNumero = ta_ultimoNro from Talonario where ta_id = @@ta_id
  if @ultimoNumero < @numero update Talonario set ta_ultimoNro = @numero where ta_id = @@ta_id
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



