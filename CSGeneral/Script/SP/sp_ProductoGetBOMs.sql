if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetBOMs]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetBOMs]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_ProductoGetBOMs 35639

*/

go
create procedure sp_ProductoGetBOMs (
  @@pr_id     int
)
as

begin

  set nocount on

  select 
         pbm_id,
         pbm_codigo,
         pbm_fechaAuto,
         pbm_nombre

  from ProductoBOM pbm

  where 
      exists(select * from productoBOMElaborado 
             where pr_id = @@pr_id and pbm_id = pbm.pbm_id)
end

go