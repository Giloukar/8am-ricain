-- Repair only audited extraction artifacts; preserve source/source_url provenance.
update public.lexicon
set definition='Boisson chaude ou froide, obtenue en faisant macérer, avec ou sans épices, dans du vin sucré, du citron ou de l’orange.'
where id=13619 and content_status='ready'
  and definition='. Boisson chaude ou froide, obtenue en faisant macérer, avec ou sans épices, dans du vin sucré, du citron ou de l’orange.';

update public.lexicon
set definition='Religion néo-païenne lunaire, attentive à l’écologie de la planète.'
where id=17107 and content_status='ready'
  and definition=', religion néo-païenne lunaire, attentive à l’écologie de la planète.';

update public.lexicon
set definition='Goudron de houille surtout utilisé pour protéger le bois des bateaux.'
where id=21193 and content_status='ready'
  and definition=', goudron de houille surtout utilisé pour protéger le bois des bateaux.';

update public.lexicon
set definition='Rosier sauvage aux fruits oblongs, d’un rouge vif, renfermant des semences enveloppées de poils.'
where id=25545 and content_status='ready'
  and definition='Rosier sauvage aux fruits oblongs, d’un rouge vif, renfermant des semences enveloppées de poils (';

update public.lexicon
set definition=regexp_replace(btrim(definition), ',[[:space:]]*$', '.')
where content_status='ready'
  and difficulty between 4 and 5
  and right(btrim(definition),1)=',';

update public.lexicon
set content_status='hidden'
where id in (15634,16631,21747,23153,25503,20987,25055)
  and content_status='ready';
