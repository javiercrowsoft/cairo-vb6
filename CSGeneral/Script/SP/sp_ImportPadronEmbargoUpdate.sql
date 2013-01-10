if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ImportPadronEmbargoUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ImportPadronEmbargoUpdate]

/*

*/

go
create procedure sp_ImportPadronEmbargoUpdate (
  @@cuit         varchar(50),
  @@fecha        varchar(50),
  @@saldo        decimal(18,6),
  @@nombre      varchar(255)
)
as

begin

  set nocount on

  if exists(select * from ARBA_Deudores where arbad_cuit = @@cuit) begin

    update ARBA_Deudores set arbad_archivo = @@fecha, arbad_deuda = @@saldo, arbad_nombre = @@nombre where arbad_cuit = @@cuit

  end else begin

    insert into ARBA_Deudores (arbad_cuit, arbad_archivo, arbad_deuda, arbad_nombre)
                       values (@@cuit,     @@fecha,     @@saldo,     @@nombre) 

  end

end
go