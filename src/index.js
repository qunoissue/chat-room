const { Elm }  = require('./Main.elm');
const mountNode = document.getElementById('main');

require('./styles/label.scss');

var newMessage = "";

const app = Elm.Main.init({
  node: document.getElementById('main'),
  flags: newMessage
});

// Initialize Firebase
const config = {databaseURL: "Your App URL"};
firebase.initializeApp(config);
const database = firebase.database();
const ref = database.ref('messages');

// Loads chat messages history and listens for upcoming ones.
ref.on("child_added", (snapshot) => {
    newMessage = {
        id: snapshot.key,
        value: snapshot.val()
    };
    // DEBUG
    console.log(newMessage);

    app.ports.newMessage.send(newMessage);
});

// Saves a new message on the Firebase DB.
const postMessage = (content) => {
  // DEBUG
  console.log(content);

  ref.push(content)
  .then((res) => {
    console.log(res);
  });
};

app.ports.postMessage.subscribe((data) => {
  postMessage(JSON.stringify(data));
});
