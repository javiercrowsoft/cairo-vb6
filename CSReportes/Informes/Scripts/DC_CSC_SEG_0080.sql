/*---------------------------------------------------------------------
  Nombre: Permisos por prestacion, usuario, empresa y departamento
---------------------------------------------------------------------*/

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_SEG_0080]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SEG_0080]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create procedure DC_CSC_SEG_0080 (

  @@us_id    int,

@@us_id_usuario varchar(255),
@@emp_id        varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @us_id_usuario  int
declare @emp_id         int
declare @us_id          int
declare @empus_id        int

declare @ram_id_usuario int
declare @ram_id_empresa int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_usuario, @us_id_usuario out, @ram_id_usuario out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_usuario <> 0 begin

--  exec sp_ArbGetGroups @ram_id_usuario, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_usuario, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_usuario, @clienteID 
  end else 
    set @ram_id_usuario = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare c_usemp insensitive cursor for

  select 
  
    u.us_id,
    e.emp_id
  
  from usuario u, empresa e
  
  where 
  
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
        (u.us_id   = @us_id_usuario   or @us_id_usuario=0)
  and   (e.emp_id = @emp_id         or @emp_id=0)
  
  
  -- Arboles
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 3 
                    and  rptarb_hojaid = u.us_id
                   ) 
             )
          or 
             (@ram_id_usuario = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 1018
                    and  rptarb_hojaid = e.emp_id
                   ) 
             )
          or 
             (@ram_id_empresa = 0)
         )

  open c_usemp

  fetch next from c_usemp into @us_id, @emp_id
  while @@fetch_status = 0
  begin

    if not exists (select * from empresausuario where emp_id = @emp_id and us_id = @us_id) begin

      exec sp_dbgetnewid 'EmpresaUsuario', 'empus_id', @empus_id out, 0

      insert into EmpresaUsuario (empus_id, emp_id, us_id, modifico) 
                           values(@empus_id, @emp_id, @us_id, @@us_id)

    end

    fetch next from c_usemp into @us_id, @emp_id
  end

  close c_usemp
  deallocate c_usemp

  select 1, 'El proceso termino con éxito' as Info

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

