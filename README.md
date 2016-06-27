# Description

Interactive interface for the Herbert Willliams' "Dictionary of the Maori Language", published by NZETC under a Creative Commons Attribution-Share Alike 3.0 New Zealand License. Ported from a Flex version, written for Android. See original project for information about the process followed to parse Willliams' dictionary - [https://github.com/widged/MaoriDictionary](github.com/widged/MaoriDictionary)

![preview](https://raw.githubusercontent.com/widged/elm-maori-dictionary/gh-pages/preview.png "Preview")

It is designed to work for elm version **0.17.x**.

You will need at least node.js version **4**.


## Getting Started

Clone this repository and `cd` into it:

```
$ git clone https://github.com/widged/elm-maori-dictionary.git
$ cd elm-seed
```

Run the following two commands to install all dependencies:

```
$ npm install
$ elm package install
```

Start the placeholder API with:

```
$ node api
```

And set the webpack server to serve the HTML, JS and CSS with:

```
$ npm run dev
```

If all went well, the "Hello" message should be viewable at `localhost:3000`.
