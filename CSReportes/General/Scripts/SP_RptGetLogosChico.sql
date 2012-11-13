if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_RptGetLogosChico]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_RptGetLogosChico]

go

-- select * from documentodigital
-- SP_RptGetLogosChico 2

create procedure SP_RptGetLogosChico (

	@@emp_id int = 0
)
as

set nocount on

declare @codigo varchar(50)
set @codigo = 'LOGOCHICO##_' + convert(varchar(50),@@emp_id)
select dd_file from documentodigital where dd_codigo = @codigo

