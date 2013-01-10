if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_informeCopy]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_informeCopy]

/*

 sp_informeCopy 

*/

go
create procedure sp_informeCopy as

begin

declare @min int set @min = 10000000
declare @max int set @max = 10999999

declare @pre_id int

declare  
        @inf_id                   int,
        @id                       int,
        @inf_nombre                varchar(255),
        @inf_codigo               varchar(255),
        @inf_descrip              varchar(255),
        @inf_storedprocedure      varchar(255),
        @inf_reporte              varchar(255),
        @inf_presentaciondefault   smallint,
        @inf_modulo                varchar(255),
        @inf_tipo                  smallint,
        @inf_propietario          smallint,
        @inf_colocultas            smallint,
        @inf_checkbox              smallint,
        @inf_totalesgrales        smallint,
        @inf_connstr              varchar(255)

declare
        @infp_id                  int,
        @infp_nombre              varchar(255),
        @infp_orden                smallint,
        @infp_tipo                smallint,
        @infp_default              varchar(255),
        @infp_visible              smallint,
        @infp_sqlstmt              varchar(255),
        @tbl_id                    int

declare c_inf insensitive cursor for 

select 
        inf_id,
        inf_nombre,
        inf_codigo,
        inf_descrip,
        inf_storedprocedure,
        inf_reporte,
        inf_presentaciondefault,
        inf_modulo,
        inf_tipo,
        inf_propietario,
        inf_colocultas,
        inf_checkbox,
        inf_totalesgrales,
        inf_connstr

 from cairogngas..informe where inf_codigo not in (select inf_codigo from informe)
                            and  substring(inf_codigo,1,6) = 'DC_CSC'

open c_inf

fetch next from c_inf into 
      @inf_id,
      @inf_nombre,
      @inf_codigo,
      @inf_descrip,
      @inf_storedprocedure,
      @inf_reporte,
      @inf_presentaciondefault,
      @inf_modulo,
      @inf_tipo,
      @inf_propietario,
      @inf_colocultas,
      @inf_checkbox,
      @inf_totalesgrales,
      @inf_connstr

while @@fetch_status=0
begin

  exec sp_dbgetnewid 'Informe', 'inf_id', @id out, 0

  exec sp_dbgetnewid2 'Prestacion', 'pre_id', @min, @max, @pre_id out, 0

  insert Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,activo)
              values(@pre_id,@inf_nombre,'Informes',@inf_modulo,1)

  insert into Informe(
        inf_id,
        inf_nombre,
        inf_codigo,
        inf_descrip,
        inf_storedprocedure,
        inf_reporte,
        inf_presentaciondefault,
        inf_modulo,
        inf_tipo,
        inf_propietario,
        inf_colocultas,
        inf_checkbox,
        inf_totalesgrales,
        inf_connstr,
        pre_id,
        modifico
          )
    values(
        @id,
        @inf_nombre,
        @inf_codigo,
        @inf_descrip,
        @inf_storedprocedure,
        @inf_reporte,
        @inf_presentaciondefault,
        @inf_modulo,
        @inf_tipo,
        @inf_propietario,
        @inf_colocultas,
        @inf_checkbox,
        @inf_totalesgrales,
        @inf_connstr,
        @pre_id,
        1
          )

  declare c_params insensitive cursor for select 
                                                  infp_nombre,
                                                  infp_orden,
                                                  infp_tipo,
                                                  infp_default,
                                                  infp_visible,
                                                  infp_sqlstmt,
                                                  tbl_id

                                          from cairogngas..informeparametro where inf_id = @inf_id

  open c_params

  fetch next from c_params into
                                @infp_nombre,
                                @infp_orden,
                                @infp_tipo,
                                @infp_default,
                                @infp_visible,
                                @infp_sqlstmt,
                                @tbl_id

  while @@fetch_status = 0 begin

    exec sp_dbgetnewid 'InformeParametro','infp_id',@infp_id out,0

    insert into InformeParametro
            (
            inf_id,
            infp_id,
            infp_nombre,
            infp_orden,
            infp_tipo,
            infp_default,
            infp_visible,
            infp_sqlstmt,
            tbl_id,
            modifico
            )
      values(
            @id,
            @infp_id,
            @infp_nombre,
            @infp_orden,
            @infp_tipo,
            @infp_default,
            @infp_visible,
            @infp_sqlstmt,
            @tbl_id,
            1
            )

    fetch next from c_params into
                                  @infp_nombre,
                                  @infp_orden,
                                  @infp_tipo,
                                  @infp_default,
                                  @infp_visible,
                                  @infp_sqlstmt,
                                  @tbl_id
  end
  
  close c_params
  deallocate c_params


  fetch next from c_inf into 
        @inf_id,
        @inf_nombre,
        @inf_codigo,
        @inf_descrip,
        @inf_storedprocedure,
        @inf_reporte,
        @inf_presentaciondefault,
        @inf_modulo,
        @inf_tipo,
        @inf_propietario,
        @inf_colocultas,
        @inf_checkbox,
        @inf_totalesgrales,
        @inf_connstr
end

close c_inf
deallocate c_inf

end
go