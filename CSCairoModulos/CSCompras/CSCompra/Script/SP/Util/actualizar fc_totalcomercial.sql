    update facturacompra 
    set fc_totalcomercial = isnull( (select sum(fcd_importe) 
                                     from facturacompradeuda fcd 
                                     where fc_id = facturacompra.fc_id 
                                    ),0) 
                            +
                            isnull( (select sum(fcp_importe) 
                                     from facturacomprapago fcp 
                                     where fc_id = facturacompra.fc_id 
                                    ),0)

GO
