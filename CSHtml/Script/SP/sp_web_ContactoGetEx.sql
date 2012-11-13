if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ContactoGetEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactoGetEx]

/*

-- 43750526

update contacto set cont_tipo=1 where us_id = 1

select * from contacto where prov_id is not null

sp_web_ContactoGetEx 
																  0,
																  0,
																  'a%',
																  101,
																	0,
																	'',
																	2

*/

go
create procedure sp_web_ContactoGetEx (
	@@cli_id									int,
	@@prov_id			 						int,
	@@cont_nombre							varchar(100),
	@@us_id									  int,
	@@cont_id                 int=0,
  @@filter                  varchar(100)='',
  @@cont_tipo               int=0
)

as

begin

	set nocount on

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 2001, @@cont_id, @@us_id, 2

	set @@filter 			= IsNull(@@filter,'')
	set @@cont_nombre = IsNull(@@cont_nombre,'')


declare @bShowEmptyContact int

set @bShowEmptyContact = 0

--/////////////////////////////////////////////////////////////////////////////////////////////
	
if not exists
         (select per_id 
					from Permiso inner join Agenda on pre_id = pre_id_listar
                       inner join Contacto on Agenda.agn_id = Contacto.agn_id
          where cont_id = @@cont_id 
           and (Permiso.us_id = @@us_id
                or (exists( select rol_id 
														from UsuarioRol 
														where rol_id = Permiso.rol_id 
															and us_id = @@us_id))
                )
         )
begin

	set @bShowEmptyContact = 1

end

--/////////////////////////////////////////////////////////////////////////////////////////////

	if @@cont_tipo = 3 set @@cont_tipo = 0

	if @@cont_id = 0 begin

		select

					cont_id,
					'Tipo'            = cont_tipo,
					'Cargo'           = cont_cargo,
					'Nombre'          =	case
																when cont_apellido<>'' then cont_apellido +', '+cont_nombre
																else                        cont_nombre
															end,
	        'Codigo'          = cont_codigo,
	        'Telefono'        = cont_tel,
	        'Celular'         = cont_celular,
	        'Email'           = cont_email,
	        'Direccion'       = cont_direccion,
					'Descripcion'    	= cont_descrip,
					'Cliente'				  = cli_nombre,
				  'Proveedor'  			= prov_nombre,
					'Usuario' 			  =	us.us_nombre,
					'Activo'					= c.activo, 
          'Modifico'        = m.us_nombre,
					'Descripción' 		= cont_descrip,
          'Agenda'          = agn_nombre,
           c.us_id
		from 
	
			Contacto as c 		 inner join Agenda as a       on c.agn_id       = a.agn_id
                         left join usuario as us 			on c.us_id   			= us.us_id
												 left join cliente       			on c.cli_id       = cliente.cli_id
												 left join proveedor     			on c.prov_id      = proveedor.prov_id
												 left join usuario as m       on c.modifico     = m.us_id
	
		where
					(c.cli_id             = @@cli_id 					or @@cli_id = 0)
		and   (c.prov_id            = @@prov_id 				or @@prov_id = 0)

		and   (		 
								-- Los personales
								(
										(@@us_id = c.us_id 
                    or exists(select per_id from Permiso inner join Agenda on Permiso.pre_id = Agenda.pre_id_propietario
                                                                          and Agenda.agn_id  = c.agn_id
                                             where us_id = @@us_id 
                                                or (exists(select rol_id from UsuarioRol 
                                                           where rol_id = Permiso.rol_id and us_id = @@us_id))
                               )
                    )
								and	cont_tipo = 2
								and (@@cont_tipo = 2 or @@cont_tipo = 0)
								) 

						or @@us_id = 0

						-- Los corporativos
						or (
										cont_tipo = 1 -- Publico
								and (@@cont_tipo = 1 or @@cont_tipo = 0)
                and exists(select per_id from Permiso inner join Agenda on Permiso.pre_id = Agenda.pre_id_listar
                                                                       and Agenda.agn_id  = c.agn_id
                                         where us_id = @@us_id 
                                            or (exists(select rol_id from UsuarioRol 
                                                       where rol_id = Permiso.rol_id and us_id = @@us_id))
                           )
							)
					)

    and   (		 cont_nombre    like @@cont_nombre  
						or cont_apellido  like @@cont_nombre  
						or @@cont_nombre = '')	
		and   (		 cli_nombre 		like @@filter 
						or prov_nombre 		like @@filter 
						or cont_cliente 	like @@filter
						or cont_proveedor	like @@filter
						or @@filter = ''
					)

		order by cont_nombre, cli_nombre, prov_nombre

	end else begin

    declare @bCanEdit int

    if exists(select per_id from Permiso inner join Agenda on pre_id = pre_id_propietario
                                         inner join Contacto on Agenda.agn_id = Contacto.agn_id
              where cont_id = @@cont_id 
                 and (Permiso.us_id = @@us_id
                      or (exists(select rol_id from UsuarioRol where rol_id = Permiso.rol_id and us_id = @@us_id))
                      )
             )
    begin

      if exists(select per_id from Permiso inner join Agenda on pre_id = pre_id_editar
                                           inner join Contacto on Agenda.agn_id = Contacto.agn_id
                where cont_id = @@cont_id 
                   and (Permiso.us_id = @@us_id
                        or (exists(select rol_id from UsuarioRol where rol_id = Permiso.rol_id and us_id = @@us_id))
                        )
               )
      begin
                  set @bCanEdit = 1
      end
      else        set @bCanEdit = 0
    end
    else          set @bCanEdit = 0

		select
					contacto.*,
          cli_nombre,
          prov_nombre,
          ciu_nombre,
          pro_nombre,
          pa_nombre,
          agn_nombre,
          bCanEdit = @bCanEdit
		from 
					Contacto inner join Agenda     on Contacto.agn_id   = Agenda.agn_id
                   left join Cliente     on Contacto.cli_id   = Cliente.cli_id
                   left join Proveedor   on Contacto.prov_id  = Proveedor.prov_id
                   left join Ciudad      on Contacto.ciu_id   = Ciudad.ciu_id
                   left join Provincia   on    (Contacto.pro_id   = Provincia.pro_id and Contacto.pro_id is not null)
                                            or (Ciudad.pro_id     = Provincia.pro_id)
                   left join Pais        on Provincia.pa_id   = Pais.pa_id
                                            
		where
	
				cont_id = @@cont_id
			and @bShowEmptyContact = 0

	end
end
go