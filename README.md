# Simple Signal Bot

[See Medium Article](https://medium.com/digital-forensics-deep-learning-and-dev/simple-signal-bot-6ce841c7982e) 

**Signal** is a cross-platform encrypted messaging service. It uses the Internet to send one-to-one and group messages, which can include files, voice notes, images and videos. Its mobile apps can also make one-to-one voice and video calls, and the Android version can optionally function as an SMS app.

Signal uses standard cellular telephone numbers as identifiers and uses end-to-end encryption to secure all communications to other Signal users. The apps include mechanisms by which users can independently verify the identity of their contacts and the integrity of the data channel.

A **bot** is an application that runs automated, usually repetitive tasks over the Internet. Simple bot get messages as commands and return a results. For example, a server system status, etc.

Why **bash**?, because I know it, and it works well with signal-cli and command execution in terminal.

## Requirements

    A Signal account. Take one in: https://signal.org/
    A mobile phone with signal app installed. (Android, iPhone).. or Desktop ;-)
    A linux as bot server

## Requeriments Installation
### signal-cli installation

Unpack a release from https://github.com/AsamK/signal-cli/releases, e.g. to ~/signal-cli.

Open a command line and change to the subdirectory bin where the release has been unpacked into:

cd ~/signal-cli/bin

### Set up an account

Note: In Signal/signal-cli the account is called “username”, which is slightly misleading, since it is a phone number including the country code. The used phone number is required for one-time verification of the installation. In this example I will use two German cell phone numbers, thus they will start with +491515…

    Register your phone number Enter

```./signal-cli -u +4915151111111 register```

on the command line. If all goes well, there is no reply. Execution takes a few seconds. +491515111111 is thus the phone number that will be used by the signal-cli installation.

After a few seconds, you will receive an SMS on the cell phone with phone number +4915151111111 that contains the verification code (123–456 in this example):

Your TextSecure verification code: 123–456 25 Feb. 2017 10:52

Note: You can register Signal using a land line number. In this case you can skip SMS verification process and jump directly to the voice call verification by adding the --voice switch at the end of above register command.

    Verify your phone number Enter

```./signal-cli -u +4915151111111 verify 123–456```

on the command line. Again, no reply if all is fine.
Send a first message from the command line

We assume that the receiver of the message has the phone number +4915152222222. Enter

```./signal-cli -u +4915151111111 send -m “My first message from the CLI” +4915152222222```

on the command line. Again, no reply if all is fine.

Within a few seconds, the Signal App on the cell phone +4915152222222 will receive the message.
Send a first reply to the command line

With the same setup, enter a message (e.g. “First reply to the CLI”) on the cell phone +4915152222222.

Enter

```./signal-cli -u +4915151111111 receive```

on the command line. This gets more output after a few seconds:

```
Envelope from: +4915152222222 (device: 1) Timestamp: 1488016532387 (2017–02–25T09:55:32.387Z) Message timestamp: 1488016532387 (2017–02–25T09:55:32.387Z) Body: First reply to the CLIEnvelope from: +4915152222222 (device: 1) Timestamp: 1488017026720 (2017–02–25T10:03:46.720Z) Got receipt.
```

The message is contained in the line starting with

```Body:```

## signalbot Installation

Unpack a release from https://github.com/fmuinos/signalbot

1º Edit file “signal.lib.sh” and put the signalbot phone number.

 ```signaluser=”+12 123456789”```

2º Add to “whitelist.txt” the phone numbers with perms to exec commands. This is the access control to signalbot.

```
+4915152222222
+4915153333333
```

3º Load the signalbot library in Bash:

```. signal.lib.sh```

4º Exec the bot:

```start_signal_chatbot```

5º Change signal.lib.sh for your commands…

That’s is all, Folks!
