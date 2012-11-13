
delete cuenta where cue_id not in (select cue_id from cuentagrupo)
and cue_id not in (select cue_id from tasaimpositiva)
and cue_id not in (select cue_id from retenciontipo)
and cue_id not in (select cue_id from percepciontipo)
and cue_id not in (select cue_id from tipooperacioncuentagrupo)

