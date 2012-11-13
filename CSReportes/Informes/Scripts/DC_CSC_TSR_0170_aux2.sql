/*---------------------------------------------------------------------
Nombre: Prespuesto Financiero
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0170_aux2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0170_aux2]

/*

*/

go
create procedure DC_CSC_TSR_0170_aux2 (

	@@concepto_id int,

	@@ccos_id1				int,
	@@ccos_id2				int,
	@@ccos_id3				int,
	@@ccos_id4				int,
	@@ccos_id5				int,

	@@mes         varchar(7),
	@@ccos_id			int,
	@@importe     decimal(18,6)

)as 

begin

set nocount on

	update #t_meses set 

											mes1_ccos1 = mes1_ccos1 + case when mes1=@@mes and ccos_id1 = @@ccos_id then @@importe else 0 end,
											mes1_ccos2 = mes1_ccos2 + case when mes1=@@mes and ccos_id2 = @@ccos_id then @@importe else 0 end,
											mes1_ccos3 = mes1_ccos3 + case when mes1=@@mes and ccos_id3 = @@ccos_id then @@importe else 0 end,
											mes1_ccos4 = mes1_ccos4 + case when mes1=@@mes and ccos_id4 = @@ccos_id then @@importe else 0 end,
											mes1_ccos5 = mes1_ccos5 + case when mes1=@@mes and ccos_id5 = @@ccos_id then @@importe else 0 end,
											mes1_otros = mes1_otros + case when mes1=@@mes and ccos_id1 <> @@ccos_id 
																																		 and ccos_id2 <> @@ccos_id 
																																		 and ccos_id3 <> @@ccos_id 
																																		 and ccos_id4 <> @@ccos_id 
																																		 and ccos_id5 <> @@ccos_id 
																																															then @@importe else 0 end,

											mes2_ccos1 = mes2_ccos1 + case when mes2=@@mes and ccos_id1 = @@ccos_id then @@importe else 0 end,
											mes2_ccos2 = mes2_ccos2 + case when mes2=@@mes and ccos_id2 = @@ccos_id then @@importe else 0 end,
											mes2_ccos3 = mes2_ccos3 + case when mes2=@@mes and ccos_id3 = @@ccos_id then @@importe else 0 end,
											mes2_ccos4 = mes2_ccos4 + case when mes2=@@mes and ccos_id4 = @@ccos_id then @@importe else 0 end,
											mes2_ccos5 = mes2_ccos5 + case when mes2=@@mes and ccos_id5 = @@ccos_id then @@importe else 0 end,
											mes2_otros = mes2_otros + case when mes2=@@mes and ccos_id1 <> @@ccos_id 
																																		 and ccos_id2 <> @@ccos_id 
																																		 and ccos_id3 <> @@ccos_id 
																																		 and ccos_id4 <> @@ccos_id 
																																		 and ccos_id5 <> @@ccos_id 
																																															then @@importe else 0 end,

											mes3_ccos1 = mes3_ccos1 + case when mes3=@@mes and ccos_id1 = @@ccos_id then @@importe else 0 end,
											mes3_ccos2 = mes3_ccos2 + case when mes3=@@mes and ccos_id2 = @@ccos_id then @@importe else 0 end,
											mes3_ccos3 = mes3_ccos3 + case when mes3=@@mes and ccos_id3 = @@ccos_id then @@importe else 0 end,
											mes3_ccos4 = mes3_ccos4 + case when mes3=@@mes and ccos_id4 = @@ccos_id then @@importe else 0 end,
											mes3_ccos5 = mes3_ccos5 + case when mes3=@@mes and ccos_id5 = @@ccos_id then @@importe else 0 end,
											mes3_otros = mes3_otros + case when mes3=@@mes and ccos_id1 <> @@ccos_id 
																																		 and ccos_id2 <> @@ccos_id 
																																		 and ccos_id3 <> @@ccos_id 
																																		 and ccos_id4 <> @@ccos_id 
																																		 and ccos_id5 <> @@ccos_id 
																																															then @@importe else 0 end

		where concepto_id = @@concepto_id and (mes1 = @@mes or mes2 = @@mes or mes3 = @@mes)

end

GO