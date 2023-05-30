const words = require("./words.json");

const predictions = require("./predictions.json");

const token = require("./token.json");

function select(choices) {
    return choices[Math.floor(choices.length * Math.random())];
}

function generate() {
    let word = "";
    let message = "";
    for (let i = 0; i < 100; i++) {
        let options = predictions[words.indexOf(word)];
        word = select(options);
        if (word == "\n") break;
        message = message.concat(" ").concat(word);
    }
    return message;
}

const { Client, GatewayIntentBits } = require("discord.js");

const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] });

client.on('messageCreate', async message => {
    if (message.author.bot) return;
    // The number in the line below is the probability of sending a message.
    if (Math.random() < 0.5) return;
    // Optionally restrict activity within a given server to a particular channel.
    // if (message.guildId == integer_guild_ID_goes_here && message.channel.name != string_channel_name_goes_here) return;
    else message.channel.send(generate());
});

// The bot signs in to discord using its token.
client.login(token);
