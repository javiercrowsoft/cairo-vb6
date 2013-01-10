if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_GetSocio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_GetSocio]

/*

sp_web_GetSocio '999'

*/

go
create procedure sp_web_GetSocio (
  @@AABAsoc_codigo        varchar(50)
)
as

begin

  set nocount on

  select  AABAsoc_id,
          AABAsoc_apellido,
          AABAsoc_nombre,
          AABAsoc_codigo
  from
        AABA_socio
  where
        AABAsoc_codigo = @@AABAsoc_codigo
end

go
