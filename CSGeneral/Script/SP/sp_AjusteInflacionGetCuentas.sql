if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AjusteInflacionGetCuentas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AjusteInflacionGetCuentas]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_AjusteInflacionGetCuentas 3

create procedure sp_AjusteInflacionGetCuentas (
  @@aje_id  int,
  @@tipo    tinyint  /*
                        - 1 Activo y Pasivo
                        - 2 Resultados
                        - 3 Patrimoniales
                    */
)
as

set nocount on

begin

  select   aji.*,
          cue_nombre,
          cuec_nombre,
          ajit_nombre

  from AjusteInflacionItem aji inner join Cuenta cue on aji.cue_id = cue.cue_id
                               inner join CuentaCategoria cuec on cue.cuec_id = cuec.cuec_id
                               left  join AjusteInflacionItemTipo ajit on aji.ajit_id = ajit.ajit_id
  where aje_id = @@aje_id
    and (        (aji.ajit_id in (1,5,6) and @@tipo = 1) -- Sin Definir, Bienes de Uso, Bienes de Cambio
            or  (aji.ajit_id in (4,7)   and @@tipo = 2) -- Costos de Venta, Ingresos y Egresos
            or  (aji.ajit_id in (2,3)   and @@tipo = 3) -- Cualitativos, Cuantitativos
        )

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



