/*---------------------------------------------------------------------
Nombre: Gastos por Rubro
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0230_aux2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0230_aux2]

/*

*/

go
create procedure DC_CSC_TSR_0230_aux2 (

	@@pr_id 	int,
	@@cue_id 	int,

	@@mes         varchar(7),
	@@importe     decimal(18,6)

)as 

begin

set nocount on

	update #t_meses set 

											imes1  = imes1 +case when mes1 =@@mes then @@importe else 0 end,
											imes2  = imes2 +case when mes2 =@@mes then @@importe else 0 end,
											imes3  = imes3 +case when mes3 =@@mes then @@importe else 0 end,
											imes4  = imes4 +case when mes4 =@@mes then @@importe else 0 end,
											imes5  = imes5 +case when mes5 =@@mes then @@importe else 0 end,
											imes6  = imes6 +case when mes6 =@@mes then @@importe else 0 end,
											imes7  = imes7 +case when mes7 =@@mes then @@importe else 0 end,
											imes8  = imes8 +case when mes8 =@@mes then @@importe else 0 end,
											imes9  = imes9 +case when mes9 =@@mes then @@importe else 0 end,
											imes10 = imes10+case when mes10=@@mes then @@importe else 0 end,
											imes11 = imes11+case when mes11=@@mes then @@importe else 0 end,
											imes12 = imes12+case when mes12=@@mes then @@importe else 0 end

		where (pr_id = @@pr_id or @@pr_id is null) and (cue_id = @@cue_id or @@cue_id is null)

				and (			mes1 = @@mes 
							or 	mes2 = @@mes 
							or 	mes3 = @@mes
							or 	mes4 = @@mes 
							or 	mes5 = @@mes
							or 	mes6 = @@mes 
							or 	mes7 = @@mes
							or 	mes8 = @@mes 
							or 	mes9 = @@mes
							or 	mes10 = @@mes 
							or 	mes11 = @@mes
							or 	mes12 = @@mes 
						)
end

GO