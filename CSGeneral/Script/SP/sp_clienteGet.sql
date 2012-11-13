if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteGet]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_clienteGet 35639

*/

go
create procedure sp_clienteGet (
	@@cli_id 		int
)
as

begin

	set nocount on


  select 
					cliente.*,
					pro_nombre, 
					zon_nombre, 
					cpg_nombre, 
					lp_nombre, 
					ld_nombre, 
					ven_nombre, 
					trans_nombre,
					clict_nombre,
					proy_nombre,
          cli2.cli_nombre   as cli_nombrepadre,
					cli3.cli_nombre   as referido,
					cpa_codigo,
					fp_nombre,
          us_nombre,
          us.activo         as us_activo

 from 
			cliente left join provincia  				on cliente.pro_id   		= provincia.pro_id
							left join zona 							on cliente.zon_id   		= zona.zon_id
							left join condicionpago			on cliente.cpg_id   		= condicionpago.cpg_id
							left join listaprecio				on cliente.lp_id    		= listaprecio.lp_id
							left join listadescuento		on cliente.ld_id    		= listadescuento.ld_id
							left join vendedor					on cliente.ven_id   		= vendedor.ven_id
							left join transporte				on cliente.trans_id 		= transporte.trans_id
							left join cliente cli2      on cliente.cli_id_padre = cli2.cli_id
							left join usuario us        on cliente.us_id        = us.us_id

							left join clientecontactotipo clict on cliente.clict_id = clict.clict_id
							left join cliente cli3      on cliente.cli_id_referido  = cli3.cli_id
							left join proyecto proy     on cliente.proy_id 					= proy.proy_id
							left join codigopostal cpa  on cliente.cpa_id           = cpa.cpa_id
							left join formapago fp      on cliente.fp_id            = fp.fp_id

 where cliente.cli_id = @@cli_id 

end

go