if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_RptGetLogosGrande]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_RptGetLogosGrande]

go


-- SP_RptGetLogosGrande 'LOGOCHICO##'
-- SP_RptGetLogosGrande 'LOGOGRANDE##'

create procedure SP_RptGetLogosGrande (

  @@emp_id int = 0
)
as

set nocount on
declare @codigo varchar(50)
set @codigo = 'LOGOGRANDE##_' + convert(varchar(50),@@emp_id)
select dd_file from documentodigital where dd_codigo = @codigo

