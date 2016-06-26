/* jshint esnext: true */

'use strict';

// Require index.html so it gets copied to dist
require('./index.html');

require('./js/sqlite/SqliteProvider.es6.js');
var Elm = require('../src/Main.elm');
var mountNode = document.getElementById('main');

// The third value on embed are the initial values for incomming ports into Elm
var app = Elm.Main.embed(mountNode);

class DictionaryProvider {
  constructor() {
    this.state = {db: null, loaded: false};
  }
  initialize(asyncReturn) {
    var sqlite = new SqliteProvider();
    this.state.db = sqlite;
    sqlite.loadFile('../dist/etc/data/maori_dictionary_0.2.sqlite', () => {
      this.state.loaded = true;
      asyncReturn();
    });
  }

  listItemsForLetter(letter, asyncReturn) {
    const {db} = this.state;
    db.runCommand(`SELECT word, definition FROM dictionary WHERE letter="${letter}"`, (rows) => {
      asyncReturn(rows)
    });
  }

  listItemsForWord(word, asyncReturn) {
    const {db} = this.state;
    db.runCommand(`SELECT word, definition FROM dictionary WHERE word LIKE "%${word}%"`, (rows) => {
      asyncReturn(rows)
    });
  }

}

  var dict = new DictionaryProvider();
  dict.initialize(() => {
  });

  app.ports.letterChange.subscribe(function(letter) {
    console.log('[LETTER CHANGE]', letter);
    dict.listItemsForLetter(letter, (rows) => {
      console.log('  [rows]', rows.length);
      app.ports.setRows.send(rows);
    });
  });

  app.ports.wordChange.subscribe(function(word) {
    console.log('[WORD CHANGE]', word);
    dict.listItemsForWord(word, (rows) => {
      console.log('  [rows]', rows.length);
      app.ports.setRows.send(rows);
    });
  });
