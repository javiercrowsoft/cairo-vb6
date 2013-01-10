if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetHojasAgenda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetHojasAgenda]

/*
select agn_id from Agenda group by agn_id
select * from tabla where tbl_nombrefisico = 'Agenda'
select * from listaprecioitem
select * from rama where arb_id in (select arb_id from arbol where tbl_id = 2010)
select * from hoja where ram_id = 10268

sp_ArbGetHojasAgenda 446,10268

*/

go
create procedure sp_ArbGetHojasAgenda (
  @@us_id        int,
  @@ram_id         int,
  @@soloColumnas   smallint = 0,
  @@aBuscar       varchar(255) ='',
  @@top           int = 1500
)
as
begin
set nocount on

declare @ram_id_padre    smallint
declare @arb_id          int

  select @ram_id_padre = ram_id_padre, @arb_id = arb_id from rama where ram_id = @@ram_id
  
  if @ram_id_padre = 0 -- Estamos en una raiz
   begin

    create table #HojaId (hoja_id int, id int)

    -- Ids de la raiz
    insert into #HojaId select hoja_id,id from Hoja where ram_id = @@ram_id

    -- Ids sin asignar
    insert into #HojaId 
        select agn_id *-1, agn_id 
        from Agenda 
        where not exists (select * from Hoja 
                          where Hoja.id = Agenda.agn_id 
                            and arb_id = @arb_id 
                          )

    select --top @@top 
  
            hoja_id, 
            ID              = Agenda.agn_id, 
            Nombre          = agn_nombre
    from 
          -- el filtro esta en #HojaId
          Agenda  inner join #HojaId         on #HojaId.id = Agenda.agn_id

    where      (
                    (
                      exists(select * from Permiso 
                             where pre_id = Agenda.pre_id_propietario 
                               and us_id = @@us_id
                            )
                    )
                  or 
                    (
                      exists(select * from Permiso  
                             where pre_id = Agenda.pre_id_propietario 
                               and exists (select * from UsuarioRol 
                                           where rol_id = Permiso.rol_id
                                            and  us_id = @@us_id
                                          )
                            )
                    )
                )


   end
  else 
    select --top @@top 
  
            hoja_id, 
            ID              = Agenda.agn_id, 
            Nombre          = agn_nombre
    from 
          Agenda  inner join Hoja on Hoja.id = Agenda.agn_id 
    where 
          Hoja.ram_id = @@ram_id
      and      (
                    (
                      exists(select * from Permiso 
                             where pre_id = Agenda.pre_id_propietario 
                               and us_id = @@us_id
                            )
                    )
                  or 
                    (
                      exists(select * from Permiso  
                             where pre_id = Agenda.pre_id_propietario 
                               and exists (select * from UsuarioRol 
                                           where rol_id = Permiso.rol_id
                                            and  us_id = @@us_id
                                          )
                            )
                    )
                )

 end

go