const { Elm }  = require('./Main.elm');
const mountNode = document.getElementById('main');

require('./styles/app.scss');
require('./styles/form.scss');
require('./styles/loader.scss');
require('./styles/talk.scss');

var receiveMessage = {};
var receiveLocalStorage = {};

const app = Elm.Main.init({
  node: document.getElementById('main'),
  flags: {receiveMessage, receiveLocalStorage}
});

// Loads items from the local storage.
app.ports.getLocalStorage.subscribe( (key) => {
  receiveLocalStorage = {
    key: key,
    value: localStorage.getItem(key)
  };
  app.ports.receiveLocalStorage.send(receiveLocalStorage);
});

// Saves a new item on the local storage.
app.ports.setLocalStorage.subscribe( (req) => {
  localStorage.setItem(req[0],req[1]);
});


// Initialize Firebase
const config = {databaseURL: "Your App Name"};
firebase.initializeApp(config);
const database = firebase.database();
const ref = database.ref('messages');

// Loads chat messages history and listens for upcoming ones.
ref.on("child_added", (snapshot) => {
    receiveMessage = {
        key: snapshot.key,
        value: snapshot.val()
    };
    app.ports.receiveMessage.send(receiveMessage);
});

// Saves a new message on the Firebase DB.
const postMessage = (content) => {
  ref.push(content)
  .then((res) => {
    console.log(res);
  });
};

app.ports.postMessage.subscribe((data) => {
  postMessage(JSON.stringify(data));
});
