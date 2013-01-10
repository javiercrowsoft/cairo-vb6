if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_GetSocioLASFAR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_GetSocioLASFAR]

/*

sp_web_GetSocioLASFAR '4'

*/

go
create procedure sp_web_GetSocioLASFAR (
  @@AABAsocl_codigo        varchar(50)
)
as

begin

  set nocount on

  select  aabasocl_id,
          aabasocl_apellido,
          aabasocl_nombre,
          aabasocl_codigo,
          aabasocl_asociacion,
          aabaasoc_id
  from
        aaba_sociolasfar
  where
        aabasocl_codigo = @@aabasocl_codigo
end

go
