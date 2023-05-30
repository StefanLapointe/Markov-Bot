# Markov-Bot
### Some code I use to make discord bots that immitate users.

## Instructions:
1. Download channels as JSON files using DiscordChatExporter by Tyrrrz. `messages` can be any character vector, but in my workflow, I use DiscordChatExporter, and I have included the functions that I use to turn the JSON file it gives me into a character vecctor.
2. Put these JSON files into a folder called `channels` within the `Markov-Bot` folder.
3. Run the R script to generate the bot folder. You will be asked to enter the bot's token, but if you don't trust my R script, you can always enter something else and then manually change the token.json file in the bot folder.
4. Install discord.js for your JavaScript runtime environment.
5. Your bot should now be ready to run. I use Node.js, so I `cd` to the bot folder and then enter `node .`, but I think it would work with any other JavaScript runtime environment.

## How does it work?
It is essentially a Markov chain in that each word is selected randomly with a distribution according to the previous word. In the R script, each string in `messages` is tokenized into nonempty words with whitespace as the delimiter. `""` and `"\n"` encode the beginning and end of a message respectively, so generation always starts with `""` as the first word, and terminates when the word `"\n"` is chosen. `words.json` will be a list of every word that appears more than once. The `i`th entry of `predictions.json` will be a list that contains every word that has followed the `i`th entry of `words.json` more than once. In the JavaScript bot code, the next word in a message is chosen by looking up the index of the last word in `words.json` and then randomly choosing a word from the corresponding index of `predictions.json`. If the corresponding index of `predictions.json` is an empty list, the message generation terminates. I arbitrarily cap message length at 100 words.

## Random stuff
The R script includes a function called `generate()` which you can use to test out the Markov chain by running `generate(word_prediction_table)` before starting up the bot. If you look in `index.js`, so you can see that there is a commented-out line that allows you to restrict the bot's activity in a given server to a specific channel.
