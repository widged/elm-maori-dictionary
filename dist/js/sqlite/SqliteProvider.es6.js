/* jshint esnext: true */

function rowsAsObjects(rows) {
  if(!rows) { return [];}
  const {columns, values} = rows;
  return values.map((item) => {
    return item.reduce((acc, d, i) => {
      acc[columns[i]] = d;
      return acc;
    }, {});
  });
}


class SqliteProvider {
  constructor(file) {
    SqliteProvider.STATUS = {undefined: 0, loading: 1, loaded: 2};
    this.state = {status: SqliteProvider.STATUS.loading, db: undefined, file};
  }

  onLoaded(db) {
    this.state.status = SqliteProvider.STATUS.loaded;
    this.state.db = db;
  }

  loadFile(db, asyncReturn) {
    let {status} = this.state;
    if(status === SqliteProvider.STATUS.loaded) {
      return asyncReturn();
    } else {
      let onLoaded = this.onLoaded.bind(this);
      var xhr = new XMLHttpRequest();
      xhr.open('GET', db, true);
      xhr.responseType = 'arraybuffer';
      xhr.onload = function(e) {
        var uInt8Array = new Uint8Array(this.response);
        var db = new SQL.Database(uInt8Array);
        onLoaded(db);
        asyncReturn();
      };
      xhr.send();
    }
  }

  listAllItemsInTable(table, asyncReturn) {
    let {db} = this.state;
    if(!db || typeof db.exec !== "function") { return; }
    var rows = db.exec(`SELECT * FROM ${table}`);
    asyncReturn(rowsAsObjects(rows[0]));
  }

  runCommand(cmd, asyncReturn) {
    let {db} = this.state;
    if(!db || typeof db.exec !== "function") { return; }
    var rows = db.exec(cmd);
    asyncReturn(rowsAsObjects(rows[0]));
  }

}

window.SqliteProvider = SqliteProvider;
