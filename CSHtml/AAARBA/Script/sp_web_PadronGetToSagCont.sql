if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_PadronGetToSagCont]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PadronGetToSagCont]

/*

sp_web_PadronGetToSagCont 1,'20000101','25000101','0',0

select * from aaarbaweb..padronsocio where pad_numero = 138

*/

go
create procedure sp_web_PadronGetToSagCont (

  @@us_id            int,
  @@Fini              datetime,
  @@Ffin              datetime,
  @@soc_id           varchar(255),
  @@bTodas          tinyint = 0

)as 

begin

  set nocount on

  declare @soc_id         int
  
  declare @ram_id_socio            int
  
  declare @clienteID int
  
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@soc_id,  @soc_id out,  @ram_id_socio out
  
  exec sp_GetRptId @clienteID out
  
  if @ram_id_socio <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_socio, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_socio, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_socio, @clienteID 
    end else 
      set @ram_id_socio = 0
  end
  
    select
          pad_id,
          pad_fecha                            as Fecha,
          pad_apellidoNombre                  as Socio,
          us_id_carga                          as Modifico,
          est_id                              as Estado,
          pad_descrip                          as Observaciones
  
    into #tmp_padronsocio
  
    from aaarbaweb..PadronSocio pad 
    where 
  
        (      pad_fecha between @@Fini and @@Ffin
          or  soc_id = @soc_id)
  
        -- Solo fichas originales
        --
        and pad_id_padre is null
  
  /* -///////////////////////////////////////////////////////////////////////
  
  INICIO SEGUNDA PARTE DE ARBOLES
  
  /////////////////////////////////////////////////////////////////////// */
  
  and   (soc_id  = @soc_id  or @soc_id  =0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 39
                    and  rptarb_hojaid = soc_id
                   ) 
             )
          or 
             (@ram_id_socio = 0)
         )
  
  order by pad_fecha
  
  declare @pad_id              int
  declare @pad_id_padre       int
  declare @Fecha              datetime
  declare @Socio              varchar(50)
  declare @Modifico            int
  declare @Estado              int
  declare @Observaciones      varchar(255)
  
  
  create table #tmp_padronsocio2( pad_id           int, 
                                  pad_id_padre    int, 
                                  pad_id_abuelo    int,
                                  Fecha           datetime,
                                  Socio           varchar(50),
                                  Modifico        int,
                                  Estado          int,
                                  Observaciones   varchar(255),
                                  pendiente       tinyint
                                 )
  
  declare c_fichas insensitive cursor for select    pad_id,
                                                    Fecha,
                                                    Socio,
                                                    Modifico,
                                                    Estado,
                                                    Observaciones
                                                    
                                          from #tmp_padronsocio 
  
  
  open c_fichas
  
  fetch next from c_fichas into   @pad_id,
                                  @Fecha,
                                  @Socio,
                                  @Modifico,
                                  @Estado,
                                  @Observaciones
  
  while @@fetch_status=0
  begin
  
    insert into #tmp_padronsocio2 ( pad_id,
                                    pad_id_abuelo,
                                    pad_id_padre,
                                    Fecha,
                                    Socio,
                                    Modifico,
                                    Estado,
                                    Observaciones,
                                    pendiente)
                  values          (
                                    @pad_id,
                                    @pad_id,
                                    null,
                                    @Fecha,
                                    @Socio,
                                    @Modifico,
                                    @Estado,
                                    @Observaciones,
                                    0
                                  )
  
    set @pad_id_padre = @pad_id
  
    while exists (select * from aaarbaweb..PadronSocio where pad_id_padre = @pad_id_padre and @pad_id_padre is not null)
    begin
  
      insert into #tmp_padronsocio2 ( pad_id,
                                      pad_id_abuelo,
                                      pad_id_padre,
                                      Fecha,
                                      Socio,
                                      Modifico,
                                      Estado,
                                      Observaciones,
                                      pendiente
                                    )
                    
        select
              pad_id,
              @pad_id,
              pad_id_padre,
              pad_fecha,
              pad_apellidoNombre,
              us_id_carga,
              est_id,
              pad_descrip,
              1
      
        from aaarbaweb..PadronSocio 

        where pad_id_padre = @pad_id_padre
  
        select @pad_id_padre = pad_id from #tmp_padronsocio2 where pendiente <> 0
  
        update #tmp_padronsocio2 set pendiente = 0 where pad_id = @pad_id_padre
  
    end
  
    fetch next from c_fichas into   @pad_id,
                                    @Fecha,
                                    @Socio,
                                    @Modifico,
                                    @Estado,
                                    @Observaciones
  
  end
  close c_fichas
  deallocate c_fichas

--  update #tmp_padronsocio2 set pad_id = null where exists(select * from aaarbaweb..PadronSocio where pad_id_padre = #tmp_padronsocio2.pad_id)

  select           
          pad.pad_id,
          pad_numero          as [Ficha],
          Fecha,
          Socio,
          us_nombre         as Modifico,
          est_nombre        as Estado,
          pad2.creado       as Modificado,
          Observaciones

 from #tmp_padronsocio2 pad inner join Usuario                 us       on pad.Modifico     = us.us_id
                            inner join aaarbaweb..PadronSocio  pad2    on pad.pad_id       = pad2.pad_id
                            inner join Estado                  est     on pad2.est_id_cont = est.est_id

 where
          (    not exists(select * from aaarbaweb..PadronSocio where pad_id_padre = pad.pad_id) 
           or @@bTodas <> 0
          )
    and    est_id_cont = 1012  --Pendiente de aplicar SAG contaduria

end
go