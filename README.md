# RentsWatch

This app requires a system with `node` (tested with *5.7.1*), `npm` (tested with *3.5.2*) and `grunt-cli` (tested wwith *0.1.13*).

## Quick install

From the root directory

```
make install
```

## Configure

Create a configuration file using the template:

```
cp server/config/local.env.sample.js  server/config/local.env.js
```

Then change values to add the `DATABASE_URL` and the `RENTSWATCH_API_TOKEN`:

```node
module.exports = {
  DOMAIN: 'http://localhost:9000',
  SESSION_SECRET: "rentswatchapp-secret",
  DATABASE_URL: 'mysql://...',
  RENTSWATCH_API_TOKEN: '...'
};
```

## Serve files

Still from the root directory

```
make run
```

## Deploy

To deploy the app on Heroku, you must have `Docker` and `Docker Compose`
installed on your machine.

To verify that you have a working Docker installation, open a shell and run:

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND ...
$ docker-compose --version
docker-compose version 1.5.2, build 7240ff3
```

You may now install the [Heroku Toolbet](https://toolbelt.heroku.com/) as follow:

```
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
```

And the Docker plugin for the toolbelt:

```
heroku plugins:install heroku-docker
```

You may now be able to deploy the app using this command:

```
make deploy
```

## Commands

This application comes with a few commands to run in your terminal.

Command | Description
--- | ---
`make install` | ...
`make run` | ...
`make prefetch` | ...
`make deploy` | ...
`make artillery` | ...

## Translation credits

Huge thanks to:

* Adrián Blanco for the Spanish version
* Riccardo Maddalozzo for the Italian version
* Markéta Malinová, and Douglas Arellanes for the Czech version
* Karl Martinsson for the Swedish version

and to [Pinkie](https://twitter.com/penhleakchan) for her help!

## Press coverage

- [Votre loyer est-il trop élevé ?](http://www.francetvinfo.fr/economie/immobilier/prix-immobilier/votre-loyer-est-il-trop-eleve_1428059.html), FranceTV Info (Paris).
- [Une application pour savoir si son loyer correspond au prix du marché](http://www.directmatin.fr/france/2016-05-01/une-application-pour-savoir-si-son-loyer-correspond-au-prix-du-marche-728575), DirectMatin (Paris).
- [Votre loyer est-il trop élevé? La réponse en quelques clics](http://lexpansion.lexpress.fr/actualite-economique/votre-loyer-est-il-trop-eleve-la-reponse-en-quelques-clics_1788005.html), L'Expansion (Paris).
- [Non, la rue la plus chère de Suisse n'est pas celle que vous croyez](http://www.rts.ch/info/suisse/7677603-non-la-rue-la-plus-chere-de-suisse-n-est-pas-celle-que-vous-croyez.html), RTS (Genève).
- [Votre loyer est-il trop cher ? La réponse qui pique](http://www.lesinrocks.com/2016/05/news/loyer-cher-reponse-piquante/), Les Inrocks (Paris).
- [Loyers. Un nouvel outil pour savoir si vous payez trop cher](http://www.letelegramme.fr/dataspot/loyers-un-nouvel-outil-pour-savoir-si-vous-payez-trop-cher-02-05-2016-11052491.php#closePopUp), Le Télégramme (Brest).
- [Votre loyer coûte-t-il trop cher?](http://www.gqmagazine.fr/pop-culture/news/articles/votre-loyer-coute-t-il-trop-cher-/41208), GQ Magazine (Paris).
- [Huurt u duur of goedkoop?](http://netto.tijd.be/vastgoed/Huurt_u_duur_of_goedkoop.9762015-1625.art?ckc=1&ts=1462265570), De Tijd (Brussels).
- [Grâce à cette infographie, vous allez savoir si vous payez votre loyer trop cher](http://www.konbini.com/fr/tendances-2/payez-vous-votre-loyer-trop-cher/), Konbini (Paris).
- Rentswatch dans [la chronique immobilier de BFM Business](http://www.dailymotion.com/video/x48feff_marie-coeurderoy-rentswatch-votre-loyer-est-il-trop-eleve-03-05_news) (Paris).
- [Un site pour vérifier que votre loyer n’est pas trop cher](http://www.lesoir.be/1199528/article/economie/2016-05-03/un-site-pour-verifier-que-votre-loyer-n-est-pas-trop-cher), Le Soir (Brussels).
- [Immobilier : votre loyer est-il trop élevé ?](http://www.ladepeche.fr/article/2016/05/03/2337185-immobilier-votre-loyer-est-il-trop-eleve.html), La Dépêche (Toulouse).
- [¿Vives en un piso caro o barato?](http://www.elconfidencial.com/sociedad/2016-05-04/vives-en-un-piso-caro-o-barato_1193950/pass_6e052cecbaa82b871a6b1c6ee783c911/), El Confidencial (Madrid).
- [Votre loyer est-il trop cher ? Cette application va vous le dire](http://www.cosmopolitan.fr/,votre-loyer-est-il-trop-cher-cette-application-va-vous-le-dire,1963736.asp) Cosmopolitain (Paris).
- [VIDÉO - Avec l'application RentsWatch, découvrez si votre loyer est trop élevé](http://www.rtl.fr/culture/web-high-tech/video-avec-l-application-rentswatch-decouvrez-si-votre-loyer-est-trop-eleve-7783087152), RTL (Paris).
- [Payez-vous trop cher votre loyer ? La réponse en quelques clics](http://www.midilibre.fr/2016/05/04/payez-vous-trop-cher-votre-loyer-la-reponse-en-quelques-clics,1326797.php), Midi Libre, (Montpellier).
- [Bruxelles: votre loyer est-il trop élevé ? (INFOGRAPHIE)](http://www.dhnet.be/regions/bruxelles/bruxelles-votre-loyer-est-il-trop-eleve-infographie-5727b92635702a22d6fa902b), DHnet (Bruxelles).
- [Logement. Payez-vous votre loyer trop cher ?](http://m.jactiv.ouest-france.fr/actualites/france/logement-payez-vous-votre-loyer-trop-cher-62468), Ouest-France (Rennes)
- [VIDEO. Rentswatch, le site qui vérifie si votre loyer est trop élevé](http://www.20minutes.fr/high-tech/1839967-20160504-video-rentswatch-site-verifie-si-loyer-trop-eleve), 20 Minutes (Paris).
- [Votre loyer est-il trop élevé ? Cliquez pour connaître la réponse](http://immobilier.lefigaro.fr/article/votre-loyer-est-il-trop-eleve-cliquez-pour-connaitre-la-reponse_ce0b2ee4-112e-11e6-add5-a67a916e7483/), Le Figaro (Paris).
- [Ist Ihre Miete zu hoch? Diese Seite verrät es Ihnen!](http://www.stern.de/wirtschaft/immobilien/ist-ihre-miete-zu-hoch--diese-seite-verraet-es-ihnen--6831746.html?utm_campaign=alle-nachrichten&utm_medium=rss-feed&utm_source=standard), Stern (Hamburg).
- [Payez-vous trop cher votre loyer ?](http://start.lesechos.fr/continuer-etudes/vie-etudiante/payez-vous-trop-cher-votre-loyer-4563.php#xtor=CS2-9), Les Echos (Paris).
- [RentsWatch : de la big data pour savoir si votre loyer est trop élevé](http://www.numerama.com/tech/167989-rentswatch-de-la-big-data-pour-savoir-si-votre-loyer-est-trop-eleve.html?utm_source=twitterfeed&utm_medium=twitter), Numérama (Paris).
- [Votre loyer est-il trop cher ?](http://www.itele.fr/economie/video/votre-loyer-est-il-trop-cher-163645), iTélé (Paris).
- [Ist ihre Miete angemessen?](http://www.bz-berlin.de/liveticker/ist-ihre-miete-angemessen), BZ (Berlin).
- [Un site internet pour savoir si vous ne payez pas trop cher votre loyer](Un site internet pour savoir si vous ne payez pas trop cher votre loyer), Var-Matin (Nice).
- [Mit diesem Tool kannst du herausfinden, ob du zu viel Miete zahlst](http://ze.tt/mit-diesem-tool-kannst-du-herausfinden-ob-du-zu-viel-miete-zahlst/), Ze.tt (Berlin)
- ["Rentswatch" : le site pratique qui nous dit si notre loyer est trop élevé](http://www.bibamagazine.fr/style-de-vie/bonsplans/rentswatch-le-site-pratique-qui-nous-dit-si-notre-loyer-est-trop-eleve-56055), BIBA (Paris).
- [Payez-vous votre loyer trop cher? Faites le test!](http://www.bienpublic.com/actualite/2016/05/06/payez-vous-votre-loyer-trop-cher-faites-le-test), Le Bien Public (Dijon) & L'Alsace (Strasbourg).
- [Эксперты опровергли предложенную в «Монополии» систему оценки недвижимости](http://dom.lenta.ru/news/2016/05/06/swiss/), Lenta.ru (Moskva)
- [Votre loyer est-il trop élevé ? Une application le vérifie pour vous](http://www.sudouest.fr/2016/05/07/votre-loyer-est-il-trop-eleve-une-application-le-verifie-pour-vous-2354796-705.php), Sud Ouest (Bordeaux)
- [Mit diesem Tool kannst du herausfinden, ob du zu viel Miete zahlst](http://businessinsider.de/mit-diesem-tool-kannst-du-herausfinden-ob-du-zu-viel-miete-zahlst-2016-5), Business Insider (Karlsruhe)
- [Votre loyer est-il trop cher ? Faites le test](http://www.lequotidien.lu/economie/votre-loyer-est-il-trop-cher-faites-le-test/), Le Quotidien (Luxembourg)
- [Voici l'application pour savoir si vous payez (vraiment) trop cher votre loyer](http://www.planet.fr/immobilier-voici-lapplication-pour-savoir-si-vous-payez-vraiment-trop-cher-votre-loyer.1070985.1555.html), Planet.fr (Paris).
- [Ist die Miete zu hoch? – „Rentswatch“ verrät es ](http://www.noz.de/deutschland-welt/niedersachsen/artikel/710923/ist-die-miete-zu-hoch-rentswatch-verrat-es) Neue Osnabrücker Zeitung (Osnabrück).
- [Votre loyer est-il trop élevé ?](http://blogs.lecho.be/tzine/2016/05/votre-loyer-est-il-trop-%C3%A9lev%C3%A9-.html), L'Echo (Bruxelles).
- [RentsWatch, la mappa degli affitti in Europa](http://tg24.sky.it/tg24/economia/2016/05/11/rentswatch-mappa-affitti-europa.html?utm_source=dlvr.it&utm_medium=twitter), Sky (Milan)
- [Una web permet de comparar el preu del lloguer del vostre pis amb el de tot Europa](http://www.vilaweb.cat/noticies/una-web-permet-comparar-el-vostre-preu-de-lloguer-amb-el-de-tot-europa/), VilaWeb (Barcelona)
- [LA CARTE DES LOYERS PAR STATION DE MÉTRO](http://www.streetpress.com/sujet/1462985273-carte-loyers-par-station-de-metro), Streetpress (Paris)
- [La carte de métro des loyers parisiens](http://www.lefigaro.fr/sortir-paris/2016/05/19/30004-20160519ARTFIG00369-la-carte-de-metro-des-loyers-parisiens.php), Le Figaro (Paris)