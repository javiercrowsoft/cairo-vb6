if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ArbolAbmBuscar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbolAbmBuscar]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*

 sp_ArbolAbmBuscar 1,2

*/

create procedure sp_ArbolAbmBuscar (
	@@arb_id 		int,
	@@id 				int
)
as
begin
	set nocount on

  select hoja.ram_id 
	from hoja inner join rama on hoja.ram_id = rama.ram_id
	where hoja.arb_id = @@arb_id
		and rama.ram_id <> rama.ram_id_padre
  	and id = @@id
	
end


