if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_SQLCompare]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SQLCompare]

/*

sp_SQLCompare
								'cairo',
								'cairoEmpty'

*/

go

create procedure sp_SQLCompare (
	
	@@db1 		varchar(255),
	@@db2 		varchar(255),
	@@bCreateSql tinyint = 0

)

as

begin

	declare @sqlstmt varchar(8000)

  set nocount on


	if @@bCreateSql = 0 begin

		set @sqlstmt = 
											'select t1.name ['+@@db1+'_tabla], c1.name ['+@@db1+'_columna], t2.name ['+@@db2+'_tabla], c2.name ['+@@db2+'_columna]'
										
										+	'from '+@@db1+'..sysobjects t1 '
																						+'		inner join '+@@db1+'..syscolumns c1 on t1.id = c1.id '
																						+'		left  join '+@@db2+'..sysobjects t2 on t1.name = t2.name '
																						+'		left  join '+@@db2+'..syscolumns c2 on 	t2.id = c2.id '
																																									+'	and c1.name = c2.name '
										+ 'where IsNull(t1.xtype,''U'') = ''U'' and IsNull(t2.xtype,''U'') = ''U'''
										+  ' and (    t1.name is null or c1.name is null'
										+  '       or t2.name is null or c2.name is null'
										+  '     )'
	
		exec (@sqlstmt)
	
	
		set @sqlstmt = 
											'select t1.name ['+@@db2+'_tabla], c1.name ['+@@db2+'_columna], t2.name ['+@@db1+'_tabla], c2.name ['+@@db1+'_columna]'
										
										+	'from '+@@db2+'..sysobjects t1 '
																						+'		inner join '+@@db2+'..syscolumns c1 on t1.id = c1.id '
																						+'		left  join '+@@db1+'..sysobjects t2 on t1.name = t2.name '
																						+'		left  join '+@@db1+'..syscolumns c2 on 	t2.id = c2.id '
																																									+'	and c1.name = c2.name '
										+ 'where IsNull(t1.xtype,''U'') = ''U'' and IsNull(t2.xtype,''U'') = ''U'''
										+  ' and (    t1.name is null or c1.name is null'
										+  '       or t2.name is null or c2.name is null'
										+  '     )'

	end else begin

		if @@bCreateSql = 1 begin

			set @sqlstmt = 
												'select ''alter table '' + t1.name + '' add '' +'

																+char(13)+'c1.name + isnull('
																
																+char(13)+'case c1.type'
																
																+char(13)+'	when 38		then '' int '''
																+char(13)+'	when 39		then '' varchar('' + convert(varchar,c1.prec) + '') '''
																+char(13)+'	when 48   then '' tinyint'''
																+char(13)+'	when 52   then '' smallint'''
																+char(13)+'	when 56		then '' int'''
																+char(13)+'	when 59   then '' real'''
																+char(13)+'	when 61   then '' datetime'''
																+char(13)+'	when 109  then '' real'''
																+char(13)+'	when 55   then '' decimal(18,6)'''
																+char(13)+'	else ''( '' + convert(varchar,c1.type) + '' ) '''																
																+char(13)+'end +'
																
																+char(13)+'case c1.isnullable'
																
																+char(13)+'	when 0 then '' not null '''
																+char(13)+'	else        '' null '''
																
																+char(13)+'end'
																
																+char(13)+'+ case when t.text is null then '''' else ''default '' + t.text end'

											+char(13)+ ',''''), t2.name ['+@@db2+'_tabla], c2.name ['+@@db2+'_columna]'
											
											+char(13)+	'from '+@@db1+'..sysobjects t1 '
																							+char(13)+'		inner join '+@@db1+'..syscolumns c1 on t1.id = c1.id '
																							+char(13)+'		left  join '+@@db2+'..sysobjects t2 on t1.name = t2.name '
																							+char(13)+'		left  join '+@@db2+'..syscolumns c2 on 	t2.id = c2.id '
																																										+'	and c1.name = c2.name '

																							+char(13)+'		left join '+@@db1+'..sysobjects t3 on 	t3.parent_obj = t1.id'
																							+char(13)+'														and col_name(t1.id , t3.info) = c1.name'
																							+char(13)+'														and t3.xtype in ( ''D '')'
																
																							+char(13)+'		left join '+@@db1+'..syscomments t on t3.id = t.id'

											+char(13)+ 'where IsNull(t1.xtype,''U'') = ''U'' and IsNull(t2.xtype,''U'') = ''U'''
											+char(13)+  ' and (    t1.name is null or c1.name is null'
											+char(13)+  '       or t2.name is null or c2.name is null'
											+char(13)+  '     )'
											+char(13)+  ' and t2.name is not null and c2.name is null'

		end else begin

			if @@bCreateSql = 2 begin
	
				set @sqlstmt = 
													'select distinct t1.name ['+@@db1+'_tabla]'
												
												+	'from '+@@db1+'..sysobjects t1 '
																								+'		inner join '+@@db1+'..syscolumns c1 on t1.id = c1.id '
																								+'		left  join '+@@db2+'..sysobjects t2 on t1.name = t2.name '
																								+'		left  join '+@@db2+'..syscolumns c2 on 	t2.id = c2.id '
																																											+'	and c1.name = c2.name '
												+ 'where IsNull(t1.xtype,''U'') = ''U'' and IsNull(t2.xtype,''U'') = ''U'''
												+  ' and (    t1.name is null or c1.name is null'
												+  '       or t2.name is null or c2.name is null'
												+  '     )'
												+  ' and t2.name is null and c2.name is null '
												+ 'Order by t1.name'
			end
		end
	end
	
	exec (@sqlstmt)

ControlError:

end