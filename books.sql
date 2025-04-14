use LMT;

insert BookDescription(ISBN, title, pubYear, synopsis)
values (9781250007209, 'Cinder', 2013, 'Humans and androids crowd the raucous streets of New Beijing. A deadly plague ravages the population. From space, a ruthless lunar people watch, waiting to make their move. No one knows that Earth''s fate hinges on one girl.... Sixteen-year-old Cinder, a gifted mechanic, is a cyborg. She''s a second-class citizen with a mysterious past and is reviled by her stepmother. But when her life becomes intertwined with the handsome Prince Kai''s, she suddenly finds herself at the center of an intergalactic struggle, and a forbidden attraction. Caught between duty and freedom, loyalty and betrayal, she must uncover secrets about her past in order to protect her worlds future. Becuase there is something unusual about Cinder, something that others would kill for.'),
(9781250007216, 'Scarlet', 2014, 'Cinder, the cyborg mechanic, returns in the second thrilling installment of the bestselling Lunar Chronicles. She is trying to break out of prison -even though if she succeeds, shell be the Commonwealth''s most wanted fugitive. Halfway around the world, Scarlet Benoit''s grandmother is missing. When Scarlet encounters Wolf, a street fighter who may have information about her grandmother''s whereabouts, she is loath to trust this stranger, but is inexplicably drawn to him, and he to her. As Scarlet and Wolf unravel one mystery, they encounter another when they meet Cinder. Now, all of them must stay one step ahead of the vicious Lunar Queen Levana, who will do anything for the handsome Prince Kai to become her husband, her king, her prisoner.'),
(9781250007223, 'Cress', 2015, 'Cress, having risked everything to warn Cinder of Queen Levana''s evil plan, has a slight problem. She''s been imprisooned on a satellite since childhood and has only ever had her netscreens as company. All that screen time has made Cress an excellent hacker. Unfortunately, she''s just received orders from Levana to track down Cinder and her handsome accomplice. When a daring rescue of Cress involving Cinder, Captain Thorne, Scarlet, and Wolf goes awry, the gropu is separated. Cress finally has her freedom, but it comes at a high price. Meanwhile, Queen Levana will let nothing prevent her marriage to Emperor Kai. Cress, Scarlet, and Cinder may not have signed up to save the world, but they may be the only hope the world has.'),
(9781250074218, 'Winter', 2015, 'Princess Winter is admired by the Lunar people for her grace and kindness, and despite the scars that mark her face, her beauty is said to be more breathtaking than that of her stepmother, Queen Levana. Winter despises her stepmother, and knows Levana won''t approve of her feelings for her childhood friend--the handsome palace guard, Jacin. But Winter isn''t as weak as Levana believes her to be and she''s been undermining her stepmother''s wishes for years. Together with the cyborg, Cinder, and her allies, Winter might even have the power to launch a revolution and win a war that''s been raging for far too long. Can Cinder, Scarlet, Cress, and Winter defeat Levana and find their happily ever afters?'),
(9781250104458, 'Stars Above', 2016, 'The universe of the Lunar Chronicles holds stories—and secrets—that are wondrous, vicious, and romantic. How did Cinder first arrive in New Beijing? How did the brooding soldier Wolf transform from young man to killer? When did Princess Winter and the palace guard Jacin realize their destinies?'),
(9781250069665, 'Fairest', 2015, 'Queen Levana is a ruler who uses her ''glamour'' to gain power. But long before she crossed paths with Cinder, Scarlet, and Cress, Levana lived a very different story-a story that has never been told... until now');

insert into BookGenre select ISBN, 'Fantasy' from BookDescription;
insert into BookGenre select ISBN, 'Science Fiction' from BookDescription;
insert into BookGenre select ISBN, 'Fiction' from BookDescription;
insert into BookGenre select ISBN, 'Romance' from BookDescription;

insert Author(name) values('Marissa Meyer');

insert into Book_Author select ISBN, id from BookDescription, Author;

insert Series(name) values('Lunar Chronicles');

insert into Book_Series select ISBN, id from BookDescription, Series;
