insert into public.achievements(key,title,description,icon,xp) values
('lexi_session_50','Marathon lexical','Terminer une session de 50 mots','🏃',100),
('lexi_session_100','Centurion des mots','Terminer une session de 100 mots','💯',250),
('lexi_500','Bibliothèque vivante','Apprendre 500 mots','📚',750),
('lexi_1000','Maître du lexique','Apprendre 1 000 mots','👑',1500)
on conflict(key) do nothing;