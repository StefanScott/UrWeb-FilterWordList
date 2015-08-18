# UrWeb-FilterWordList

This is a simple Ur/Web example which lets the user type lowercase letters [a-z]* into a `<ctextbox>` to instantly filter a table of 192,425 English words, using the SQL `LIKE` operator, to show up to 50 rows at a time.

You can use the `\copy` command in `psql`, to add the words.

The file `script.txt` contains all the Linux and psql commands to:

- compile the program,
- drop the database,
- create the database,
- insert the extra-long word list, and
- run the program

using Postgres as the database.

Issues:

(1) This is basically my first attempt at FRP, so I have no idea if this is best / proper way to wire the source and signal together.

(2) Since a signal is *automatically* updated when its source changes (without the need to write any `on_` event code), it feels kinda kludgy to be using the `onkeyup` event of the the `<ctextbox>`.

So I wonder if there is a way to update the recordset simply in response to the user typing in the `<ctextbox>` - without using an `on_` event anywhere.

This has been done for another example - but that example used only client-side data:

https://github.com/StefanScott/urweb-ctextbox-echo

So I'm not sure if the present example, which involves reading data from the server-side (ie, running `queryX1`), can be done without using an `on_` event - because of the questions below:

Questions:

(1) For an example like this, which does a transactional "read" (but no transacational "write") on the server (ie: it uses `queryX1`), is it *obligatory* to have a "blocking" call to `rpc` somewhere in the code?

(2) If the answer to Question (1) is "YES", then does this further imply that a control *must* be used which has an `on_` event (eg, currently the `onkeyup` event of the `<ctextbox>` control) - simply because it's necessary to have an `on_` event somewhere, in which make the call to `rpc`? 

I suspect the answer to (2) *may* "NO" here - eg, maybe the call to `rpc` could be done from inside a `<dyn>` tag, which would obviate the need for an `on_` event.

I've been trying this, but so far have not gotten it to work - I keep getting type errors. (I think the result type of an `on_` event is `transaction unit` - whereas the result type of the code in the `signal` attribute of a `<dyn>` is `signal xml` - so this may be causing the type errors). 

---

Minor quibble:

The `LIKE` operator in Postgres is case-sensitive. There is also a non-case-sensitive version `ILIKE`, but it does not appear to have been implemented yet in Ur/Web. 

Of course, a case-insensitive pattern-match could be done using a work-around: eg, before searching, simply convert the search string to all lower-case (resp. all upper-case), and then while doing the search, also convert the column being searched to all lower-case (resp. all upper-case). 

I imagine that it might not be too difficult for a programmer to add support for Postgres `ILIKE` (plus whatever the corresponding operator is in MySQL) to the Ur/Web compiler.

---

Thanks for any feedback. It feels really cool to use Ur/Web FRP to instantly filter records like this!

###

