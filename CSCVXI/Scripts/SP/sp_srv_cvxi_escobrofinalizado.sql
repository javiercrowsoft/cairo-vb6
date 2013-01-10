if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_escobrofinalizado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_escobrofinalizado]

go
/*

*/

create procedure sp_srv_cvxi_escobrofinalizado (

  @@cmi_id              int,
  @@cmic_cobroId       varchar(50)

)

as

begin

  set nocount on

  if exists(select cmic_nick, cmic.creado 
            from ComunidadInternetCobro cmic left join PedidoVenta pv on cmic.pv_id = pv.pv_id
            where pv.est_id = 5
              and cmic_cobroId = @@cmic_cobroId
              and cmi_id = @@cmi_id)

    select 1 as result

  else

    select 0 as result

end