delete ajusteinflacionindice

insert into ajusteinflacionindice(ajii_id,ajii_fecha,ajii_indice,modifico)

select id,fecha,round(indice,2),1 from t_indices

sp_iddelete