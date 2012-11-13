update asientoitem set asi_debe = abs(asi_haber), asi_haber = 0 where asi_haber < 0
update asientoitem set asi_haber = abs(asi_debe), asi_debe = 0 where asi_debe < 0