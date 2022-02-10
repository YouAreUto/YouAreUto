# YouAreUto

![Uto logo](https://i.imgur.com/ifXSDKn.png)

> _Let your name be traveler, first rains of spring._

**YouAreUto** is an open source mobile game that pushes you to think outside the box and use your lateral thinking.

The game is developed with [Godot Engine v3.4](https://godotengine.org/download/).

[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

## Principles

- Free as in freedom
- No ads
- Foster creativity
- Bring enjoyment
- Maintain high quality standards

## Download

- PlayStore: https://play.google.com/store/apps/details?id=com.youare.uto
- AppStore: https://apps.apple.com/app/brain-game-teaser-youareuto/id1590561597
- Itch: https://uto-games.itch.io/youareuto

## Contribute and create your challenge

If you want to contribute or create your unique challenge, that's amazing!

Before diving into the contributing guidelines, feel free to [join us on Discord](https://discord.gg/3zxN6kQ).  
Here you can get in touch to discuss anything about YouAreUto.

## Challenge submission process

![challenge flow](https://user-images.githubusercontent.com/6860637/82320094-03da2a80-99d3-11ea-913a-9c219329214c.png)

### Challenge Idea

New challenges can be proposed by any member of the community.

To propose a new **Challenge Idea** [open an issue](https://github.com/YouAreUto/YouAreUto/issues/new?assignees=&labels=challenge+proposal&template=new-challenge-idea.md&title=New+Challenge%3A+%3Ctitle%3E) describing:

1. Challenge name
2. Rules (victory condition and constraints)
3. Solution

If you want to submit a challenge idea and you don't have a GitHub account, send us an email to hello@youareuto.com

Each challenge needs to follow these guidelines:

1. Rules need to be displayed during the game
2. At least one rule needs to be changed by the player in order to win

The original author(s) of the challenge will be credited (if they so desire)
in a dedicated page of the official app (YouAreUto).

### Challenge Prospect

Challenge Ideas that are interesting and are in accordance with YouAreUto’s criteria will be labeled as `prospect` by the admins.

A **Challenge Prospect** could take inputs and ideas from any member of the
community with the aim to improve the challenge if possible.
In any case the intent should be to preserve the original idea as much as possible.

Only Prospects can eventually become Official Challenges.

Once a Prospect is defined, the original authors can start the development and
they can ask for help to the community for the design and development.

Community members cannot independently take over other members’ ideas.

### Official Challenge

When a challenge is fully developed and tested the admins make it an
Official Challenge and add it to the official app.

Each Official Challenge gets a progressive number (i.e. the first
Official Challenge after the MVP will get number 6).

### Challenge Development

To create a new challenge, follow these steps:

- Fork the repository
- Clone the project on your computer
- Open the project with [Godot 3.4.2](https://godotengine.org/download)
- Create a new **Node2D** scene in `scenes/ChallengesProspects/<Username>-<ChallengeTitle>/<ChallengeTitle>.tscn`
- The Node2D root node needs to extend the `Challenge.gd` class:
  - Add a script to your root Node2D
  - Make sure it `extends Challenge`
  - Set the `title` variable in `_init()` (eg: `title = "My Challenge"`)
- Instance `objects/UTO.tscn`
- Create your unique challenge!
- You can:
  - include generic components found in `res://objects/Components`
  - dispatch the `victory` signal
  - dispatch the `game_over` signal
- Create a Pull Request to submit your challenge 🎉

You don't need to create the challenge title audio (eg: [C1.ogg](https://github.com/YouAreUto/YouAreUto/blob/master/assets/sounds/C1.ogg)).  
We will create it and integrate it in the game.

You can find an example in [scenes/ChallengesProspects/ExampleChallenge/](./scenes/ChallengesProspects/ExampleChallenge/)

### Support us

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/T6T11833Q)

## Original developers

- Mauro Pellegrini - Ideator
- Daniela Arienti - Graphic Designer
- Davide Cristini - Game Programmer

Additional help for the open source release:

- Giovanni Bodega
