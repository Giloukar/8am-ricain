insert into public.achievements(key,title,description,icon,xp) values
('first_win','Première victoire','Remporter sa première partie','🏆',50),
('ten_wins','Habitué du podium','Remporter 10 parties','🥇',150),
('fifty_games','Pilier du Salon','Terminer 50 parties','🎲',250),
('lexi_10','Curieux','Apprendre 10 mots','📖',50),
('lexi_100','Lexicophile','Apprendre 100 mots','🧠',250),
('lexi_master_50','Mémoire d’acier','Maîtriser 50 mots','💎',400),
('streak_7','Régulier','Étudier 7 jours consécutifs','🔥',150)
on conflict(key) do nothing;